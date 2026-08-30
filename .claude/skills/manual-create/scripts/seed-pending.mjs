/**
 * '대기중' (가입 승인 대기) 상태를 만들어 둡니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-pending.mjs
 *   node .claude/skills/manual-create/scripts/seed-pending.mjs --status  # 현재 상태만 확인
 *
 * 왜 필요한가
 *   그룹 매뉴얼의 "가입 신청 승인하기" 화면(04b-pending)은 **승인 대기 중인
 *   신청이 실제로 있어야** 승인/거부 버튼이 찍힙니다. 신청이 없으면
 *   `대기 중인 가입 요청이 없습니다` 빈 화면이 나옵니다.
 *
 *   그래서 김아들(test-owner2)을 김가네 가족에 PENDING 상태로 남겨둡니다.
 *   **이 신청을 승인하지 마세요.** 승인하면 촬영용 상태가 사라집니다.
 *
 * 동작
 *   이미 멤버라면 내보낸 뒤 초대 코드로 다시 가입 신청합니다.
 *   이미 PENDING이면 아무것도 하지 않습니다.
 */

import { login, api, apiBaseUrl } from './lib.mjs';

const STATUS_ONLY = process.argv.includes('--status');

/** 촬영용으로 대기 상태를 유지할 그룹·계정 */
const GROUP_NAME = '김가네 가족';
const APPLICANT = 'test-owner2@familyplanner.test';
const APPLICANT_NAME = '김아들';

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken } = await login();

  const groups = await api(accessToken, 'GET', 'groups');
  const group = groups.find((g) => g.name === GROUP_NAME);
  if (!group) throw new Error(`"${GROUP_NAME}" 그룹을 찾을 수 없습니다.`);

  const members = await api(accessToken, 'GET', `groups/${group.id}/members`);
  const list = members.members ?? members;
  const requests = await api(accessToken, 'GET', `groups/${group.id}/join-requests`);
  const pending = requests.filter((r) => r.status === 'PENDING');

  console.log(`\n그룹: ${group.name}`);
  console.log('멤버:', list.map((m) => `${m.user?.name}/${m.role?.name}`).join(', '));
  console.log('대기중:', pending.map((r) => r.email).join(', ') || '없음');

  if (STATUS_ONLY) return;

  if (pending.some((r) => r.email === APPLICANT)) {
    console.log(`\n✓ ${APPLICANT_NAME}이(가) 이미 대기중입니다. 그대로 둡니다.`);
    return;
  }

  // 이미 멤버면 내보내야 다시 신청할 수 있습니다.
  const asMember = list.find((m) => m.user?.email === APPLICANT);
  if (asMember) {
    await api(accessToken, 'DELETE', `groups/${group.id}/members/${asMember.user.id}`);
    console.log(`\n${APPLICANT_NAME} 내보냄 (대기 상태 재현용)`);
  }

  const applicant = await login(APPLICANT);
  const res = await api(applicant.accessToken, 'POST', 'groups/join', {
    inviteCode: group.inviteCode,
  });
  console.log(`${APPLICANT_NAME} 가입 신청: ${res.status}`);
  console.log('\n✓ 대기중 상태 준비 완료. 이 신청은 승인하지 마세요.');
}

main().catch((e) => { console.error('실패:', e.message); process.exit(1); });
