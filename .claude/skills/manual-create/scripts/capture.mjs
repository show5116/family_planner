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
  if (f.endsWith('.png')) rmSync(path.join(OUT_DIR, f), { force: true });
}

/** Flutter 엔진 기동 + 시맨틱스 활성화 대기 */
async function bootFlutter(page) {
  await page.waitForSelector('flutter-view', { timeout: 180000 });
  await page.waitForTimeout(6000);
  await enableSemantics(page);
}

/** 시맨틱스 플레이스홀더를 클릭해 접근성 트리를 켭니다 (라벨 기반 탐색의 전제). */
async function enableSemantics(page) {
  await page.evaluate(() => {
    const el = document.querySelector('flt-semantics-placeholder');
    if (el) el.click();
  });
  await page.waitForTimeout(1200);
}

/**
 * 라벨이 정확히 일치하는 시맨틱 노드 (가장 안쪽 = 실제 조작 대상).
 *
 * Flutter 시맨틱스는 위젯에 따라 텍스트를 노드 본문에 넣기도 하고
 * aria-label에만 넣기도 합니다(팝업 메뉴 항목 등). 둘 다 매칭해야 합니다.
 */
/** 텍스트가 정확히 일치하는 시맨틱 노드 (가장 안쪽 = 실제 조작 대상) */
function nodeByText(page, label) {
  return page.locator('flt-semantics', { hasText: new RegExp(`^${escapeRe(label)}$`) });
}

/**
 * 라벨로 요소를 클릭합니다.
 *
 * aria-label 완전일치 → 텍스트 완전일치 순으로 시도합니다.
 * aria-label 탐색은 CSS 선택자 대신 DOM을 직접 훑어 좌표를 얻습니다
 * (줄바꿈·따옴표가 든 라벨도 안전하게 처리하기 위함).
 */
async function clickLabel(page, label, timeout = 45000) {
  const box = await page.evaluate((want) => {
    const el = [...document.querySelectorAll('flt-semantics')]
      .find((n) => (n.getAttribute('aria-label') || '') === want);
    if (!el) return null;
    const r = el.getBoundingClientRect();
    if (r.width === 0 || r.height === 0) return null;
    return { x: r.x, y: r.y, w: r.width, h: r.height };
  }, label);

  if (box) {
    await page.mouse.click(box.x + box.w / 2, box.y + box.h / 2);
    return;
  }

  await nodeByText(page, label).last().click({ timeout });
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
    case 'tapNth': {
      await enableSemantics(page);
      const loc = page.locator('flt-semantics', {
        hasText: new RegExp(escapeRe(step.contains)),
      });
      await loc.nth(step.index ?? 0).click({ timeout: 45000 });
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
      await page.mouse.move(200, 500);
      await page.mouse.wheel(0, step.dy ?? 400);
      await settle(page, step.wait ?? 1800);
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
    case 'shot': {
      const file = path.join(OUT_DIR, `${step.name}.png`);
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
  const context = await browser.newContext({
    ...devices[flow.device ?? 'iPhone 13'],
    locale: flow.locale ?? 'ko-KR',
    // 스크린샷 시각을 고정하고 싶다면 timezoneId 지정
    timezoneId: flow.timezone ?? 'Asia/Seoul',
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
    // 실패 지점 스냅샷을 남겨 디버깅을 돕습니다.
    await page.screenshot({ path: path.join(OUT_DIR, '_failure.png') }).catch(() => {});
    console.error('\n촬영 중단:', e.message);
  }

  const manifest = path.join(OUT_DIR, 'shots.json');
  writeFileSync(manifest, JSON.stringify({ flow: flow.name, shots: state.shots }, null, 2));
  console.log(`\n총 ${state.shots.length}장 저장 → ${path.relative(PROJECT_ROOT, OUT_DIR)}`);

  await browser.close();
  if (failed) process.exit(1);
}

main();
