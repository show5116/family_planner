import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/holding_record_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';

// ─── 색상 팔레트 ───────────────────────────────────────────────────────────────
const _palette = [
  Color(0xFF4285F4),
  Color(0xFFEA4335),
  Color(0xFFFBBC05),
  Color(0xFF34A853),
  Color(0xFFAB47BC),
  Color(0xFF00ACC1),
  Color(0xFFFF7043),
  Color(0xFF8D6E63),
];

Color _colorFor(int index) => _palette[index % _palette.length];

// ─── 파이차트 Painter ──────────────────────────────────────────────────────────
class _PieChartPainter extends CustomPainter {
  final List<HoldingRecordModel> records;
  final double totalRatio;

  _PieChartPainter(this.records, this.totalRatio);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    final remaining = (100 - totalRatio).clamp(0.0, 100.0);
    final items = [
      ...records.map((r) => (ratio: r.ratio, color: _colorFor(records.indexOf(r)))),
      if (remaining > 0) (ratio: remaining, color: const Color(0xFFE0E0E0)),
    ];

    double startAngle = -math.pi / 2;
    for (final item in items) {
      final sweep = (item.ratio / 100) * 2 * math.pi;
      paint.color = item.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        paint,
      );
      startAngle += sweep;
    }

    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, paint);
  }

  @override
  bool shouldRepaint(_PieChartPainter old) =>
      old.records != records || old.totalRatio != totalRatio;
}

// ─── 메인 섹션 ─────────────────────────────────────────────────────────────────
class HoldingRecordsSection extends ConsumerStatefulWidget {
  final String accountId;
  /// 자산 기록 목록 — 날짜 선택기의 선택지로 사용
  final List<AssetRecordModel> assetRecords;

  const HoldingRecordsSection({
    super.key,
    required this.accountId,
    required this.assetRecords,
  });

  @override
  ConsumerState<HoldingRecordsSection> createState() => _HoldingRecordsSectionState();
}

class _HoldingRecordsSectionState extends ConsumerState<HoldingRecordsSection> {
  String? _selectedDate; // YYYY-MM-DD

  @override
  void initState() {
    super.initState();
    // 가장 최신 자산 기록 날짜를 기본 선택
    if (widget.assetRecords.isNotEmpty) {
      final sorted = [...widget.assetRecords]
        ..sort((a, b) => b.recordDate.compareTo(a.recordDate));
      _selectedDate = _toDateString(sorted.first.recordDate);
    }
  }

  @override
  void didUpdateWidget(HoldingRecordsSection old) {
    super.didUpdateWidget(old);
    // 자산 기록이 새로 로드됐고 아직 날짜 미선택이면 최신 날짜 자동 선택
    if (_selectedDate == null && widget.assetRecords.isNotEmpty) {
      final sorted = [...widget.assetRecords]
        ..sort((a, b) => b.recordDate.compareTo(a.recordDate));
      setState(() => _selectedDate = _toDateString(sorted.first.recordDate));
    }
  }

  String _toDateString(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  String _formatDateLabel(String date) {
    final parts = date.split('-');
    return '${parts[0]}년 ${int.parse(parts[1])}월 ${int.parse(parts[2])}일';
  }

  @override
  Widget build(BuildContext context) {
    final sortedRecords = [...widget.assetRecords]
      ..sort((a, b) => b.recordDate.compareTo(a.recordDate));
    final dateOptions = sortedRecords.map((r) => _toDateString(r.recordDate)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '포트폴리오',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (_selectedDate != null)
                TextButton.icon(
                  onPressed: () => _showAddSheet(context, _selectedDate!),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('종목 추가'),
                ),
            ],
          ),
        ),

        // 날짜 선택기
        if (dateOptions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSizes.spaceM),
            child: Text(
              '잔액 기록을 먼저 추가하면 포트폴리오를 기록할 수 있습니다.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          )
        else ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, 0),
            child: _DateSelector(
              dates: dateOptions,
              selected: _selectedDate,
              onChanged: (d) => setState(() => _selectedDate = d),
              formatLabel: _formatDateLabel,
            ),
          ),
          if (_selectedDate != null)
            _HoldingRecordsList(
              accountId: widget.accountId,
              recordDate: _selectedDate!,
              assetBalance: sortedRecords
                  .where((r) => _toDateString(r.recordDate) == _selectedDate)
                  .map((r) => r.balance)
                  .firstOrNull,
            ),
        ],
      ],
    );
  }

  Future<void> _showAddSheet(BuildContext context, String recordDate) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _HoldingRecordFormSheet(
        accountId: widget.accountId,
        recordDate: recordDate,
      ),
    );
  }
}

