import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/core/constants/app_sizes.dart';
import 'package:family_planner/features/main/assets/data/models/asset_record_model.dart';
import 'package:family_planner/features/main/assets/data/models/holding_record_model.dart';
import 'package:family_planner/features/main/assets/data/repositories/asset_repository.dart';
import 'package:family_planner/features/main/assets/providers/asset_provider.dart';
import 'package:family_planner/features/main/assets/utils/asset_utils.dart';

// ─── 천 단위 콤마 포매터 ──────────────────────────────────────────────────────
class _ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue nw) {
    final digits = nw.text.replaceAll(',', '');
    if (digits.isEmpty) return nw.copyWith(text: '');
    final n = int.tryParse(digits);
    if (n == null) return old;
    final formatted = _fmt(n);
    return nw.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ─── 색상 팔레트 ───────────────────────────────────────────────────────────────
const _palette = [
  Color(0xFF6366F1),
  Color(0xFF22C55E),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
  Color(0xFF14B8A6),
  Color(0xFFA855F7),
  Color(0xFFF97316),
  Color(0xFF3B82F6),
  Color(0xFFEC4899),
  Color(0xFF84CC16),
];

Color _colorFor(int index) => _palette[index % _palette.length];

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
  bool _compareMode = false;
  String? _compareDateA;
  String? _compareDateB;

  @override
  void initState() {
    super.initState();
    // 가장 최신 snapshot 기록 날짜를 기본 선택
    final snapshots = widget.assetRecords.where((r) => r.isSnapshot).toList()
      ..sort((a, b) => b.recordDate.compareTo(a.recordDate));
    if (snapshots.isNotEmpty) {
      _selectedDate = _toDateString(snapshots.first.recordDate);
    }
  }

