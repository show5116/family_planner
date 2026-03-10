import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:family_planner/features/minigame/data/models/minigame_model.dart';
import 'package:family_planner/features/minigame/data/repositories/minigame_repository.dart';
import 'package:family_planner/features/minigame/providers/minigame_provider.dart';
import 'package:family_planner/features/settings/groups/providers/group_provider.dart';

// 룰렛 색상 팔레트
const _kRouletteColors = [
  Color(0xFFE53935),
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFFFB8C00),
  Color(0xFF8E24AA),
  Color(0xFF00ACC1),
  Color(0xFFD81B60),
  Color(0xFF3949AB),
];

class RouletteGameScreen extends ConsumerStatefulWidget {
  const RouletteGameScreen({super.key});

  @override
  ConsumerState<RouletteGameScreen> createState() => _RouletteGameScreenState();
}

class _RouletteGameScreenState extends ConsumerState<RouletteGameScreen>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController(text: '룰렛');
  final List<TextEditingController> _itemControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  late AnimationController _spinController;
  late Animation<double> _spinAnim;
  double _currentAngle = 0;
  double _targetAngle = 0;
  String? _winner;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _spinAnim = CurvedAnimation(
      parent: _spinController,
      curve: Curves.decelerate,
    );
    _spinController.addListener(() {
      setState(() {
        _currentAngle = _targetAngle * _spinAnim.value;
      });
    });
    _spinController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _spinning = false);
        _showWinnerDialog();
        _autoSaveIfGroupSelected();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _itemControllers) { c.dispose(); }
    _spinController.dispose();
    super.dispose();
  }

  List<String> get _validItems => _itemControllers
      .map((c) => c.text.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final items = _validItems;
    final selectedGroupId = ref.watch(minigameSelectedGroupIdProvider);
    final groups = ref.watch(myGroupsProvider).valueOrNull ?? [];
    final selectedGroup = selectedGroupId != null
        ? groups.where((g) => g.id == selectedGroupId).firstOrNull
        : null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('룰렛')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (selectedGroup != null)
              _GroupBanner(groupName: selectedGroup.name),
            // 제목
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '게임 제목',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // 항목 편집
            _ItemsEditor(
              controllers: _itemControllers,
              onAdd: () => setState(
                  () => _itemControllers.add(TextEditingController())),
              onRemove: (i) => setState(() {
                _itemControllers[i].dispose();
                _itemControllers.removeAt(i);
              }),
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 20),
            // 룰렛 휠
            if (items.length >= 2) ...[
              SizedBox(
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 룰렛 원판
                    Transform.rotate(
                      angle: _currentAngle,
                      child: CustomPaint(
                        size: const Size(260, 260),
                        painter: _RoulettePainter(items: items),
                      ),
                    ),
                    // 중앙 포인터
                    const Positioned(
                      top: 0,
                      child: Icon(Icons.arrow_drop_down,
                          size: 40, color: Colors.black87),
                    ),
                    // 중앙 버튼
                    GestureDetector(
                      onTap: _spinning ? null : _spin,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 4, color: Colors.black26),
                          ],
                        ),
                        child: Icon(
                          _spinning ? Icons.hourglass_top : Icons.play_arrow,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _spinning ? null : _spin,
                icon: const Icon(Icons.refresh),
                label: const Text('돌리기'),
              ),
            ] else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '항목을 2개 이상 입력해주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            // 결과 표시 + 저장
            if (_winner != null && !_spinning) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('결과',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text(
                        _winner!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _spin() {
    final items = _validItems;
    if (items.length < 2 || _spinning) return;

    final rng = Random();
    final winnerIndex = rng.nextInt(items.length);
    final sliceAngle = (2 * pi) / items.length;

    // 당첨 칸이 상단 포인터(12시 방향)에 오도록 각도 계산
    // 현재 각도를 기준으로 최소 5바퀴 + 보정
    final baseRotations = (5 + rng.nextInt(3)) * 2 * pi;
    final correction = -(winnerIndex * sliceAngle + sliceAngle / 2);
    final totalRotation = baseRotations + correction - (_currentAngle % (2 * pi));

    _winner = null;
    _spinning = true;
    _targetAngle = _currentAngle + totalRotation;

    _spinController.reset();
    _spinController.forward();

    // 당첨자 미리 저장
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _winner = items[winnerIndex]);
      }
    });
  }

  void _showWinnerDialog() {
    if (_winner == null || !mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('결과'),
        content: Text(
          _winner!,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _autoSaveIfGroupSelected() {
    final groupId = ref.read(minigameSelectedGroupIdProvider);
    if (groupId == null) return;

    ref.read(minigameManagementProvider.notifier).saveResult(
      SaveMinigameResultDto(
        groupId: groupId,
        gameType: MinigameType.roulette,
        title: _titleController.text.trim(),
        participants: [],
        options: _validItems,
        result: {'winner': _winner},
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

// ─── 항목 편집기 ──────────────────────────────────────────────────────────────

class _ItemsEditor extends StatelessWidget {
  final List<TextEditingController> controllers;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final VoidCallback onChanged;

  const _ItemsEditor({
    required this.controllers,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('항목',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...controllers.asMap().entries.map((entry) {
          final i = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: _kRouletteColors[i % _kRouletteColors.length],
                    shape: BoxShape.circle,
                  ),
                ),
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
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, size: 16),
          label: const Text('항목 추가'),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ],
    );
  }
}

// ─── 룰렛 원판 Painter ────────────────────────────────────────────────────────

class _RoulettePainter extends CustomPainter {
  final List<String> items;

  _RoulettePainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final sliceAngle = (2 * pi) / items.length;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var i = 0; i < items.length; i++) {
      final startAngle = i * sliceAngle - pi / 2;

      // 부채꼴
      final paint = Paint()
        ..color = _kRouletteColors[i % _kRouletteColors.length]
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sliceAngle,
        true,
        paint,
      );

      // 경계선
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sliceAngle,
        true,
        borderPaint,
      );

      // 텍스트
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(startAngle + sliceAngle / 2);
      textPainter.text = TextSpan(
        text: items[i],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout(maxWidth: radius * 0.6);
      textPainter.paint(
        canvas,
        Offset(radius * 0.35, -textPainter.height / 2),
      );
      canvas.restore();
    }

    // 중앙 원
    canvas.drawCircle(
      center,
      radius * 0.12,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_RoulettePainter oldDelegate) =>
      oldDelegate.items != items;
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
