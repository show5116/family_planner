/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (대시보드)
 *
 * 대시보드 기본 위젯(오늘의 일정 · 가계 현황 · 투자 지표 · 육아 포인트)과
 * 추가로 보여줄 위젯(할일 · 기념일 · 메모)이 **빈 화면으로 찍히지 않도록**
 * 각 위젯이 읽는 데이터를 채웁니다.
 *
 * 가계부 데이터는 seed.mjs가 이미 만들므로 여기서는 건드리지 않습니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-dashboard.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-dashboard.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-dashboard.mjs --cleanup
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 기존 데이터는 수정/삭제하지 않고 추가만 합니다.
 * - 생성한 ID는 seed-dashboard-manifest.json에 기록해 --cleanup으로 되돌립니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-dashboard-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

/**
 * 대시보드 위젯은 대부분 "오늘"을 기준으로 조회하므로
 * 날짜는 반드시 실행 시점 기준으로 만듭니다.
 */
const now = new Date();
const iso = (dt) => dt.toISOString();
/** 오늘 HH:mm (로컬 기준) → ISO */
const todayAt = (hour, minute = 0) => {
  const dt = new Date(now);
  dt.setHours(hour, minute, 0, 0);
  return iso(dt);
};
const daysFromNow = (n, hour = 9) => {
  const dt = new Date(now);
  dt.setDate(dt.getDate() + n);
  dt.setHours(hour, 0, 0, 0);
  return iso(dt);
};
const ymd = (dt) =>
  `${dt.getFullYear()}-${String(dt.getMonth() + 1).padStart(2, '0')}-${String(dt.getDate()).padStart(2, '0')}`;

/**
 * 오늘의 일정 위젯용.
 * 종일 일정 1건 + 시간 일정 2건으로 두 표시 형태를 모두 덮습니다.
 *
 * ⚠️ location은 name·address·lat·lng를 **모두** 채워야 합니다.
 * 앱의 TaskLocation.fromJson이 네 필드를 필수로 읽어서, 하나라도 비면
 * 일정 목록 전체 파싱이 실패하고 위젯이 "오늘 일정이 없습니다"로 보입니다.
 */
const SCHEDULES = [
  {
    title: '어린이집 학부모 상담',
    type: 'CALENDAR_ONLY',
    scheduledAt: todayAt(10, 30),
    location: {
      name: '햇살 어린이집',
      address: '서울 마포구 월드컵북로 120',
      lat: 37.5665,
      lng: 126.978,
    },
  },
  {
    title: '가족 저녁 외식',
    type: 'CALENDAR_ONLY',
    scheduledAt: todayAt(18, 30),
    location: {
      name: '동네 삼겹살집',
      address: '서울 마포구 성미산로 42',
      lat: 37.5601,
      lng: 126.9256,
    },
  },
  {
    title: '재활용 분리수거일',
    type: 'CALENDAR_ONLY',
    allDay: true,
    scheduledAt: todayAt(0),
  },
];

/**
 * 할일 요약 위젯용.
 * 오늘 마감 2건 + 이번 주 마감 1건으로 '오늘/금주' 보기 차이를 보여줍니다.
 */
const TODOS = [
  { title: '아이 준비물 챙기기', type: 'TODO_ONLY', priority: 'HIGH', dueAt: todayAt(20) },
  { title: '관리비 납부', type: 'TODO_ONLY', priority: 'MEDIUM', dueAt: todayAt(22) },
  { title: '자동차 정기 점검 예약', type: 'TODO_ONLY', priority: 'LOW', dueAt: daysFromNow(3, 15) },
];

/** 기념일 위젯용 (D-day 표시) */
const ANNIVERSARIES = [
  { title: '결혼기념일', date: '2015-10-12', emoji: '💍' },
  { title: '민준이 생일', date: '2018-09-14', emoji: '🎂' },
];

/**
 * 육아 포인트 위젯용.
 * 자녀 2명, 잔액이 서로 다르게 보이도록 거래를 다르게 넣습니다.
 */
const CHILDREN = [
  {
    name: '김민준',
    birthDate: '2018-09-14',
    transactions: [
      { type: 'ALLOWANCE', amount: 3000, description: '9월 용돈' },
      { type: 'REWARD', amount: 500, description: '방 정리 완료' },
      { type: 'PURCHASE', amount: 800, description: '문구점 스티커' },
    ],
  },
  {
    name: '김서연',
    birthDate: '2021-04-02',
    transactions: [
      { type: 'ALLOWANCE', amount: 2000, description: '9월 용돈' },
      { type: 'REWARD', amount: 300, description: '심부름 완료' },
    ],
  },
];

/**
 * 투자 지표 위젯용 즐겨찾기.
 * 즐겨찾기가 없으면 위젯이 "즐겨찾기한 지표가 없습니다"로만 찍힙니다.
 * 위젯 설명(코스피·나스닥·환율)과 같은 세 가지를 담습니다.
 * 즐겨찾기는 그룹이 아니라 **계정 단위**입니다.
 */
