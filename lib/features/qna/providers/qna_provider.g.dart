// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qna_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$questionDetailHash() => r'dfa4f7b899fa57794be4852aa68f3dedd9315c18';

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
/// autoDispose: 상세 화면을 벗어나면 캐시 삭제
///
/// Copied from [questionDetail].
@ProviderFor(questionDetail)
const questionDetailProvider = QuestionDetailFamily();

/// 질문 상세 Provider
///
/// autoDispose: 상세 화면을 벗어나면 캐시 삭제
///
/// Copied from [questionDetail].
class QuestionDetailFamily extends Family<AsyncValue<QuestionModel>> {
  /// 질문 상세 Provider
  ///
  /// autoDispose: 상세 화면을 벗어나면 캐시 삭제
  ///
  /// Copied from [questionDetail].
  const QuestionDetailFamily();

  /// 질문 상세 Provider
  ///
  /// autoDispose: 상세 화면을 벗어나면 캐시 삭제
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
/// autoDispose: 상세 화면을 벗어나면 캐시 삭제
///
/// Copied from [questionDetail].
class QuestionDetailProvider extends AutoDisposeFutureProvider<QuestionModel> {
  /// 질문 상세 Provider
  ///
  /// autoDispose: 상세 화면을 벗어나면 캐시 삭제
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

String _$questionsHash() => r'6c083822156afda1b759964e4c040f4632824d48';

abstract class _$Questions
    extends BuildlessAutoDisposeAsyncNotifier<List<QuestionListItem>> {
  late final String? filter;

  FutureOr<List<QuestionListItem>> build({String? filter});
}

/// 질문 목록 Provider (통합)
///
/// autoDispose: 화면을 벗어나면 캐시 삭제 → 항상 최신 데이터 보장
/// keepAlive: 페이징 중에는 캐시 유지
///
/// Copied from [Questions].
@ProviderFor(Questions)
const questionsProvider = QuestionsFamily();

/// 질문 목록 Provider (통합)
///
/// autoDispose: 화면을 벗어나면 캐시 삭제 → 항상 최신 데이터 보장
/// keepAlive: 페이징 중에는 캐시 유지
///
/// Copied from [Questions].
class QuestionsFamily extends Family<AsyncValue<List<QuestionListItem>>> {
  /// 질문 목록 Provider (통합)
  ///
  /// autoDispose: 화면을 벗어나면 캐시 삭제 → 항상 최신 데이터 보장
  /// keepAlive: 페이징 중에는 캐시 유지
  ///
  /// Copied from [Questions].
  const QuestionsFamily();

  /// 질문 목록 Provider (통합)
  ///
  /// autoDispose: 화면을 벗어나면 캐시 삭제 → 항상 최신 데이터 보장
  /// keepAlive: 페이징 중에는 캐시 유지
  ///
  /// Copied from [Questions].
  QuestionsProvider call({String? filter}) {
    return QuestionsProvider(filter: filter);
  }

  @override
  QuestionsProvider getProviderOverride(covariant QuestionsProvider provider) {
    return call(filter: provider.filter);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'questionsProvider';
}

/// 질문 목록 Provider (통합)
///
/// autoDispose: 화면을 벗어나면 캐시 삭제 → 항상 최신 데이터 보장
/// keepAlive: 페이징 중에는 캐시 유지
///
/// Copied from [Questions].
class QuestionsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          Questions,
          List<QuestionListItem>
        > {
  /// 질문 목록 Provider (통합)
  ///
  /// autoDispose: 화면을 벗어나면 캐시 삭제 → 항상 최신 데이터 보장
  /// keepAlive: 페이징 중에는 캐시 유지
  ///
  /// Copied from [Questions].
  QuestionsProvider({String? filter})
    : this._internal(
        () => Questions()..filter = filter,
        from: questionsProvider,
        name: r'questionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$questionsHash,
        dependencies: QuestionsFamily._dependencies,
        allTransitiveDependencies: QuestionsFamily._allTransitiveDependencies,
        filter: filter,
      );

  QuestionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filter,
  }) : super.internal();

  final String? filter;

  @override
  FutureOr<List<QuestionListItem>> runNotifierBuild(
    covariant Questions notifier,
  ) {
    return notifier.build(filter: filter);
  }

  @override
  Override overrideWith(Questions Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuestionsProvider._internal(
        () => create()..filter = filter,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filter: filter,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<Questions, List<QuestionListItem>>
  createElement() {
    return _QuestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuestionsProvider && other.filter == filter;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuestionsRef
    on AutoDisposeAsyncNotifierProviderRef<List<QuestionListItem>> {
  /// The parameter `filter` of this provider.
  String? get filter;
}

class _QuestionsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          Questions,
          List<QuestionListItem>
        >
    with QuestionsRef {
  _QuestionsProviderElement(super.provider);

  @override
  String? get filter => (origin as QuestionsProvider).filter;
}

String _$questionManagementHash() =>
    r'70a05394da850b40acde94a0c3eef712f4d86392';

/// 질문 관리 Provider (작성, 수정, 삭제)
///
/// 상태를 저장하지 않고 단순 액션 처리용
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
