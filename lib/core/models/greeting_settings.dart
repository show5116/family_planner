/// 기본 제공 인사말 팩 ID
///
/// 육아 팁은 아이 나이대에 따라 필요한 내용이 완전히 달라서 연령별로 나눠 둔다.
class GreetingPackIds {
  const GreetingPackIds._();

  /// 아기 (0~12개월)
  static const String infant = 'infant';

  /// 걸음마 (1~3세)
  static const String toddler = 'toddler';

  /// 유아 (3~5세)
  static const String preschool = 'preschool';

  /// 초등 (6~12세)
  static const String school = 'school';

  /// 청소년 (13세~)
  static const String teen = 'teen';

  /// 부모 마음 — 연령과 무관한 육아 원칙
  static const String parenting = 'parenting';

  /// 명언과 속담
  static const String quote = 'quote';

  /// 응원 한마디
  static const String cheer = 'cheer';

  /// 집안일 — 주방과 식품
  static const String choreKitchen = 'choreKitchen';

  /// 집안일 — 세탁과 옷
  static const String choreLaundry = 'choreLaundry';

  /// 집안일 — 청소와 곰팡이
  static const String choreCleaning = 'choreCleaning';

  /// 영어 한 문장 — 생활 회화
  static const String englishDaily = 'englishDaily';

  /// 영어 한 문장 — 여행과 외식
  static const String englishTravel = 'englishTravel';

  /// 영어 한 문장 — 직장과 이메일
  static const String englishWork = 'englishWork';

  /// 아이 나이대별 팩
  static const List<String> childPacks = [
    infant,
    toddler,
    preschool,
    school,
    teen,
  ];

  /// 마음 챙기기 팩 (연령 무관)
  static const List<String> mindPacks = [parenting, quote, cheer];

  /// 집안일 팩
  static const List<String> chorePacks = [
    choreKitchen,
    choreLaundry,
    choreCleaning,
  ];

  /// 영어 한 문장 팩
  static const List<String> englishPacks = [
    englishDaily,
    englishTravel,
    englishWork,
  ];

  /// 설정 화면에 보여줄 묶음 순서
  static const List<List<String>> groups = [
    childPacks,
    mindPacks,
    chorePacks,
    englishPacks,
  ];

  /// 전체 팩 목록
  static const List<String> all = [
    ...childPacks,
    ...mindPacks,
    ...chorePacks,
    ...englishPacks,
  ];
}

/// 대시보드 인사말 설정 모델
///
/// 기기 로컬(SharedPreferences)에만 저장한다.
class GreetingSettings {
  /// 내 인사말(프리셋 팩 + 직접 등록한 문구) 사용 여부
  ///
  /// false면 기존 시간대별 인사말로 되돌아간다.
  final bool enabled;

  /// 활성화된 기본 제공 팩 ID 목록
  final List<String> enabledPacks;

  /// 사용자가 직접 등록한 문구 목록
  final List<String> customMessages;

  const GreetingSettings({
    this.enabled = true,
    // 아이 나이를 알 수 없으므로 연령 무관한 팩만 기본으로 켠다
    this.enabledPacks = const [
      GreetingPackIds.parenting,
      GreetingPackIds.cheer,
    ],
    this.customMessages = const [],
  });

  /// 사용자 문구 최대 개수
  static const int maxCustomMessages = 100;

  /// 사용자 문구 1건 최대 길이
  static const int maxMessageLength = 200;

  GreetingSettings copyWith({
    bool? enabled,
    List<String>? enabledPacks,
    List<String>? customMessages,
  }) {
    return GreetingSettings(
      enabled: enabled ?? this.enabled,
      enabledPacks: enabledPacks ?? this.enabledPacks,
      customMessages: customMessages ?? this.customMessages,
    );
  }

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'enabledPacks': enabledPacks,
        'customMessages': customMessages,
      };

  factory GreetingSettings.fromJson(Map<String, dynamic> json) {
    return GreetingSettings(
      enabled: json['enabled'] as bool? ?? true,
      // 알 수 없는 팩 ID(구버전/오타)는 걸러낸다
      enabledPacks: (json['enabledPacks'] as List<dynamic>?)
              ?.map((e) => e as String)
              .where(GreetingPackIds.all.contains)
              .toList() ??
          const [],
      customMessages: (json['customMessages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }
}
