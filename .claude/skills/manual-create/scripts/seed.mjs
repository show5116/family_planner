/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (가계부)
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed.mjs            # 시딩
 *   node .claude/skills/manual-create/scripts/seed.mjs --cleanup  # 시딩분 삭제
 *   node .claude/skills/manual-create/scripts/seed.mjs --dry-run  # 생성 예정만 출력
 *
 * 안전 규칙
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 기존 데이터는 수정/삭제하지 않고 **추가만** 합니다.
 * - 생성한 리소스 ID를 seed-manifest.json에 기록해 --cleanup으로 되돌릴 수 있습니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(PROJECT_ROOT, '.claude/skills/manual-create/scripts/seed-manifest.json');
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

/** 스크린샷은 "이번 달" 화면을 찍으므로 현재 월 기준으로 날짜를 만듭니다. */
const now = new Date();
const Y = now.getFullYear();
const M = now.getMonth() + 1;
const d = (day) => `${Y}-${String(M).padStart(2, '0')}-${String(day).padStart(2, '0')}`;

/** 소비처 */
const MERCHANTS = ['이마트', '스타벅스', '쿠팡', 'GS주유소'];

/**
 * 지출/입금 내역.
 * 매뉴얼에서 다뤄야 할 케이스를 의도적으로 모두 포함합니다:
 * 수입, 카테고리 다양성, 결제수단 3종, 소비처 연결, 환불.
 */
const EXPENSES = [
  { type: 'INCOME', amount: 3200000, incomeCategory: 'SALARY', date: d(5), description: '이번 달 급여', paymentMethod: 'TRANSFER' },
  { type: 'INCOME', amount: 150000, incomeCategory: 'SIDE_INCOME', date: d(12), description: '부업 정산', paymentMethod: 'TRANSFER' },
  { type: 'EXPENSE', amount: 142000, category: 'GROCERIES', date: d(3), description: '마트 장보기', paymentMethod: 'CARD', merchant: '이마트' },
  { type: 'EXPENSE', amount: 6800, category: 'FOOD', date: d(4), description: '카페', paymentMethod: 'CARD', merchant: '스타벅스' },
  { type: 'EXPENSE', amount: 68000, category: 'FOOD', date: d(8), description: '가족 외식', paymentMethod: 'CARD' },
  { type: 'EXPENSE', amount: 55000, category: 'TRANSPORTATION', date: d(9), description: '주유', paymentMethod: 'CARD', merchant: 'GS주유소' },
  { type: 'EXPENSE', amount: 89000, category: 'LIVING', date: d(11), description: '생필품 구매', paymentMethod: 'CARD', merchant: '쿠팡' },
  { type: 'EXPENSE', amount: 320000, category: 'EDUCATION', date: d(14), description: '학원비', paymentMethod: 'TRANSFER' },
  { type: 'EXPENSE', amount: 45000, category: 'MEDICAL', date: d(16), description: '병원 진료비', paymentMethod: 'CASH' },
  { type: 'EXPENSE', amount: 30000, category: 'LEISURE', date: d(18), description: '영화 관람', paymentMethod: 'CARD' },
  { type: 'EXPENSE', amount: 120000, category: 'CELEBRATION', date: d(20), description: '결혼식 축의금', paymentMethod: 'CASH' },
  { type: 'EXPENSE', amount: 78000, category: 'COMMUNICATION', date: d(22), description: '통신비', paymentMethod: 'TRANSFER' },
];

/** 환불 케이스: 쿠팡 생필품 일부 반품 (원본 지출에 연결) */
const REFUND = { amount: 19000, category: 'LIVING', date: d(15), description: '생필품 일부 반품', linkTo: '생필품 구매' };

/** 고정지출 (반복 내역 화면용) */
const RECURRING = [
  { type: 'EXPENSE', amount: 850000, category: 'LIVING', description: '월세', dayOfMonth: 25, paymentMethod: 'TRANSFER' },
  { type: 'EXPENSE', amount: 62000, category: 'COMMUNICATION', description: '인터넷·TV', dayOfMonth: 15, paymentMethod: 'CARD' },
  { type: 'EXPENSE', amount: 13900, category: 'LEISURE', description: '넷플릭스 구독', dayOfMonth: 5, paymentMethod: 'CARD' },
  { type: 'EXPENSE', amount: 180000, category: 'LIVING', isVariable: true, description: '관리비 (변동)', dayOfMonth: 20, paymentMethod: 'TRANSFER' },
];

/** 예산 (예산 대비 사용량 진척도 표시용) */
const BUDGETS = [
  { category: 'FOOD', amount: 400000 },
  { category: 'GROCERIES', amount: 350000 },
  { category: 'TRANSPORTATION', amount: 200000 },
  { category: 'EDUCATION', amount: 400000 },
  { category: 'LIVING', amount: 300000 },
  { category: 'MEDICAL', amount: 150000 },
  { category: 'LEISURE', amount: 150000 },
  { category: 'COMMUNICATION', amount: 100000 },
];

