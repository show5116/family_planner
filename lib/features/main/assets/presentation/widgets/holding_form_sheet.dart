import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/holding_model.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';

class HoldingFormSheet extends ConsumerStatefulWidget {
  final String accountId;
  final HoldingModel? existing;

  const HoldingFormSheet({super.key, required this.accountId, this.existing});

  @override
  ConsumerState<HoldingFormSheet> createState() => _HoldingFormSheetState();
}

class _HoldingFormSheetState extends ConsumerState<HoldingFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _tickerCtrl;
  late final TextEditingController _ratioCtrl;
  bool _loading = false;
  String? _errorMsg;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _tickerCtrl = TextEditingController(text: widget.existing?.ticker ?? '');
    _ratioCtrl = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.ratio.toStringAsFixed(
              widget.existing!.ratio % 1 == 0 ? 0 : 2,
            )
          : '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tickerCtrl.dispose();
    _ratioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom +
            AppSizes.spaceM,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEdit ? l10n.asset_holding_edit : l10n.asset_holding_add,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSizes.spaceM),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.asset_holding_name,
                  hintText: l10n.asset_holding_name_hint,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.asset_holding_name_required
                    : null,
              ),
              const SizedBox(height: AppSizes.spaceM),
              TextFormField(
                controller: _tickerCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: l10n.asset_holding_ticker,
                  hintText: l10n.asset_holding_ticker_hint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),
              TextFormField(
                controller: _ratioCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.asset_holding_ratio,
                  hintText: l10n.asset_holding_ratio_hint,
                  suffixText: '%',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.asset_holding_ratio_required;
                  }
                  final n = double.tryParse(v.trim());
                  if (n == null || n < 0.01 || n > 100) {
                    return l10n.asset_holding_ratio_invalid;
                  }
                  return null;
                },
              ),
              if (_errorMsg != null) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(_errorMsg!,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: AppSizes.spaceL),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.common_save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    final ticker = _tickerCtrl.text.trim();
    final ratio = double.parse(_ratioCtrl.text.trim());
    final notifier = ref.read(holdingsProvider(widget.accountId).notifier);

    try {
      if (_isEdit) {
        await notifier.update(
          widget.existing!.id,
          UpdateHoldingDto(
            name: name,
            ticker: ticker.isEmpty ? null : ticker,
            ratio: ratio,
          ),
        );
      } else {
        await notifier.create(
          CreateHoldingDto(
            name: name,
            ticker: ticker.isEmpty ? null : ticker,
            ratio: ratio,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMsg = e.toString().contains('100%')
            ? l10n.asset_holding_ratio_exceeded
            : l10n.common_error;
      });
    }
  }
}
