import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 하단 네비게이션 아이템 모델
class NavigationItem {
  final String id;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isFixed; // 고정 여부 (홈, 더보기)

  const NavigationItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.isFixed = false,
  });

  NavigationItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    IconData? selectedIcon,
    bool? isFixed,
  }) {
    return NavigationItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      selectedIcon: selectedIcon ?? this.selectedIcon,
      isFixed: isFixed ?? this.isFixed,
    );
  }
}

/// 하단 네비게이션 설정 상태
class BottomNavigationSettings {
  final NavigationItem fixedLeft; // 고정: 홈 (맨 좌측)
  final List<String> middleSlots; // 가변: 중간 3개 슬롯 (ID만 저장)
  final NavigationItem fixedRight; // 고정: 더보기 (맨 우측)

  BottomNavigationSettings({
    required this.fixedLeft,
    required this.middleSlots,
    required this.fixedRight,
  });

  BottomNavigationSettings copyWith({
    NavigationItem? fixedLeft,
    List<String>? middleSlots,
    NavigationItem? fixedRight,
  }) {
    return BottomNavigationSettings(
      fixedLeft: fixedLeft ?? this.fixedLeft,
      middleSlots: middleSlots ?? this.middleSlots,
      fixedRight: fixedRight ?? this.fixedRight,
    );
  }
}

/// 하단 네비게이션 설정 프로바이더
class BottomNavigationSettingsNotifier extends StateNotifier<BottomNavigationSettings> {
  static const String _storageKey = 'bottom_navigation_settings_v2';

  // 고정 아이템
  static const NavigationItem _fixedHome = NavigationItem(
    id: 'home',
    label: '홈',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    isFixed: true,
  );

  static const NavigationItem _fixedMore = NavigationItem(
    id: 'more',
    label: '더보기',
    icon: Icons.more_horiz,
    selectedIcon: Icons.more_horiz,
    isFixed: true,
  );

  // 사용 가능한 모든 메뉴 아이템들 (고정 메뉴 제외)
  static const Map<String, NavigationItem> _availableItems = {
    'assets': NavigationItem(
      id: 'assets',
      label: '자산',
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
    ),
    'calendar': NavigationItem(
      id: 'calendar',
      label: '일정',
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
    ),
    'todo': NavigationItem(
      id: 'todo',
      label: '할일',
      icon: Icons.check_box_outlined,
      selectedIcon: Icons.check_box,
    ),
    'household': NavigationItem(
      id: 'household',
      label: '가계관리',
      icon: Icons.attach_money,
      selectedIcon: Icons.attach_money,
    ),
    'childPoints': NavigationItem(
      id: 'childPoints',
      label: '육아포인트',
      icon: Icons.child_care,
      selectedIcon: Icons.child_care,
    ),
    'memo': NavigationItem(
      id: 'memo',
      label: '메모',
      icon: Icons.note_outlined,
      selectedIcon: Icons.note,
    ),
    'miniGames': NavigationItem(
      id: 'miniGames',
      label: '미니게임',
      icon: Icons.games_outlined,
      selectedIcon: Icons.games,
    ),
  };

  // 기본 중간 슬롯 (자산, 일정, 할일)
  static const List<String> _defaultMiddleSlots = ['assets', 'calendar', 'todo'];

  BottomNavigationSettingsNotifier()
      : super(BottomNavigationSettings(
          fixedLeft: _fixedHome,
          middleSlots: List.from(_defaultMiddleSlots),
          fixedRight: _fixedMore,
        )) {
    _loadSettings();
  }

  /// 모든 사용 가능한 아이템 가져오기 (고정 메뉴 제외)
  Map<String, NavigationItem> get availableItems => _availableItems;

  /// 현재 하단 네비게이션에 표시되는 전체 아이템 리스트
  List<NavigationItem> get displayedItems {
    final items = <NavigationItem>[
      state.fixedLeft,
      ...state.middleSlots.map((id) => _availableItems[id]!),
      state.fixedRight,
    ];
    return items;
  }

  /// 하단 네비게이션에 표시되지 않는 메뉴 ID 목록
  List<String> get nonDisplayedMenuIds {
    return _availableItems.keys
        .where((id) => !state.middleSlots.contains(id))
        .toList();
  }

  /// 설정 불러오기
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_storageKey);

      if (settingsJson != null && settingsJson.isNotEmpty) {
        final slots = settingsJson.split(',');
        // 유효성 검사: 3개의 슬롯이 모두 사용 가능한 메뉴인지 확인
        if (slots.length == 3 &&
            slots.every((id) => _availableItems.containsKey(id))) {
          state = state.copyWith(middleSlots: slots);
        }
      }
    } catch (e) {
      debugPrint('하단 네비게이션 설정 불러오기 실패: $e');
    }
  }

  /// 설정 저장하기
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = state.middleSlots.join(',');
      await prefs.setString(_storageKey, settingsString);
    } catch (e) {
      debugPrint('하단 네비게이션 설정 저장 실패: $e');
    }
  }

  /// 중간 슬롯 순서 변경
  Future<void> reorderMiddleSlots(int oldIndex, int newIndex) async {
    final slots = List<String>.from(state.middleSlots);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = slots.removeAt(oldIndex);
    slots.insert(newIndex, item);

    state = state.copyWith(middleSlots: slots);
    await _saveSettings();
  }

  /// 특정 슬롯의 메뉴 변경
  Future<void> changeSlotMenu(int slotIndex, String newMenuId) async {
    if (slotIndex < 0 || slotIndex >= 3) {
      debugPrint('잘못된 슬롯 인덱스: $slotIndex');
      return;
    }

    if (!_availableItems.containsKey(newMenuId)) {
      debugPrint('사용할 수 없는 메뉴 ID: $newMenuId');
      return;
    }

    // 이미 다른 슬롯에서 사용 중인 메뉴인 경우 교체
    final slots = List<String>.from(state.middleSlots);
    final oldMenuId = slots[slotIndex];
    final existingIndex = slots.indexOf(newMenuId);

    if (existingIndex != -1 && existingIndex != slotIndex) {
      // 기존 슬롯과 새 슬롯의 메뉴를 교체
      slots[existingIndex] = oldMenuId;
      slots[slotIndex] = newMenuId;
    } else {
      // 단순 변경
      slots[slotIndex] = newMenuId;
    }

    state = state.copyWith(middleSlots: slots);
    await _saveSettings();
  }

  /// 설정 초기화
  Future<void> resetToDefault() async {
    state = state.copyWith(middleSlots: List.from(_defaultMiddleSlots));
    await _saveSettings();
  }
}

/// 하단 네비게이션 설정 프로바이더
final bottomNavigationSettingsProvider =
    StateNotifierProvider<BottomNavigationSettingsNotifier, BottomNavigationSettings>(
  (ref) => BottomNavigationSettingsNotifier(),
);
