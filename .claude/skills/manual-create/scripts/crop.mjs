/** 실기기 캡처에서 iOS 상태바 영역을 잘라냅니다 (Playwright로 클리핑). */
import { chromium } from 'playwright';
import { readFileSync } from 'node:fs';

const [src, out, topStr] = process.argv.slice(2);
const top = Number(topStr ?? 150);
const b64 = readFileSync(src).toString('base64');

const browser = await chromium.launch();
const page = await browser.newPage({ deviceScaleFactor: 1 });
await page.setContent(
  `<body style="margin:0"><img id="i" src="data:image/png;base64,${b64}"></body>`,
);
const size = await page.evaluate(async () => {
  const img = document.getElementById('i');
  await img.decode();
  return { w: img.naturalWidth, h: img.naturalHeight };
});
await page.setViewportSize({ width: size.w, height: Math.min(size.h, 30000) });
await page.screenshot({
  path: out,
  clip: { x: 0, y: top, width: size.w, height: size.h - top },
});
await browser.close();
console.log(`잘라냄: ${size.w}x${size.h} → ${size.w}x${size.h - top} (상단 ${top}px 제거)`);
