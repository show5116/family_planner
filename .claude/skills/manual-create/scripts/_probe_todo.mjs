import { login, api } from './lib.mjs';
const { accessToken: t } = await login();
const groups = await api(t, 'GET', 'groups');
const ids = groups.map(g=>g.id).join(',');
for (const [label, q] of [
  ['view=todo 전체', `tasks?view=todo&groupIds=${encodeURIComponent(ids)}&includePersonal=true&limit=50`],
  ['view=todo 이번주', `tasks?view=todo&groupIds=${encodeURIComponent(ids)}&includePersonal=true&startDate=2026-08-30T15:00:00.000Z&endDate=2026-09-06T14:59:59.000Z&limit=50`],
]) {
  const r = await api(t, 'GET', q).catch(e=>({error:e.message}));
  const arr = r.data ?? [];
  console.log(`${label}: ${r.error ? '✗ '+r.error.slice(0,80) : arr.length+'건'}`);
  for (const x of arr) console.log(`   ${x.title} | type=${x.type} status=${x.status} dueAt=${x.dueAt} scheduledAt=${x.scheduledAt}`);
}
