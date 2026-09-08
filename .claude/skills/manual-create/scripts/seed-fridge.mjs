/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (냉장고)
 *
 * 냉장고 화면은 보관소가 하나도 없으면 "보관소가 없습니다" 빈 화면만 찍힙니다.
 * 보관 방법이 다른 보관소 3곳과, D-Day 뱃지 색이 모두 다르게 나오도록
 * 유통기한을 흩어놓은 품목들을 넣습니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-fridge.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-fridge.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-fridge.mjs --cleanup
 *
 * ⚠️ 유통기한이 **실행 시점 기준 상대 날짜**입니다. 하루만 지나도 D-Day 뱃지가
 *    밀리므로, 촬영 전에 --cleanup 후 다시 시딩하세요 (seed-all.mjs --refresh).
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 이름이 같은 보관소가 있으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 생성한 ID는 seed-fridge-manifest.json에 기록해 --cleanup으로 되돌립니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-fridge-manifest.json',
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

/**
 * 보관소 3종 + 품목.
 *
 * 매뉴얼에서 설명할 상태를 모두 덮도록 의도적으로 다르게 만듭니다.
 * - 보관 방법 3종 (냉장 / 냉동 / 팬트리) — 아이콘과 분류 라벨이 다릅니다
 * - D-Day 뱃지 4색 — 지남(D+) / 오늘(D-Day) / 3일 이내(주황) / 여유(파랑)
 * - 유통기한 없는 품목 — 뱃지가 붙지 않는 경우
 * - 단위 있음/없음, 메모 있음/없음
 * - 알림일(alertDaysBefore) 기본값 3과 다른 값
 */
const STORAGES = [
  {
    name: '냉장실',
    type: 'FRIDGE',
    items: [
      { name: '우유', quantity: 2, unit: '개', expiresAt: day(2), alertDaysBefore: 1, memo: '1L 팩' },
      { name: '두부', quantity: 1, unit: '모', expiresAt: day(0) },
      { name: '시금치', quantity: 1, unit: '단', expiresAt: day(-1), memo: '빨리 먹기' },
      { name: '딸기', quantity: 2, unit: '팩', expiresAt: day(4) },
      { name: '계란', quantity: 12, unit: '알', expiresAt: day(12), alertDaysBefore: 5 },
      { name: '김치', quantity: 1, unit: '통' },
    ],
  },
  {
    name: '냉동실',
    type: 'FREEZER',
    items: [
      { name: '소고기', quantity: 3, unit: '팩', expiresAt: day(90), memo: '국거리용' },
      { name: '만두', quantity: 2, unit: '봉', expiresAt: day(45) },
      { name: '아이스크림', quantity: 5, unit: '개' },
    ],
  },
  {
    name: '팬트리',
    type: 'PANTRY',
    items: [
      { name: '라면', quantity: 8, unit: '개', expiresAt: day(150) },
      { name: '쌀', quantity: 1, unit: '포', expiresAt: day(60), memo: '10kg' },
      { name: '참기름', quantity: 1, unit: '병', expiresAt: day(300) },
    ],
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
  // DELETE /fridge/storages/:id 는 groupId 쿼리 파라미터가 없으면 404입니다.
  const groupId = m.groupId ?? (await pickGroup(token)).id;
  let ok = 0;
  let fail = 0;
  // 보관소를 지우면 안에 있는 품목도 함께 삭제됩니다.
  for (const id of m.storages ?? []) {
    try {
      await api(token, 'DELETE', `fridge/storages/${id}?groupId=${groupId}`);
      ok++;
    } catch {
      fail++;
    }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(
    MANIFEST,
    JSON.stringify({ storages: [], groupId, cleanedAt: now.toISOString() }, null, 2),
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
    for (const s of STORAGES) {
      console.log(`  보관소 "${s.name}" (${s.type}) — 품목 ${s.items.length}건`);
    }
    return;
  }

  const existing = asList(
    await api(accessToken, 'GET', `fridge/storages?groupId=${groupId}`).catch(() => []),
  );
  const existingNames = new Set(existing.map((s) => s.name));

  const created = { storages: [], groupId, seededAt: now.toISOString() };
  let itemCount = 0;

  for (const storage of STORAGES) {
    if (existingNames.has(storage.name)) {
      console.log(`· ${storage.name}: 이미 있어 건너뜁니다`);
      continue;
    }
    const res = await tryCreate(`보관소 "${storage.name}"`, () =>
      api(accessToken, 'POST', 'fridge/storages', {
        groupId,
        name: storage.name,
        type: storage.type,
      }),
    );
    if (!res?.id) continue;
    created.storages.push(res.id);

    for (const item of storage.items) {
      const r = await tryCreate(`품목 "${item.name}"`, () =>
        api(accessToken, 'POST', 'fridge/items', {
          groupId,
          storageLocationId: res.id,
          ...item,
        }),
      );
      if (r) itemCount++;
    }
    console.log(`  ✓ ${storage.name} — 품목 ${storage.items.length}건`);
  }

  console.log(`\n보관소 생성: ${created.storages.length}건 / 품목 ${itemCount}건`);

  let prev = { storages: [] };
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
        storages: [...new Set([...(prev.storages ?? []), ...created.storages])],
        groupId,
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-fridge.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
