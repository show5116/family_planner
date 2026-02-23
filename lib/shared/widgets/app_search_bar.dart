import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 공통 검색바 위젯
///
/// 검색어 입력 후 검색 버튼(돋보기) 또는 엔터 키를 눌러야 검색이 실행됩니다.
/// 캘린더, 할일, 메모 등 검색이 필요한 모든 화면에서 재사용합니다.
///
/// 사용 예:
/// ```dart
/// AppSearchBar(
///   hintText: l10n.memo_searchHint,
///   onSearch: (query) => ref.read(memoListProvider.notifier).setSearch(query),
///   onClose: () {
///     ref.read(searchActiveProvider.notifier).state = false;
///   },
/// )
/// ```
class AppSearchBar extends StatefulWidget {
  /// 검색 실행 콜백 — null이면 검색 해제
  final ValueChanged<String?> onSearch;

  /// 닫기(X) 버튼 콜백
  final VoidCallback onClose;

  /// 힌트 텍스트
  final String? hintText;

  /// 초기 검색어
  final String? initialQuery;

  const AppSearchBar({
    super.key,
    required this.onSearch,
    required this.onClose,
    this.hintText,
    this.initialQuery,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 검색 실행 (버튼 또는 엔터) — 명시적 사용자 액션에만 호출됨
  void _submitSearch() {
    final query = _controller.text.trim();
    widget.onSearch(query.isEmpty ? null : query);
  }

  /// 검색어 초기화 및 닫기 — 검색 해제는 onClose 콜백에 위임
  void _clearAndClose() {
    _controller.clear();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hintText = widget.hintText ?? l10n.common_search;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spaceM,
        vertical: AppSizes.spaceS,
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          // 검색 버튼 (왼쪽) — 클릭 시 검색 실행
          prefixIcon: IconButton(
            icon: const Icon(Icons.search),
            tooltip: l10n.common_search,
            onPressed: _submitSearch,
          ),
          // 닫기 버튼 (오른쪽) — 검색 초기화 + 검색바 닫기
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            tooltip: l10n.common_close,
            onPressed: _clearAndClose,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceM,
            vertical: AppSizes.spaceS,
          ),
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _submitSearch(),
      ),
    );
  }
}
