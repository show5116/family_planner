// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qna_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questionDetailHash() => r'8643e7b0f1bc1e1dc07a1ae3619c4202879988f4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 질문 상세 Provider
///
/// Copied from [questionDetail].
@ProviderFor(questionDetail)
const questionDetailProvider = QuestionDetailFamily();

/// 질문 상세 Provider
///
/// Copied from [questionDetail].
class QuestionDetailFamily extends Family<AsyncValue<QuestionModel>> {
  /// 질문 상세 Provider
  ///
  /// Copied from [questionDetail].
  const QuestionDetailFamily();

  /// 질문 상세 Provider
  ///
  /// Copied from [questionDetail].
  QuestionDetailProvider call(String id) {
    return QuestionDetailProvider(id);
  }

  @override
  QuestionDetailProvider getProviderOverride(
    covariant QuestionDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'questionDetailProvider';
}

/// 질문 상세 Provider
///
/// Copied from [questionDetail].
class QuestionDetailProvider extends AutoDisposeFutureProvider<QuestionModel> {
  /// 질문 상세 Provider
  ///
  /// Copied from [questionDetail].
  QuestionDetailProvider(String id)
    : this._internal(
        (ref) => questionDetail(ref as QuestionDetailRef, id),
        from: questionDetailProvider,
        name: r'questionDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$questionDetailHash,
        dependencies: QuestionDetailFamily._dependencies,
        allTransitiveDependencies:
            QuestionDetailFamily._allTransitiveDependencies,
        id: id,
      );

  QuestionDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<QuestionModel> Function(QuestionDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuestionDetailProvider._internal(
        (ref) => create(ref as QuestionDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<QuestionModel> createElement() {
    return _QuestionDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuestionDetailRef on AutoDisposeFutureProviderRef<QuestionModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _QuestionDetailProviderElement
    extends AutoDisposeFutureProviderElement<QuestionModel>
    with QuestionDetailRef {
  _QuestionDetailProviderElement(super.provider);

  @override
  String get id => (origin as QuestionDetailProvider).id;
}

String _$publicQuestionsHash() => r'1a61d1d60ce4c6476cea7f6ca8a76104c2475be7';

/// 공개 질문 목록 Provider
///
/// Copied from [PublicQuestions].
@ProviderFor(PublicQuestions)
final publicQuestionsProvider =
    AutoDisposeAsyncNotifierProvider<
      PublicQuestions,
      List<QuestionModel>
    >.internal(
      PublicQuestions.new,
      name: r'publicQuestionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$publicQuestionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PublicQuestions = AutoDisposeAsyncNotifier<List<QuestionModel>>;
String _$myQuestionsHash() => r'a2f77a0495473d934acb17325c9ff419cb412329';

/// 내 질문 목록 Provider
///
/// Copied from [MyQuestions].
@ProviderFor(MyQuestions)
final myQuestionsProvider =
    AutoDisposeAsyncNotifierProvider<MyQuestions, List<QuestionModel>>.internal(
      MyQuestions.new,
      name: r'myQuestionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$myQuestionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MyQuestions = AutoDisposeAsyncNotifier<List<QuestionModel>>;
String _$questionManagementHash() =>
    r'1f367354e968b88627c8ed2a888847792c901938';

/// 질문 관리 Provider (작성, 수정, 삭제)
///
/// Copied from [QuestionManagement].
@ProviderFor(QuestionManagement)
final questionManagementProvider =
    AutoDisposeAsyncNotifierProvider<QuestionManagement, void>.internal(
      QuestionManagement.new,
      name: r'questionManagementProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$questionManagementHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuestionManagement = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
