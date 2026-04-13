import 'package:flutter/material.dart';

import 'package:family_planner/features/main/task/providers/task_form_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

/// 제목 입력 필드 위젯
class TitleField extends StatefulWidget {
  final TextEditingController controller;
  final TaskFormNotifier formNotifier;

  const TitleField({
    super.key,
    required this.controller,
    required this.formNotifier,
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

/// 장소 입력 필드 위젯
class LocationField extends StatefulWidget {
  final TextEditingController controller;
  final TaskFormNotifier formNotifier;

  const LocationField({
    super.key,
    required this.controller,
    required this.formNotifier,
  });

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
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
    widget.formNotifier.setLocation(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: l10n.schedule_location,
        hintText: l10n.schedule_locationHint,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.location_on_outlined),
      ),
      textInputAction: TextInputAction.next,
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
