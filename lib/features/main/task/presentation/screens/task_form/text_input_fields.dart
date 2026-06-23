import 'package:flutter/material.dart';

import 'package:family_planner/core/constants/app_colors.dart';
import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/core/services/place_search_service.dart';
import 'package:family_planner/features/main/task/data/models/task_model.dart';
import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 제목 입력 필드 위젯
class TitleField extends StatefulWidget {
  final TextEditingController controller;
  final TaskFormNotifier formNotifier;
  final FocusNode? focusNode;

  const TitleField({
    super.key,
    required this.controller,
    required this.formNotifier,
    this.focusNode,
  });

  @override
  State<TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<TitleField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    widget.formNotifier.setTitle(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        labelText: l10n.schedule_title,
        hintText: l10n.schedule_titleHint,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.title),
      ),
      textInputAction: TextInputAction.next,
      maxLength: 100,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.schedule_titleRequired;
        }
        return null;
      },
    );
  }
}

/// 장소 선택 필드 (탭 시 카카오 장소 검색 바텀시트)
class LocationField extends StatelessWidget {
  final TaskLocation? location;
  final TaskFormNotifier formNotifier;

  const LocationField({
    super.key,
    required this.location,
    required this.formNotifier,
  });

  void _openSearch(BuildContext context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _PlaceSearchSheet(
        onSelected: (place) => formNotifier.setLocation(place.toTaskLocation()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasLocation = location != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _openSearch(context),
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.schedule_location,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on_outlined),
              suffixIcon: hasLocation
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () => formNotifier.setLocation(null),
                    )
                  : const Icon(Icons.search, size: 18),
            ),
            child: Text(
              hasLocation ? location!.name : l10n.schedule_locationHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: hasLocation
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (hasLocation) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Padding(
            padding: const EdgeInsets.only(left: AppSizes.spaceS),
            child: Text(
              location!.address,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}

/// 카카오 장소 검색 바텀시트
class _PlaceSearchSheet extends StatefulWidget {
  final ValueChanged<PlaceSearchResult> onSelected;

  const _PlaceSearchSheet({required this.onSelected});

  @override
  State<_PlaceSearchSheet> createState() => _PlaceSearchSheetState();
}

class _PlaceSearchSheetState extends State<_PlaceSearchSheet> {
  final _controller = TextEditingController();
  List<PlaceSearchResult> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    final results = await PlaceSearchService.search(query);
    if (mounted) setState(() { _results = results; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            // 핸들
            const SizedBox(height: AppSizes.spaceS),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceM),
            // 검색창
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '장소명 또는 주소 검색',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _results = []);
                          },
                        )
                      : null,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _search,
                onChanged: (v) {
                  setState(() {});
                  if (v.length >= 2) _search(v);
                },
              ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            // 결과 목록
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                      ? Center(
                          child: Text(
                            _controller.text.isEmpty ? '장소를 검색해보세요' : '검색 결과가 없습니다',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _results.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final place = _results[i];
                            return ListTile(
                              leading: const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.primary,
                              ),
                              title: Text(place.name),
                              subtitle: Text(
                                place.roadAddress.isNotEmpty
                                    ? place.roadAddress
                                    : place.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: place.category != null && place.category!.isNotEmpty
                                  ? Text(
                                      place.category!,
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant,
                                      ),
                                    )
                                  : null,
                              onTap: () {
                                widget.onSelected(place);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 설명 입력 필드 위젯
class DescriptionField extends StatefulWidget {
  final TextEditingController controller;
  final TaskFormNotifier formNotifier;

  const DescriptionField({
    super.key,
    required this.controller,
    required this.formNotifier,
  });

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    widget.formNotifier.setDescription(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: l10n.schedule_description,
        hintText: l10n.schedule_descriptionHint,
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      maxLines: 4,
      textInputAction: TextInputAction.done,
    );
  }
}
