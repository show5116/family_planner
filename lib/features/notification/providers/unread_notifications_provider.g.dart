// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unreadNotificationsHash() =>
    r'adb1c87142d15d0468059b865701a1604181ff08';

/// 읽지 않은 알림 Provider
/// 홈 화면에서 최신 읽지 않은 알림 목록을 표시하기 위해 사용
///
/// Copied from [UnreadNotifications].
@ProviderFor(UnreadNotifications)
final unreadNotificationsProvider =
    AutoDisposeAsyncNotifierProvider<
      UnreadNotifications,
      List<NotificationModel>
    >.internal(
      UnreadNotifications.new,
      name: r'unreadNotificationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$unreadNotificationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UnreadNotifications =
    AutoDisposeAsyncNotifier<List<NotificationModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
