/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (장보기)
 *
 * 장보기는 탭이 셋이라 셋 다 값이 있어야 합니다.
 *   장바구니 / 자주 사는 것 / 구매 이력
 *
 * 구매 이력은 따로 만드는 API가 없습니다. **장바구니를 채우고 완료 처리**해야
 * 이력이 생깁니다. 그래서 순서가 중요합니다.
 *   자주 사는 것 → 이력용 장바구니 채우고 완료(2회) → 화면에 남길 장바구니 채우기
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-shopping.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-shopping.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-shopping.mjs --cleanup
 *
 * ⚠️ seed-fridge.mjs 를 먼저 돌려야 합니다. 이력 하나가 품목을 **팬트리**로
 *    이관하는데, 보관소가 없으면 이관 없는 이력만 만들어집니다.
 *    이관 대상을 팬트리로 둔 이유는 냉장고 매뉴얼 스크린샷(냉장실·냉동실)을
 *    건드리지 않기 위해서입니다.
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 이미 있으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 생성한 ID는 seed-shopping-manifest.json에 기록해 --cleanup으로 되돌립니다.
 *   이력을 지워도 이관된 냉장고 품목은 서버가 남기므로 매니페스트에 따로 적어 함께 지웁니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-shopping-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();

/** 오늘 기준 offset일 뒤 날짜를 'YYYY-MM-DD'로 */
function day(offset) {
  const d = new Date(now.getFullYear(), now.getMonth(), now.getDate() + offset);
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}`;
}

/** 오늘 기준 offset일 전 시각 (ISO) */
function ago(days, hour = 18) {
  const d = new Date(now.getFullYear(), now.getMonth(), now.getDate() - days, hour, 30);
  return d.toISOString();
}

/**
 * 자주 사는 것 5종.
 *
 * `소진 시 자동 장바구니` 스위치가 켜진 것과 꺼진 것을 섞고,
 * 기본 단위가 없는 항목도 하나 둡니다.
 */
const FREQUENT = [
  { name: '우유', defaultUnit: '개', autoAdd: true },
  { name: '계란', defaultUnit: '판', autoAdd: true },
  { name: '두부', defaultUnit: '모', autoAdd: true },
  { name: '화장지', defaultUnit: '팩', autoAdd: false },
  { name: '주방세제', autoAdd: false },
];

/**
 * 구매 이력 2건.
 *
 * 매뉴얼에서 설명할 상태를 갈라 놓습니다.
 * - 가계부 연동 O / X  → 목록의 `가계부 연결됨` 배지
 * - 냉장고 이관 O / X  → 상세의 `냉장고에 이관됨` / `이관 안 함`
 * - 금액 있음 / 없음   → 상세의 `가격 미입력`
 */
const HISTORIES = [
  {
    label: '마트 장보기',
    daysAgo: 3,
    items: [
      { name: '밀가루', quantity: 1, unit: '포', price: 3200, toPantry: true, expiresInDays: 180 },
      { name: '설탕', quantity: 1, unit: '봉', price: 2800, toPantry: true, expiresInDays: 365 },
      { name: '주방세제', quantity: 1, unit: '개', price: 4900 },
      { name: '화장지', quantity: 1, unit: '팩', price: 12900 },
    ],
    expense: { paymentMethod: 'CARD', description: '마트 장보기' },
  },
  {
    label: '동네 슈퍼',
    daysAgo: 10,
    items: [
      { name: '커피', quantity: 2, unit: '봉', price: 8900 },
      { name: '물티슈', quantity: 3, unit: '개' }, // 금액 미입력 케이스
    ],
    // 가계부 미등록 · 이관 없음
  },
];

/**
 * 화면에 남길 장바구니 5건.
 *
 * 금액 있음/없음, 메모 있음/없음, 단위 있음/없음을 섞어
 * 합계 바와 품목 줄의 보조 정보가 모두 보이게 합니다.
 */
const CART = [
  { name: '우유', quantity: 2, unit: '개', price: 3500 },
  { name: '계란', quantity: 1, unit: '판', price: 6900 },
  { name: '사과', quantity: 5, unit: '개' },
  { name: '화장지', quantity: 1, unit: '팩', price: 12900, memo: '3겹' },
  { name: '커피', quantity: 2, unit: '봉' },
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
  const del = async (label, ep) => {
    try {
      await api(token, 'DELETE', ep);
      return true;
    } catch {
      return false;
    }
  };

  let ok = 0;
  let fail = 0;
  for (const id of m.cartItems ?? []) {
    (await del('장바구니', `shopping/cart/items/${id}?groupId=${groupId}`)) ? ok++ : fail++;
  }
  for (const id of m.histories ?? []) {
    (await del('이력', `shopping/history/${id}?groupId=${groupId}`)) ? ok++ : fail++;
  }
  // 이력을 지워도 이관된 냉장고 품목은 남습니다 (서버 정책)
  for (const id of m.fridgeItems ?? []) {
    (await del('이관 품목', `fridge/items/${id}?groupId=${groupId}`)) ? ok++ : fail++;
  }
  for (const id of m.frequentItems ?? []) {
    (await del('자주 사는 것', `fridge/frequent-items/${id}?groupId=${groupId}`)) ? ok++ : fail++;
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(
    MANIFEST,
    JSON.stringify(
      { frequentItems: [], histories: [], fridgeItems: [], cartItems: [], groupId, cleanedAt: now.toISOString() },
      null,
      2,
    ),
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
    console.log(`  자주 사는 것 ${FREQUENT.length}건`);
    for (const h of HISTORIES) {
      const t = h.items.filter((i) => i.toPantry).length;
      console.log(`  구매 이력 "${h.label}" — 품목 ${h.items.length}건, 팬트리 이관 ${t}건, 가계부 ${h.expense ? 'O' : 'X'}`);
    }
    console.log(`  장바구니 ${CART.length}건`);
    return;
  }

  const created = {
    frequentItems: [],
    histories: [],
    fridgeItems: [],
    cartItems: [],
    groupId,
    seededAt: now.toISOString(),
  };

  // ── 1) 자주 사는 것 ──────────────────────────────────────────────────────
  // 냉장고 품목의 frequentItemId는 **품목을 만들 때** 이름으로 연결되므로
  // 자주 사는 것을 먼저 만들어 둡니다.
  const existingFreq = asList(
    await api(token, 'GET', `fridge/frequent-items?groupId=${groupId}`).catch(() => []),
  );
  const freqNames = new Set(existingFreq.map((f) => f.name));
  for (const f of FREQUENT) {
    if (freqNames.has(f.name)) {
      console.log(`· 자주 사는 것 "${f.name}": 이미 있어 건너뜁니다`);
      continue;
    }
    const res = await tryCreate(`자주 사는 것 "${f.name}"`, () =>
      api(token, 'POST', 'fridge/frequent-items', { groupId, ...f }),
    );
    if (res?.id) created.frequentItems.push(res.id);
  }
  console.log(`  ✓ 자주 사는 것 ${created.frequentItems.length}건`);

  // ── 2) 구매 이력 ────────────────────────────────────────────────────────
  const historyRes = await api(token, 'GET', `shopping/history?groupId=${groupId}`).catch(() => null);
  const historyTotal = historyRes?.total ?? asList(historyRes).length;

  if (historyTotal > 0) {
    console.log(`· 구매 이력: 이미 ${historyTotal}건 있어 건너뜁니다`);
  } else {
    const storages = asList(await api(token, 'GET', `fridge/storages?groupId=${groupId}`).catch(() => []));
    const pantry = storages.find((s) => s.type === 'PANTRY');
    if (!pantry) {
      console.log('  ⚠ 팬트리 보관소가 없습니다. 이관 없는 이력만 만듭니다 (seed-fridge.mjs 먼저 실행하세요).');
    }

    for (const h of HISTORIES) {
      // 장바구니에 넣고 → 완료 처리하면 이력이 됩니다
      const cart = await tryCreate(`이력 "${h.label}" 장바구니 담기`, () =>
        api(token, 'PATCH', 'shopping/cart/items/bulk', {
          groupId,
          inserts: h.items.map(({ toPantry, expiresInDays, ...i }) => i),
        }),
      );
      if (!cart) continue;

      const byName = new Map((cart.items ?? []).map((i) => [i.name, i]));
      const transfers = pantry
        ? h.items
            .filter((i) => i.toPantry && byName.has(i.name))
            .map((i) => ({
              cartItemId: byName.get(i.name).id,
              storageLocationId: pantry.id,
              quantity: i.quantity,
              unit: i.unit,
              price: i.price,
              expiresAt: day(i.expiresInDays ?? 90),
            }))
        : [];

      const res = await tryCreate(`이력 "${h.label}" 완료 처리`, () =>
        api(token, 'POST', 'shopping/cart/complete', {
          groupId,
          completedAt: ago(h.daysAgo),
          transfers,
          ...(h.expense
            ? {
                expense: {
                  ...h.expense,
                  date: day(-h.daysAgo),
                  amount: h.items.reduce((s, i) => s + (i.price ?? 0), 0),
                },
              }
            : {}),
        }),
      );
      if (!res?.id) continue;
      created.histories.push(res.id);
      for (const item of res.items ?? []) {
        if (item.fridgeItemId) created.fridgeItems.push(item.fridgeItemId);
      }
      console.log(`  ✓ 이력 "${h.label}" — 품목 ${h.items.length}건, 이관 ${transfers.length}건`);
    }
  }

  // ── 3) 화면에 남길 장바구니 ──────────────────────────────────────────────
  const cartNow = await api(token, 'GET', `shopping/cart?groupId=${groupId}`).catch(() => null);
  if ((cartNow?.items ?? []).length > 0) {
    console.log(`· 장바구니: 이미 ${cartNow.items.length}건 있어 건너뜁니다`);
  } else {
    const res = await tryCreate('장바구니 담기', () =>
      api(token, 'PATCH', 'shopping/cart/items/bulk', { groupId, inserts: CART }),
    );
    for (const item of res?.items ?? []) created.cartItems.push(item.id);
    console.log(`  ✓ 장바구니 ${created.cartItems.length}건`);
  }

  // ── 매니페스트 ──────────────────────────────────────────────────────────
  let prev = {};
  if (existsSync(MANIFEST)) {
    try {
      prev = JSON.parse(readFileSync(MANIFEST, 'utf8'));
    } catch {
      /* 손상 시 새로 시작 */
    }
  }
  const merge = (k) => [...new Set([...(prev[k] ?? []), ...created[k]])];
  writeFileSync(
    MANIFEST,
    JSON.stringify(
      {
        frequentItems: merge('frequentItems'),
        histories: merge('histories'),
        fridgeItems: merge('fridgeItems'),
        cartItems: merge('cartItems'),
        groupId,
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('\n매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-shopping.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
