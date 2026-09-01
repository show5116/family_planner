import { chromium, devices } from 'playwright';
import { APP_ORIGIN, onboardingSuppressScript, groupCoachMarkKeys, login } from './lib.mjs';
const b = await chromium.launch();
const ctx = await b.newContext({ ...devices['iPhone 13'], locale:'ko-KR', timezoneId:'Asia/Seoul', geolocation:{latitude:37.5665,longitude:126.978}, permissions:['geolocation'] });
const { accessToken } = await login();
await ctx.addInitScript(onboardingSuppressScript(await groupCoachMarkKeys(accessToken)));
const p = await ctx.newPage();
const boot = async (w=8000) => { await p.waitForSelector('flutter-view',{timeout:180000}); await p.waitForTimeout(w); await p.evaluate(()=>document.querySelector('flt-semantics-placeholder')?.click()); await p.waitForTimeout(1500); };
await p.goto(APP_ORIGIN+'/',{waitUntil:'load',timeout:180000}); await boot();
const h = await p.evaluateHandle(() => [...document.querySelectorAll('flt-semantics')].find(n=>(n.textContent||'').split('\n')[0].trim()==='테스트 계정으로 로그인 (그룹 소유자)')??null);
await h.asElement()?.click(); await p.waitForTimeout(16000);
await p.goto(APP_ORIGIN+'/calendar',{waitUntil:'load',timeout:180000}); await boot(14000);
// 1일 탭
const d1 = await p.evaluateHandle(() => {
  const c=[...document.querySelectorAll('flt-semantics')].filter(n=>(n.textContent||'').includes('1'));
  return c.sort((a,b)=>{const x=a.getBoundingClientRect(),y=b.getBoundingClientRect();return x.width*x.height-y.width*y.height;})[0]??null;});
await d1.asElement()?.click(); await p.waitForTimeout(5000);
await p.mouse.move(200,500); await p.mouse.wheel(0,700); await p.waitForTimeout(2500);
await p.evaluate(()=>document.querySelector('flt-semantics-placeholder')?.click()); await p.waitForTimeout(1200);
const labels = await p.evaluate(() => [...document.querySelectorAll('flt-semantics')]
  .filter(n=>(n.textContent||'').includes('어린이집'))
  .map(n=>({role:n.getAttribute('role'), aria:n.getAttribute('aria-label'), text:JSON.stringify((n.textContent||'').slice(0,70))})));
console.log(JSON.stringify(labels,null,1));
await b.close();