// ─── 날짜 선택기 ───────────────────────────────────────────────────────────────
class _DateSelector extends StatelessWidget {
  final List<String> dates;
  final String? selected;
  final ValueChanged<String> onChanged;
  final String Function(String) formatLabel;

  const _DateSelector({
    required this.dates,
    required this.selected,
    required this.onChanged,
    required this.formatLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: DropdownButton<String>(
        value: selected,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.calendar_today, size: 16),
        items: dates
            .map((d) => DropdownMenuItem(value: d, child: Text(formatLabel(d))))
            .toList(),
        onChanged: (v) { if (v != null) onChanged(v); },
      ),
    );
  }
}

// ─── 종목 기록 목록 ────────────────────────────────────────────────────────────
class _HoldingRecordsList extends ConsumerWidget {
  final String accountId;
  final String recordDate;
  final double? assetBalance;

  const _HoldingRecordsList({
    required this.accountId,
    required this.recordDate,
    this.assetBalance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (accountId: accountId, recordDate: recordDate);
    final recordsAsync = ref.watch(holdingRecordsProvider(args));

    return recordsAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spaceL),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Text('오류가 발생했습니다.', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
      data: (records) {
        if (records.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceL),
            child: Center(
              child: Text(
                '이 날짜에 등록된 종목이 없습니다.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            ),
          );
        }

        final totalRatio = records.fold(0.0, (s, r) => s + r.ratio);

        return Column(
          children: [
            const SizedBox(height: AppSizes.spaceM),
            // 파이차트 + 범례
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: _PieChartPainter(records, totalRatio),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...records.map((r) => _LegendItem(
                              color: _colorFor(records.indexOf(r)),
                              label: r.ticker != null ? '${r.name} (${r.ticker})' : r.name,
                              ratio: r.ratio,
                            )),
                        if (totalRatio < 100)
                          _LegendItem(
                            color: const Color(0xFFE0E0E0),
                            label: '미할당',
                            ratio: 100 - totalRatio,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            // 잔액 기준 합계 표시
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '비중 합계: ${totalRatio.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: totalRatio > 100
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  if (assetBalance != null)
                    Text(
                      '잔액: ₩${formatAssetAmount(assetBalance!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spaceS),
            // 종목 목록
            ...records.asMap().entries.map((e) => _HoldingRecordListItem(
                  record: e.value,
                  color: _colorFor(e.key),
                  onEdit: () => _showEditSheet(context, ref, e.value),
                  onDelete: () => _confirmDelete(context, ref, e.value),
                )),
            const SizedBox(height: AppSizes.spaceM),
          ],
        );
      },
    );
  }

  Future<void> _showEditSheet(BuildContext context, WidgetRef ref, HoldingRecordModel record) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _HoldingRecordFormSheet(
        accountId: accountId,
        recordDate: recordDate,
        existing: record,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, HoldingRecordModel record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('종목 삭제'),
        content: Text('${record.name} 기록을 삭제할까요?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('취소')),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('삭제', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(holdingRecordsProvider((accountId: accountId, recordDate: recordDate)).notifier)
            .delete(record.id);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제에 실패했습니다.')),
          );
        }
      }
    }
  }
}

