/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (Q&A)
 *
 * 질문이 없으면 "등록된 질문이 없습니다"만 찍힙니다.
 * 매뉴얼에서 설명할 상태를 덮도록 다섯 건을 만듭니다.
 *   - 상태: 답변 대기 / 답변 완료 / 해결됨
 *   - 공개 범위: 공개 / 비공개
 *   - 카테고리: 사용법 · 버그 · 기능 요청 · 결제 등 골고루
 *
 * ⚠️ **답변 작성은 운영자(ADMIN) 전용**입니다 (`qna-admin.controller.ts`).
 *    개발 DB에서 테스트 계정을 잠깐 운영자로 올린 뒤 시딩하고,
 *    **촬영 전에 반드시 되돌려야** 합니다. 운영자 상태로 찍으면 Q&A 상세에
 *    답변 작성 폼이 보이고, 투자 지표·공지사항에도 관리자 버튼이 나타납니다.
 *
 *      cd ../family_planner_back_end && node -e "const{PrismaClient}=require('@prisma/client');const p=new PrismaClient();p.user.update({where:{email:'test-owner@familyplanner.test'},data:{isAdmin:true}}).then(()=>p.\$disconnect())" && cd -
 *      node .claude/skills/manual-create/scripts/seed-qna.mjs
 *      cd ../family_planner_back_end && node -e "const{PrismaClient}=require('@prisma/client');const p=new PrismaClient();p.user.update({where:{email:'test-owner@familyplanner.test'},data:{isAdmin:false}}).then(()=>p.\$disconnect())" && cd -
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-qna.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-qna.mjs
 *   node .claude/skills/manual-create/scripts/seed-qna.mjs --cleanup
 *
 * 안전 규칙 (seed.mjs와 동일)
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션 금지.
 * - 같은 제목이 있으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 기존에 있던 다른 사람의 질문은 건드리지 않습니다 (내 질문이 최신이라 위에 옵니다).
 * - 생성한 ID는 seed-qna-manifest.json에 기록해 --cleanup으로 되돌립니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-qna-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();

/**
 * 질문 5건.
 *
 * `answer`가 있으면 운영자 권한으로 답변까지 답니다.
 * `resolve: true`면 질문자가 "해결됨"으로 표시한 상태까지 만듭니다.
 * 내용은 리치 텍스트라 HTML로 넣습니다 (화면에서 서식 그대로 보입니다).
 */
const QUESTIONS = [
  {
    title: '가계부 지출을 잘못 입력했는데 수정할 수 있나요?',
    content:
      '<p>어제 저녁 식비를 금액을 잘못 넣었습니다.</p><p>이미 저장한 지출도 고칠 수 있는지 궁금합니다.</p>',
    category: 'USAGE',
    visibility: 'PUBLIC',
    answer:
      '<p>네, 가능합니다.</p><p>가계부에서 해당 지출을 눌러 상세로 들어간 뒤 오른쪽 위 수정 버튼을 누르면 금액과 날짜를 모두 바꿀 수 있습니다.</p>',
    resolve: true,
  },
  {
    title: '가족을 초대했는데 상대방에게 알림이 안 갑니다',
    content:
      '<p>그룹 초대 코드를 보냈는데 상대방 폰에 알림이 오지 않는다고 합니다.</p><p>제가 뭘 더 해야 하나요?</p>',
    category: 'BUG',
    visibility: 'PUBLIC',
    answer:
      '<p>초대 코드는 푸시 알림으로 전달되지 않고, 상대방이 앱에서 직접 입력하는 방식입니다.</p><p>그룹 관리 화면의 초대 코드를 복사해 메신저로 보내주세요.</p>',
  },
  {
    title: '위젯에 이번 주 일정도 보이게 해주세요',
    content:
      '<p>홈 화면 위젯에 오늘 일정만 나오는데, 이번 주 일정까지 보이면 좋겠습니다.</p>',
    category: 'FEATURE',
    visibility: 'PUBLIC',
    // 답변 대기 상태로 둡니다
  },
  {
    title: '구독을 해지하면 그동안 쓴 기록도 사라지나요?',
    content:
      '<p>광고 제거 구독을 쓰고 있는데 해지를 고민 중입니다.</p><p>해지하면 가계부나 일정 기록이 지워지는지 궁금합니다.</p>',
    category: 'PAYMENT',
    visibility: 'PRIVATE',
    answer:
      '<p>기록은 그대로 남습니다.</p><p>구독을 해지해도 데이터는 유지되고, 광고가 다시 표시되는 것만 달라집니다.</p>',
  },
  {
    title: '기기를 바꿨는데 데이터를 옮기려면 어떻게 하나요?',
    content: '<p>새 폰으로 바꿨습니다. 같은 계정으로 로그인하면 되나요?</p>',
    category: 'ACCOUNT',
    visibility: 'PRIVATE',
    // 답변 대기 · 비공개
  },
];

