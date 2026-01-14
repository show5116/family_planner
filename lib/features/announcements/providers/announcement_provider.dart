import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/announcements/data/models/announcement_model.dart';
import 'package:family_planner/features/announcements/data/repositories/announcement_repository.dart';
import 'package:family_planner/features/announcements/data/dto/announcement_dto.dart';

part 'announcement_provider.g.dart';

/// 공지사항 목록 Provider (무한 스크롤 지원)
@riverpod
class AnnouncementList extends _$AnnouncementList {
  int _currentPage = 1;
  bool _hasMore = true;
  List<AnnouncementModel> _items = [];
  AnnouncementCategory? _selectedCategory;

  @override
  Future<List<AnnouncementModel>> build() async {
    return await _loadAnnouncements();
  }

  /// 공지사항 목록 로드
  Future<List<AnnouncementModel>> _loadAnnouncements({int page = 1}) async {
    final repository = ref.read(announcementRepositoryProvider);
    final response = await repository.getAnnouncements(
      page: page,
      limit: 20,
      category: _selectedCategory,
    );

    _hasMore = response.items.length >= 20;
    _currentPage = page;

    if (page == 1) {
      _items = response.items;
    } else {
      _items.addAll(response.items);
    }

    return _items;
  }

  /// 다음 페이지 로드 (무한 스크롤)
  Future<void> loadMore() async {
    if (!_hasMore) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadAnnouncements(page: _currentPage + 1);
    });
  }

  /// 새로고침
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _items = [];

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadAnnouncements(page: 1);
    });
  }

  /// 카테고리 필터 설정
  Future<void> setCategory(AnnouncementCategory? category) async {
    _selectedCategory = category;
    await refresh();
  }

  /// 현재 선택된 카테고리
  AnnouncementCategory? get selectedCategory => _selectedCategory;

  /// 공지사항 작성 후 목록 갱신
  Future<void> afterCreate() async {
    await refresh();
  }

  /// 공지사항 수정 후 목록 갱신
  Future<void> afterUpdate(String id, AnnouncementModel updated) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = updated;
      state = AsyncValue.data([..._items]);
    }
  }

  /// 공지사항 삭제 후 목록 갱신
  Future<void> afterDelete(String id) async {
    _items.removeWhere((item) => item.id == id);
    state = AsyncValue.data([..._items]);
  }

  /// 공지사항 읽음 처리 (로컬 상태만 업데이트)
  void markAsRead(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1 && !_items[index].isRead) {
      _items[index] = _items[index].copyWith(isRead: true);
      state = AsyncValue.data([..._items]);
    }
  }

  /// 더 가져올 데이터가 있는지 여부
  bool get hasMore => _hasMore;
}

/// 고정 공지사항 목록 Provider
@riverpod
Future<List<AnnouncementModel>> pinnedAnnouncements(
    PinnedAnnouncementsRef ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  final response = await repository.getAnnouncements(
    page: 1,
    limit: 5,
    pinnedOnly: true,
  );
  return response.items;
}

/// 특정 공지사항 상세 Provider
@riverpod
Future<AnnouncementModel> announcementDetail(
  AnnouncementDetailRef ref,
  String id,
) async {
  final repository = ref.watch(announcementRepositoryProvider);
  return await repository.getAnnouncementById(id);
}

/// 읽지 않은 공지사항 개수 Provider
@riverpod
Future<int> unreadAnnouncementCount(UnreadAnnouncementCountRef ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  final response = await repository.getAnnouncements(page: 1, limit: 100);

  // 읽지 않은 공지 개수 계산
  return response.items.where((item) => !item.isRead).length;
}

/// 공지사항 관리 Notifier (ADMIN 전용)
class AnnouncementManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final AnnouncementRepository _repository;
  final Ref _ref;

  AnnouncementManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// 공지사항 작성
  Future<AnnouncementModel?> createAnnouncement(
      CreateAnnouncementDto dto) async {
    state = const AsyncValue.loading();
    try {
      final announcement = await _repository.createAnnouncement(dto);

      // 목록 갱신
      _ref.read(announcementListProvider.notifier).afterCreate();

      state = const AsyncValue.data(null);
      return announcement;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 공지사항 수정
  Future<AnnouncementModel?> updateAnnouncement(
    String id,
    CreateAnnouncementDto dto,
  ) async {
    state = const AsyncValue.loading();
    try {
      final announcement = await _repository.updateAnnouncement(id, dto);

      // 목록 갱신
      _ref.read(announcementListProvider.notifier).afterUpdate(id, announcement);

      // 상세 Provider 무효화
      _ref.invalidate(announcementDetailProvider(id));

      state = const AsyncValue.data(null);
      return announcement;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 공지사항 삭제
  Future<bool> deleteAnnouncement(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteAnnouncement(id);

      // 목록 갱신
      _ref.read(announcementListProvider.notifier).afterDelete(id);

      // 상세 Provider 무효화
      _ref.invalidate(announcementDetailProvider(id));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 공지사항 고정/해제
  Future<bool> togglePin(String id, bool isPinned) async {
    state = const AsyncValue.loading();
    try {
      final announcement = await _repository.togglePin(id, isPinned);

      // 목록 갱신
      _ref.read(announcementListProvider.notifier).afterUpdate(id, announcement);

      // 상세 Provider 무효화
      _ref.invalidate(announcementDetailProvider(id));

      // 고정 공지 목록 무효화
      _ref.invalidate(pinnedAnnouncementsProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// 공지사항 관리 Notifier Provider (ADMIN 전용)
final announcementManagementProvider =
    StateNotifierProvider<AnnouncementManagementNotifier, AsyncValue<void>>(
        (ref) {
  final repository = ref.watch(announcementRepositoryProvider);
  return AnnouncementManagementNotifier(repository, ref);
});