// ─── 범례 아이템 ───────────────────────────────────────────────────────────────
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double ratio;

  const _LegendItem({required this.color, required this.label, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 4),
          Text(
            '${ratio.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ─── 종목 목록 아이템 ──────────────────────────────────────────────────────────
class _HoldingRecordListItem extends StatelessWidget {
  final HoldingRecordModel record;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HoldingRecordListItem({
    required this.record,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
      leading: Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      title: Text(
        record.ticker != null ? '${record.name} (${record.ticker})' : record.name,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        '₩${formatAssetAmount(record.amount)}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${record.ratio.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: AppSizes.spaceS),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('수정')),
              PopupMenuItem(
                value: 'delete',
                child: Text('삭제', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
          ),
        ],
      ),
    );
  }
}

// ─── 종목 추가/수정 바텀시트 ──────────────────────────────────────────────────
class _HoldingRecordFormSheet extends ConsumerStatefulWidget {
  final String accountId;
  final String recordDate;
  final HoldingRecordModel? existing;

  const _HoldingRecordFormSheet({
    required this.accountId,
    required this.recordDate,
    this.existing,
  });

  @override
  ConsumerState<_HoldingRecordFormSheet> createState() => _HoldingRecordFormSheetState();
}

class _HoldingRecordFormSheetState extends ConsumerState<_HoldingRecordFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _tickerCtrl;
  late final TextEditingController _amountCtrl;
  List<String> _nameSuggestions = [];
  bool _loading = false;
  String? _errorMsg;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _tickerCtrl = TextEditingController(text: widget.existing?.ticker ?? '');
    _amountCtrl = TextEditingController(
      text: widget.existing != null
          ? widget.existing!.amount.toInt().toString()
          : '',
    );
    _loadNameSuggestions();
  }

  Future<void> _loadNameSuggestions() async {
    final repo = ref.read(assetRepositoryProvider);
    final names = await repo.getHoldingRecordNames(widget.accountId);
    if (mounted) setState(() => _nameSuggestions = names);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _tickerCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spaceM,
        right: AppSizes.spaceM,
        top: AppSizes.spaceM,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spaceM,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEdit ? '종목 수정' : '종목 추가',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSizes.spaceXS),
              Text(
                _formatDateLabel(widget.recordDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 종목명 (자동완성)
              Autocomplete<String>(
                initialValue: TextEditingValue(text: _nameCtrl.text),
                optionsBuilder: (value) {
                  if (value.text.isEmpty) return _nameSuggestions;
                  return _nameSuggestions.where(
                    (s) => s.toLowerCase().contains(value.text.toLowerCase()),
                  );
                },
                onSelected: (s) => _nameCtrl.text = s,
                fieldViewBuilder: (ctx, controller, focusNode, _) {
                  // Autocomplete 내부 controller와 _nameCtrl 동기화
                  controller.addListener(() => _nameCtrl.text = controller.text);
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: '종목명',
                      hintText: '예: 나스닥 ETF, 삼성전자',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? '종목명을 입력해주세요' : null,
                  );
                },
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 티커 (선택)
              TextFormField(
                controller: _tickerCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: '티커 (선택)',
                  hintText: '예: QQQ, 005930',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSizes.spaceM),

              // 금액
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '금액',
                  hintText: '예: 2000000',
                  prefixText: '₩ ',
                  border: OutlineInputBorder(),
                  helperText: '비율은 잔액 기준으로 자동 계산됩니다',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return '금액을 입력해주세요';
                  final n = double.tryParse(v.trim().replaceAll(',', ''));
                  if (n == null || n <= 0) return '유효한 금액을 입력해주세요';
                  return null;
                },
              ),

              if (_errorMsg != null) ...[
                const SizedBox(height: AppSizes.spaceS),
                Text(_errorMsg!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],

              const SizedBox(height: AppSizes.spaceL),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateLabel(String date) {
    final parts = date.split('-');
    return '${parts[0]}년 ${int.parse(parts[1])}월 ${int.parse(parts[2])}일';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _errorMsg = null; });

    final name = _nameCtrl.text.trim();
    final ticker = _tickerCtrl.text.trim();
    final amount = double.parse(_amountCtrl.text.trim().replaceAll(',', ''));
    final notifier = ref.read(
      holdingRecordsProvider((accountId: widget.accountId, recordDate: widget.recordDate)).notifier,
    );

    try {
      if (_isEdit) {
        await notifier.update(
          widget.existing!.id,
          UpdateHoldingRecordDto(
            name: name,
            ticker: ticker.isEmpty ? null : ticker,
            amount: amount,
          ),
        );
      } else {
        await notifier.create(
          CreateHoldingRecordDto(
            recordDate: widget.recordDate,
            name: name,
            ticker: ticker.isEmpty ? null : ticker,
            amount: amount,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }
}
