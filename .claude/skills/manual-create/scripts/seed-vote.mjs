/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (투표)
 *
 * 투표가 하나도 없으면 "아직 투표가 없습니다"만 찍힙니다.
 * 매뉴얼에서 설명할 상태를 모두 덮도록 네 가지를 만듭니다.
 *   - 진행중 / 종료됨       → 목록 상단 필터 칩 양쪽
 *   - 복수 선택 / 익명       → 제목 옆 배지
 *   - 마감 있음 / 없음       → `N일 후 마감` vs 표시 없음
 *   - 내가 참여함 / 미참여   → `참여함` 배지, 상세의 투표하기 vs 재투표하기
 *
 * 득표수를 만들려면 두 계정이 필요해서 김아빠(owner)와 박엄마(member)로
 * 각각 로그인해 표를 던집니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-vote.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-vote.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-vote.mjs --cleanup
 *
 * ⚠️ 마감 시각이 **실행 시점 기준 상대 시각**입니다. `N일 후 마감` 문구가 밀리므로
 *    촬영 전에 --cleanup 후 다시 시딩하세요 (seed-all.mjs --refresh).
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 같은 제목이 있으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 생성한 ID는 seed-vote-manifest.json에 기록해 --cleanup으로 되돌립니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, TEST_ACCOUNTS, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-vote-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();

/** 지금부터 offset일 뒤 시각 (ISO) */
function inDays(offset, hour = 21) {
  const d = new Date(now.getFullYear(), now.getMonth(), now.getDate() + offset, hour, 0);
  return d.toISOString();
}

/** 지금부터 n초 뒤 시각 (ISO) */
function inSeconds(n) {
  return new Date(now.getTime() + n * 1000).toISOString();
}

/**
 * 종료된 투표를 만드는 방법.
 *
 * 마감이 지난 투표에는 표를 던질 수 없습니다("마감된 투표입니다" 400).
 * 그렇다고 마감을 과거로 두고 만들면 득표 0인 빈 투표가 되어 결과 화면을 못 찍습니다.
 * 그래서 **곧 마감되도록** 만들어 표를 먼저 넣고, 마감 시각이 지날 때까지 기다립니다.
 */
const CLOSE_AFTER_SEC = 100;

/**
 * 투표 4종.
 *
 * `ownerPick` / `memberPick` 은 **선택지 라벨**입니다 (ID는 생성 후에 알 수 있습니다).
 * 배열로 주면 복수 선택입니다.
 */
