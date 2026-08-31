import { login, api } from './lib.mjs';
const { accessToken: t } = await login();
const groups = await api(t, 'GET', 'groups');
const gid = groups.find(g => g.name === '김가네 가족').id;
const tasks = (await api(t, 'GET', `tasks?groupIds=${gid}&limit=200`)).data ?? [];
for (const x of tasks.filter(x => x.title.includes('D-Day') || x.title === 'test')) {
  console.log(`${x.title.padEnd(18)} ${String(x.scheduledAt).slice(0,10)}  anniversaryId=${x.anniversaryId ?? '-'}  id=${x.id.slice(0,8)}`);
}
const anns = await api(t, 'GET', `tasks/anniversaries?groupId=${gid}`);
console.log('\n현재 기념일:', (Array.isArray(anns)?anns:anns.data??[]).map(a=>`${a.title}(${a.id.slice(0,8)})`).join(', '));
