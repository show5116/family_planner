/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (루틴)
 *
 * 루틴 화면은 습관 목록·카테고리·묶음·히트맵·통계·배지가 모두 데이터에
 * 의존합니다. 매뉴얼에서 설명할 케이스를 한 번에 덮도록 구성합니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-routine.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-routine.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-routine.mjs --cleanup
 *   node .claude/skills/manual-create/scripts/seed-routine.mjs --purge   # 기존 습관까지 전부 삭제
 *
 * 안전 규칙
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 기본은 이름 기준 중복 가드라 재실행해도 늘지 않습니다.
 * - `--purge` 는 **기존 습관·카테고리·묶음을 모두 지웁니다.** 매뉴얼용으로
 *   깨끗한 상태를 만들 때만 쓰세요.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-routine-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');
const PURGE = process.argv.includes('--purge');

const now = new Date();
const ymd = (d) =>
  `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
const daysAgo = (n) => {
  const d = new Date(now);
  d.setDate(d.getDate() - n);
  return ymd(d);
};

/** 카테고리 — 습관을 성격별로 묶어 보여줍니다 */
const CATEGORIES = [
  { title: '건강', emoji: '💪', color: '#22C55E' },
  { title: '공부', emoji: '📚', color: '#6366F1' },
  { title: '집안일', emoji: '🧹', color: '#F59E0B' },
];

/** 루틴(습관 묶음) — 시간대별로 묶어 한 번에 확인 */
const GROUPS = [
  { title: '아침 루틴', emoji: '🌅', color: '#F59E0B' },
  { title: '저녁 루틴', emoji: '🌙', color: '#6366F1' },
];

/**
 * 습관 8개.
 *
 * 매뉴얼에서 설명할 요소를 골고루 덮습니다.
 * - 기록 방식 4종: BOOLEAN(단순 체크) · NUMERIC(수치) · TIME(시각) · TEXT(메모)
 * - 반복 주기 3종: DAILY · WEEKLY(요일 지정 / 주 N회) · MONTHLY
 * - 묶음 소속 / 독립 습관
 * - 중요도, 시간대 분류
 * - checkDays: 며칠 전에 체크했는지 (히트맵·스트릭·달성률용)
 *
 * 체크 날짜는 아무렇게나 고른 값이 아닙니다.
 * - 최근 3일(오늘 포함)은 하루 체크 6건을 채워 **일일 목표를 연속 달성**하게 만듭니다.
 *   → '3일 연속 달성' 배지가 실제로 부여되어 배지 화면에 획득/미획득이 함께 찍힙니다.
 * - '아침 물 한 잔'은 지난주(월~일) 7일을 모두 채워 상세 화면의
 *   '최근 8주 달성 현황' 스트립에 색칠된 칸이 최소 하나는 나오게 합니다.
 * - 요일 지정 습관은 지정 요일(화·금)에만 체크해 설정과 기록이 어긋나지 않게 합니다.
 */
const ROUTINES = [
  {
    title: '아침 물 한 잔',
    emoji: '💧', color: '#22C55E',
    group: '아침 루틴', categories: ['건강'],
    recordType: 'BOOLEAN', frequencyType: 'DAILY',
    importance: 'HIGH', timeFilter: 'MORNING',
    checkDays: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], // 스트릭 + 지난주 7/7 달성
  },
  {
    title: '스트레칭 10분',
    emoji: '🧘', color: '#22C55E',
    group: '아침 루틴', categories: ['건강'],
    recordType: 'BOOLEAN', frequencyType: 'DAILY',
    importance: 'MEDIUM', timeFilter: 'MORNING',
    checkDays: [0, 1, 2, 4, 5, 7, 9, 11],
  },
  {
    title: '영어 단어 외우기',
    emoji: '📖', color: '#6366F1',
    categories: ['공부'],
    // 수치 기록 — 몇 개 외웠는지 숫자로 남깁니다
    recordType: 'NUMERIC', frequencyType: 'DAILY',
    importance: 'HIGH', timeFilter: 'EVENING',
    checkDays: [0, 1, 2, 3, 4, 6, 8, 10],
    checkValues: { numericValue: 30 },
  },
  {
    title: '취침 시간 지키기',
    emoji: '🛏️', color: '#6366F1',
    group: '저녁 루틴', categories: ['건강'],
    // 시각 기록 — 몇 시에 잤는지 남깁니다
    recordType: 'TIME', frequencyType: 'DAILY',
    importance: 'MEDIUM', timeFilter: 'EVENING',
    checkDays: [0, 1, 2, 3, 5, 6, 9],
    checkValues: { timeValue: '23:10' },
  },
  {
    title: '오늘 한 줄 일기',
    emoji: '✏️', color: '#8B5CF6',
    group: '저녁 루틴',
    // 텍스트 기록
    recordType: 'TEXT', frequencyType: 'DAILY',
    timeFilter: 'EVENING',
    checkDays: [0, 1, 2, 5, 8],
    checkValues: { textValue: '오늘도 무사히' },
  },
  {
    title: '주 3회 운동',
    emoji: '🏃', color: '#EF4444',
    categories: ['건강'],
    // 요일 무관 주 3회
    recordType: 'BOOLEAN', frequencyType: 'WEEKLY',
    weeklyMode: 'COUNT_ONLY', targetCount: 3,
    importance: 'HIGH',
    checkDays: [0, 1, 3, 6, 8, 10],
  },
  {
    title: '분리수거',
    emoji: '♻️', color: '#F59E0B',
    categories: ['집안일'],
    // 특정 요일 지정 (화·금)
    recordType: 'BOOLEAN', frequencyType: 'WEEKLY',
    weeklyMode: 'FIXED_DAYS', targetDays: [2, 5],
    checkDays: [2, 6, 9, 13],   // 실제 화·금에만 체크
  },
  {
    title: '가계부 정리',
    emoji: '💰', color: '#0EA5E9',
    categories: ['집안일'],
    recordType: 'BOOLEAN', frequencyType: 'MONTHLY', targetCount: 2,
    checkDays: [1, 4, 14],      // 이번 달 1건 / 지난달 2건
  },
];

async function pickGroup(token) {
  const groups = await api(token, 'GET', 'groups');
  if (!Array.isArray(groups) || groups.length === 0) {
    throw new Error('그룹이 없습니다. 테스트 계정에 그룹이 있어야 합니다.');
  }
  const idx = process.argv.indexOf('--group');
  if (idx !== -1 && process.argv[idx + 1]) {
    const want = process.argv[idx + 1];
    const hit = groups.find((g) => g.name === want);
    if (!hit) throw new Error(`"${want}" 그룹을 찾을 수 없습니다.`);
    return hit;
  }
  return groups.find((g) => g.myRole?.name === 'OWNER') ?? groups[0];
}

const asList = (r) => (Array.isArray(r) ? r : (r?.items ?? r?.data ?? []));

async function tryCall(label, fn, quiet = false) {
  try {
    return await fn();
  } catch (e) {
    if (!quiet) console.log(`  ✗ ${label}: ${String(e.message).slice(0, 130)}`);
    return null;
  }
}

/** 기존 습관·카테고리·묶음을 전부 삭제 (매뉴얼용 초기화) */
async function purge(token) {
  let n = 0;
  for (const [ep, label] of [
    ['routines', '습관'],
    ['routines/routine-groups', '루틴(묶음)'],
    ['routines/categories', '카테고리'],
  ]) {
    const items = asList(await api(token, 'GET', ep).catch(() => []));
    for (const it of items) {
      const ok = await tryCall(`${label} "${it.title}" 삭제`, () =>
        api(token, 'DELETE', `${ep}/${it.id}`),
      );
      if (ok !== null) n++;
    }
    console.log(`  ${label}: ${items.length}건 삭제 시도`);
  }
  return n;
}

async function cleanup(token) {
  if (!existsSync(MANIFEST)) {
    console.log('삭제할 매니페스트가 없습니다:', MANIFEST);
    return;
  }
  const m = JSON.parse(readFileSync(MANIFEST, 'utf8'));
  let ok = 0;
  let fail = 0;
  const del = async (ep) => {
    try {
      await api(token, 'DELETE', ep);
      ok++;
    } catch {
      fail++;
    }
  };
  // 습관 → 묶음 → 카테고리 순 (참조 역순)
  for (const id of m.routines ?? []) await del(`routines/${id}`);
  for (const id of m.groups ?? []) await del(`routines/routine-groups/${id}`);
  for (const id of m.categories ?? []) await del(`routines/categories/${id}`);
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(
    MANIFEST,
    JSON.stringify({ routines: [], groups: [], categories: [], cleanedAt: now.toISOString() }, null, 2),
  );
}

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`);

  if (CLEANUP) return cleanup(accessToken);

  const group = await pickGroup(accessToken);
  console.log('대상 그룹:', group.name, group.id);

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    console.log(`  카테고리 ${CATEGORIES.length}건, 루틴(묶음) ${GROUPS.length}건`);
    console.log(`  습관 ${ROUTINES.length}건`);
    console.log(`  체크 ${ROUTINES.reduce((s, r) => s + r.checkDays.length, 0)}건`);
    if (PURGE) console.log('  ⚠ --purge: 기존 습관·묶음·카테고리를 먼저 전부 삭제합니다');
    return;
  }

  if (PURGE) {
    console.log('\n[기존 데이터 삭제]');
    await purge(accessToken);
  }

  const created = { routines: [], groups: [], categories: [], seededAt: now.toISOString() };

  // 1) 카테고리
  const existCats = asList(await api(accessToken, 'GET', 'routines/categories').catch(() => []));
  const catByTitle = new Map(existCats.map((c) => [c.title, c.id]));
  for (const c of CATEGORIES) {
    if (catByTitle.has(c.title)) continue;
    const r = await tryCall(`카테고리 "${c.title}"`, () =>
      api(accessToken, 'POST', 'routines/categories', c),
    );
    if (r?.id) {
      catByTitle.set(c.title, r.id);
      created.categories.push(r.id);
    }
  }
  console.log(`카테고리: 신규 ${created.categories.length}건 (전체 ${catByTitle.size}건)`);

  // 2) 루틴(묶음)
  const existGroups = asList(
    await api(accessToken, 'GET', 'routines/routine-groups').catch(() => []),
  );
  const groupByTitle = new Map(existGroups.map((g) => [g.title, g.id]));
  for (const g of GROUPS) {
    if (groupByTitle.has(g.title)) continue;
    const r = await tryCall(`루틴 "${g.title}"`, () =>
      api(accessToken, 'POST', 'routines/routine-groups', g),
    );
    if (r?.id) {
      groupByTitle.set(g.title, r.id);
      created.groups.push(r.id);
    }
  }
  console.log(`루틴(묶음): 신규 ${created.groups.length}건 (전체 ${groupByTitle.size}건)`);

  // 3) 습관 + 체크 이력
  const existRoutines = asList(await api(accessToken, 'GET', 'routines').catch(() => []));
  const routineTitles = new Set(existRoutines.map((r) => r.title));
  let checkCount = 0;

  for (const rt of ROUTINES) {
    if (routineTitles.has(rt.title)) {
      console.log(`· ${rt.title}: 이미 있어 건너뜁니다`);
      continue;
    }
    const { group: groupTitle, categories = [], checkDays, checkValues, ...rest } = rt;
    const body = {
      ...rest,
      startDate: daysAgo(20),
      ...(groupTitle && groupByTitle.has(groupTitle)
        ? { routineGroupId: groupByTitle.get(groupTitle) }
        : {}),
      ...(categories.length
        ? { categoryIds: categories.map((t) => catByTitle.get(t)).filter(Boolean) }
        : {}),
    };
    const res = await tryCall(`습관 "${rt.title}"`, () =>
      api(accessToken, 'POST', 'routines', body),
    );
    if (!res?.id) continue;
    created.routines.push(res.id);

    // 체크 이력 — 오래된 날짜부터 넣습니다
    for (const d of [...checkDays].sort((a, b) => b - a)) {
      const ok = await tryCall(
        `체크 ${rt.title} ${daysAgo(d)}`,
        () =>
          api(accessToken, 'POST', `routines/${res.id}/check`, {
            date: daysAgo(d),
            ...(checkValues ?? {}),
          }),
        true, // 중복 체크 등은 조용히 넘어갑니다
      );
      if (ok) checkCount++;
    }
    console.log(`  ✓ ${rt.emoji} ${rt.title} — 체크 ${checkDays.length}건`);
  }

  console.log(`\n습관: 신규 ${created.routines.length}건 / 체크 ${checkCount}건`);

  let prev = { routines: [], groups: [], categories: [] };
  if (existsSync(MANIFEST)) {
    try {
      prev = JSON.parse(readFileSync(MANIFEST, 'utf8'));
    } catch {
      /* 손상 시 새로 시작 */
    }
  }
  const merge = (a, b) => [...new Set([...(a ?? []), ...b])];
  writeFileSync(
    MANIFEST,
    JSON.stringify(
      {
        routines: merge(prev.routines, created.routines),
        groups: merge(prev.groups, created.groups),
        categories: merge(prev.categories, created.categories),
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-routine.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
