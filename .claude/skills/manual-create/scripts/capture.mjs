/**
 * 매뉴얼용 모바일 스크린샷 촬영 (Playwright)
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/capture.mjs <플로우파일.json>
 *
 * 사전 조건 (중요)
 * 1. **release 빌드**를 정적 서버로 띄워야 합니다.
 *    debug 빌드(flutter run)는 DDC가 1865개 모듈을 로드하면서 헤드리스에서
 *    엔진이 기동하지 않습니다. 반드시 아래 순서를 따르세요.
 *
 *      flutter build web --release --dart-define=ENVIRONMENT=development
 *      node .claude/skills/manual-create/scripts/serve.mjs
 *
 * 2. 접속은 반드시 `localhost:3001`. 백엔드 CORS가 127.0.0.1을 허용하지 않습니다.
 *
 * 동작
 * - iPhone 13 프로필로 모바일 뷰포트·터치·UA를 에뮬레이트합니다 (DPR 3 → 레티나 PNG).
 * - Flutter 시맨틱스를 켜서 위젯을 **한국어 라벨로** 찾습니다 (좌표 클릭 아님).
 * - 코치마크 오버레이는 localStorage 선주입으로 억제합니다.
 */

import { chromium, devices } from 'playwright';
import { mkdirSync, readFileSync, writeFileSync, readdirSync, rmSync } from 'node:fs';
import path from 'node:path';
import {
  APP_ORIGIN, PROJECT_ROOT, onboardingSuppressScript,
  groupCoachMarkKeys, login,
} from './lib.mjs';

const flowPath = process.argv[2];
if (!flowPath) {
  console.error('사용법: node capture.mjs <플로우파일.json>');
  process.exit(1);
}

const flow = JSON.parse(readFileSync(path.resolve(flowPath), 'utf8'));
const OUT_DIR = path.resolve(PROJECT_ROOT, flow.outDir);
mkdirSync(OUT_DIR, { recursive: true });

// 이전 실행의 스크린샷을 지웁니다. 플로우에서 이름을 바꾸면 옛 파일이 남아
// 매뉴얼이 참조하지 않는 유령 이미지가 쌓입니다.
for (const f of readdirSync(OUT_DIR)) {
  if (f.endsWith('.png') || f === '_failure-labels.txt') {
    rmSync(path.join(OUT_DIR, f), { force: true });
  }
}

/** Flutter 엔진 기동 + 시맨틱스 활성화 대기 */
async function bootFlutter(page) {
  await page.waitForSelector('flutter-view', { timeout: 180000 });
  await page.waitForTimeout(6000);
  await enableSemantics(page);
}

/** 시맨틱스 플레이스홀더를 클릭해 접근성 트리를 켭니다 (라벨 기반 탐색의 전제). */
async function enableSemantics(page, { minNodes = 1, timeout = 6000 } = {}) {
  await page.evaluate(() => {
    const el = document.querySelector('flt-semantics-placeholder');
    if (el) el.click();
  });
  // 고정 대기 대신 시맨틱 노드가 실제로 생길 때까지 기다립니다.
  // Flutter 웹은 스크롤·화면 전환 직후 트리를 곧바로 갱신하지 않아,
  // 화면에는 보이는데 시맨틱스에는 없어서 탭이 실패하는 일이 있었습니다.
  const deadline = Date.now() + timeout;
  while (Date.now() < deadline) {
    const n = await page.evaluate(
      () => document.querySelectorAll('flt-semantics').length,
    );
    if (n >= minNodes) break;
    await page.waitForTimeout(300);
  }
  await page.waitForTimeout(400);
}

/** 현재 화면의 시맨틱 라벨 목록 (실패 디버깅용) */
async function dumpLabels(page) {
  return page
    .evaluate(() =>
      [...document.querySelectorAll('flt-semantics')]
        .map((n) => ({
          role: n.getAttribute('role') || '',
          aria: n.getAttribute('aria-label') || '',
          text: (n.textContent || '').replace(/\n/g, ' | ').trim().slice(0, 90),
        }))
        .filter((o) => o.aria || o.text),
    )
    .catch(() => []);
}

