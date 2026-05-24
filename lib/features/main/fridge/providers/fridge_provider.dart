import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/main/fridge/data/models/fridge_models.dart';
import 'package:family_planner/features/main/fridge/data/repositories/fridge_repository.dart';

// ── 현재 그룹 ID ──────────────────────────────────────────────────────────────

final fridgeSelectedGroupIdProvider = StateProvider<String?>((ref) => null);

// ── Storage Provider ──────────────────────────────────────────────────────────

final storagesProvider =
    AsyncNotifierProvider<StoragesNotifier, List<StorageModel>>(
        StoragesNotifier.new);

class StoragesNotifier extends AsyncNotifier<List<StorageModel>> {
  @override
  Future<List<StorageModel>> build() async {
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    if (groupId == null) return [];
    return ref.read(fridgeRepositoryProvider).getStorages(groupId: groupId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => future);
  }

  Future<void> create(CreateStorageDto dto) async {
    final repo = ref.read(fridgeRepositoryProvider);
    final created = await repo.createStorage(dto);
    state = AsyncData([...state.value ?? [], created]);
    // storagesWithItemsProvider에도 빈 보관소 섹션 추가
    ref.read(storagesWithItemsProvider.notifier).addStorage(created);
  }

  Future<void> edit(String storageId, UpdateStorageDto dto) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    final repo = ref.read(fridgeRepositoryProvider);
    final updated = await repo.updateStorage(storageId, dto, groupId: groupId);
    state = AsyncData(
      (state.value ?? []).map((s) => s.id == storageId ? updated : s).toList(),
    );
    ref.read(storagesWithItemsProvider.notifier).updateStorage(updated);
  }

  Future<void> delete(String storageId) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    await ref.read(fridgeRepositoryProvider).deleteStorage(storageId, groupId: groupId);
    state = AsyncData((state.value ?? []).where((s) => s.id != storageId).toList());
    ref.read(storagesWithItemsProvider.notifier).removeStorage(storageId);
  }

  Future<void> reorder(List<String> ids) async {
    await ref.read(fridgeRepositoryProvider).reorderStorages(ids);
    final current = state.value ?? [];
    final reordered = ids
        .map((id) => current.firstWhere((s) => s.id == id))
        .toList();
    state = AsyncData(reordered);
  }
}

// ── 보관소 + 품목 통합 Provider ───────────────────────────────────────────────────

final storagesWithItemsProvider = AsyncNotifierProvider<
    StoragesWithItemsNotifier,
    List<StorageWithItemsModel>>(StoragesWithItemsNotifier.new);

class StoragesWithItemsNotifier
    extends AsyncNotifier<List<StorageWithItemsModel>> {
  @override
  Future<List<StorageWithItemsModel>> build() async {
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    if (groupId == null) return [];
    return ref
        .read(fridgeRepositoryProvider)
        .getItemsGroupedByStorage(groupId: groupId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => future);
  }

  void updateItem(FridgeItemModel updated) {
    state = AsyncData(
      (state.value ?? []).map((swi) {
        if (swi.storage.id != updated.storageLocationId) return swi;
        return StorageWithItemsModel(
          storage: swi.storage,
          items: swi.items
              .map((i) => i.id == updated.id ? updated : i)
              .toList(),
        );
      }).toList(),
    );
  }

  void addStorage(StorageModel storage) {
    state = AsyncData([
      ...state.value ?? [],
      StorageWithItemsModel(storage: storage, items: []),
    ]);
  }

  void updateStorage(StorageModel updated) {
    state = AsyncData(
      (state.value ?? []).map((swi) => swi.storage.id == updated.id
          ? StorageWithItemsModel(storage: updated, items: swi.items)
          : swi).toList(),
    );
  }

  void removeStorage(String storageId) {
    state = AsyncData(
      (state.value ?? []).where((swi) => swi.storage.id != storageId).toList(),
    );
  }

  void addItem(FridgeItemModel item) {
    state = AsyncData(
      (state.value ?? []).map((swi) {
        if (swi.storage.id != item.storageLocationId) return swi;
        return StorageWithItemsModel(
          storage: swi.storage,
          items: [...swi.items, item],
        );
      }).toList(),
    );
  }

  void addItems(List<FridgeItemModel> items) {
    var current = state.value ?? [];
    for (final item in items) {
      current = current.map((swi) {
        if (swi.storage.id != item.storageLocationId) return swi;
        return StorageWithItemsModel(
          storage: swi.storage,
          items: [...swi.items, item],
        );
      }).toList();
    }
    state = AsyncData(current);
  }

  void removeItem(String itemId) {
    state = AsyncData(
      (state.value ?? []).map((swi) => StorageWithItemsModel(
            storage: swi.storage,
            items: swi.items.where((i) => i.id != itemId).toList(),
          )).toList(),
    );
  }

  Future<void> bulkUpdate(BulkUpdateFridgeItemDto dto) async {
    await ref.read(fridgeRepositoryProvider).bulkUpdateFridgeItems(dto);
    // 서버가 보관소 목록 전체를 반환하지 않으므로 전체 재조회
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    final fresh = await ref
        .read(fridgeRepositoryProvider)
        .getItemsGroupedByStorage(groupId: groupId);
    state = AsyncData(fresh);
    // 수량 감소 시 자주 사는 항목 연동으로 장바구니가 자동 추가될 수 있으므로 재조회
    ref.invalidate(cartProvider);
  }
}

