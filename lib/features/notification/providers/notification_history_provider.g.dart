// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationHistoryHash() =>
    r'447b70a7b0023a989adfa960adf50dbe6606c44a';

/// 알림 히스토리 Provider
///
/// Copied from [NotificationHistory].
@ProviderFor(NotificationHistory)
final notificationHistoryProvider =
    AutoDisposeAsyncNotifierProvider<
      NotificationHistory,
      List<NotificationModel>
    >.internal(
      NotificationHistory.new,
      name: r'notificationHistoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationHistory =
    AutoDisposeAsyncNotifier<List<NotificationModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
