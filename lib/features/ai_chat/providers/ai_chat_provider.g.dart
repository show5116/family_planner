// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiChatHash() => r'9e698b72bc19cc31443970e18345548fd3985a6f';

/// 채팅 메시지 목록 + 전송 로직
///
/// Copied from [AiChat].
@ProviderFor(AiChat)
final aiChatProvider =
    AutoDisposeNotifierProvider<AiChat, List<AiChatMessage>>.internal(
      AiChat.new,
      name: r'aiChatProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiChatHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiChat = AutoDisposeNotifier<List<AiChatMessage>>;
String _$aiChatLoadingHash() => r'5f07d223723b36c0b3817094f071c42e1d0e59d6';

/// AI 응답 로딩 상태
///
/// Copied from [AiChatLoading].
@ProviderFor(AiChatLoading)
final aiChatLoadingProvider =
    AutoDisposeNotifierProvider<AiChatLoading, bool>.internal(
      AiChatLoading.new,
      name: r'aiChatLoadingProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiChatLoadingHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AiChatLoading = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
