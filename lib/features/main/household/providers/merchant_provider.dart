import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:family_planner/features/main/household/data/models/merchant_model.dart';
import 'package:family_planner/features/main/household/data/repositories/household_repository.dart';
import 'package:family_planner/features/main/household/providers/household_provider.dart';

part 'merchant_provider.g.dart';

/// 소비처 목록 Provider
/// keepAlive는 MerchantsScreen이 마운트될 때 활성화되고 dispose 시 해제됩니다.
@riverpod
class Merchants extends _$Merchants {
  KeepAliveLink? _keepAliveLink;

  void keepAlive() {
    _keepAliveLink ??= ref.keepAlive();
  }

  void releaseKeepAlive() {
    _keepAliveLink?.close();
    _keepAliveLink = null;
  }

  @override
  Future<List<MerchantModel>> build() async {
    final groupId = ref.watch(householdSelectedGroupIdProvider);
    return ref.watch(householdRepositoryProvider).getMerchants(groupId: groupId);
  }

  Future<MerchantModel?> create(String name) async {
    final groupId = ref.read(householdSelectedGroupIdProvider);
    final merchant = await ref
        .read(householdRepositoryProvider)
        .createMerchant(CreateMerchantDto(groupId: groupId, name: name));
    state = AsyncValue.data([merchant, ...state.valueOrNull ?? []]);
    return merchant;
  }

  Future<void> edit(String id, String name) async {
    final merchant = await ref
        .read(householdRepositoryProvider)
        .updateMerchant(id, UpdateMerchantDto(name: name));
    state = AsyncValue.data(
      (state.valueOrNull ?? []).map((m) => m.id == id ? merchant : m).toList(),
    );
  }

  Future<void> remove(String id) async {
    await ref.read(householdRepositoryProvider).deleteMerchant(id);
    state = AsyncValue.data(
      (state.valueOrNull ?? []).where((m) => m.id != id).toList(),
    );
  }
}
