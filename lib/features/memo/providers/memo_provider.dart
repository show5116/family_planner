import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/repositories/memo_repository.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart'
    show CreateMemoDto, UpdateMemoDto, CreateChecklistItemDto, UpdateChecklistItemDto;

part 'memo_provider.g.dart';

/// 메모 목록 Provider (무한 스크롤 + 검색 지원)
@riverpod
class MemoList extends _$MemoList {
  int _currentPage = 1;
  bool _hasMore = true;
  List<MemoModel> _items = [];
  String? _searchQuery;
  String? _visibilityFilter;
  String? _groupIdFilter;
  String? _tagFilter;

  @override
  Future<List<MemoModel>> build() async {
    return await _loadMemos();
  }

  /// 메모 목록 로드
  Future<List<MemoModel>> _loadMemos({int page = 1}) async {
    final repository = ref.read(memoRepositoryProvider);
    final response = await repository.getMemos(
      page: page,
      limit: 20,
      search: _searchQuery,
      visibility: _visibilityFilter,
      groupId: _groupIdFilter,
      tag: _tagFilter,
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
      return await _loadMemos(page: _currentPage + 1);
    });
  }

  /// 새로고침
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _items = [];

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadMemos(page: 1);
    });
  }

  /// 검색어 설정
  Future<void> setSearch(String? query) async {
    _searchQuery = (query != null && query.trim().isEmpty) ? null : query?.trim();
    await refresh();
  }

  /// 공개 범위 필터 설정
  Future<void> setVisibility(String? visibility) async {
    _visibilityFilter = visibility;
    _groupIdFilter = null;
    await refresh();
  }

  /// 그룹 필터 설정
  Future<void> setGroupId(String? groupId) async {
    _groupIdFilter = groupId;
    _visibilityFilter = null;
    await refresh();
  }

  /// 태그 필터 설정
  Future<void> setTag(String? tag) async {
    _tagFilter = tag;
    await refresh();
  }

  /// 현재 태그 필터
  String? get tagFilter => _tagFilter;

  /// 메모 작성 후 목록 갱신
  Future<void> afterCreate() async {
    await refresh();
  }

  /// 메모 수정 후 목록 갱신
  Future<void> afterUpdate(String id, MemoModel updated) async {
    if (_items.isEmpty) return;

    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items = List<MemoModel>.from(_items);
      _items[index] = updated;
      state = AsyncValue.data([..._items]);
    }
  }

  /// 메모 삭제 후 목록 갱신
  Future<void> afterDelete(String id) async {
    if (_items.isEmpty) return;

    _items = List<MemoModel>.from(_items);
    _items.removeWhere((item) => item.id == id);
    state = AsyncValue.data([..._items]);
  }

  /// 더 가져올 데이터가 있는지 여부
  bool get hasMore => _hasMore;

  /// 현재 검색어
  String? get searchQuery => _searchQuery;

  /// 현재 공개 범위 필터
  String? get visibilityFilter => _visibilityFilter;

  /// 현재 그룹 ID 필터
  String? get groupIdFilter => _groupIdFilter;
}

/// 태그 목록 Provider
/// [groupId]: 특정 그룹의 태그, [personal]: 개인 메모 태그, 둘 다 null이면 전체
@riverpod
Future<List<String>> memoTags(
  Ref ref, {
  String? groupId,
  bool? personal,
}) async {
  final repository = ref.watch(memoRepositoryProvider);
  return repository.getTags(groupId: groupId, personal: personal);
}

/// 특정 메모 상세 Provider
@riverpod
Future<MemoModel> memoDetail(
  MemoDetailRef ref,
  String id,
) async {
  final repository = ref.watch(memoRepositoryProvider);
  return await repository.getMemoById(id);
}

