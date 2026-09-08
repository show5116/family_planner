/**
 * 매뉴얼 스크린샷용 테스트 데이터 시딩 (메모)
 *
 * 메모 화면은 서식 있는 본문·체크리스트·태그·고정·공개 범위가 모두
 * 데이터에 의존합니다. 매뉴얼에서 설명할 케이스를 한 번에 덮도록 구성합니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-memo.mjs --dry-run
 *   node .claude/skills/manual-create/scripts/seed-memo.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-memo.mjs --cleanup
 *
 * 안전 규칙
 * - 개발 백엔드(API_BASE_URL_DEV)에만 씁니다. 프로덕션은 건드리지 않습니다.
 * - 제목이 같으면 건너뛰므로 재실행해도 늘지 않습니다.
 * - 생성한 ID는 seed-memo-manifest.json에 기록해 --cleanup으로 되돌립니다.
 */

import { writeFileSync, readFileSync, existsSync } from 'node:fs';
import path from 'node:path';
import { login, api, apiBaseUrl, PROJECT_ROOT } from './lib.mjs';

const MANIFEST = path.join(
  PROJECT_ROOT,
  '.claude/skills/manual-create/scripts/seed-memo-manifest.json',
);
const DRY_RUN = process.argv.includes('--dry-run');
const CLEANUP = process.argv.includes('--cleanup');

const now = new Date();

/**
 * 본문은 Quill Delta(JSON 문자열)입니다. 앱의 저장 형식과 같아야
 * 서식이 그대로 보입니다.
 *
 * 줄 속성(제목·글머리 기호·체크리스트)은 그 줄의 줄바꿈 op에 붙이고,
 * 글자 속성(굵게·기울임·링크)은 글자 op에 붙입니다.
 */
const t = (text, attrs) => (attrs ? { insert: text, attributes: attrs } : { insert: text });
const line = (attrs) => (attrs ? { insert: '\n', attributes: attrs } : { insert: '\n' });
const delta = (...ops) => JSON.stringify(ops);

/**
 * 메모 6건.
 *
 * 매뉴얼에서 설명할 요소를 골고루 덮습니다.
 * - 서식: 제목 · 굵게 · 기울임 · 글머리 기호 · 번호 목록 · 하이퍼링크
 * - 체크리스트: 일부만 체크된 상태(카드에 "2/5 완료"가 찍히도록)
 * - 태그: 여러 개를 넣어 목록 위 태그 칩 줄이 채워지도록
 * - 공개 범위: 나만 보기 / 특정 그룹
 * - 고정: 목록 맨 위 "📌 고정된 메모" 구역이 생기도록
 *
 * 목록은 최신순이고 화면에 보이는 카드만 그려집니다. 촬영에서 탭해야 하는
 * 체크리스트 메모(여행 준비물)는 스크롤 없이 잡히도록 맨 마지막에 만듭니다.
 */
