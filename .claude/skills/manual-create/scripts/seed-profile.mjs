/**
 * 테스트 계정·그룹 이름을 매뉴얼용 "정감 있는" 이름으로 바꿉니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-profile.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-profile.mjs
 *
 * 왜 필요한가
 *   기본값인 "테스트 그룹장", "테스트 가족 2"는 스크린샷에 그대로 찍혀
 *   사용자 매뉴얼로 쓰기에 딱딱합니다. 김아빠·박엄마·김아들 / 김가네 가족처럼
 *   실제 사용 장면에 가까운 이름으로 바꿉니다.
 *
 * 안전 규칙
 *   - 개발 백엔드에만 적용합니다.
 *   - 이름(name)만 바꾸고 비밀번호·이메일은 건드리지 않습니다.
 *   - 되돌리려면 --revert 를 쓰세요.
 */

import { login, api, apiBaseUrl, TEST_ACCOUNTS, TEST_PASSWORD } from './lib.mjs';

const DRY_RUN = process.argv.includes('--dry-run');
const REVERT = process.argv.includes('--revert');

/** 계정별 표시 이름 (이메일 → 이름) */
const PROFILES = [
  { email: TEST_ACCOUNTS.owner, friendly: '김아빠', original: '테스트 그룹장', color: '#4A90D9' },
  { email: TEST_ACCOUNTS.member, friendly: '박엄마', original: '테스트 멤버', color: '#E8739B' },
  { email: 'test-owner2@familyplanner.test', friendly: '김아들', original: '테스트 그룹장2', color: '#5FBF77' },
];

/** 그룹 이름 (원래 이름 → 바꿀 이름) */
const GROUPS = [
  { original: '테스트 가족', friendly: '김가네 가족', description: '우리 집 일정과 살림을 함께 관리해요' },
  { original: '테스트 가족 2', friendly: '김가네 이웃 모임', description: '동네 이웃들과 함께하는 모임' },
];

async function renameUser(p) {
  const target = REVERT ? p.original : p.friendly;
  // 각 계정으로 로그인해야 자기 프로필을 바꿀 수 있습니다.
  let token;
  try {
    ({ accessToken: token } = await login(p.email));
  } catch (e) {
    console.log(`  ⚠ ${p.email} 로그인 실패 — 건너뜁니다 (${String(e).slice(0, 60)})`);
    return;
  }
  await api(token, 'PATCH', 'auth/update-profile', {
    name: target,
    // LOCAL 계정은 현재 비밀번호를 함께 보내야 합니다.
    currentPassword: TEST_PASSWORD,
    ...(REVERT ? {} : { personalColor: p.color }),
  });
  console.log(`  ✓ ${p.email} → ${target}`);
}

async function renameGroups(token) {
  const groups = await api(token, 'GET', 'groups');
  for (const spec of GROUPS) {
    const from = REVERT ? spec.friendly : spec.original;
    const to = REVERT ? spec.original : spec.friendly;
    const hit = groups.find((g) => g.name === from);
    if (!hit) continue; // 이미 바뀌었거나 이 계정 소속이 아님
    if (hit.myRole?.name !== 'OWNER') {
      // 그룹 이름 변경은 소유자만 가능합니다.
      console.log(`  ⚠ "${from}" 은 소유자가 아니라 이름을 바꿀 수 없습니다 (myRole=${hit.myRole?.name})`);
      continue;
    }
    await api(token, 'PATCH', `groups/${hit.id}`, {
      name: to,
      ...(REVERT ? {} : { description: spec.description }),
    });
    console.log(`  ✓ "${from}" → "${to}"`);
  }
}

async function main() {
  console.log('API:', apiBaseUrl());
  console.log(REVERT ? '모드: 원래 이름으로 되돌리기' : '모드: 매뉴얼용 이름 적용');

  if (DRY_RUN) {
    console.log('\n[dry-run] 계정 이름');
    for (const p of PROFILES) console.log(`  ${p.email}: ${p.original} → ${p.friendly}`);
    console.log('[dry-run] 그룹 이름');
    for (const g of GROUPS) console.log(`  ${g.original} → ${g.friendly}`);
    return;
  }

  console.log('\n계정 이름 변경');
  for (const p of PROFILES) await renameUser(p);

  // 그룹 이름은 소유자만 바꿀 수 있습니다. 테스트 그룹마다 소유자가 달라서
  // 계정을 번갈아 로그인하며 각자 소유한 그룹을 처리합니다.
  console.log('\n그룹 이름 변경');
  for (const email of [TEST_ACCOUNTS.owner, 'test-owner2@familyplanner.test']) {
    let token;
    try {
      ({ accessToken: token } = await login(email));
    } catch {
      continue;
    }
    await renameGroups(token);
  }

  console.log('\n완료. 되돌리려면 --revert 를 붙여 실행하세요.');
}

main().catch((e) => { console.error('실패:', e.message); process.exit(1); });