async function cleanup(token) {
  if (!existsSync(MANIFEST)) {
    console.log('삭제할 매니페스트가 없습니다:', MANIFEST);
    return;
  }
  const m = JSON.parse(readFileSync(MANIFEST, 'utf8'));
  let ok = 0;
  let fail = 0;
  for (const id of m.questions ?? []) {
    try {
      await api(token, 'DELETE', `qna/questions/${id}`);
      ok++;
    } catch {
      fail++;
    }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(
    MANIFEST,
    JSON.stringify({ questions: [], cleanedAt: now.toISOString() }, null, 2),
  );
}

async function tryCreate(label, fn) {
  try {
    return await fn();
  } catch (e) {
    console.log(`  ✗ ${label}: ${String(e.message).slice(0, 170)}`);
    return null;
  }
}

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken: token, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`, 'isAdmin=', user.isAdmin);

  if (CLEANUP) return cleanup(token);

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    for (const q of QUESTIONS) {
      const state = q.resolve ? '해결됨' : q.answer ? '답변 완료' : '답변 대기';
      console.log(`  [${q.category}] ${q.visibility === 'PUBLIC' ? '공개' : '비공개'} "${q.title}" → ${state}`);
    }
    return;
  }

  const needsAdmin = QUESTIONS.some((q) => q.answer);
  if (needsAdmin && !user.isAdmin) {
    console.log(
      '\n⚠️ 답변을 달려면 운영자 권한이 필요합니다.\n' +
        '   개발 DB에서 이 계정의 isAdmin을 잠시 true로 바꾼 뒤 다시 실행하세요.\n' +
        '   시딩이 끝나면 반드시 false로 되돌려야 합니다 (파일 상단 주석 참고).',
    );
  }

  const list = await api(token, 'GET', 'qna/questions?page=1&limit=50').catch(() => null);
  const existingTitles = new Set((list?.data ?? []).map((q) => q.title));

  const created = { questions: [], seededAt: now.toISOString() };
  let answered = 0;
  let resolved = 0;

  // 목록이 최신순이라 역순으로 넣어 위 순서를 맞춥니다
  for (const q of [...QUESTIONS].reverse()) {
    if (existingTitles.has(q.title)) {
      console.log(`· "${q.title}": 이미 있어 건너뜁니다`);
      continue;
    }
    const { answer, resolve, ...body } = q;
    const res = await tryCreate(`질문 "${q.title.slice(0, 20)}…"`, () =>
      api(token, 'POST', 'qna/questions', body),
    );
    if (!res?.id) continue;
    created.questions.push(res.id);

    if (answer) {
      const a = await tryCreate('답변', () =>
        api(token, 'POST', `qna/admin/questions/${res.id}/answers`, { content: answer }),
      );
      if (a) answered++;
    }
    if (resolve) {
      const r = await tryCreate('해결됨 처리', () =>
        api(token, 'POST', `qna/questions/${res.id}/resolve`),
      );
      if (r !== null) resolved++;
    }
    console.log(`  ✓ "${q.title.slice(0, 24)}…"`);
  }

  console.log(
    `\n질문 ${created.questions.length}건 / 답변 ${answered}건 / 해결 처리 ${resolved}건`,
  );

  let prev = { questions: [] };
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
        questions: [...new Set([...(prev.questions ?? []), ...created.questions])],
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('\n⚠️ 촬영 전에 운영자 권한을 반드시 되돌리세요 (파일 상단 주석의 명령 참고).');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
