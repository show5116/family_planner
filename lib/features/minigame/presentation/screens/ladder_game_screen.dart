import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/minigame/data/models/minigame_model.dart';
import 'package:family_planner/features/minigame/data/repositories/minigame_repository.dart';
import 'package:family_planner/features/minigame/providers/minigame_provider.dart';
import 'package:family_planner/features/settings/groups/models/group_member.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

// ─── 사다리 데이터 ─────────────────────────────────────────────────────────────

class LadderData {
  /// horizontalBridges[row][col] = true → col과 col+1 세로선 사이 가로선
  final List<List<bool>> horizontalBridges;
  final int columns;
  final int rows;

  const LadderData({
    required this.horizontalBridges,
    required this.columns,
    required this.rows,
  });

  /// startCol에서 출발해 도달하는 열 반환
  int trace(int startCol) {
    var col = startCol;
    for (var row = 0; row < rows; row++) {
      if (col < columns - 1 && horizontalBridges[row][col]) {
        col++;
      } else if (col > 0 && horizontalBridges[row][col - 1]) {
        col--;
      }
    }
    return col;
  }

  /// startCol의 경로 좌표 반환: (row, col) 리스트
  /// row: 0 = 최상단, rows = 최하단
  /// 가로 이동은 같은 row에서 col만 바뀜
  List<(int row, int col)> tracePath(int startCol) {
    var col = startCol;
    final path = <(int, int)>[];
    path.add((0, col));

    for (var row = 0; row < rows; row++) {
      // 가로선 도달 위치 (row의 가로선은 row+0.5 높이에 위치)
      if (col < columns - 1 && horizontalBridges[row][col]) {
        // 오른쪽으로 이동: 세로 이동 후 가로 이동
        path.add((row, col));       // 가로선 왼쪽 끝 (row 중간)
        col++;
        path.add((row, col));       // 가로선 오른쪽 끝
      } else if (col > 0 && horizontalBridges[row][col - 1]) {
        // 왼쪽으로 이동
        path.add((row, col));
        col--;
        path.add((row, col));
      }
      // 세로 이동 (다음 행으로)
      path.add((row + 1, col));
    }
    return path;
  }
}

LadderData generateLadder({required int columns, int rows = 10}) {
  final rng = Random();
  final bridges = List.generate(rows, (_) => List<bool>.filled(columns - 1, false));

  for (var row = 0; row < rows; row++) {
    for (var col = 0; col < columns - 1; col++) {
      if (col > 0 && bridges[row][col - 1]) continue;
      // 약 30% 확률로 가로선 생성
      bridges[row][col] = rng.nextInt(10) < 3;
    }
  }
  return LadderData(horizontalBridges: bridges, columns: columns, rows: rows);
}

// ─── 화면 상태 ─────────────────────────────────────────────────────────────────

enum _GamePhase { setup, playing, done }

// ─── 화면 ──────────────────────────────────────────────────────────────────────

class LadderGameScreen extends ConsumerStatefulWidget {
  const LadderGameScreen({super.key});

  @override
  ConsumerState<LadderGameScreen> createState() => _LadderGameScreenState();
}

