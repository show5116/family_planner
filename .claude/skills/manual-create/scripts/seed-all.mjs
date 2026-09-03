/**
 * 매뉴얼용 테스트 데이터 전체 재시딩
 *
 * 시딩 스크립트 상당수가 **실행 시점의 날짜**로 데이터를 만듭니다
 * (오늘 일정, 이번 달 가계부, 이번 달 포인트 거래 등).
 * 그래서 하루만 지나도 "오늘 일정이 없습니다" 같은 빈 화면이 찍힙니다.
 *
 * 촬영 전에 이 스크립트를 한 번 돌리면 모든 메뉴의 데이터가 오늘 기준으로 맞춰집니다.
 *
 * 사용법:
 *   node .claude/skills/manual-create/scripts/seed-all.mjs --group "김가네 가족"
 *   node .claude/skills/manual-create/scripts/seed-all.mjs --group "김가네 가족" --refresh
 *
 * --refresh 를 붙이면 날짜에 민감한 데이터(대시보드)를 cleanup 후 다시 만듭니다.
 * 붙이지 않으면 없는 것만 채웁니다.
 */

import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { PROJECT_ROOT } from './lib.mjs';

const SCRIPTS = path.join(PROJECT_ROOT, '.claude/skills/manual-create/scripts');
const REFRESH = process.argv.includes('--refresh');

const groupIdx = process.argv.indexOf('--group');
const groupArgs = groupIdx !== -1 && process.argv[groupIdx + 1]
  ? ['--group', process.argv[groupIdx + 1]]
  : [];

/**
 * dateSensitive: 날짜 기준으로 만들어져 --refresh 때 재생성이 필요한 것
 * cleanupSafe:   --cleanup 으로 되돌려도 안전한 것 (삭제 API가 있는 것)
 */
const STEPS = [
  { file: 'seed.mjs', label: '가계부', dateSensitive: true, cleanupSafe: true },
  { file: 'seed-dashboard.mjs', label: '대시보드(일정·할일·기념일·메모·지표)', dateSensitive: true, cleanupSafe: true },
  { file: 'seed-assets.mjs', label: '자산', dateSensitive: false, cleanupSafe: true },
  { file: 'seed-childcare.mjs', label: '육아 포인트', dateSensitive: true, cleanupSafe: true },
  { file: 'seed-savings.mjs', label: '그룹 저금통', dateSensitive: false, cleanupSafe: true },
];

const run = (file, args) => {
  const r = spawnSync('node', [path.join(SCRIPTS, file), ...args], {
    encoding: 'utf8',
    cwd: PROJECT_ROOT,
  });
  return { ok: r.status === 0, out: (r.stdout || '') + (r.stderr || '') };
};

console.log(`대상 그룹: ${groupArgs[1] ?? '(소유 그룹 자동 선택)'}`);
console.log(REFRESH ? '모드: 날짜 민감 데이터 재생성\n' : '모드: 없는 것만 채우기\n');

let failed = 0;
for (const step of STEPS) {
  process.stdout.write(`[${step.label}] `);

  if (REFRESH && step.dateSensitive && step.cleanupSafe) {
    const c = run(step.file, ['--cleanup']);
    if (!c.ok) console.log('\n  ⚠ cleanup 실패 — 이어서 시딩만 시도합니다');
  }

  const r = run(step.file, groupArgs);
  if (!r.ok) {
    failed++;
    console.log('✗ 실패');
    console.log(
      r.out
        .split('\n')
        .filter((l) => l.trim())
        .slice(-4)
        .map((l) => `    ${l}`)
        .join('\n'),
    );
    continue;
  }
  // 각 스크립트의 요약 줄만 추립니다
  const summary = r.out
    .split('\n')
    .filter((l) => /생성|건|건너뜁|준비|즐겨찾기/.test(l) && !l.startsWith('API:'))
    .slice(-3)
    .map((l) => l.trim())
    .join(' · ');
  console.log(`✓ ${summary || '완료'}`);
}

console.log(
  failed === 0
    ? '\n전부 완료. 이제 capture.mjs 를 돌리면 됩니다.'
    : `\n${failed}건 실패 — 위 로그를 확인하세요.`,
);
process.exit(failed === 0 ? 0 : 1);
