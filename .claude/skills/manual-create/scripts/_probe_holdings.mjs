import { login, api } from './lib.mjs';
const { accessToken: t } = await login();
const groups = await api(t, 'GET', 'groups');
const gid = groups.find(g => g.name === '김가네 가족').id;
const accs = await api(t, 'GET', `assets/accounts?groupId=${gid}`);
const acc = accs.find(a => a.name === '해외주식 계좌') ?? accs[0];
console.log('계좌:', acc.name, acc.id);
for (const [label, m, ep] of [
  ['GET holdings', 'GET', `assets/accounts/${acc.id}/holdings`],
  ['GET holding-records', 'GET', `assets/accounts/${acc.id}/holding-records`],
  ['GET withdrawals', 'GET', `assets/accounts/${acc.id}/withdrawals`],
]) {
  try { const r = await api(t, m, ep); console.log(`  ✓ ${label}: ${Array.isArray(r)?r.length+'건':JSON.stringify(r).slice(0,60)}`); }
  catch(e){ console.log(`  ✗ ${label}: ${String(e.message).slice(0,90)}`); }
}