/// 요소를 누릅니다. 핸들 클릭이 flt-glass-pane에 막히면 좌표로 직접 누릅니다.
///
/// Flutter 웹은 시맨틱 노드 위를 glass-pane이 덮고 있고 좌표로 히트 테스트합니다.
/// 대부분은 핸들 클릭이 그대로 통하지만, 노드가 pane에 완전히 가려져 Playwright가
/// 계속 재시도만 하는 경우가 있어(메모 목록의 체크리스트 카드) 그때는 노드 위치를
/// 구해 그 좌표를 직접 누릅니다. 실제 사용자의 탭과 같은 경로입니다.
async function clickElement(page, el, timeout = 45000) {
  try {
    await el.click({ timeout: Math.min(timeout, 8000) });
    return;
  } catch {
    // 아래 좌표 클릭으로 넘어갑니다
  }
  await el.scrollIntoViewIfNeeded().catch(() => {});
  const box = await el.boundingBox();
  if (!box) throw new Error('요소의 위치를 구하지 못했습니다');
  await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
}

async function clickLabel(page, label, timeout = 45000) {
  // 매칭을 3단계로 넓혀가며 시도합니다. 실제 촬영에서 아래 경우를 모두 만났습니다.
  //  1) aria-label 완전일치 — 대부분의 버튼
  //  2) 텍스트 첫 줄 일치 — ListTile은 "제목\n부제목"으로 합쳐집니다
  //  3) 부분 포함 — 일정 카드처럼 "제목\n오전 10:30"이 통째로 aria-label이거나,
  //     기념일처럼 이모지·D-day가 앞뒤에 붙는 경우
  //
  // 좌표(page.mouse)가 아니라 요소 핸들로 클릭합니다. 화면 밖 요소는 좌표 클릭이
  // 통하지 않지만(스크롤을 하지 않음) 핸들 클릭은 먼저 스크롤합니다.
  //
  // 다만 시맨틱 노드 위를 flt-glass-pane이 덮고 있으면 핸들 클릭이 계속 막힙니다.
  // (메모 목록의 체크리스트 카드가 그랬습니다.) 이때는 노드 위치를 구해 그 좌표를
  // 직접 누릅니다 — Flutter는 원래 glass-pane에서 좌표로 히트 테스트하므로
  // 이쪽이 실제 사용자의 탭에 더 가깝습니다.
  const find = (mode) =>
    page.evaluateHandle(
      ({ want, mode }) => {
        const visible = (n) => {
          const r = n.getBoundingClientRect();
          return r.width > 0 && r.height > 0;
        };
        const area = (n) => {
          const r = n.getBoundingClientRect();
          return r.width * r.height;
        };
        const nodes = [...document.querySelectorAll('flt-semantics')].filter(visible);

        if (mode === 'aria') {
          return nodes.find((n) => (n.getAttribute('aria-label') || '') === want) ?? null;
        }
        if (mode === 'firstLine') {
          return (
            nodes
              .filter((n) => (n.textContent || '').split('\n')[0].trim() === want)
              .sort((a, b) => area(a) - area(b))[0] ?? null
          );
        }
        // contains — 가장 작은 노드를 골라 상위 컨테이너를 피합니다
        return (
          nodes
            .filter((n) =>
              ((n.getAttribute('aria-label') || '') + (n.textContent || '')).includes(want),
            )
            .sort((a, b) => area(a) - area(b))[0] ?? null
        );
      },
      { want: label, mode },
    );

  for (const mode of ['aria', 'firstLine', 'contains']) {
    const handle = await find(mode);
    const el = handle.asElement();
    if (el) {
      await clickElement(page, el, timeout);
      return;
    }
  }

  // 세 방식 모두 실패 — 시맨틱스를 한 번 더 켜고 마지막으로 시도
  await enableSemantics(page);
  const retry = await find('contains');
  const el = retry.asElement();
  if (el) {
    await clickElement(page, el, timeout);
    return;
  }
  throw new Error(`"${label}" 을(를) 찾지 못했습니다 (aria/첫줄/부분일치 모두 실패)`);
}