// ── FridgeItems Provider ───────────────────────────────────────────────────────

/// 보관소 ID → 해당 보관소의 품목 목록 (직접 CRUD용)
final fridgeItemsByStorageProvider = StateNotifierProvider.family<
    FridgeItemsNotifier, List<FridgeItemModel>, String>(
  (ref, storageId) => FridgeItemsNotifier(ref, storageId),
);

class FridgeItemsNotifier extends StateNotifier<List<FridgeItemModel>> {
  final Ref _ref;
  final String storageId;

  FridgeItemsNotifier(this._ref, this.storageId) : super([]);

  void setItems(List<FridgeItemModel> items) {
    state = items;
  }

  Future<void> create(CreateFridgeItemDto dto) async {
    final item = await _ref.read(fridgeRepositoryProvider).createFridgeItem(dto);
    state = [...state, item];
  }

  Future<void> update(String itemId, UpdateFridgeItemDto dto) async {
    final groupId = _ref.read(fridgeSelectedGroupIdProvider);
    final updated = await _ref
        .read(fridgeRepositoryProvider)
        .updateFridgeItem(itemId, dto, groupId: groupId);
    state = state.map((i) => i.id == itemId ? updated : i).toList();
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    final groupId = _ref.read(fridgeSelectedGroupIdProvider);
    final updated = await _ref
        .read(fridgeRepositoryProvider)
        .updateFridgeItemQuantity(itemId, quantity, groupId: groupId);
    state = state.map((i) => i.id == itemId ? updated : i).toList();
    // 수량이 0이 되면 카트를 새로고침 (서버가 자동으로 카트에 추가)
    if (updated.quantity == 0) {
      _ref.invalidate(cartProvider);
    }
  }

  Future<void> delete(String itemId) async {
    final groupId = _ref.read(fridgeSelectedGroupIdProvider);
    await _ref
        .read(fridgeRepositoryProvider)
        .deleteFridgeItem(itemId, groupId: groupId);
    state = state.where((i) => i.id != itemId).toList();
  }
}

// ── FrequentItems Provider ─────────────────────────────────────────────────────

final frequentItemsProvider =
    AsyncNotifierProvider<FrequentItemsNotifier, List<FrequentItemModel>>(
        FrequentItemsNotifier.new);

class FrequentItemsNotifier extends AsyncNotifier<List<FrequentItemModel>> {
  @override
  Future<List<FrequentItemModel>> build() async {
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    if (groupId == null) return [];
    return ref
        .read(fridgeRepositoryProvider)
        .getFrequentItems(groupId: groupId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => future);
  }

  Future<void> create(CreateFrequentItemDto dto) async {
    final item =
        await ref.read(fridgeRepositoryProvider).createFrequentItem(dto);
    state = AsyncData([...state.value ?? [], item]);
  }

