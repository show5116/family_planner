/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (자산관리)
 *
 * 자산 화면은 계좌가 하나도 없으면 빈 목록만 찍힙니다.
 * 유형이 다른 계좌 4개와 3개월치 기록을 넣어 요약 카드·추이 차트·
 * 유형별 통계가 모두 값을 갖도록 만듭니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-assets.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-assets.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-assets.mjs --cleanup
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 기존 데이터는 수정/삭제하지 않고 추가만 합니다.
 * - 같은 이름의 계좌가 이미 있으면 건너뜁니다 (재실행해도 늘지 않음).
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-assets-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();
/** n개월 전 1일 (YYYY-MM-DD) */
const monthsAgo = (n) => {
  const d = new Date(now.getFullYear(), now.getMonth() - n, 1);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-01`;
};

/**
 * 계좌 4종 — 유형별 통계가 한 종류로 쏠리지 않게 섞습니다.
 * records는 오래된 것부터 넣어야 추이 차트가 자연스럽게 그려집니다.
 */
const ACCOUNTS = [
  {
    name: '주택청약',
    institution: '국민은행',
    type: 'SAVINGS',
    records: [
      { m: 2, balance: 12000000, principal: 12000000, profit: 0 },
      { m: 1, balance: 12500000, principal: 12500000, profit: 0 },
      { m: 0, balance: 13000000, principal: 13000000, profit: 0 },
    ],
  },
  {
    name: '비상금 통장',
    institution: '카카오뱅크',
    type: 'DEPOSIT',
    records: [
      { m: 2, balance: 5000000, principal: 5000000, profit: 0 },
      { m: 1, balance: 5200000, principal: 5200000, profit: 0 },
      { m: 0, balance: 5400000, principal: 5400000, profit: 0 },
    ],
  },
  {
    name: '연금저축펀드',
    institution: '미래에셋증권',
    type: 'FUND',
    records: [
      { m: 2, balance: 8200000, principal: 8000000, profit: 200000 },
      { m: 1, balance: 8600000, principal: 8300000, profit: 300000 },
      { m: 0, balance: 9150000, principal: 8600000, profit: 550000 },
    ],
  },
  {
    name: '해외주식 계좌',
    institution: '토스증권',
    type: 'STOCK',
    records: [
      { m: 2, balance: 6400000, principal: 6000000, profit: 400000 },
      { m: 1, balance: 6100000, principal: 6200000, profit: -100000 },
      { m: 0, balance: 7050000, principal: 6400000, profit: 650000 },
    ],
    // 보유 종목 — 계좌 상세의 종목 섹션이 비지 않게
    holdings: [
      { name: '애플', ticker: 'AAPL', ratio: 40 },
      { name: '마이크로소프트', ticker: 'MSFT', ratio: 35 },
      { name: 'S&P500 ETF', ticker: 'SPY', ratio: 25 },
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
  let ok = 0;
  let fail = 0;
  // 계좌를 지우면 기록·보유 종목도 함께 정리됩니다.
  for (const id of m.accounts ?? []) {
    try {
      await api(token, 'DELETE', `assets/accounts/${id}`);
      ok++;
    } catch {
      fail++;
    }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(MANIFEST, JSON.stringify({ accounts: [], cleanedAt: now.toISOString() }, null, 2));
}

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

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    console.log(`  계좌 ${ACCOUNTS.length}건`);
    console.log(`  자산 기록 ${ACCOUNTS.reduce((s, a) => s + a.records.length, 0)}건`);
    console.log(
      `  보유 종목 ${ACCOUNTS.reduce((s, a) => s + (a.holdings?.length ?? 0), 0)}건`,
    );
    return;
  }

  const created = { accounts: [], seededAt: now.toISOString() };

  const existing = await api(accessToken, 'GET', `assets/accounts?groupId=${groupId}`).catch(
    () => [],
  );
  const existingNames = new Set((Array.isArray(existing) ? existing : []).map((a) => a.name));

  let recordCount = 0;
  let holdingCount = 0;
  for (const acc of ACCOUNTS) {
    if (existingNames.has(acc.name)) {
      console.log(`· ${acc.name}: 이미 있어 건너뜁니다`);
      continue;
    }
    const res = await tryCreate(`계좌 "${acc.name}"`, () =>
      api(accessToken, 'POST', 'assets/accounts', {
        groupId,
        name: acc.name,
        institution: acc.institution,
        type: acc.type,
      }),
    );
    if (!res?.id) continue;
    created.accounts.push(res.id);

    // 오래된 기록부터 넣어야 추이 차트가 자연스럽습니다.
    for (const r of acc.records) {
      const ok = await tryCreate(`기록 "${acc.name}" ${monthsAgo(r.m)}`, () =>
        api(accessToken, 'POST', `assets/accounts/${res.id}/records`, {
          recordDate: monthsAgo(r.m),
          inputMode: 'manual',
          balance: r.balance,
          principal: r.principal,
          profit: r.profit,
        }),
      );
      if (ok) recordCount++;
    }

    for (const h of acc.holdings ?? []) {
      const ok = await tryCreate(`종목 "${h.name}"`, () =>
        api(accessToken, 'POST', `assets/accounts/${res.id}/holdings`, h),
      );
      if (ok) holdingCount++;
    }
  }

  console.log(
    `\n계좌 생성: ${created.accounts.length}건 / 기록 ${recordCount}건 / 보유 종목 ${holdingCount}건`,
  );

  let prev = { accounts: [] };
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
      { accounts: [...new Set([...(prev.accounts ?? []), ...created.accounts])], seededAt: created.seededAt },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-assets.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
