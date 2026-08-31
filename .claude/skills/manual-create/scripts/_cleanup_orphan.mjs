import { login, api } from './lib.mjs';
const { accessToken: t } = await login();
const groups = await api(t, 'GET', 'groups');
const gid = groups.find(g => g.name === '김가네 가족').id;
const tasks = (await api(t, 'GET', `tasks?groupIds=${gid}&limit=200`)).data ?? [];
// anniversaryId가 없는 D-Day 마일스톤 = 기념일이 지워졌는데 남은 고아
const orphans = tasks.filter(x => x.title.includes('D-Day') && !x.anniversaryId);
console.log(`고아 D-Day 마일스톤 ${orphans.length}건 삭제`);
for (const o of orphans) {
  await api(t, 'DELETE', `tasks/${o.id}`);
  console.log(`  삭제: ${o.title} (${o.id.slice(0,8)})`);
}
const after = (await api(t, 'GET', `tasks?groupIds=${gid}&limit=200`)).data ?? [];
console.log('\n남은 일정/할일:', after.map(x=>x.title).join(', '));