  Future<void> edit(String itemId, UpdateFrequentItemDto dto) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    final updated = await ref
        .read(fridgeRepositoryProvider)
        .updateFrequentItem(itemId, dto, groupId: groupId);
    state = AsyncData(
      (state.value ?? []).map((i) => i.id == itemId ? updated : i).toList(),
    );
  }

  Future<void> toggleAutoAdd(String itemId, bool autoAdd) async {
    await edit(itemId, UpdateFrequentItemDto(autoAdd: autoAdd));
  }

  Future<void> delete(String itemId) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    await ref
        .read(fridgeRepositoryProvider)
        .deleteFrequentItem(itemId, groupId: groupId);
    state = AsyncData(
      (state.value ?? []).where((i) => i.id != itemId).toList(),
    );
  }

  Future<void> reorder(List<String> ids) async {
    await ref.read(fridgeRepositoryProvider).reorderFrequentItems(ids);
    final current = state.value ?? [];
    final reordered = ids
        .map((id) => current.firstWhere((i) => i.id == id))
        .toList();
    state = AsyncData(reordered);
  }
}

// ── Cart Provider ─────────────────────────────────────────────────────────────

final cartProvider =
    AsyncNotifierProvider<CartNotifier, CartModel?>(CartNotifier.new);

class CartNotifier extends AsyncNotifier<CartModel?> {
  @override
  Future<CartModel?> build() async {
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    if (groupId == null) return null;
    return ref.read(fridgeRepositoryProvider).getCart(groupId: groupId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => future);
  }

  Future<void> addItem(AddCartItemDto dto) async {
    final item = await ref.read(fridgeRepositoryProvider).addCartItem(dto);
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(items: [...current.items, item]));
    } else {
      await refresh();
    }
  }

  Future<void> bulkAddItems(BulkAddCartItemDto dto) async {
    final newItems =
        await ref.read(fridgeRepositoryProvider).bulkAddCartItems(dto);
    final current = state.value;
    if (current != null) {
      state =
          AsyncData(current.copyWith(items: [...current.items, ...newItems]));
    } else {
      await refresh();
    }
  }

  Future<void> updateItem(String itemId, UpdateCartItemDto dto) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    final updated = await ref
        .read(fridgeRepositoryProvider)
        .updateCartItem(itemId, dto, groupId: groupId);
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          items: current.items
              .map((i) => i.id == itemId ? updated : i)
              .toList(),
        ),
      );
    }
  }

  Future<void> toggleCheck(String itemId, bool checked) async {
    await updateItem(itemId, UpdateCartItemDto(isChecked: checked));
  }

  Future<void> deleteItem(String itemId) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    await ref
        .read(fridgeRepositoryProvider)
        .deleteCartItem(itemId, groupId: groupId);
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          items: current.items.where((i) => i.id != itemId).toList(),
        ),
      );
    }
  }

  Future<void> bulkUpdate(BulkUpdateCartItemDto dto) async {
    final updated = await ref.read(fridgeRepositoryProvider).bulkUpdateCartItems(dto);
    state = AsyncData(updated);
  }

  Future<ShoppingHistoryModel> complete(CompleteCartDto dto) async {
    final history =
        await ref.read(fridgeRepositoryProvider).completeCart(dto);
    // AsyncLoading을 거치지 않고 즉시 빈 장바구니로 교체 → 다이얼로그 유지
    state = const AsyncData(null);
    // 보관소·이력은 invalidate로 백그라운드 갱신
    ref.invalidate(storagesWithItemsProvider);
    ref.invalidate(shoppingHistoryProvider);
    return history;
  }
}

// ── Shopping History Provider ─────────────────────────────────────────────────

final shoppingHistoryProvider =
    AsyncNotifierProvider<ShoppingHistoryNotifier, ShoppingHistoryPageModel>(
        ShoppingHistoryNotifier.new);

class ShoppingHistoryNotifier
    extends AsyncNotifier<ShoppingHistoryPageModel> {
  static const _limit = 20;

  @override
  Future<ShoppingHistoryPageModel> build() async {
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    if (groupId == null) {
      return ShoppingHistoryPageModel(data: [], total: 0, page: 1, limit: _limit);
    }
    return ref.read(fridgeRepositoryProvider).getShoppingHistory(
          groupId: groupId,
          page: 1,
          limit: _limit,
        );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => future);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore) return;
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    final next = await ref.read(fridgeRepositoryProvider).getShoppingHistory(
          groupId: groupId,
          page: current.page + 1,
          limit: _limit,
        );
    state = AsyncData(ShoppingHistoryPageModel(
      data: [...current.data, ...next.data],
      total: next.total,
      page: next.page,
      limit: next.limit,
    ));
  }
}