/// 메모 관리 Notifier (생성/수정/삭제)
class MemoManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final MemoRepository _repository;
  final Ref _ref;

  MemoManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// 메모 작성
  Future<MemoModel?> createMemo(CreateMemoDto dto) async {
    state = const AsyncValue.loading();
    try {
      final memo = await _repository.createMemo(dto);

      // 목록 갱신
      await _ref.read(memoListProvider.notifier).afterCreate();

      // 태그 목록 갱신
      _ref.invalidate(memoTagsProvider);

      state = const AsyncValue.data(null);
      return memo;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 메모 수정
  Future<MemoModel?> updateMemo(String id, UpdateMemoDto dto) async {
    state = const AsyncValue.loading();
    try {
      final memo = await _repository.updateMemo(id, dto);

      // 목록 갱신
      _ref.read(memoListProvider.notifier).afterUpdate(id, memo);

      // 상세 Provider 무효화
      _ref.invalidate(memoDetailProvider(id));

      state = const AsyncValue.data(null);
      return memo;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// 메모 삭제
  Future<bool> deleteMemo(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteMemo(id);

      // 목록 갱신
      _ref.read(memoListProvider.notifier).afterDelete(id);

      // 상세 Provider 무효화
      _ref.invalidate(memoDetailProvider(id));

      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

/// 메모 관리 Notifier Provider
final memoManagementProvider =
    StateNotifierProvider<MemoManagementNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(memoRepositoryProvider);
  return MemoManagementNotifier(repository, ref);
});

// ── 체크리스트 ──────────────────────────────────────────────────

/// 체크리스트 상태: 항목 목록을 로컬에서 관리
class ChecklistNotifier extends StateNotifier<AsyncValue<List<ChecklistItem>>> {
  final MemoRepository _repository;
  final Ref _ref;
  final String memoId;

  /// 개별 항목 요청 진행 중 ID 집합 (토글/삭제/수정 중복 방지)
  final Set<String> _pendingItemIds = {};
  /// 전체 작업(toggleAll, addItem) 진행 중 여부
  bool _isBusy = false;

  ChecklistNotifier(this._repository, this._ref, this.memoId)
      : super(const AsyncValue.loading());

  /// 초기 항목 목록 세팅 (상세 화면에서 memo.checklistItems 전달)
  void init(List<ChecklistItem> items) {
    state = AsyncValue.data(List<ChecklistItem>.from(items));
  }

  List<ChecklistItem> get _items =>
      state.valueOrNull ?? [];

  /// 항목 추가
  Future<void> addItem(String content) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      final dto = CreateChecklistItemDto(
        content: content,
        order: _items.length,
      );
      final newItem = await _repository.addChecklistItem(memoId, dto);
      state = AsyncValue.data([..._items, newItem]);
      _invalidateDetail();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isBusy = false;
    }
  }

  /// 항목 내용 수정
  Future<void> updateItem(String itemId, String content) async {
    if (_pendingItemIds.contains(itemId)) return;
    _pendingItemIds.add(itemId);
    try {
      final dto = UpdateChecklistItemDto(content: content);
      final updated =
          await _repository.updateChecklistItem(memoId, itemId, dto);
      state = AsyncValue.data(
        _items.map((i) => i.id == itemId ? updated : i).toList(),
      );
      _invalidateDetail();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _pendingItemIds.remove(itemId);
    }
  }

  /// 항목 삭제
  Future<void> deleteItem(String itemId) async {
    if (_pendingItemIds.contains(itemId)) return;
    _pendingItemIds.add(itemId);
    try {
      await _repository.deleteChecklistItem(memoId, itemId);
      state = AsyncValue.data(
        _items.where((i) => i.id != itemId).toList(),
      );
      _invalidateDetail();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _pendingItemIds.remove(itemId);
    }
  }

  /// 항목 체크/해제 토글
  Future<void> toggleItem(String itemId) async {
    if (_pendingItemIds.contains(itemId) || _isBusy) return;
    _pendingItemIds.add(itemId);
    // 낙관적 업데이트
    state = AsyncValue.data(
      _items
          .map((i) => i.id == itemId ? i.copyWith(isChecked: !i.isChecked) : i)
          .toList(),
    );
    try {
      final updated = await _repository.toggleChecklistItem(memoId, itemId);
      state = AsyncValue.data(
        _items.map((i) => i.id == itemId ? updated : i).toList(),
      );
      _invalidateDetail();
    } catch (_) {
      // 실패 시 낙관적 업데이트 롤백
      state = AsyncValue.data(
        _items
            .map((i) => i.id == itemId ? i.copyWith(isChecked: !i.isChecked) : i)
            .toList(),
      );
    } finally {
      _pendingItemIds.remove(itemId);
    }
  }

  /// 전체 선택/해제
  Future<void> toggleAll({required bool checkAll}) async {
    if (_isBusy || _pendingItemIds.isNotEmpty) return;
    _isBusy = true;
    // 낙관적 업데이트
    state = AsyncValue.data(
      _items.map((i) => i.copyWith(isChecked: checkAll)).toList(),
    );
    try {
      await _repository.toggleAllChecklist(memoId, checkAll: checkAll);
      _invalidateDetail();
    } catch (_) {
      // 실패 시 롤백
      state = AsyncValue.data(
        _items.map((i) => i.copyWith(isChecked: !checkAll)).toList(),
      );
    } finally {
      _isBusy = false;
    }
  }

  void _invalidateDetail() {
    _ref.invalidate(memoDetailProvider(memoId));
  }
}

/// 체크리스트 Provider (memoId별 인스턴스)
final checklistProvider = StateNotifierProvider.family<
    ChecklistNotifier, AsyncValue<List<ChecklistItem>>, String>(
  (ref, memoId) {
    final repository = ref.watch(memoRepositoryProvider);
    return ChecklistNotifier(repository, ref, memoId);
  },
);

// ── 핀 ──────────────────────────────────────────────────────────

/// 핀된 메모 목록 Provider
@riverpod
Future<List<MemoModel>> pinnedMemos(
  Ref ref, {
  String? groupId,
  bool? personal,
}) async {
  final repository = ref.watch(memoRepositoryProvider);
  return repository.getPinnedMemos(groupId: groupId, personal: personal);
}

/// 핀 토글 Notifier
class MemoPinNotifier extends StateNotifier<AsyncValue<void>> {
  final MemoRepository _repository;
  final Ref _ref;

  MemoPinNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<MemoModel?> togglePin(String id) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _repository.togglePin(id);

      // 핀 목록 갱신
      _ref.invalidate(pinnedMemosProvider);

      // 메모 목록에서 로컬 상태 업데이트
      _ref.read(memoListProvider.notifier).afterUpdate(id, updated);

      // 상세 Provider 무효화
      _ref.invalidate(memoDetailProvider(id));

      state = const AsyncValue.data(null);
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

/// 핀 토글 Provider
final memoPinProvider =
    StateNotifierProvider<MemoPinNotifier, AsyncValue<void>>((ref) {
  return MemoPinNotifier(ref.watch(memoRepositoryProvider), ref);
});
