import { login, api } from './lib.mjs';
const { accessToken: t } = await login();
const groups = await api(t, 'GET', 'groups');
const ids = groups.map(g=>g.id).join(',');
const r = await api(t, 'GET', `tasks?view=todo&groupIds=${encodeURIComponent(ids)}&includePersonal=true&limit=50`);
for (const x of r.data ?? []) console.log(`${x.title.padEnd(20)} dueAt=${x.dueAt} daysUntilDue=${x.daysUntilDue}`);
