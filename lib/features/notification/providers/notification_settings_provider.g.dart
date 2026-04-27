// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationSettingsHash() =>
    r'3024da13d94f15f6e2be85a314f1685c5b953852';

/// 알림 설정 Provider
///
/// Copied from [NotificationSettings].
@ProviderFor(NotificationSettings)
final notificationSettingsProvider =
    AutoDisposeAsyncNotifierProvider<
      NotificationSettings,
      NotificationSettingsModel
    >.internal(
      NotificationSettings.new,
      name: r'notificationSettingsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$notificationSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NotificationSettings =
    AutoDisposeAsyncNotifier<NotificationSettingsModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
