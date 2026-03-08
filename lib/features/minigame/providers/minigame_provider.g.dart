// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minigame_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$minigameResultsHash() => r'6d4723a91116594a99b375aab86877eec3700c91';

/// 게임 이력 목록 Provider
///
/// Copied from [MinigameResults].
@ProviderFor(MinigameResults)
final minigameResultsProvider =
    AutoDisposeAsyncNotifierProvider<
      MinigameResults,
      List<MinigameResult>
    >.internal(
      MinigameResults.new,
      name: r'minigameResultsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$minigameResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MinigameResults = AutoDisposeAsyncNotifier<List<MinigameResult>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