class _LadderGameScreenState extends ConsumerState<LadderGameScreen>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController(text: '사다리타기');
  final List<TextEditingController> _participantControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  // 결과 항목 (이름, 수량) 쌍
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<TextEditingController> _optionCountControllers = [
    TextEditingController(text: '1'),
    TextEditingController(text: '1'),
  ];

  LadderData? _ladderData;
  // 각 참여자 열에 대한 결과 항목 배정 (index = 도착 열)
  List<String>? _resultOptions; // length == participants.length
  // 현재 애니메이션 중인 열
  int? _animatingCol;
  // 완료된 열 집합
  final Set<int> _completedCols = {};
  // 각 열의 애니메이션 진행률 (0~1)
  final Map<int, double> _colProgress = {};

  late AnimationController _animController;
  late Animation<double> _animValue;

  _GamePhase _phase = _GamePhase.setup;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _animValue = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.addListener(() {
      if (_animatingCol != null) {
        setState(() => _colProgress[_animatingCol!] = _animValue.value);
      }
    });
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _animatingCol != null) {
        setState(() {
          _completedCols.add(_animatingCol!);
          _colProgress[_animatingCol!] = 1.0;
          _animatingCol = null;
          if (_completedCols.length == _participants.length) {
            _phase = _GamePhase.done;
            _autoSaveIfGroupSelected();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _participantControllers) { c.dispose(); }
    for (final c in _optionControllers) { c.dispose(); }
    for (final c in _optionCountControllers) { c.dispose(); }
    _animController.dispose();
    super.dispose();
  }

  List<String> get _participants => _participantControllers
      .map((c) => c.text.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  List<String> get _options => _optionControllers
      .map((c) => c.text.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  int _optionCount(int i) =>
      int.tryParse(_optionCountControllers[i].text.trim()) ?? 1;

  int get _totalOptionCount {
    var total = 0;
    for (var i = 0; i < _optionControllers.length; i++) {
      if (_optionControllers[i].text.trim().isNotEmpty) {
        total += _optionCount(i);
      }
    }
    return total;
  }

  bool get _canStart {
    final n = _participants.length;
    return n >= 2 && _options.isNotEmpty && _totalOptionCount == n;
  }

  @override
  Widget build(BuildContext context) {
    final selectedGroupId = ref.watch(minigameSelectedGroupIdProvider);
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final selectedGroup = selectedGroupId != null
        ? groups.where((g) => g.id == selectedGroupId).firstOrNull
        : null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('사다리타기')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (selectedGroup != null)
                _GroupBanner(groupName: selectedGroup.name),
              if (_phase == _GamePhase.setup) ...[
                _buildSetupSection(selectedGroupId),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _canStart ? _buildLadder : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('사다리 생성'),
                ),
              ],
              if (_phase != _GamePhase.setup && _ladderData != null) ...[
                _buildLadderSection(),
                const SizedBox(height: 12),
                if (_phase == _GamePhase.playing) ...[
                  Text(
                    '참여자 이름을 눌러 사다리를 타세요!',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _animatingCol != null ? null : _skipAll,
                    icon: const Icon(Icons.fast_forward, size: 18),
                    label: const Text('전체 스킵'),
                  ),
                ],
                if (_phase == _GamePhase.done) ...[
                  const SizedBox(height: 4),
                  _buildResultCard(),
                ],
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _animatingCol != null ? null : _reset,
                  child: const Text('다시 설정'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetupSection(String? groupId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: '게임 제목',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ListEditor(
                label: '참여자',
                controllers: _participantControllers,
                hintPrefix: '참여자',
                groupId: groupId,
                onAdd: () => setState(
                    () => _participantControllers.add(TextEditingController())),
                onRemove: (i) => setState(() {
                  _participantControllers[i].dispose();
                  _participantControllers.removeAt(i);
                }),
                onChanged: () => setState(() {}),
                onAddFromGroup: (names) => setState(() {
                  for (final name in names) {
                    // 빈 텍스트박스가 있으면 먼저 채우기
                    final emptyIdx = _participantControllers
                        .indexWhere((c) => c.text.trim().isEmpty);
                    if (emptyIdx != -1) {
                      _participantControllers[emptyIdx].text = name;
                    } else {
                      _participantControllers
                          .add(TextEditingController(text: name));
                    }
                  }
                }),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OptionsEditor(
                controllers: _optionControllers,
                countControllers: _optionCountControllers,
                participantCount: _participants.length,
                totalOptionCount: _totalOptionCount,
                onAdd: () => setState(() {
                  _optionControllers.add(TextEditingController());
                  _optionCountControllers.add(TextEditingController(text: '1'));
                }),
                onRemove: (i) => setState(() {
                  _optionControllers[i].dispose();
                  _optionControllers.removeAt(i);
                  _optionCountControllers[i].dispose();
                  _optionCountControllers.removeAt(i);
                }),
                onChanged: () => setState(() {}),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLadderSection() {
    final participants = _participants;
    final n = participants.length;
    const labelH = 40.0;
    const ladderH = 360.0;
    final colColors = _colColors(n);

    return Column(
      children: [
        // 참여자 레이블 (클릭 가능)
        SizedBox(
          height: labelH,
          child: Row(
            children: List.generate(n, (col) {
              final isDone = _completedCols.contains(col);
              final isAnimating = _animatingCol == col;
              return Expanded(
                child: GestureDetector(
                  onTap: (_phase == _GamePhase.playing &&
                          !isDone &&
                          _animatingCol == null)
                      ? () => _startAnimation(col)
                      : null,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: (isDone || isAnimating)
                          ? colColors[col].withValues(alpha: 0.15)
                          : Colors.transparent,
                      border: Border.all(
                        color: (isDone || isAnimating)
                            ? colColors[col]
                            : Colors.grey.shade300,
                        width: isAnimating ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        participants[col],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (isDone || isAnimating)
                              ? colColors[col]
                              : (_phase == _GamePhase.playing &&
                                      _animatingCol == null)
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 4),
        // 사다리 본체
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, _) => CustomPaint(
              size: const Size(double.infinity, ladderH),
              painter: _LadderPainter(
                ladderData: _ladderData!,
                columnCount: n,
                colProgress: Map.from(_colProgress),
                animatingCol: _animatingCol,
                completedCols: Set.from(_completedCols),
                colColors: colColors,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // 결과 항목 레이블
        SizedBox(
          height: labelH,
          child: Row(
            children: List.generate(n, (destCol) {
              // destCol이 몇 번 참여자의 도착지인지 찾기
              int? arrivedParticipantCol;
              if (_phase == _GamePhase.done && _resultOptions != null) {
                // _resultOptions[participantCol] = option
                // 이 destCol에 도착한 참여자 col 찾기
                for (var pCol = 0; pCol < n; pCol++) {
                  if (_ladderData!.trace(pCol) == destCol) {
                    arrivedParticipantCol = pCol;
                    break;
                  }
                }
              }
              final isRevealed = arrivedParticipantCol != null &&
                  _completedCols.contains(arrivedParticipantCol);
              final option = _resultOptions != null && destCol < _resultOptions!.length
                  ? _resultOptions![destCol]
                  : '';

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isRevealed
                        ? colColors[arrivedParticipantCol].withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isRevealed
                          ? colColors[arrivedParticipantCol]
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isRevealed
                            ? colColors[arrivedParticipantCol]
                            : Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    final participants = _participants;
    final n = participants.length;
    final assignments = List.generate(n, (col) {
      final destCol = _ladderData!.trace(col);
      return LadderAssignment(
        participant: participants[col],
        option: _resultOptions![destCol],
      );
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('최종 결과',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...assignments.map((a) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(a.participant,
                              style: const TextStyle(fontWeight: FontWeight.w500))),
                      const Icon(Icons.arrow_forward, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          a.option,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _buildLadder() {
    final participants = _participants;
    final n = participants.length;

    // 결과 항목 배정: 도착 열(destCol) 기준으로 미리 배정
    final resultOptions = _assignOptions(n);

    setState(() {
      _ladderData = generateLadder(columns: n);
      _resultOptions = resultOptions;
      _completedCols.clear();
      _colProgress.clear();
      _animatingCol = null;
      _phase = _GamePhase.playing;
    });
  }

  /// 수량 기반으로 n개 결과 항목 배정 (섞어서 반환)
  List<String> _assignOptions(int n) {
    final expanded = <String>[];
    for (var i = 0; i < _optionControllers.length; i++) {
      final name = _optionControllers[i].text.trim();
      if (name.isEmpty) continue;
      final count = _optionCount(i).clamp(0, n);
      for (var j = 0; j < count; j++) {
        expanded.add(name);
      }
    }
    expanded.shuffle(Random());
    return expanded;
  }

  void _startAnimation(int col) {
    if (_animatingCol != null || _completedCols.contains(col)) return;
    setState(() => _animatingCol = col);
    _colProgress[col] = 0;
    _animController.reset();
    _animController.forward();
  }

  void _skipAll() {
    _animController.stop();
    final n = _participants.length;
    setState(() {
      _animatingCol = null;
      for (var col = 0; col < n; col++) {
        _completedCols.add(col);
        _colProgress[col] = 1.0;
      }
      _phase = _GamePhase.done;
    });
    _autoSaveIfGroupSelected();
  }

  void _reset() {
    _animController.stop();
    setState(() {
      _ladderData = null;
      _resultOptions = null;
      _completedCols.clear();
      _colProgress.clear();
      _animatingCol = null;
      _phase = _GamePhase.setup;
    });
  }

  void _autoSaveIfGroupSelected() {
    final groupId = ref.read(minigameSelectedGroupIdProvider);
    if (groupId == null) return;

    final participants = _participants;
    final n = participants.length;
    final assignments = List.generate(n, (col) {
      final destCol = _ladderData!.trace(col);
      return LadderAssignment(
        participant: participants[col],
        option: _resultOptions![destCol],
      );
    });

    ref.read(minigameManagementProvider.notifier).saveResult(
      SaveMinigameResultDto(
        groupId: groupId,
        gameType: MinigameType.ladder,
        title: _titleController.text.trim(),
        participants: _participants,
        options: _options,
        result: {
          'assignments': assignments.map((a) => a.toJson()).toList(),
        },
      ),
    ).then((saved) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(saved != null ? '게임 결과가 저장되었습니다' : '저장 실패')),
        );
      }
    });
  }
}

// ─── 색상 헬퍼 ────────────────────────────────────────────────────────────────

List<Color> _colColors(int n) {
  const palette = [
    Colors.red, Colors.blue, Colors.green, Colors.orange,
    Colors.purple, Colors.teal, Colors.pink, Colors.indigo,
  ];
  return List.generate(n, (i) => palette[i % palette.length]);
}

// ─── 사다리 CustomPainter ─────────────────────────────────────────────────────

class _LadderPainter extends CustomPainter {
  final LadderData ladderData;
  final int columnCount;
  final Map<int, double> colProgress;   // col → 0~1
  final int? animatingCol;
  final Set<int> completedCols;
  final List<Color> colColors;

  _LadderPainter({
    required this.ladderData,
    required this.columnCount,
    required this.colProgress,
    required this.animatingCol,
    required this.completedCols,
    required this.colColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = columnCount;
    final rows = ladderData.rows;
    final colW = size.width / n;
    final rowH = size.height / rows;

    // ── 기본 사다리 ──────────────────────────────────────────────────────────
    final basePaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 세로선
    for (var col = 0; col < n; col++) {
      final x = colW * col + colW / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), basePaint);
    }

    // 가로선
    for (var row = 0; row < rows; row++) {
      final y = rowH * row + rowH / 2;
      for (var col = 0; col < n - 1; col++) {
        if (ladderData.horizontalBridges[row][col]) {
          final x1 = colW * col + colW / 2;
          final x2 = colW * (col + 1) + colW / 2;
          canvas.drawLine(Offset(x1, y), Offset(x2, y), basePaint);
        }
      }
    }

    // ── 경로 그리기 ──────────────────────────────────────────────────────────
    for (var startCol = 0; startCol < n; startCol++) {
      final progress = colProgress[startCol];
      if (progress == null || progress <= 0) continue;

      final path = ladderData.tracePath(startCol);
      _drawPath(canvas, path, size, progress, colColors[startCol]);
    }
  }

  void _drawPath(Canvas canvas, List<(int, int)> path,
      Size size, double progress, Color color) {
    final n = columnCount;
    final rows = ladderData.rows;
    final colW = size.width / n;
    final rowH = size.height / rows;

    // 경로 전체 픽셀 길이 계산
    final points = path.map((p) {
      final (row, col) = p;
      final x = colW * col + colW / 2;
      // row가 정수이면 세로선 위, 가로선은 row + 0.5 위치
      // tracePath에서 가로 이동은 같은 row로 기록됨
      // 가로선 y는 row + 0.5
      final y = rowH * row + rowH / 2;
      return Offset(x, y);
    }).toList();

    // 첫 점은 상단 시작
    if (points.isEmpty) return;
    final allPoints = [Offset(colW * path.first.$2 + colW / 2, 0), ...points];

    // 전체 길이
    double totalLen = 0;
    for (var i = 0; i < allPoints.length - 1; i++) {
      totalLen += (allPoints[i + 1] - allPoints[i]).distance;
    }

    final drawLen = totalLen * progress;

    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double drawnLen = 0;
    for (var i = 0; i < allPoints.length - 1; i++) {
      final from = allPoints[i];
      final to = allPoints[i + 1];
      final segLen = (to - from).distance;

      if (drawnLen + segLen <= drawLen) {
        canvas.drawLine(from, to, paint);
        drawnLen += segLen;
      } else {
        final remaining = drawLen - drawnLen;
        final t = remaining / segLen;
        final end = from + (to - from) * t;
        canvas.drawLine(from, end, paint);
        break;
      }
    }
  }

  @override
  bool shouldRepaint(_LadderPainter old) =>
      old.colProgress != colProgress ||
      old.animatingCol != animatingCol ||
      old.ladderData != ladderData;
}

// ─── 결과 항목 편집기 (이름 + 수량) ────────────────────────────────────────────

class _OptionsEditor extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<TextEditingController> countControllers;
  final int participantCount;
  final int totalOptionCount;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final VoidCallback onChanged;

  const _OptionsEditor({
    required this.controllers,
    required this.countControllers,
    required this.participantCount,
    required this.totalOptionCount,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isMatch = totalOptionCount == participantCount;
    final statusColor = isMatch ? Colors.green : Colors.orange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Text('결과 항목',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(
              '$totalOptionCount / $participantCount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...controllers.asMap().entries.map((entry) {
          final i = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                // 항목 이름
                Expanded(
                  child: TextField(
                    controller: entry.value,
                    onChanged: (_) => onChanged(),
                    decoration: InputDecoration(
                      hintText: '항목 ${i + 1}',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // 수량
                SizedBox(
                  width: 48,
                  child: TextField(
                    controller: countControllers[i],
                    onChanged: (_) => onChanged(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '1',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    ),
                  ),
                ),
                if (controllers.length > 1)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () => onRemove(i),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('항목 추가'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
        if (!isMatch)
          Text(
            '수량 합계($totalOptionCount)가 참여자 수($participantCount)와 같아야 합니다',
            style: TextStyle(fontSize: 11, color: statusColor),
          ),
      ],
    );
  }
}

// ─── 그룹 배너 ────────────────────────────────────────────────────────────────

class _GroupBanner extends StatelessWidget {
  final String groupName;

  const _GroupBanner({required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.group,
              size: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
          const SizedBox(width: 8),
          Text(
            groupName,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '그룹으로 플레이 중',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 참여자 편집기 ─────────────────────────────────────────────────────────────

class _ListEditor extends ConsumerWidget {
  final String label;
  final List<TextEditingController> controllers;
  final String hintPrefix;
  final String? groupId;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final VoidCallback onChanged;
  final void Function(List<String> names)? onAddFromGroup;

  const _ListEditor({
    required this.label,
    required this.controllers,
    required this.hintPrefix,
    this.groupId,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
    this.onAddFromGroup,
  });

  Future<void> _showMemberPicker(BuildContext context, WidgetRef ref) async {
    final membersAsync = ref.read(groupMembersProvider(groupId!));
    final members = membersAsync.valueOrNull ?? [];

    if (members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('그룹 멤버를 불러오는 중입니다. 잠시 후 다시 시도해주세요.')),
      );
      return;
    }

    final alreadyAdded =
        controllers.map((c) => c.text.trim()).toSet();

    await showDialog<void>(
      context: context,
      builder: (ctx) => _MemberPickerDialog(
        members: members,
        alreadyAdded: alreadyAdded,
        onSelect: (names) {
          onAddFromGroup?.call(names);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // groupId가 있으면 미리 로딩
    if (groupId != null) {
      ref.watch(groupMembersProvider(groupId!));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...controllers.asMap().entries.map((entry) {
          final i = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: entry.value,
                    onChanged: (_) => onChanged(),
                    decoration: InputDecoration(
                      hintText: '$hintPrefix ${i + 1}',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                  ),
                ),
                if (controllers.length > 2)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () => onRemove(i),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          );
        }),
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.edit, size: 16),
                label: Text('$label 직접 추가'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                ),
              ),
            ),
            if (groupId != null && onAddFromGroup != null)
              Expanded(
                child: TextButton.icon(
                  onPressed: () => _showMemberPicker(context, ref),
                  icon: const Icon(Icons.person_add, size: 16),
                  label: const Text('멤버 선택'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─── 멤버 선택 다이얼로그 ──────────────────────────────────────────────────────

class _MemberPickerDialog extends StatefulWidget {
  final List<GroupMember> members;
  final Set<String> alreadyAdded;
  final void Function(List<String> names) onSelect;

  const _MemberPickerDialog({
    required this.members,
    required this.alreadyAdded,
    required this.onSelect,
  });

  @override
  State<_MemberPickerDialog> createState() => _MemberPickerDialogState();
}

class _MemberPickerDialogState extends State<_MemberPickerDialog> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('그룹 멤버 선택'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.members.length,
          itemBuilder: (ctx, i) {
            final member = widget.members[i];
            final name = member.user?.name ?? '알 수 없음';
            final isAlreadyAdded = widget.alreadyAdded.contains(name);
            final isSelected = _selected.contains(name);

            return CheckboxListTile(
              value: isSelected || isAlreadyAdded,
              onChanged: isAlreadyAdded
                  ? null
                  : (checked) {
                      setState(() {
                        if (checked == true) {
                          _selected.add(name);
                        } else {
                          _selected.remove(name);
                        }
                      });
                    },
              title: Text(name),
              subtitle: isAlreadyAdded
                  ? const Text('이미 추가됨',
                      style: TextStyle(fontSize: 11, color: Colors.grey))
                  : null,
              secondary: CircleAvatar(
                radius: 16,
                child: Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              dense: true,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () {
                  widget.onSelect(_selected.toList());
                  Navigator.pop(context);
                },
          child: Text('추가 (${_selected.length})'),
        ),
      ],
    );
  }
}