const MEMOS = [
  {
    title: '우리 집 규칙',
    pin: true,
    toGroup: true,
    tags: ['가족', '규칙'],
    content: delta(
      t('집안일 분담'),
      line({ header: 2 }),
      t('설거지'),
      line({ list: 'bullet' }),
      t('분리수거'),
      line({ list: 'bullet' }),
      t('화장실 청소'),
      line({ list: 'bullet' }),
      t('약속'),
      line({ header: 2 }),
      t('밤 10시 이후에는 '),
      t('조용히', { bold: true }),
      t(' 하기'),
      line(),
      t('먹은 그릇은 바로 싱크대에'),
      line(),
    ),
  },
  {
    title: '주말 나들이 후보',
    toGroup: true,
    tags: ['가족', '나들이'],
    content: delta(
      t('가까운 곳부터 순서대로'),
      line({ italic: true }),
      t('서울숲 — 주차 편함'),
      line({ list: 'ordered' }),
      t('한강공원 — 자전거'),
      line({ list: 'ordered' }),
      t('국립중앙박물관 — 비 오는 날'),
      line({ list: 'ordered' }),
      t('예약은 '),
      t('공식 홈페이지', { link: 'https://www.museum.go.kr' }),
      t('에서'),
      line(),
    ),
  },
  {
    title: '아이 학원 상담 메모',
    toGroup: true,
    tags: ['육아'],
    content: delta(
      t('수학 학원 상담 (10/14)'),
      line({ header: 2 }),
      t('진도는 한 학기 앞서 나감'),
      line({ list: 'bullet' }),
      t('숙제량이 많은 편 — '),
      t('주 3회', { bold: true }),
      t(' 정도'),
      line({ list: 'bullet' }),
      t('한 달 더 다녀보고 결정하기로'),
      line({ list: 'bullet' }),
    ),
  },
  {
    title: '읽고 싶은 책',
    tags: ['취미'],
    content: delta(
      t('올해 안에'),
      line({ header: 2 }),
      t('죽음의 수용소에서'),
      line({ list: 'checked' }),
      t('사피엔스'),
      line({ list: 'unchecked' }),
      t('아주 작은 습관의 힘'),
      line({ list: 'unchecked' }),
    ),
  },
  {
    // 태그 없이 나만 보기 — 카드에 "나만 보기"만 붙는 경우
    title: '보험 만기일',
    content: delta(
      t('실손 — 매년 3월'),
      line({ list: 'bullet' }),
      t('자동차 — 매년 9월'),
      line({ list: 'bullet' }),
      t('갱신 전에 비교해보기'),
      line({ italic: true }),
    ),
  },
  {
    title: '여행 준비물',
    tags: ['여행'],
    content: delta(
      t('제주도 3박 4일'),
      line({ header: 2 }),
      t('여권 / 신분증'),
      line({ list: 'checked' }),
      t('세면도구'),
      line({ list: 'checked' }),
      t('여벌 옷'),
      line({ list: 'unchecked' }),
      t('충전기'),
      line({ list: 'unchecked' }),
      t('상비약'),
      line({ list: 'unchecked' }),
    ),
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

const asList = (r) => (Array.isArray(r) ? r : (r?.items ?? r?.data ?? []));

async function tryCall(label, fn) {
  try {
    return await fn();
  } catch (e) {
    console.log(`  ✗ ${label}: ${String(e.message).slice(0, 140)}`);
    return null;
  }
}

/** 체크리스트 개수 집계 — 앱의 CreateMemoDto와 같은 규칙 */
function checklistMeta(deltaJson) {
  const ops = JSON.parse(deltaJson);
  let total = 0;
  let checked = 0;
  for (const op of ops) {
    const list = op.attributes?.list;
    if (list === 'unchecked') total++;
    if (list === 'checked') {
      total++;
      checked++;
    }
  }
  return total === 0 ? null : { total, checked };
}

async function cleanup(token) {
  if (!existsSync(MANIFEST)) {
    console.log('삭제할 매니페스트가 없습니다:', MANIFEST);
    return;
  }
  const m = JSON.parse(readFileSync(MANIFEST, 'utf8'));
  let ok = 0;
  let fail = 0;
  for (const id of m.memos ?? []) {
    try {
      await api(token, 'DELETE', `memos/${id}`);
      ok++;
    } catch {
      fail++;
    }
  }
  console.log(`정리 완료: 삭제 ${ok}건, 실패(이미 없음 포함) ${fail}건`);
  writeFileSync(MANIFEST, JSON.stringify({ memos: [], cleanedAt: now.toISOString() }, null, 2));
}

async function main() {
  console.log('API:', apiBaseUrl());
  const { accessToken, user } = await login();
  console.log('로그인:', user.name, `(${user.email})`);

  if (CLEANUP) return cleanup(accessToken);

  const group = await pickGroup(accessToken);
  console.log('대상 그룹:', group.name, group.id);

  if (DRY_RUN) {
    console.log('\n[dry-run] 생성 예정');
    console.log(`  메모 ${MEMOS.length}건`);
    console.log(`  고정 ${MEMOS.filter((m) => m.pin).length}건`);
    console.log(`  그룹 공유 ${MEMOS.filter((m) => m.toGroup).length}건`);
    const tags = new Set(MEMOS.flatMap((m) => m.tags ?? []));
    console.log(`  태그 ${tags.size}종: ${[...tags].join(', ')}`);
    return;
  }

  const existing = asList(await api(accessToken, 'GET', 'memos?limit=100').catch(() => []));
  const existingTitles = new Set(existing.map((m) => m.title));

  const created = { memos: [], seededAt: now.toISOString() };
  let pinned = 0;

  for (const memo of MEMOS) {
    if (existingTitles.has(memo.title)) {
      console.log(`· ${memo.title}: 이미 있어 건너뜁니다`);
      continue;
    }
    const meta = checklistMeta(memo.content);
    const body = {
      title: memo.title,
      content: memo.content,
      format: 'DELTA',
      visibility: memo.toGroup ? 'GROUP' : 'PRIVATE',
      ...(memo.toGroup ? { groupId: group.id } : {}),
      ...(memo.tags?.length ? { tags: memo.tags.map((name) => ({ name })) } : {}),
      ...(meta ? { checklistMeta: meta } : {}),
    };
    const res = await tryCall(`메모 "${memo.title}"`, () =>
      api(accessToken, 'POST', 'memos', body),
    );
    if (!res?.id) continue;
    created.memos.push(res.id);

    if (memo.pin) {
      const ok = await tryCall(`고정 "${memo.title}"`, () =>
        api(accessToken, 'POST', `memos/${res.id}/pin`),
      );
      if (ok !== null) pinned++;
    }

    const marks = [
      memo.pin ? '📌' : null,
      meta ? `체크리스트 ${meta.checked}/${meta.total}` : null,
      memo.toGroup ? '그룹' : '나만 보기',
      memo.tags?.length ? `#${memo.tags.join(' #')}` : null,
    ].filter(Boolean);
    console.log(`  ✓ ${memo.title} — ${marks.join(' · ')}`);
  }

  console.log(`\n메모: 신규 ${created.memos.length}건 / 고정 ${pinned}건`);

  let prev = { memos: [] };
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
        memos: [...new Set([...(prev.memos ?? []), ...created.memos])],
        seededAt: created.seededAt,
      },
      null,
      2,
    ),
  );
  console.log('매니페스트 기록:', MANIFEST);
  console.log('되돌리려면: node .claude/skills/manual-create/scripts/seed-memo.mjs --cleanup');
}

main().catch((e) => {
  console.error('시딩 실패:', e.message);
  process.exit(1);
});
