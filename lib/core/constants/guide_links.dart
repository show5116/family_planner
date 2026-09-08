/// 사용 설명서 링크
///
/// 문서 본체는 홈페이지(familyplanner.hmncorp.org)에 메뉴별 페이지로 올라가
/// 있고, 앱은 각 화면의 더보기 메뉴에서 해당 페이지를 열어 준다. 슬러그는
/// 홈페이지 라우트(`/family-planner/guide/{slug}`)와 1:1로 맞춰야 하므로
/// 화면마다 URL을 적지 않고 여기서만 관리한다.
class GuideLinks {
  GuideLinks._();

  static const String _base =
      'https://familyplanner.hmncorp.org/family-planner/guide';

  /// 설명서 목록 (매칭되는 문서가 없는 화면의 기본값)
  static const String home = _base;

  // ── 시작하기 ──────────────────────────────────────────────────────────────
  static const String groups = '$_base/groups';
  static const String dashboard = '$_base/dashboard';

  // ── 일정·할일 ─────────────────────────────────────────────────────────────
  static const String calendar = '$_base/calendar';
  static const String todo = '$_base/todo';

  // ── 돈 ────────────────────────────────────────────────────────────────────
  static const String household = '$_base/household';
  static const String assets = '$_base/assets';
  static const String savings = '$_base/savings';
  static const String investment = '$_base/investment';

  // ── 가족 ──────────────────────────────────────────────────────────────────
  static const String childcare = '$_base/childcare';
  static const String routine = '$_base/routine';
  static const String routineTogether = '$routine#together';
  static const String memo = '$_base/memo';
  static const String vote = '$_base/vote';
  static const String minigame = '$_base/minigame';
  static const String minigameLadder = '$minigame#ladder';
  static const String minigameRoulette = '$minigame#roulette';

  // ── 살림 ──────────────────────────────────────────────────────────────────
  static const String fridge = '$_base/fridge';
  static const String shopping = '$_base/shopping';

  // ── 설정 ──────────────────────────────────────────────────────────────────
  static const String settings = '$_base/settings';
  static const String qna = '$_base/qna';
  static const String subscription = '$_base/subscription';
}
