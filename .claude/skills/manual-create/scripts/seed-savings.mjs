/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (그룹 저금통)
 *
 * 저금통 화면은 목표가 없으면 빈 목록만 찍힙니다.
 * 상태가 다른 목표 4개와 입출금 내역을 넣어 목록·상세·내역 화면이
 * 모두 값을 갖도록 만듭니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-savings.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-savings.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-savings.mjs --cleanup
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 이름이 같으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 생성한 ID는 seed-savings-manifest.json에 기록해 --cleanup으로 되돌립니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-savings-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();

/**
 * 적립 목표 4종.
 *
 * 매뉴얼에서 설명할 상태를 모두 덮도록 의도적으로 다르게 만듭니다.
 * - 자동 적립 ON/OFF
 * - 목표 금액 있음 / 없음(무기한 적립)
 * - 자산 통계 연동 ON/OFF
 * - 달성률 낮음 / 중간 / 100% 달성
 */
const GOALS = [
  {
    name: '제주도 가족여행',
    description: '내년 여름 4인 가족 항공권과 숙소',
    targetAmount: 3000000,
    autoDeposit: true,
    monthlyAmount: 300000,
    depositDay: 25,
    includeInAssets: true,
    // 달성률 40% + 출금 이력까지 보여주기
    deposits: [600000, 300000, 300000],
    withdrawals: [{ amount: 100000, description: '항공권 예약금 결제' }],
  },
  {
    name: '아이 학원비',
    description: '분기마다 목돈이 나가서 미리 모아둡니다',
    targetAmount: 1200000,
    autoDeposit: true,
    monthlyAmount: 200000,
    depositDay: 1,
    includeInAssets: true,
    deposits: [200000, 200000],
  },
  {
    name: '비상금',
    // 목표 금액 없이 무기한 적립하는 경우
    description: '급한 일이 생겼을 때를 위해',
    autoDeposit: false,
    includeInAssets: true,
    deposits: [500000, 150000],
  },
  {
    name: '김치냉장고 바꾸기',
    description: '10년 썼습니다',
    targetAmount: 800000,
    autoDeposit: false,
    includeInAssets: false,
    // 목표 달성 상태 — "목표 금액 달성!" 표시를 찍기 위해
    deposits: [500000, 300000],
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
  // 목표를 지우면 그 안의 거래 내역도 함께 정리됩니다.
  for (const id of m.goals ?? []) {
    try {
      await api(token, 'DELETE', `savings/${id}`);
      ok++;
    } catch {
      fail++;
    }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(MANIFEST, JSON.stringify({ goals: [], cleanedAt: now.toISOString() }, null, 2));
}

async function tryCreate(label, fn) {
  try {
    return await fn();
  } catch (e) {
    console.log(`  ✗ ${label}: ${String(e.message).slice(0, 140)}`);
    return null;
  }
}

const asList = (r) => (Array.isArray(r) ? r : (r?.items ?? r?.data ?? []));

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`);

  if (CLEANUP) return cleanup(accessToken);

  const group = await pickGroup(accessToken);
  const groupId = group.id;
  console.log('대상 그룹:', group.name, groupId);

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    console.log(`  적립 목표 ${GOALS.length}건`);
    const dep = GOALS.reduce((s, g) => s + (g.deposits?.length ?? 0), 0);
    const wd = GOALS.reduce((s, g) => s + (g.withdrawals?.length ?? 0), 0);
    console.log(`  입금 ${dep}건, 출금 ${wd}건`);
    return;
  }

  const existing = asList(await api(accessToken, 'GET', `savings?groupId=${groupId}`).catch(() => []));
  const existingNames = new Set(existing.map((g) => g.name));

  const created = { goals: [], seededAt: now.toISOString() };
  let depositCount = 0;
  let withdrawCount = 0;

  for (const goal of GOALS) {
    if (existingNames.has(goal.name)) {
      console.log(`· ${goal.name}: 이미 있어 건너뜁니다`);
      continue;
    }
    const { deposits = [], withdrawals = [], ...body } = goal;
    const res = await tryCreate(`목표 "${goal.name}"`, () =>
      api(accessToken, 'POST', 'savings', { groupId, ...body }),
    );
    if (!res?.id) continue;
    created.goals.push(res.id);

    for (const amount of deposits) {
      const r = await tryCreate(`입금 ${amount}원`, () =>
        api(accessToken, 'POST', `savings/${res.id}/deposit`, { amount }),
      );
      if (r) depositCount++;
    }
    // 출금은 사용 목적(description)이 필수입니다.
    for (const w of withdrawals) {
      const r = await tryCreate(`출금 ${w.amount}원`, () =>
        api(accessToken, 'POST', `savings/${res.id}/withdraw`, {
          amount: w.amount,
          description: w.description,
        }),
      );
      if (r) withdrawCount++;
    }
    console.log(`  ✓ ${goal.name} — 입금 ${deposits.length}건, 출금 ${withdrawals.length}건`);
  }

  console.log(
    `\n목표 생성: ${created.goals.length}건 / 입금 ${depositCount}건 / 출금 ${withdrawCount}건`,
  );

  let prev = { goals: [] };
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
      { goals: [...new Set([...(prev.goals ?? []), ...created.goals])], seededAt: created.seededAt },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-savings.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
