import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/repositories/memo_repository.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';

part 'memo_provider.g.dart';

/// 메모 필터 선택값 Provider
final memoSelectedFilterProvider = StateProvider<String?>((ref) => null);

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

  Future<void> loadMore() async {
    if (!_hasMore) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadMemos(page: _currentPage + 1));
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    _items = [];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _loadMemos(page: 1));
  }

  Future<void> setSearch(String? query) async {
    _searchQuery = (query != null && query.trim().isEmpty) ? null : query?.trim();
    await refresh();
  }

  Future<void> setFilter({String? groupId, String? visibility}) async {
    _groupIdFilter = groupId;
    _visibilityFilter = visibility;
    await refresh();
  }

  Future<void> setTag(String? tag) async {
    _tagFilter = tag;
    await refresh();
  }

  Future<void> afterCreate() async => await refresh();

  Future<void> afterUpdate(String id, MemoModel updated) async {
    if (_items.isEmpty) return;
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items = List<MemoModel>.from(_items)..[index] = updated;
      state = AsyncValue.data([..._items]);
    }
  }

  Future<void> afterDelete(String id) async {
    if (_items.isEmpty) return;
    _items = List<MemoModel>.from(_items)..removeWhere((item) => item.id == id);
    state = AsyncValue.data([..._items]);
  }

  bool get hasMore => _hasMore;
  String? get searchQuery => _searchQuery;
  String? get visibilityFilter => _visibilityFilter;
  String? get groupIdFilter => _groupIdFilter;
  String? get tagFilter => _tagFilter;
}

/// 태그 목록 Provider
@riverpod
Future<List<String>> memoTags(
  Ref ref, {
  String? groupId,
  bool? personal,
}) async {
  final repository = ref.watch(memoRepositoryProvider);
  return repository.getTags(groupId: groupId, personal: personal);
}

/// 메모 상세 Provider
@riverpod
Future<MemoModel> memoDetail(
  Ref ref,
  String id,
) async {
  final repository = ref.watch(memoRepositoryProvider);
  return await repository.getMemoById(id);
}

/// 메모 관리 Notifier (생성/수정/삭제/체크 토글)
class MemoManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final MemoRepository _repository;
  final Ref _ref;

  MemoManagementNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<MemoModel?> createMemo(CreateMemoDto dto) async {
    state = const AsyncValue.loading();
    try {
      final memo = await _repository.createMemo(dto);
      await _ref.read(memoListProvider.notifier).afterCreate();
      _ref.invalidate(memoTagsProvider);
      state = const AsyncValue.data(null);
      return memo;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<MemoModel?> updateMemo(String id, UpdateMemoDto dto) async {
    state = const AsyncValue.loading();
    try {
      final memo = await _repository.updateMemo(id, dto);
      _ref.read(memoListProvider.notifier).afterUpdate(id, memo);
      _ref.invalidate(memoDetailProvider(id));
      state = const AsyncValue.data(null);
      return memo;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> deleteMemo(String id) async {
    state = const AsyncValue.loading();
    try {
      await _repository.deleteMemo(id);
      _ref.read(memoListProvider.notifier).afterDelete(id);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final memoManagementProvider =
    StateNotifierProvider<MemoManagementNotifier, AsyncValue<void>>((ref) {
  return MemoManagementNotifier(ref.watch(memoRepositoryProvider), ref);
});

// ── 핀 ──────────────────────────────────────────────────────────

@riverpod
Future<List<MemoModel>> pinnedMemos(
  Ref ref, {
  String? groupId,
  bool? personal,
}) async {
  final repository = ref.watch(memoRepositoryProvider);
  return repository.getPinnedMemos(groupId: groupId, personal: personal);
}

class MemoPinNotifier extends StateNotifier<AsyncValue<void>> {
  final MemoRepository _repository;
  final Ref _ref;

  MemoPinNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  Future<MemoModel?> togglePin(String id) async {
    state = const AsyncValue.loading();
    try {
      final updated = await _repository.togglePin(id);
      _ref.invalidate(pinnedMemosProvider);
      _ref.read(memoListProvider.notifier).afterUpdate(id, updated);
      _ref.invalidate(memoDetailProvider(id));
      state = const AsyncValue.data(null);
      return updated;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final memoPinProvider =
    StateNotifierProvider<MemoPinNotifier, AsyncValue<void>>((ref) {
  return MemoPinNotifier(ref.watch(memoRepositoryProvider), ref);
});
