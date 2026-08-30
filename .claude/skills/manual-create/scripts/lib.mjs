/**
 * manual-create 공용 유틸
 *
 * 스크린샷 촬영 파이프라인에서 seed.mjs / capture.mjs가 공유하는 헬퍼입니다.
 */

import { readFileSync } from 'node:fs';
import path from 'node:path';

/** 프로젝트 루트 (.claude/skills/manual-create/scripts 기준 4단계 위) */
export const PROJECT_ROOT = path.resolve(
  path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1')),
  '../../../..',
);

/** .env 파싱 (dotenv 의존 없이 최소 구현) */
export function loadEnv() {
  const env = {};
  try {
    const raw = readFileSync(path.join(PROJECT_ROOT, '.env'), 'utf8');
    for (const line of raw.split(/\r?\n/)) {
      const m = line.match(/^\s*([A-Z0-9_]+)\s*=\s*(.*)\s*$/);
      if (m) env[m[1]] = m[2].replace(/^["']|["']$/g, '');
    }
  } catch {
    // .env가 없으면 기본값 사용
  }
  return env;
}

/** 개발 백엔드 API base URL (environment.dart의 development 분기와 동일) */
export function apiBaseUrl() {
  const env = loadEnv();
  const base =
    env.API_BASE_URL_DEV ||
    'https://familyplannerbackend-development.up.railway.app';
  return `${base}/v1`;
}

/**
 * 앱 정적 서버 주소.
 *
 * 반드시 `localhost`여야 합니다. 백엔드 CORS 허용 목록에
 * `http://localhost:3001`만 등록되어 있어 `127.0.0.1`로 접속하면
 * 로그인 요청이 CORS로 차단됩니다.
 */
export const APP_ORIGIN = 'http://localhost:3001';

/** environment.dart의 테스트 계정 (isTestAccountLoginEnabled = local/development 한정) */
export const TEST_ACCOUNTS = {
  owner: 'test-owner@familyplanner.test',
  member: 'test-member@familyplanner.test',
};
export const TEST_PASSWORD = 'Test1234!';

/** 로그인 후 accessToken 반환 */
export async function login(email = TEST_ACCOUNTS.owner) {
  const res = await fetch(`${apiBaseUrl()}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password: TEST_PASSWORD }),
  });
  if (!res.ok) {
    throw new Error(`로그인 실패 (${res.status}): ${await res.text()}`);
  }
  return res.json();
}

/** 인증 포함 API 호출 */
export async function api(token, method, endpoint, body) {
  const res = await fetch(`${apiBaseUrl()}/${endpoint.replace(/^\//, '')}`, {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      ...(body ? { 'Content-Type': 'application/json' } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const text = await res.text();
  let data = null;
  try {
    data = text ? JSON.parse(text) : null;
  } catch {
    data = text;
  }
  if (!res.ok) {
    throw new Error(`${method} ${endpoint} 실패 (${res.status}): ${text.slice(0, 300)}`);
  }
  return data;
}

/**
 * 코치마크(기능 온보딩) 억제용 localStorage 시드.
 *
 * OnboardingService는 SharedPreferences를 쓰고, 웹에서는 `flutter.` 접두사가
 * 붙은 localStorage 키로 저장됩니다. 미리 true로 세팅해두면 촬영 중
 * 반투명 오버레이가 화면을 가리지 않습니다.
 */
/** OnboardingService의 CoachMarkKeys와 대응 (lib/features/onboarding/services/onboarding_service.dart) */
export const COACH_MARK_KEYS = [
  'home', 'calendar', 'calendar_form', 'todo', 'group_management',
  'household', 'assets', 'more', 'savings', 'child_points', 'memo',
  'mini_games', 'mini_games_ladder', 'mini_games_roulette',
  'investment_indicators', 'votes', 'fridge', 'cart', 'frequent_items',
  'shopping_history', 'routines', 'routine_together',
];

/**
 * 코치마크·온보딩 오버레이를 모두 억제합니다.
 *
 * 그룹 상세 코치마크는 `group_detail_<groupId>` 처럼 **그룹마다 키가 달라서**
 * 고정 목록으로는 막을 수 없습니다. 그래서 목록으로 한 번 막고,
 * `getItem`을 가로채 `coach_mark_`로 시작하는 키는 무조건 'true'를
 * 돌려주도록 합니다. (앱이 어떤 그룹을 열든 오버레이가 뜨지 않습니다.)
 */
export function onboardingSuppressScript(extraKeys = []) {
  const keys = [...COACH_MARK_KEYS, ...extraKeys];
  return `(() => {
    try {
      localStorage.setItem('flutter.onboarding_completed', 'true');
      for (const k of ${JSON.stringify(keys)}) {
        localStorage.setItem('flutter.coach_mark_' + k, 'true');
      }
    } catch (e) {}
  })()`;
}

/**
 * 그룹 상세 코치마크 키를 만들어 줍니다.
 *
 * SharedPreferences는 앱 시작 시 localStorage를 통째로 읽어 캐시하므로
 * getItem을 가로채는 방법은 통하지 않습니다. **페이지 로드 전에 실제 키가
 * 존재해야** 하고, 키가 그룹 ID를 포함하므로 API로 그룹 목록을 먼저 받아옵니다.
 */
export async function groupCoachMarkKeys(token) {
  try {
    const groups = await api(token, 'GET', 'groups');
    return (Array.isArray(groups) ? groups : []).map((g) => `group_detail_${g.id}`);
  } catch {
    return [];
  }
}