function escapeRe(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

/** 렌더 안정화 대기: 캔버스가 더 이상 바뀌지 않을 때까지 */
async function settle(page, ms = 2500) {
  await page.waitForTimeout(ms);
}

async function runStep(page, step, ctxState) {
  switch (step.action) {
    case 'goto': {
      await page.goto(APP_ORIGIN + step.path, { waitUntil: 'load', timeout: 180000 });
      await bootFlutter(page);
      await settle(page, step.wait ?? 8000);
      break;
    }
    case 'login': {
      // 개발 환경에서만 노출되는 테스트 계정 원클릭 버튼
      const label =
        step.as === 'member'
          ? '테스트 계정으로 로그인 (그룹 멤버)'
          : '테스트 계정으로 로그인 (그룹 소유자)';
      await clickLabel(page, label, 60000);
      await page.waitForTimeout(step.wait ?? 15000);
      await enableSemantics(page);
      break;
    }
    case 'tap': {
      await enableSemantics(page);
      await clickLabel(page, step.label, step.timeout ?? 45000);
      await settle(page, step.wait ?? 3500);
      await enableSemantics(page);
      break;
    }
    case 'tapRole': {
      // 라벨이 없는 컨트롤(스위치·체크박스)용. 화면에 같은 역할이 여러 개면
      // index로 위에서부터 몇 번째인지 지정합니다.
      await enableSemantics(page);
      const handle = await page.evaluateHandle(({ role, index }) => {
        const nodes = [...document.querySelectorAll('flt-semantics')]
          .filter((n) => n.getAttribute('role') === role)
          .filter((n) => {
            const r = n.getBoundingClientRect();
            return r.width > 0 && r.height > 0;
          })
          .sort((a, b) => a.getBoundingClientRect().y - b.getBoundingClientRect().y);
        return nodes[index ?? 0] ?? null;
      }, { role: step.role, index: step.index });
      const target = handle.asElement();
      if (!target) throw new Error(`role="${step.role}" 요소를 찾지 못했습니다`);
      await clickElement(page, target, step.timeout ?? 45000);
      await settle(page, step.wait ?? 3500);
      await enableSemantics(page);
      break;
    }
    case 'tapContains': {
      // 부분일치 — 이모지·D-day처럼 라벨 앞뒤에 다른 글자가 붙는 항목용
      // (예: "💍결혼기념일10/12 · D+3976"). 후보 중 가장 작은 노드를 고릅니다.
      await enableSemantics(page);
      const handle = await page.evaluateHandle((want) => {
        const area = (n) => {
          const r = n.getBoundingClientRect();
          return r.width * r.height;
        };
        return (
          [...document.querySelectorAll('flt-semantics')]
            .filter((n) => {
              const t = (n.getAttribute('aria-label') || '') + (n.textContent || '');
              const r = n.getBoundingClientRect();
              return t.includes(want) && r.width > 0 && r.height > 0;
            })
            .sort((a, b) => area(a) - area(b))[0] ?? null
        );
      }, step.contains);
      const target = handle.asElement();
      if (!target) throw new Error(`"${step.contains}" 를 포함한 요소를 찾지 못했습니다`);
      await clickElement(page, target, step.timeout ?? 45000);
      await settle(page, step.wait ?? 3500);
      await enableSemantics(page);
      break;
    }
    case 'tapNth': {
      await enableSemantics(page);
      const loc = page.locator('flt-semantics', {
        hasText: new RegExp(escapeRe(step.contains)),
      });
      await clickElement(page, loc.nth(step.index ?? 0), 45000);
      await settle(page, step.wait ?? 3500);
      await enableSemantics(page);
      break;
    }
    case 'tapFab': {
      // FloatingActionButton은 aria-label이 없어 라벨로 찾을 수 없습니다.
      // 시맨틱스 트리에서 "라벨 없는 정사각형 버튼 중 가장 아래·오른쪽"을 FAB로 봅니다.
      await enableSemantics(page);
      const box = await page.evaluate(() => {
        const cands = [...document.querySelectorAll('flt-semantics')]
          .filter((n) => n.getAttribute('role') === 'button')
          .filter((n) => !(n.getAttribute('aria-label') || '').trim())
          .map((n) => {
            const r = n.getBoundingClientRect();
            return { x: r.x, y: r.y, w: r.width, h: r.height };
          })
          // 정사각형에 가깝고 40~80px인 것 = FAB
          .filter((r) => r.w >= 40 && r.w <= 80 && Math.abs(r.w - r.h) < 8);
        if (!cands.length) return null;
        // 가장 오른쪽·아래
        cands.sort((a, b) => b.x + b.y - (a.x + a.y));
        return cands[0];
      });
      if (!box) throw new Error('FAB를 찾지 못했습니다');
      await page.mouse.click(box.x + box.w / 2, box.y + box.h / 2);
      await settle(page, step.wait ?? 5000);
      await enableSemantics(page);
      break;
    }
    case 'scroll': {
      // 스크롤 전 시맨틱 지문을 남겨, 트리가 실제로 갱신될 때까지 기다립니다.
      const before = await page
        .evaluate(() =>
          [...document.querySelectorAll('flt-semantics')]
            .map((n) => (n.textContent || '').slice(0, 40))
            .join('§'),
        )
        .catch(() => '');
      await page.mouse.move(200, 500);
      await page.mouse.wheel(0, step.dy ?? 400);
      await settle(page, step.wait ?? 1800);
      await enableSemantics(page);
      // 목록이 길면 갱신이 늦습니다. 최대 4초까지 바뀌기를 기다립니다.
      const deadline = Date.now() + 4000;
      while (Date.now() < deadline) {
        const after = await page
          .evaluate(() =>
            [...document.querySelectorAll('flt-semantics')]
              .map((n) => (n.textContent || '').slice(0, 40))
              .join('§'),
          )
          .catch(() => '');
        if (after !== before) break;
        await page.waitForTimeout(300);
      }
      await enableSemantics(page);
      break;
    }
    case 'back': {
      await page.goBack({ timeout: 30000 }).catch(() => {});
      await settle(page, step.wait ?? 3500);
      await enableSemantics(page);
      break;
    }
    case 'wait': {
      await settle(page, step.wait ?? 2000);
      break;
    }
    case 'reload': {
      await page.reload({ waitUntil: 'domcontentloaded' });
      await page.waitForTimeout(step.wait ?? 15000);
      await enableSemantics(page);
      break;
    }
    case 'dump': {
      // 플로우를 짤 때 실제 시맨틱 라벨과 크기를 확인하는 용도.
      await enableSemantics(page);
      const rows = await page.evaluate((role) => {
        return [...document.querySelectorAll('flt-semantics')]
          .filter((n) => !role || n.getAttribute('role') === role)
          .map((n) => {
            const r = n.getBoundingClientRect();
            return {
              role: n.getAttribute('role') || '-',
              label: (n.getAttribute('aria-label') || n.textContent || '').split('\n')[0].slice(0, 30),
              w: Math.round(r.width),
              h: Math.round(r.height),
            };
          })
          .filter((r) => r.w > 0 && r.label);
      }, step.role ?? null);
      console.log(`  [dump] ${rows.length}개`);
      for (const r of rows) console.log(`    ${r.role.padEnd(12)} ${String(r.w).padStart(4)}x${String(r.h).padStart(3)}  ${r.label}`);
      break;
    }
    case 'shot': {
      const file = path.join(OUT_DIR, `${step.name}.png`);
      await page.evaluate(() => document.fonts.ready).catch(() => {});
      await page.waitForTimeout(400);
      await page.screenshot({ path: file, fullPage: step.fullPage ?? false });
      ctxState.shots.push({
        name: step.name,
        file: path.relative(PROJECT_ROOT, file).replace(/\\/g, '/'),
        caption: step.caption ?? '',
      });
      console.log('  📸', step.name);
      break;
    }
    default:
      throw new Error(`알 수 없는 action: ${step.action}`);
  }
}

async function main() {
  const browser = await chromium.launch();
  // 위치 권한을 주지 않으면 날씨 위젯이 "현재 위치를 가져오지 못해 …" 경고를
  // 빨간 글씨로 띄웁니다. 매뉴얼 스크린샷으로 쓸 수 없으므로 기본으로 허용합니다.
  // 플로우에서 `geolocation: null` 로 두면 권한 없는 상태를 일부러 찍을 수 있습니다.
  const geolocation =
    flow.geolocation === undefined
      ? { latitude: 37.5665, longitude: 126.978 } // 서울시청
      : flow.geolocation;

  const context = await browser.newContext({
    ...devices[flow.device ?? 'iPhone 13'],
    locale: flow.locale ?? 'ko-KR',
    // 스크린샷 시각을 고정하고 싶다면 timezoneId 지정
    timezoneId: flow.timezone ?? 'Asia/Seoul',
    ...(geolocation ? { geolocation, permissions: ['geolocation'] } : {}),
  });
  // 코치마크 오버레이 억제 (페이지 로드 전 주입되어야 함).
  // 그룹 상세 코치마크는 키에 그룹 ID가 들어가므로 API로 목록을 먼저 받아옵니다.
  let extraKeys = [];
  try {
    const { accessToken } = await login();
    extraKeys = await groupCoachMarkKeys(accessToken);
  } catch {
    // 로그인 실패해도 촬영 자체는 진행합니다 (기본 코치마크는 계속 억제됨).
  }
  await context.addInitScript(onboardingSuppressScript(extraKeys));

  const page = await context.newPage();
  page.on('pageerror', (e) => console.log('  [pageerror]', String(e).slice(0, 160)));
  if (process.env.CAPTURE_DEBUG_NET) {
    page.on('requestfailed', (r) =>
      console.log('  [netfail]', r.failure()?.errorText, r.url().slice(0, 110)),
    );
    page.on('response', (r) => {
      if (/font|\.ttf|\.otf|\.woff/i.test(r.url()))
        console.log('  [font]', r.status(), r.url().slice(0, 110));
    });
  }

  const state = { shots: [] };
  let failed = null;

  try {
    for (const [i, step] of flow.steps.entries()) {
      const desc = step.action + (step.label ? ` "${step.label}"` : step.name ? ` ${step.name}` : step.path ? ` ${step.path}` : '');
      console.log(`[${i + 1}/${flow.steps.length}] ${desc}`);
      await runStep(page, step, state);
    }
  } catch (e) {
    failed = e;
    // 실패 지점 스냅샷 + 그 화면의 시맨틱 라벨 목록을 남깁니다.
    // 스크린샷만으로는 "왜 못 찾았는지"를 알 수 없어 매번 프로브 스크립트를
    // 따로 만들어야 했습니다.
    await page.screenshot({ path: path.join(OUT_DIR, '_failure.png') }).catch(() => {});
    const labels = await dumpLabels(page);
    writeFileSync(
      path.join(OUT_DIR, '_failure-labels.txt'),
      labels
        .map((o) => `${(o.role || '-').padEnd(8)} aria=${JSON.stringify(o.aria)}  text=${JSON.stringify(o.text)}`)
        .join('\n'),
    );
    console.error('\n촬영 중단:', e.message);
    console.error(`실패 화면의 시맨틱 라벨 ${labels.length}개 → ${path.relative(PROJECT_ROOT, path.join(OUT_DIR, '_failure-labels.txt'))}`);
  }

  const manifest = path.join(OUT_DIR, 'shots.json');
  writeFileSync(manifest, JSON.stringify({ flow: flow.name, shots: state.shots }, null, 2));
  console.log(`\n총 ${state.shots.length}장 저장 → ${path.relative(PROJECT_ROOT, OUT_DIR)}`);

  await browser.close();
  if (failed) process.exit(1);
}

main();