const INDICATORS = ['KOSPI', 'NASDAQ', 'USD_KRW'];

/** 메모 요약 위젯용 (그룹 공개 + 일반 텍스트) */
const MEMOS = [
  {
    title: '장보기 메모',
    content: '우유, 계란, 식빵, 아이 간식',
    format: 'PLAIN',
    visibility: 'GROUP',
  },
  {
    title: '가족 여행 후보지',
    content: '강릉 / 통영 / 경주 — 10월 연휴 기준으로 알아보기',
    format: 'PLAIN',
    visibility: 'GROUP',
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
  for (const id of m.tasks ?? []) await del(`tasks/${id}`);
  for (const id of m.anniversaries ?? []) await del(`tasks/anniversaries/${id}`);
  for (const id of m.memos ?? []) await del(`memos/${id}`);
  for (const s of m.indicators ?? []) await del(`indicators/${s}/bookmark`);
  // 자녀 프로필과 포인트 거래는 삭제 API가 없으므로 남겨둡니다.
  // (그래서 시딩 쪽에서 거래가 이미 있으면 건너뛰도록 막아둡니다.)
  if ((m.children ?? []).length > 0) {
    console.log(`자녀 프로필 ${m.children.length}건과 포인트 거래는 삭제 API가 없어 남겨둡니다.`);
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(
    MANIFEST,
    JSON.stringify(
      { tasks: [], anniversaries: [], memos: [], indicators: [], children: m.children ?? [], cleanedAt: iso(now) },
      null,
      2,
    ),
  );
}

/** 실패해도 나머지 시딩은 계속되도록 감쌉니다. */
async function tryCreate(label, fn) {
  try {
    return await fn();
  } catch (e) {
    console.log(`  ✗ ${label}: ${String(e.message).slice(0, 140)}`);
    return null;
  }
}

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`);

  if (CLEANUP) return cleanup(accessToken);

  const group = await pickGroup(accessToken);
  const groupId = group.id;
  console.log('대상 그룹:', group.name, groupId);
  console.log('기준 날짜:', ymd(now));

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    console.log(`  일정 ${SCHEDULES.length}건, 할일 ${TODOS.length}건`);
    console.log(`  기념일 ${ANNIVERSARIES.length}건, 메모 ${MEMOS.length}건, 지표 즐겨찾기 ${INDICATORS.length}건`);
    console.log(
      `  자녀 ${CHILDREN.length}명 + 포인트 거래 ${CHILDREN.reduce((s, c) => s + c.transactions.length, 0)}건`,
    );
    return;
  }

  const created = { tasks: [], anniversaries: [], memos: [], children: [], indicators: [], groupId, seededAt: iso(now) };

  // --cleanup 없이 다시 돌려도 데이터가 불어나지 않도록, 같은 제목이 이미 있으면
  // 건너뜁니다. (매뉴얼 스크린샷에 같은 일정이 두 번 찍히는 것을 막습니다.)
  const existingTitles = new Set(
    ((await api(accessToken, 'GET', `tasks?groupIds=${groupId}&limit=200`).catch(() => null))
      ?.data ?? []
    ).map((t) => t.title),
  );

  // 1) 오늘의 일정
  let skipped = 0;
  for (const s of SCHEDULES) {
    if (existingTitles.has(s.title)) { skipped++; continue; }
    const r = await tryCreate(`일정 "${s.title}"`, () =>
      api(accessToken, 'POST', 'tasks', { groupId, ...s }),
    );
    if (r?.id) created.tasks.push(r.id);
  }
  console.log(`일정 생성: ${created.tasks.length}건 (기존 ${skipped}건 건너뜀)`);

  // 2) 할일
  const beforeTodos = created.tasks.length;
  skipped = 0;
  for (const t of TODOS) {
    if (existingTitles.has(t.title)) { skipped++; continue; }
    const r = await tryCreate(`할일 "${t.title}"`, () =>
      api(accessToken, 'POST', 'tasks', { groupId, ...t }),
    );
    if (r?.id) created.tasks.push(r.id);
  }
  console.log(`할일 생성: ${created.tasks.length - beforeTodos}건 (기존 ${skipped}건 건너뜀)`);

  // 3) 기념일 (이름이 같으면 재사용 — 중복 생성 방지)
  const existingAnns = await api(accessToken, 'GET', `tasks/anniversaries?groupId=${groupId}`).catch(
    () => [],
  );
  const annList = Array.isArray(existingAnns) ? existingAnns : (existingAnns?.data ?? []);
  for (const a of ANNIVERSARIES) {
    if (annList.find((x) => x.title === a.title)) continue;
    const r = await tryCreate(`기념일 "${a.title}"`, () =>
      api(accessToken, 'POST', 'tasks/anniversaries', { groupId, ...a }),
    );
    if (r?.id) created.anniversaries.push(r.id);
  }
  console.log(`기념일 생성: ${created.anniversaries.length}건 (기존 ${annList.length}건 재사용)`);

  // 4) 자녀 + 포인트 거래
  const existingChildren = await api(accessToken, 'GET', `childcare/children?groupId=${groupId}`).catch(
    () => [],
  );
  const childList = Array.isArray(existingChildren) ? existingChildren : [];
  let txCount = 0;
  for (const c of CHILDREN) {
    let child = childList.find((x) => x.name === c.name);
    if (!child) {
      child = await tryCreate(`자녀 "${c.name}"`, () =>
        api(accessToken, 'POST', 'childcare/children', {
          groupId,
          name: c.name,
          birthDate: c.birthDate,
        }),
      );
      if (child?.id) created.children.push(child.id);
    }
    if (!child?.id) continue;

    // 포인트 계정은 자녀 등록 시 자동 생성됩니다. 계정 목록에서 찾아 거래를 넣습니다.
    const accounts = await api(accessToken, 'GET', `childcare/accounts?groupId=${groupId}`).catch(
      () => [],
    );
    const acc = (Array.isArray(accounts) ? accounts : []).find(
      (a) => a.childId === child.id || a.child?.id === child.id,
    );
    if (!acc?.id) {
      console.log(`  ✗ ${c.name}: 포인트 계정을 찾지 못해 거래를 건너뜁니다`);
      continue;
    }
    // 이미 거래가 있으면 잔액이 계속 불어나므로 한 번만 넣습니다.
    // 거래는 삭제 API가 없어 --cleanup으로도 되돌릴 수 없습니다. 반드시 걸러야 합니다.
    // 응답은 { transactions, closingBalance } 형태입니다.
    const txs = await api(accessToken, 'GET', `childcare/accounts/${acc.id}/transactions`).catch(
      () => null,
    );
    const txList = Array.isArray(txs) ? txs : (txs?.transactions ?? txs?.data ?? []);
    if (txList.length > 0) {
      console.log(`  · ${c.name}: 거래 ${txList.length}건이 이미 있어 건너뜁니다`);
      continue;
    }
    for (const tx of c.transactions) {
      const r = await tryCreate(`포인트 "${tx.description}"`, () =>
        api(accessToken, 'POST', `childcare/accounts/${acc.id}/transactions`, tx),
      );
      if (r) txCount++;
    }
  }
  console.log(`자녀 준비: ${CHILDREN.length}명 (신규 ${created.children.length}), 포인트 거래 ${txCount}건`);

  // 5) 투자 지표 즐겨찾기 (계정 단위 — 매니페스트에 기록해 되돌립니다)
  const bookmarked = new Set(
    ((await api(accessToken, 'GET', 'indicators/bookmarks').catch(() => null)) ?? [])
      .map?.((b) => b.symbol) ?? [],
  );
  for (const symbol of INDICATORS) {
    if (bookmarked.has(symbol)) continue;
    const r = await tryCreate(`지표 즐겨찾기 "${symbol}"`, () =>
      api(accessToken, 'POST', `indicators/${symbol}/bookmark`),
    );
    if (r !== null) created.indicators.push(symbol);
  }
  console.log(`지표 즐겨찾기: ${created.indicators.length}건 (기존 ${bookmarked.size}건)`);

  // 6) 메모 (제목이 같으면 재사용 — 중복 생성 방지)
  const existingMemos = await api(accessToken, 'GET', `memos?groupId=${groupId}`).catch(() => null);
  const memoTitles = new Set(
    (Array.isArray(existingMemos) ? existingMemos : (existingMemos?.data ?? [])).map((m) => m.title),
  );
  for (const m of MEMOS) {
    if (memoTitles.has(m.title)) continue;
    const r = await tryCreate(`메모 "${m.title}"`, () =>
      api(accessToken, 'POST', 'memos', { groupId, ...m }),
    );
    if (r?.id) created.memos.push(r.id);
  }
  console.log(`메모 생성: ${created.memos.length}건 (기존 ${memoTitles.size}건 재사용)`);

  // 기존 기록에 누적합니다 (덮어쓰면 앞서 만든 데이터를 지울 수 없게 됩니다).
  let prev = { tasks: [], anniversaries: [], memos: [], children: [], indicators: [] };
  if (existsSync(MANIFEST)) {
    try {
      prev = JSON.parse(readFileSync(MANIFEST, 'utf8'));
    } catch {
      /* 손상 시 새로 시작 */
    }
  }
  const merged = {
    tasks: [...new Set([...(prev.tasks ?? []), ...created.tasks])],
    anniversaries: [...new Set([...(prev.anniversaries ?? []), ...created.anniversaries])],
    memos: [...new Set([...(prev.memos ?? []), ...created.memos])],
    children: [...new Set([...(prev.children ?? []), ...created.children])],
    indicators: [...new Set([...(prev.indicators ?? []), ...created.indicators])],
    seededAt: created.seededAt,
  };
  writeFileSync(MANIFEST, JSON.stringify(merged, null, 2));
  console.log('\n매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-dashboard.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
