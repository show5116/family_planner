/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (육아 포인트)
 *
 * 자녀와 포인트 거래는 seed-dashboard.mjs가 이미 만듭니다.
 * 이 스크립트는 육아 포인트 화면의 **나머지 3개 탭**이 빈 화면으로 찍히지
 * 않도록 상점 아이템 · 규칙 · 적금 플랜 · 용돈 플랜을 채웁니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-childcare.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-childcare.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-childcare.mjs --cleanup
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 이름이 같으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 생성한 ID는 seed-childcare-manifest.json에 기록해 --cleanup으로 되돌립니다.
 *   (포인트 거래는 삭제 API가 없어 되돌릴 수 없으므로 만들지 않습니다.)
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-childcare-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();
const ymd = (d) =>
  `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
/** 이번 달 1일 */
const thisMonthFirst = () => ymd(new Date(now.getFullYear(), now.getMonth(), 1));
/** n개월 뒤 1일 */
const monthsLater = (n) => ymd(new Date(now.getFullYear(), now.getMonth() + n, 1));

/**
 * 상점 아이템 — 아이가 포인트로 바꿔 쓰는 것들.
 * 가격대를 낮음·중간·높음으로 벌려 목록이 단조롭지 않게 합니다.
 */
const SHOP_ITEMS = [
  { name: '유튜브 30분 더 보기', description: '평일 기준 30분 추가', points: 300 },
  { name: '아이스크림 사기', description: '편의점에서 하나 고르기', points: 500 },
  { name: '주말 놀이공원', description: '가족과 함께 하루 나들이', points: 3000 },
  { name: '친구 초대해서 놀기', description: '집에서 한 명 초대', points: 1500 },
];

/**
 * 규칙 — 세 가지 유형을 모두 넣어야 탭의 섹션 구분이 보입니다.
 * PLUS(적립) · MINUS(차감) · INFO(메모성, 포인트 없음)
 */
const RULES = [
  { name: '방 정리하기', description: '자기 전에 장난감과 옷 정리', type: 'PLUS', points: 500 },
  { name: '숙제 스스로 하기', description: '알려주지 않아도 먼저 시작하면', type: 'PLUS', points: 300 },
  { name: '심부름 다녀오기', description: '가까운 곳 다녀오기', type: 'PLUS', points: 200 },
  { name: '약속 시간 어기기', description: '귀가 시간을 지키지 않으면', type: 'MINUS', points: 300 },
  { name: '동생과 다투기', description: '먼저 손이 나가면', type: 'MINUS', points: 500 },
  { name: '식사 전 손 씻기', description: '포인트와 무관한 가족 약속', type: 'INFO' },
];

/** 적금 플랜 — 첫째만 넣어, 있는 상태와 없는 상태를 둘 다 보여줍니다. */
const SAVINGS_PLAN = {
  childName: '김민준',
  monthlyAmount: 1000,
  interestRate: 3.5,
  interestType: 'SIMPLE',
  startDate: thisMonthFirst(),
  endDate: monthsLater(12),
};

/**
 * 이번 달 포인트 거래.
 *
 * 히스토리 탭은 **이번 달** 기준으로 집계하므로, 지난달 거래만 있으면
 * "거래 내역이 없습니다"로 찍힙니다. 유형을 섞어야 도넛 차트도 값을 갖습니다.
 *
 * ⚠️ 포인트 거래는 삭제 API가 없어 --cleanup으로 되돌릴 수 없습니다.
 *    그래서 이번 달 거래가 하나라도 있으면 통째로 건너뜁니다.
 */
const TRANSACTIONS = [
  { type: 'ALLOWANCE', amount: 3000, description: '9월 용돈' },
  { type: 'REWARD', amount: 500, description: '방 정리 완료' },
  { type: 'REWARD', amount: 300, description: '숙제 스스로 하기' },
  { type: 'PENALTY', amount: 300, description: '약속 시간 어김' },
  { type: 'PURCHASE', amount: 500, description: '아이스크림 사기' },
];

/** 용돈 플랜 — 매달 정해진 포인트를 자동 지급 */
const ALLOWANCE_PLANS = [
  { childName: '김민준', monthlyPoints: 3000, payDay: 1, pointToMoneyRatio: 1, nextNegotiationDate: monthsLater(6) },
  { childName: '김서연', monthlyPoints: 2000, payDay: 1, pointToMoneyRatio: 1 },
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
  for (const { accountId, id } of m.shopItems ?? [])
    await del(`childcare/accounts/${accountId}/shop-items/${id}`);
  for (const { accountId, id } of m.rules ?? [])
    await del(`childcare/accounts/${accountId}/rules/${id}`);
  for (const accountId of m.savingsPlans ?? [])
    await del(`childcare/accounts/${accountId}/savings/plan`);
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  console.log('용돈 플랜은 삭제 API가 없어 남겨둡니다.');
  writeFileSync(
    MANIFEST,
    JSON.stringify({ shopItems: [], rules: [], savingsPlans: [], cleanedAt: now.toISOString() }, null, 2),
  );
}

async function tryCreate(label, fn) {
  try {
    return await fn();
  } catch (e) {
    console.log(`  ✗ ${label}: ${String(e.message).slice(0, 140)}`);
    return null;
  }
}

/** 응답이 배열이거나 {items|data} 래핑이거나 모두 대응 */
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
    console.log('\n[dry-run] 생성 예정 (자녀 1명당)');
    console.log(`  상점 아이템 ${SHOP_ITEMS.length}건, 규칙 ${RULES.length}건`);
    console.log(`  적금 플랜 1건(${SAVINGS_PLAN.childName}), 용돈 플랜 ${ALLOWANCE_PLANS.length}건`);
    return;
  }

  const children = asList(await api(accessToken, 'GET', `childcare/children?groupId=${groupId}`));
  const accounts = asList(await api(accessToken, 'GET', `childcare/accounts?groupId=${groupId}`));
  if (children.length === 0) {
    throw new Error('자녀가 없습니다. seed-dashboard.mjs를 먼저 실행하세요.');
  }

  const created = { shopItems: [], rules: [], savingsPlans: [], seededAt: now.toISOString() };

  for (const child of children) {
    const acc = accounts.find((a) => a.childId === child.id);
    if (!acc) {
      console.log(`· ${child.name}: 포인트 계정이 없어 건너뜁니다`);
      continue;
    }
    console.log(`\n[${child.name}]`);

    // 상점 아이템
    const existingShop = asList(
      await api(accessToken, 'GET', `childcare/accounts/${acc.id}/shop-items`).catch(() => []),
    );
    const shopNames = new Set(existingShop.map((s) => s.name));
    let n = 0;
    for (const item of SHOP_ITEMS) {
      if (shopNames.has(item.name)) continue;
      const r = await tryCreate(`상점 "${item.name}"`, () =>
        api(accessToken, 'POST', `childcare/accounts/${acc.id}/shop-items`, item),
      );
      if (r?.id) {
        created.shopItems.push({ accountId: acc.id, id: r.id });
        n++;
      }
    }
    console.log(`  상점 아이템: 신규 ${n}건 (기존 ${shopNames.size}건)`);

    // 규칙
    const existingRules = asList(
      await api(accessToken, 'GET', `childcare/accounts/${acc.id}/rules`).catch(() => []),
    );
    const ruleNames = new Set(existingRules.map((r) => r.name));
    n = 0;
    for (const rule of RULES) {
      if (ruleNames.has(rule.name)) continue;
      const r = await tryCreate(`규칙 "${rule.name}"`, () =>
        api(accessToken, 'POST', `childcare/accounts/${acc.id}/rules`, rule),
      );
      if (r?.id) {
        created.rules.push({ accountId: acc.id, id: r.id });
        n++;
      }
    }
    console.log(`  규칙: 신규 ${n}건 (기존 ${ruleNames.size}건)`);

    // 적금 플랜 (지정한 자녀만)
    if (child.name === SAVINGS_PLAN.childName) {
      const plan = await api(accessToken, 'GET', `childcare/accounts/${acc.id}/savings/plan`).catch(
        () => null,
      );
      if (plan?.id) {
        console.log('  적금 플랜: 이미 있어 건너뜁니다');
      } else {
        const { childName, ...body } = SAVINGS_PLAN;
        const r = await tryCreate('적금 플랜', () =>
          api(accessToken, 'POST', `childcare/accounts/${acc.id}/savings/plan`, body),
        );
        if (r?.id) {
          created.savingsPlans.push(acc.id);
          console.log('  적금 플랜: 생성');
        }
      }
    }

    // 이번 달 거래 (삭제 API가 없어 한 번만 넣습니다)
    const ym = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
    const txRes = await api(
      accessToken,
      'GET',
      `childcare/accounts/${acc.id}/transactions?month=${ym}`,
    ).catch(() => null);
    const thisMonthTx = txRes?.transactions ?? asList(txRes);
    if (thisMonthTx.length > 0) {
      console.log(`  이번 달 거래: ${thisMonthTx.length}건이 이미 있어 건너뜁니다`);
    } else {
      let c = 0;
      for (const tx of TRANSACTIONS) {
        const r = await tryCreate(`거래 "${tx.description}"`, () =>
          api(accessToken, 'POST', `childcare/accounts/${acc.id}/transactions`, tx),
        );
        if (r) c++;
      }
      console.log(`  이번 달 거래: ${c}건 생성`);
    }

    // 용돈 플랜 (POST가 생성·수정 겸용이라 중복 걱정 없음)
    const ap = ALLOWANCE_PLANS.find((p) => p.childName === child.name);
    if (ap) {
      const { childName, ...body } = ap;
      const r = await tryCreate('용돈 플랜', () =>
        api(accessToken, 'POST', `childcare/children/${child.id}/allowance-plan`, body),
      );
      if (r) console.log(`  용돈 플랜: 월 ${ap.monthlyPoints}P, ${ap.payDay}일 지급`);
    }
  }

  let prev = { shopItems: [], rules: [], savingsPlans: [] };
  if (existsSync(MANIFEST)) {
    try {
      prev = JSON.parse(readFileSync(MANIFEST, 'utf8'));
    } catch {
      /* 손상 시 새로 시작 */
    }
  }
  const key = (x) => `${x.accountId}:${x.id}`;
  const merge = (a, b) => {
    const seen = new Set(a.map(key));
    return [...a, ...b.filter((x) => !seen.has(key(x)))];
  };
  writeFileSync(
    MANIFEST,
    JSON.stringify(
      {
        shopItems: merge(prev.shopItems ?? [], created.shopItems),
        rules: merge(prev.rules ?? [], created.rules),
        savingsPlans: [...new Set([...(prev.savingsPlans ?? []), ...created.savingsPlans])],
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('\n매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-childcare.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
