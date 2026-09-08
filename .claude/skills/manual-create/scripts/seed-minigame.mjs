/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (미니게임)
 *
 * 미니게임 화면 아래 `게임 이력`은 결과가 없으면 "게임 이력이 없습니다"만 찍힙니다.
 * 사다리타기와 룰렛 결과를 섞어 넣어, 목록의 두 아이콘과 두 요약 형식이
 * 모두 보이도록 만듭니다.
 *   - LADDER  → `참여자 → 항목, 참여자 → 항목` 형태로 요약됩니다
 *   - ROULETTE → `당첨: 이름` 형태로 요약됩니다
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-minigame.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-minigame.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-minigame.mjs --cleanup
 *
 * 참고: createdAt은 서버가 정해서 전부 오늘 날짜로 남습니다(과거 날짜 지정 불가).
 *       그리고 촬영 중 실제로 게임을 끝내면 그룹이 선택돼 있을 때 결과가
 *       **자동 저장**되므로 이력이 늘어납니다. 정상 동작입니다.
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 같은 제목이 있으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 생성한 ID는 seed-minigame-manifest.json에 기록해 --cleanup으로 되돌립니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-minigame-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();

/**
 * 게임 이력 3건.
 *
 * 사다리 2건 · 룰렛 1건으로 두 요약 형식을 모두 덮고,
 * 참여자 수도 2명·3명으로 달리해 목록이 단조롭지 않게 합니다.
 */
const RESULTS = [
  {
    gameType: 'LADDER',
    title: '설거지 당번 정하기',
    participants: ['김아빠', '박엄마'],
    options: ['설거지', '빨래'],
    result: {
      assignments: [
        { participant: '김아빠', option: '설거지' },
        { participant: '박엄마', option: '빨래' },
      ],
    },
  },
  {
    gameType: 'ROULETTE',
    title: '오늘 저녁 메뉴',
    participants: [],
    options: ['삼겹살', '치킨', '피자', '파스타'],
    result: { winner: '치킨' },
  },
  {
    gameType: 'LADDER',
    title: '주말 청소 구역',
    participants: ['김아빠', '박엄마', '김아들'],
    options: ['거실', '주방', '화장실'],
    result: {
      assignments: [
        { participant: '김아빠', option: '화장실' },
        { participant: '박엄마', option: '거실' },
        { participant: '김아들', option: '주방' },
      ],
    },
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
  for (const id of m.results ?? []) {
    try {
      await api(token, 'DELETE', `minigames/results/${id}`);
      ok++;
    } catch {
      fail++;
    }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(
    MANIFEST,
    JSON.stringify({ results: [], cleanedAt: now.toISOString() }, null, 2),
  );
}

async function tryCreate(label, fn) {
  try {
    return await fn();
  } catch (e) {
    console.log(`  ✗ ${label}: ${String(e.message).slice(0, 160)}`);
    return null;
  }
}

const asList = (r) => (Array.isArray(r) ? r : (r?.items ?? r?.data ?? []));

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken: token, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`);

  if (CLEANUP) return cleanup(token);

  const group = await pickGroup(token);
  const groupId = group.id;
  console.log('대상 그룹:', group.name, groupId);

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    for (const r of RESULTS) {
      console.log(`  ${r.gameType.padEnd(8)} "${r.title}" — 참여자 ${r.participants.length}명, 항목 ${r.options.length}개`);
    }
    return;
  }

  const existing = asList(
    await api(token, 'GET', `minigames/results?groupId=${groupId}`).catch(() => []),
  );
  const existingTitles = new Set(existing.map((r) => r.title));

  const created = { results: [], seededAt: now.toISOString() };
  // 오래된 것이 아래로 가도록 역순으로 넣습니다 (목록은 최신순)
  for (const r of [...RESULTS].reverse()) {
    if (existingTitles.has(r.title)) {
      console.log(`· "${r.title}": 이미 있어 건너뜁니다`);
      continue;
    }
    const res = await tryCreate(`"${r.title}"`, () =>
      api(token, 'POST', 'minigames/results', { groupId, ...r }),
    );
    if (res?.id) {
      created.results.push(res.id);
      console.log(`  ✓ ${r.gameType} "${r.title}"`);
    }
  }

  console.log(`\n게임 이력 생성: ${created.results.length}건`);

  let prev = { results: [] };
  if (existsSync(MANIFEST)) {
    try {
      prev = JSON.parse(readFileSync(MANIFEST, 'utf8'));
    } catch {
      /* 손상 시 새로 시작 */
    }
  }
  writeFileSync(
    MANIFEST,
    JSON.stringify(
      {
        results: [...new Set([...(prev.results ?? []), ...created.results])],
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-minigame.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