/**
 * 시딩할 그룹을 고릅니다.
 *
 * `--group "이름"` 으로 지정할 수 있고, 없으면 내가 **소유한** 그룹을 우선합니다.
 * (소유 그룹이어야 예산 설정 등 관리자 기능까지 화면에 나옵니다.)
 */
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
  // 지출 → 고정지출 → 소비처 순으로 삭제 (참조 역순)
  for (const id of m.expenses ?? []) {
    try { await api(token, 'DELETE', `household/expenses/${id}`); ok++; } catch { fail++; }
  }
  for (const id of m.recurring ?? []) {
    try { await api(token, 'DELETE', `household/recurring-expenses/${id}`); ok++; } catch { fail++; }
  }
  for (const id of m.merchants ?? []) {
    try { await api(token, 'DELETE', `household/merchants/${id}`); ok++; } catch { fail++; }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(MANIFEST, JSON.stringify({ expenses: [], recurring: [], merchants: [], cleanedAt: new Date().toISOString() }, null, 2));
}

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`);

  if (CLEANUP) return cleanup(accessToken);

  const group = await pickGroup(accessToken);
  const groupId = group.id;
  console.log('대상 그룹:', group.name, groupId);
  console.log('대상 월:', `${Y}.${String(M).padStart(2, '0')}`);

  if (DRY_RUN) {
    console.log(`\n[dry-run] 생성 예정`);
    console.log(`  소비처 ${MERCHANTS.length}건, 지출/입금 ${EXPENSES.length}건 + 환불 1건`);
    console.log(`  고정지출 ${RECURRING.length}건, 예산 ${BUDGETS.length}건`);
    return;
  }

  const created = { expenses: [], recurring: [], merchants: [], groupId, seededAt: new Date().toISOString() };

  // 1) 소비처
  const merchantIds = {};
  const existing = await api(accessToken, 'GET', `household/merchants?groupId=${groupId}`).catch(() => []);
  for (const name of MERCHANTS) {
    const hit = (Array.isArray(existing) ? existing : []).find((m) => m.name === name);
    if (hit) { merchantIds[name] = hit.id; continue; } // 기존 것 재사용 (중복 생성 방지)
    const m = await api(accessToken, 'POST', 'household/merchants', { groupId, name });
    merchantIds[name] = m.id;
    created.merchants.push(m.id);
  }
  console.log(`소비처 준비: ${Object.keys(merchantIds).length}건 (신규 ${created.merchants.length})`);

  // 2) 지출/입금
  const byDescription = {};
  for (const e of EXPENSES) {
    const body = {
      groupId, type: e.type, amount: e.amount, date: e.date,
      description: e.description, paymentMethod: e.paymentMethod,
    };
    if (e.category) body.category = e.category;
    if (e.incomeCategory) body.incomeCategory = e.incomeCategory;
    if (e.merchant) body.merchantId = merchantIds[e.merchant];
    const r = await api(accessToken, 'POST', 'household/expenses', body);
    created.expenses.push(r.id);
    byDescription[e.description] = r.id;
  }
  console.log(`지출/입금 생성: ${created.expenses.length}건`);

  // 3) 환불 (원본 지출 연결)
  const origin = byDescription[REFUND.linkTo];
  if (origin) {
    const r = await api(accessToken, 'POST', 'household/expenses', {
      groupId, type: 'EXPENSE', amount: REFUND.amount, category: REFUND.category,
      date: REFUND.date, description: REFUND.description, refundedExpenseId: origin,
    });
    created.expenses.push(r.id);
    console.log('환불 내역 생성: 1건');
  }

  // 4) 고정지출
  for (const r of RECURRING) {
    const res = await api(accessToken, 'POST', 'household/recurring-expenses', {
      groupId, type: r.type, amount: r.amount, category: r.category,
      description: r.description, dayOfMonth: r.dayOfMonth,
      paymentMethod: r.paymentMethod, isVariable: r.isVariable ?? false,
    });
    created.recurring.push(res.id);
  }
  console.log(`고정지출 생성: ${created.recurring.length}건`);

  // 5) 예산 (bulk — 덮어쓰기 성격이라 매니페스트에 기록하지 않음)
  const budgetTotal = BUDGETS.reduce((s, b) => s + b.amount, 0);
  await api(accessToken, 'POST', 'household/budgets/bulk', {
    groupId,
    month: `${Y}-${String(M).padStart(2, '0')}`,
    total: budgetTotal,
    categories: BUDGETS.map((b) => ({ category: b.category, amount: b.amount })),
  }).then(() => console.log(`예산 설정: 전체 ${budgetTotal.toLocaleString()}원 + 카테고리 ${BUDGETS.length}건`))
    .catch((e) => console.log('예산 설정 건너뜀:', String(e).slice(0, 120)));

  // 여러 그룹에 나눠 시딩할 수 있으므로 기존 기록에 **누적**합니다.
  // (덮어쓰면 앞서 만든 데이터를 --cleanup으로 지울 수 없게 됩니다.)
  let prev = { expenses: [], recurring: [], merchants: [] };
  if (existsSync(MANIFEST)) {
    try { prev = JSON.parse(readFileSync(MANIFEST, 'utf8')); } catch { /* 손상 시 새로 시작 */ }
  }
  const merged = {
    expenses: [...new Set([...(prev.expenses ?? []), ...created.expenses])],
    recurring: [...new Set([...(prev.recurring ?? []), ...created.recurring])],
    merchants: [...new Set([...(prev.merchants ?? []), ...created.merchants])],
    seededAt: created.seededAt,
  };
  writeFileSync(MANIFEST, JSON.stringify(merged, null, 2));
  console.log('\n매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed.mjs --cleanup');
}

main().catch((e) => { console.error('시딩 실패:', e.message); process.exit(1); });
