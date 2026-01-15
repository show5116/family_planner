// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fcmTokenHash() => r'97f0f2f28d267b77de5d089f7a330f73eb5060f1';

/// FCM 토큰 Provider
///
/// Copied from [FcmToken].
@ProviderFor(FcmToken)
final fcmTokenProvider =
    AutoDisposeAsyncNotifierProvider<FcmToken, String?>.internal(
      FcmToken.new,
      name: r'fcmTokenProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fcmTokenHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FcmToken = AutoDisposeAsyncNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
