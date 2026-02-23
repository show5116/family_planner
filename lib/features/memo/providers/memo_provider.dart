import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/memo/data/models/memo_model.dart';
import 'package:family_planner/features/memo/data/repositories/memo_repository.dart';
import 'package:family_planner/features/memo/data/dto/memo_dto.dart';

part 'memo_provider.g.dart';

/// 메모 목록 Provider (무한 스크롤 + 검색 지원)
@riverpod
class MemoList extends _$MemoList {
  int _currentPage = 1;
  bool _hasMore = true;
  List<MemoModel> _items = [];
  String? _searchQuery;
  String? _categoryFilter;

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
      category: _categoryFilter,
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

  /// 카테고리 필터 설정
  Future<void> setCategory(String? category) async {
    _categoryFilter = category;
    await refresh();
  }

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

  /// 현재 카테고리 필터
  String? get categoryFilter => _categoryFilter;
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
