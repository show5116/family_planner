/**
 * build/web 정적 서버 (매뉴얼 스크린샷 촬영용)
 *
 *   flutter build web --release --dart-define=ENVIRONMENT=development
 *   node .claude/skills/manual-create/scripts/serve.mjs
 *
 * 반드시 localhost:3001로 서비스합니다. 백엔드 CORS 허용 목록에
 * http://localhost:3001만 있어서 포트나 호스트를 바꾸면 로그인이 실패합니다.
 */

import http from 'node:http';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { PROJECT_ROOT } from './lib.mjs';

const ROOT = path.join(PROJECT_ROOT, 'build', 'web');
const PORT = 3001;

const MIME = {
  '.html': 'text/html', '.js': 'text/javascript', '.mjs': 'text/javascript',
  '.json': 'application/json', '.wasm': 'application/wasm', '.css': 'text/css',
  '.png': 'image/png', '.jpg': 'image/jpeg', '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml', '.ttf': 'font/ttf', '.otf': 'font/otf',
  '.woff': 'font/woff', '.woff2': 'font/woff2', '.ico': 'image/x-icon',
  '.bin': 'application/octet-stream', '.symbols': 'application/octet-stream',
};

http
  .createServer(async (req, res) => {
    try {
      let p = decodeURIComponent(req.url.split('?')[0]);
      if (p === '/') p = '/index.html';
      let fp = path.join(ROOT, p);
      let buf;
      try {
        buf = await readFile(fp);
      } catch {
        // SPA 폴백: /household 같은 클라이언트 라우트도 index.html로
        fp = path.join(ROOT, 'index.html');
        buf = await readFile(fp);
      }
      res.writeHead(200, {
        'Content-Type': MIME[path.extname(fp).toLowerCase()] ?? 'application/octet-stream',
      });
      res.end(buf);
    } catch (e) {
      res.writeHead(500);
      res.end(String(e));
    }
  })
  .listen(PORT, () => {
    console.log(`serving ${ROOT}`);
    console.log(`→ http://localhost:${PORT}  (127.0.0.1 아님에 주의: CORS)`);
  });