final shoppingHistoryDetailProvider =
    FutureProvider.family<ShoppingHistoryModel, (String, String?)>((ref, args) async {
  final (historyId, groupId) = args;
  final resolvedGroupId = groupId ?? ref.watch(fridgeSelectedGroupIdProvider);
  return ref
      .read(fridgeRepositoryProvider)
      .getShoppingHistoryById(historyId, groupId: resolvedGroupId);
});

// ── ItemNames Provider ────────────────────────────────────────────────────────
// 자동완성용 품목명 전체 목록 — 그룹 변경 시 자동 갱신, 세션 동안 캐시 유지

final itemNamesProvider =
    AsyncNotifierProvider<ItemNamesNotifier, List<String>>(
        ItemNamesNotifier.new);

class ItemNamesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    if (groupId == null) return [];

    // 냉장고 품목명 + 유통기한 프리셋 카테고리를 합산하여 중복 제거
    final results = await Future.wait([
      ref.read(fridgeRepositoryProvider).getItemNameSuggestions(groupId: groupId),
      ref.read(fridgeRepositoryProvider).getExpiryPresets(groupId: groupId),
    ]);

    final itemNames = results[0] as List<String>;
    final presets = results[1] as List<ExpiryPresetModel>;
    // category + keywords 모두 자동완성 후보에 포함
    final presetNames = presets.expand((p) => [p.category, ...p.keywords]).toList();

    final merged = {...itemNames, ...presetNames}.toList()..sort();
    return merged;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => future);
  }
}

// ── ExpiryPresets Provider ────────────────────────────────────────────────────

final expiryPresetsProvider =
    AsyncNotifierProvider<ExpiryPresetsNotifier, List<ExpiryPresetModel>>(
        ExpiryPresetsNotifier.new);

class ExpiryPresetsNotifier extends AsyncNotifier<List<ExpiryPresetModel>> {
  @override
  Future<List<ExpiryPresetModel>> build() async {
    final groupId = ref.watch(fridgeSelectedGroupIdProvider);
    return ref
        .read(fridgeRepositoryProvider)
        .getExpiryPresets(groupId: groupId);
  }

  Future<void> upsert(UpsertExpiryPresetDto dto) async {
    final updated =
        await ref.read(fridgeRepositoryProvider).upsertExpiryPreset(dto);
    final current = state.value ?? [];
    final idx = current.indexWhere(
        (p) => p.category == updated.category && p.storageType == updated.storageType);
    if (idx >= 0) {
      final next = [...current];
      next[idx] = updated;
      state = AsyncData(next);
    } else {
      state = AsyncData([...current, updated]);
    }
  }

  Future<void> delete(String presetId) async {
    final groupId = ref.read(fridgeSelectedGroupIdProvider);
    await ref
        .read(fridgeRepositoryProvider)
        .deleteExpiryPreset(presetId, groupId: groupId);
    state = AsyncData(
        (state.value ?? []).where((p) => p.customPresetId != presetId).toList());
  }
}

// ── 대시보드용 냉장고 유통기한 임박 품목 Provider ────────────────────────────────

/// storagesWithItemsProvider를 watch해서 파생하므로
/// 냉장고 품목이 변경되면 대시보드 위젯도 즉시 반영된다.
final fridgeExpiryItemsProvider =
    Provider<AsyncValue<List<FridgeItemModel>>>((ref) {
  final swisAsync = ref.watch(storagesWithItemsProvider);
  return swisAsync.whenData((swis) {
    final now = DateTime.now();
    final items = swis.expand((s) => s.items).where((item) {
      if (item.expiresAt == null) return false;
      final days = item.expiresAt!.difference(now).inDays;
      return days <= item.alertDaysBefore;
    }).toList()
      ..sort((a, b) {
        final da = a.expiresAt!.difference(now).inDays;
        final db = b.expiresAt!.difference(now).inDays;
        return da.compareTo(db);
      });
    return items;
  });
});