  @override
  void didUpdateWidget(HoldingRecordsSection old) {
    super.didUpdateWidget(old);
    final oldDates = old.assetRecords
        .where((r) => r.isSnapshot)
        .map((r) => _toDateString(r.recordDate))
        .toSet();
    final snapshots = widget.assetRecords.where((r) => r.isSnapshot).toList()
      ..sort((a, b) => b.recordDate.compareTo(a.recordDate));
    if (snapshots.isEmpty) return;

    final newDate = snapshots
        .map((r) => _toDateString(r.recordDate))
        .firstWhere((d) => !oldDates.contains(d), orElse: () => '');

    if (newDate.isNotEmpty) {
      // 새로 추가된 날짜가 있으면 그 날짜로 이동
      setState(() => _selectedDate = newDate);
    } else if (_selectedDate == null) {
      // 최초 로드 시 최신 날짜 선택
      setState(() => _selectedDate = _toDateString(snapshots.first.recordDate));
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
    final snapshotRecords = sortedRecords.where((r) => r.isSnapshot).toList();
    final dateOptions = snapshotRecords.map((r) => _toDateString(r.recordDate)).toList();

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
              Row(
                children: [
                  if (!_compareMode && _selectedDate != null)
                    TextButton.icon(
                      onPressed: () => _showAddSheet(context, _selectedDate!),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('종목 추가'),
                    ),
                  if (dateOptions.length >= 2)
                    TextButton.icon(
                      onPressed: () => setState(() {
                        _compareMode = !_compareMode;
                        if (_compareMode) {
                          _compareDateA = dateOptions.first;
                          _compareDateB = dateOptions.length > 1 ? dateOptions[1] : null;
                        }
                      }),
                      icon: Icon(_compareMode ? Icons.close : Icons.compare_arrows, size: 18),
                      label: Text(_compareMode ? '닫기' : '비교'),
                    ),
                ],
              ),
            ],
          ),
        ),

        // 날짜 선택기 / 비교 모드
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
        else if (_compareMode) ...[
          // 비교 모드: 날짜 A / B 선택
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.spaceM, AppSizes.spaceS, AppSizes.spaceM, 0),
            child: Row(
              children: [
                Expanded(
                  child: _DateSelector(
                    dates: dateOptions,
                    selected: _compareDateA,
                    onChanged: (d) => setState(() => _compareDateA = d),
                    formatLabel: _formatDateLabel,
                    label: 'A',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.spaceS),
                  child: Icon(Icons.compare_arrows),
                ),
                Expanded(
                  child: _DateSelector(
                    dates: dateOptions,
                    selected: _compareDateB,
                    onChanged: (d) => setState(() => _compareDateB = d),
                    formatLabel: _formatDateLabel,
                    label: 'B',
                  ),
                ),
              ],
            ),
          ),
          if (_compareDateA != null && _compareDateB != null)
            _HoldingRecordsComparison(
              accountId: widget.accountId,
              dateA: _compareDateA!,
              dateB: _compareDateB!,
              formatDateLabel: _formatDateLabel,
            ),
        ] else ...[
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
              assetBalance: snapshotRecords
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
  final String? label;

  const _DateSelector({
    required this.dates,
    required this.selected,
    required this.onChanged,
    required this.formatLabel,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        Container(
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
        ),
      ],
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

        final totalAmount = records.fold(0.0, (s, r) => s + r.amount);
        double ratioOf(HoldingRecordModel r) =>
            totalAmount > 0 ? r.amount / totalAmount * 100 : 0;

        final remaining = (assetBalance ?? 0) - totalAmount;

        return _HoldingRecordsBody(
          records: records,
          totalAmount: totalAmount,
          ratioOf: ratioOf,
          assetBalance: assetBalance,
          remaining: remaining,
          onEdit: (r) => _showEditSheet(context, ref, r),
          onDelete: (r) => _confirmDelete(context, ref, r),
          onFillCash: remaining > 0
              ? () => _fillCash(context, ref, remaining)
              : null,
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

  Future<void> _fillCash(BuildContext context, WidgetRef ref, double amount) async {
    try {
      await ref
          .read(holdingRecordsProvider((accountId: accountId, recordDate: recordDate)).notifier)
          .create(CreateHoldingRecordDto(
            recordDate: recordDate,
            name: '현금',
            amount: amount,
          ));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
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

// ─── 파이차트 + 범례 + 종목 목록 본체 ────────────────────────────────────────
class _HoldingRecordsBody extends StatefulWidget {
  final List<HoldingRecordModel> records;
  final double totalAmount;
  final double Function(HoldingRecordModel) ratioOf;
  final double? assetBalance;
  final double remaining;
  final void Function(HoldingRecordModel) onEdit;
  final void Function(HoldingRecordModel) onDelete;
  final VoidCallback? onFillCash;

  const _HoldingRecordsBody({
    required this.records,
    required this.totalAmount,
    required this.ratioOf,
    required this.assetBalance,
    required this.remaining,
    required this.onEdit,
    required this.onDelete,
    this.onFillCash,
  });

  @override
  State<_HoldingRecordsBody> createState() => _HoldingRecordsBodyState();
}

class _HoldingRecordsBodyState extends State<_HoldingRecordsBody> {
  static const _maxVisible = 6;
  static const _othersColor = Color(0xFFBDBDBD);

  int? _touchedIndex;
  bool _othersExpanded = false;

  @override
  Widget build(BuildContext context) {
    final records = widget.records;
    final total = widget.totalAmount;

    // 상위 6개 / 기타 분리
    final mainRecords = records.length <= _maxVisible
        ? records
        : records.sublist(0, _maxVisible);
    final otherRecords = records.length <= _maxVisible
        ? <HoldingRecordModel>[]
        : records.sublist(_maxVisible);
    final hasOthers = otherRecords.isNotEmpty;
    final othersAmount = otherRecords.fold(0.0, (s, r) => s + r.amount);
    final othersRatio = total > 0 ? othersAmount / total * 100 : 0.0;

    // 파이차트 섹션 — 기타는 마지막 1개 슬라이스로 합산
    final isOthersTouched = hasOthers && _touchedIndex == mainRecords.length;
    final sections = [
      ...List.generate(mainRecords.length, (i) {
        final r = mainRecords[i];
        final isTouched = _touchedIndex == i;
        final ratio = total > 0 ? r.amount / total : 0.0;
        return PieChartSectionData(
          value: r.amount,
          color: _colorFor(i),
          radius: isTouched ? 72 : 60,
          showTitle: ratio >= 0.06,
          title: '${(ratio * 100).toStringAsFixed(1)}%',
          titleStyle: TextStyle(
            fontSize: isTouched ? 13 : 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titlePositionPercentageOffset: 0.6,
        );
      }),
      if (hasOthers)
        PieChartSectionData(
          value: othersAmount,
          color: _othersColor,
          radius: isOthersTouched ? 72 : 60,
          showTitle: othersRatio >= 6,
          title: '${othersRatio.toStringAsFixed(1)}%',
          titleStyle: TextStyle(
            fontSize: isOthersTouched ? 13 : 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titlePositionPercentageOffset: 0.6,
        ),
    ];

    // 터치된 항목 (기타 포함)
    final touchedMain = _touchedIndex != null &&
            _touchedIndex! >= 0 &&
            _touchedIndex! < mainRecords.length
        ? mainRecords[_touchedIndex!]
        : null;

    return Column(
      children: [
        const SizedBox(height: AppSizes.spaceM),
        // 파이차트
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 48,
              sectionsSpace: 2,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (event is! FlTapUpEvent) return;
                  if (response?.touchedSection == null) return;
                  final idx = response!.touchedSection!.touchedSectionIndex;
                  if (idx < 0 || idx >= sections.length) return;
                  setState(() {
                    _touchedIndex = (_touchedIndex == idx) ? null : idx;
                    // 기타 슬라이스 탭 시 인라인 펼치기 토글
                    if (hasOthers && idx == mainRecords.length) {
                      _othersExpanded = !_othersExpanded;
                    }
                  });
                },
              ),
            ),
          ),
        ),
        // 선택 항목 정보
        if (touchedMain != null) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            touchedMain.ticker != null
                ? '${touchedMain.name} (${touchedMain.ticker})'
                : touchedMain.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '₩${formatAssetAmount(touchedMain.amount)}  (${widget.ratioOf(touchedMain).toStringAsFixed(1)}%)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
        ] else if (isOthersTouched) ...[
          const SizedBox(height: AppSizes.spaceXS),
          Text(
            '기타 (${otherRecords.length}개)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            '₩${formatAssetAmount(othersAmount)}  (${othersRatio.toStringAsFixed(1)}%)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSizes.spaceXS),
        ] else
          const SizedBox(height: AppSizes.spaceM),

        // 범례
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
          child: Wrap(
            spacing: AppSizes.spaceS,
            runSpacing: AppSizes.spaceXS,
            alignment: WrapAlignment.center,
            children: [
              ...List.generate(mainRecords.length, (i) {
                final r = mainRecords[i];
                final isTouched = _touchedIndex == i;
                return _LegendChip(
                  color: _colorFor(i),
                  label: r.ticker != null ? '${r.name} (${r.ticker})' : r.name,
                  ratio: widget.ratioOf(r),
                  isTouched: isTouched,
                  onTap: () => setState(
                    () => _touchedIndex = (_touchedIndex == i) ? null : i,
                  ),
                );
              }),
              if (hasOthers)
                _LegendChip(
                  color: _othersColor,
                  label: '기타 ${otherRecords.length}개',
                  ratio: othersRatio,
                  isTouched: isOthersTouched,
                  trailing: Icon(
                    _othersExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onTap: () => setState(() {
                    _touchedIndex = isOthersTouched ? null : mainRecords.length;
                    _othersExpanded = !_othersExpanded;
                  }),
                ),
              // 기타 인라인 펼치기
              if (hasOthers && _othersExpanded)
                ...otherRecords.asMap().entries.map((e) => _LegendChip(
                      color: _colorFor(mainRecords.length + e.key),
                      label: e.value.ticker != null
                          ? '${e.value.name} (${e.value.ticker})'
                          : e.value.name,
                      ratio: widget.ratioOf(e.value),
                      isTouched: false,
                      onTap: () {},
                    )),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spaceS),
        if (widget.assetBalance != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.onFillCash != null)
                  TextButton.icon(
                    onPressed: widget.onFillCash,
                    icon: const Icon(Icons.account_balance_wallet_outlined, size: 16),
                    label: Text('현금으로 채우기 (₩${formatAssetAmount(widget.remaining)})'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                Text(
                  '잔액: ₩${formatAssetAmount(widget.assetBalance!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSizes.spaceS),
        // 종목 목록 (상위 6개)
        ...mainRecords.asMap().entries.map((e) => _HoldingRecordListItem(
              record: e.value,
              ratio: widget.ratioOf(e.value),
              color: _colorFor(e.key),
              onEdit: () => widget.onEdit(e.value),
              onDelete: () => widget.onDelete(e.value),
            )),
        // 기타 종목 목록 인라인 펼치기
        if (hasOthers) ...[
          InkWell(
            onTap: () => setState(() => _othersExpanded = !_othersExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM,
                vertical: AppSizes.spaceS,
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: _othersColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceS),
                  Text(
                    '기타 ${otherRecords.length}개  ${othersRatio.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(
                    _othersExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            ),
          ),
          if (_othersExpanded)
            ...otherRecords.asMap().entries.map((e) => _HoldingRecordListItem(
                  record: e.value,
                  ratio: widget.ratioOf(e.value),
                  color: _colorFor(mainRecords.length + e.key),
                  onEdit: () => widget.onEdit(e.value),
                  onDelete: () => widget.onDelete(e.value),
                )),
        ],
        const SizedBox(height: AppSizes.spaceM),
      ],
    );
  }
}

// ─── 범례 칩 ──────────────────────────────────────────────────────────────────
class _LegendChip extends StatelessWidget {
  final Color color;
  final String label;
  final double ratio;
  final bool isTouched;
  final Widget? trailing;
  final VoidCallback onTap;

  const _LegendChip({
    required this.color,
    required this.label,
    required this.ratio,
    required this.isTouched,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceS, vertical: 4),
        decoration: BoxDecoration(
          color: isTouched ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          border: isTouched ? Border.all(color: color.withValues(alpha: 0.4)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              '$label  ${ratio.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                  ),
            ),
            if (trailing != null) ...[const SizedBox(width: 2), trailing!],
          ],
        ),
      ),
    );
  }
}

// ─── 종목 목록 아이템 ──────────────────────────────────────────────────────────
class _HoldingRecordListItem extends StatelessWidget {
  final HoldingRecordModel record;
  final double ratio;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HoldingRecordListItem({
    required this.record,
    required this.ratio,
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
            '${ratio.toStringAsFixed(1)}%',
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

// ─── 포트폴리오 비교 ──────────────────────────────────────────────────────────
class _HoldingRecordsComparison extends ConsumerWidget {
  final String accountId;
  final String dateA;
  final String dateB;
  final String Function(String) formatDateLabel;

  const _HoldingRecordsComparison({
    required this.accountId,
    required this.dateA,
    required this.dateB,
    required this.formatDateLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncA = ref.watch(holdingRecordsProvider((accountId: accountId, recordDate: dateA)));
    final asyncB = ref.watch(holdingRecordsProvider((accountId: accountId, recordDate: dateB)));

    if (asyncA.isLoading || asyncB.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.spaceL),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (asyncA.hasError || asyncB.hasError) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.spaceM),
        child: Text('오류가 발생했습니다.',
            style: TextStyle(color: Theme.of(context).colorScheme.error)),
      );
    }

    final recordsA = asyncA.value ?? [];
    final recordsB = asyncB.value ?? [];

    // 두 날짜의 종목명 합집합
    final allNames = {
      ...recordsA.map((r) => r.name),
      ...recordsB.map((r) => r.name),
    }.toList();

    final mapA = {for (final r in recordsA) r.name: r.amount};
    final mapB = {for (final r in recordsB) r.name: r.amount};

    // 변화량 기준 내림차순 정렬 (절댓값)
    allNames.sort((a, b) {
      final diffA = ((mapB[a] ?? 0) - (mapA[a] ?? 0)).abs();
      final diffB = ((mapB[b] ?? 0) - (mapA[b] ?? 0)).abs();
      return diffB.compareTo(diffA);
    });

    return Column(
      children: [
        const SizedBox(height: AppSizes.spaceS),
        // 헤더
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceM),
          child: Row(
            children: [
              const Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Text(
                  formatDateLabel(dateA),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  formatDateLabel(dateB),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '변화',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: AppSizes.spaceS),
        // 종목별 행
        ...allNames.map((name) {
          final amtA = mapA[name];
          final amtB = mapB[name];
          final diff = (amtB ?? 0) - (amtA ?? 0);
          final isNew = amtA == null;
          final isGone = amtB == null;
          final diffColor = diff > 0
              ? Colors.green
              : diff < 0
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.outline;

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceM, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      if (isNew)
                        _CompareTag(label: 'NEW',
                            color: Theme.of(context).colorScheme.secondary)
                      else if (isGone)
                        _CompareTag(label: '삭제',
                            color: Theme.of(context).colorScheme.outline),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    amtA != null ? '₩${formatAssetAmount(amtA)}' : '—',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    amtB != null ? '₩${formatAssetAmount(amtB)}' : '—',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    diff == 0
                        ? '—'
                        : '${diff > 0 ? '+' : ''}₩${formatAssetAmount(diff)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: diffColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          );
        }),
        const Divider(height: AppSizes.spaceS),
        // 합계 행
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.spaceM, 4, AppSizes.spaceM, AppSizes.spaceM),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text('합계',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '₩${formatAssetAmount(recordsA.fold(0.0, (s, r) => s + r.amount))}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '₩${formatAssetAmount(recordsB.fold(0.0, (s, r) => s + r.amount))}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Builder(builder: (context) {
                  final totalDiff =
                      recordsB.fold(0.0, (s, r) => s + r.amount) -
                          recordsA.fold(0.0, (s, r) => s + r.amount);
                  final color = totalDiff > 0
                      ? Colors.green
                      : totalDiff < 0
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.outline;
                  return Text(
                    totalDiff == 0
                        ? '—'
                        : '${totalDiff > 0 ? '+' : ''}₩${formatAssetAmount(totalDiff)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.right,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompareTag extends StatelessWidget {
  final String label;
  final Color color;

  const _CompareTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
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
  List<({String name, String? ticker})> _nameSuggestions = [];
  bool _loading = false;
  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _tickerCtrl = TextEditingController(text: widget.existing?.ticker ?? '');
    final existingAmount = widget.existing?.amount.toInt();
    _amountCtrl = TextEditingController(
      text: existingAmount != null ? _ThousandsFormatter()._fmt(existingAmount) : '',
    );
    _loadNameSuggestions();
  }

  Future<void> _loadNameSuggestions() async {
    final groupId = ref.read(assetSelectedGroupIdProvider);
    if (groupId == null) return;
    final repo = ref.read(assetRepositoryProvider);
    final names = await repo.getHoldingRecordNames(groupId);
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
              Autocomplete<({String name, String? ticker})>(
                initialValue: TextEditingValue(text: _nameCtrl.text),
                displayStringForOption: (s) => s.name,
                optionsBuilder: (value) {
                  if (value.text.isEmpty) return _nameSuggestions;
                  return _nameSuggestions.where(
                    (s) => s.name.toLowerCase().contains(value.text.toLowerCase()),
                  );
                },
                onSelected: (s) {
                  _nameCtrl.text = s.name;
                  if (s.ticker != null) _tickerCtrl.text = s.ticker!;
                },
                fieldViewBuilder: (ctx, controller, focusNode, _) {
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
                optionsViewBuilder: (ctx, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final option = options.elementAt(i);
                            return ListTile(
                              dense: true,
                              title: Text(option.name),
                              subtitle: option.ticker != null
                                  ? Text(option.ticker!, style: const TextStyle(fontSize: 12))
                                  : null,
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
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
                inputFormatters: [_ThousandsFormatter()],
                decoration: const InputDecoration(
                  labelText: '금액',
                  hintText: '예: 2,000,000',
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
    setState(() { _loading = true; });

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
      setState(() { _loading = false; });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }
}