const VOTES = [
  {
    title: '이번 주말 나들이 어디로?',
    description: '토요일 오전에 출발하는 걸로 생각하고 골라주세요',
    options: ['한강 피크닉', '에버랜드', '근교 캠핑', '집에서 쉬기'],
    endsAt: inDays(3),
    ownerPick: ['한강 피크닉'],
    memberPick: ['근교 캠핑'],
  },
  {
    title: '저녁 메뉴 정하기',
    description: '먹고 싶은 걸 여러 개 골라도 됩니다',
    options: ['삼겹살', '치킨', '파스타', '김치찌개'],
    isMultiple: true,
    // 마감 없음 — 수동 종료
    ownerPick: ['삼겹살', '김치찌개'],
    memberPick: ['치킨'],
  },
  {
    title: '가족 여행 시기',
    description: '눈치 보지 말고 편하게 골라주세요',
    options: ['5월 연휴', '여름 방학', '10월 연휴'],
    isAnonymous: true,
    endsAt: inDays(7),
    // 김아빠는 아직 미참여 — 상세에서 `투표하기` 버튼이 보입니다
    memberPick: ['여름 방학'],
  },
  {
    title: '이번 달 외식 장소',
    description: '지난달에 정했던 투표입니다',
    options: ['중식당', '초밥집', '파스타집'],
    endsAt: inSeconds(CLOSE_AFTER_SEC), // 표를 넣은 뒤 마감되도록
    waitUntilClosed: true,
    ownerPick: ['초밥집'],
    memberPick: ['초밥집'],
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
  const groupId = m.groupId ?? (await pickGroup(token)).id;
  let ok = 0;
  let fail = 0;
  for (const id of m.votes ?? []) {
    try {
      await api(token, 'DELETE', `votes/${groupId}/${id}`);
      ok++;
    } catch {
      fail++;
    }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(
    MANIFEST,
    JSON.stringify({ votes: [], groupId, cleanedAt: now.toISOString() }, null, 2),
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

/** 라벨 목록 → 선택지 ID 목록 */
function idsFor(vote, labels) {
  return (labels ?? [])
    .map((l) => vote.options.find((o) => o.label === l)?.id)
    .filter(Boolean);
}

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken: ownerToken, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`);

  if (CLEANUP) return cleanup(ownerToken);

  const group = await pickGroup(ownerToken);
  const groupId = group.id;
  console.log('대상 그룹:', group.name, groupId);

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    for (const v of VOTES) {
      const flags = [
        v.isMultiple ? '복수선택' : null,
        v.isAnonymous ? '익명' : null,
        v.endsAt ? (new Date(v.endsAt) < now ? '종료됨' : '마감있음') : '마감없음',
      ].filter(Boolean);
      console.log(`  "${v.title}" — 선택지 ${v.options.length}개 [${flags.join(', ')}]`);
    }
    return;
  }

  // 박엄마 표를 던지려면 멤버 토큰이 필요합니다
  let memberToken = null;
  try {
    memberToken = (await login(TEST_ACCOUNTS.member)).accessToken;
  } catch {
    console.log('  ⚠ 멤버 계정 로그인 실패 — 김아빠 표만 넣습니다');
  }

  const existing = asList(await api(ownerToken, 'GET', `votes/${groupId}`).catch(() => []));
  const existingTitles = new Set(existing.map((v) => v.title));

  const created = { votes: [], groupId, seededAt: now.toISOString() };
  let ballots = 0;

  // 목록은 최신순이라 역순으로 만들어 위 순서를 맞춥니다
  for (const v of [...VOTES].reverse()) {
    if (existingTitles.has(v.title)) {
      console.log(`· "${v.title}": 이미 있어 건너뜁니다`);
      continue;
    }
    const { ownerPick, memberPick, waitUntilClosed, ...body } = v;
    const res = await tryCreate(`투표 "${v.title}"`, () =>
      api(ownerToken, 'POST', `votes/${groupId}`, body),
    );
    if (!res?.id) continue;
    created.votes.push(res.id);

    for (const [token, picks, who] of [
      [ownerToken, ownerPick, '김아빠'],
      [memberToken, memberPick, '박엄마'],
    ]) {
      if (!token || !picks?.length) continue;
      const optionIds = idsFor(res, picks);
      if (optionIds.length === 0) continue;
      const r = await tryCreate(`${who} 투표`, () =>
        api(token, 'POST', `votes/${groupId}/${res.id}/ballots`, { optionIds }),
      );
      if (r) ballots++;
    }
    console.log(`  ✓ "${v.title}"`);
  }

  console.log(`\n투표 생성: ${created.votes.length}건 / 참여 ${ballots}건`);

  // 곧 마감되는 투표가 있으면 마감될 때까지 기다립니다 (--no-wait 로 건너뜀)
  const needsWait = VOTES.some((v) => v.waitUntilClosed) && !process.argv.includes('--no-wait');
  if (needsWait && created.votes.length > 0) {
    const ms = CLOSE_AFTER_SEC * 1000 - (Date.now() - now.getTime()) + 5000;
    if (ms > 0) {
      console.log(`\n"${VOTES.find((v) => v.waitUntilClosed).title}" 마감까지 ${Math.ceil(ms / 1000)}초 대기합니다...`);
      await new Promise((r) => setTimeout(r, ms));
      console.log('마감 완료 — 이제 종료됨 상태로 보입니다');
    }
  }

  let prev = { votes: [] };
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
        votes: [...new Set([...(prev.votes ?? []), ...created.votes])],
        groupId,
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-vote.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
