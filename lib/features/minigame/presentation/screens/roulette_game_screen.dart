import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _RouletteItem {
  final TextEditingController nameController;
  final TextEditingController weightController;

  _RouletteItem({String name = '', int weight = 1})
      : nameController = TextEditingController(text: name),
        weightController = TextEditingController(text: weight.toString());

  int get weight => int.tryParse(weightController.text.trim()) ?? 1;
  String get name => nameController.text.trim();
  bool get isValid => name.isNotEmpty;

  void dispose() {
    nameController.dispose();
    weightController.dispose();
  }
}

class RouletteGameScreen extends ConsumerStatefulWidget {
  const RouletteGameScreen({super.key});

  @override
  ConsumerState<RouletteGameScreen> createState() => _RouletteGameScreenState();
}

class _RouletteGameScreenState extends ConsumerState<RouletteGameScreen>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController(text: '룰렛');
  final List<_RouletteItem> _items = [
    _RouletteItem(),
    _RouletteItem(),
    _RouletteItem(),
  ];

  late AnimationController _spinController;
  late Animation<double> _spinAnim;
  double _currentAngle = 0; // 현재 원판 각도 (누적)
  double _spinStartAngle = 0; // 스핀 시작 시점의 각도
  double _spinDelta = 0; // 이번 스핀에서 회전할 총 각도
  String? _winner;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _spinAnim = CurvedAnimation(
      parent: _spinController,
      curve: _SpinCurve(),
    );
    _spinController.addListener(() {
      setState(() {
        _currentAngle = _spinStartAngle + _spinDelta * _spinAnim.value;
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
    for (final item in _items) {
      item.dispose();
    }
    _spinController.dispose();
    super.dispose();
  }

  List<_RouletteItem> get _validItems =>
      _items.where((item) => item.isValid).toList();

  @override
  Widget build(BuildContext context) {
    final validItems = _validItems;
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
              items: _items,
              onAdd: () => setState(() => _items.add(_RouletteItem())),
              onRemove: (i) => setState(() {
                _items[i].dispose();
                _items.removeAt(i);
              }),
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 20),
            // 룰렛 휠
            if (validItems.length >= 2) ...[
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
                        painter: _RoulettePainter(items: validItems),
                      ),
                    ),
                    // 상단 포인터
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
            // 결과 표시
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
    final validItems = _validItems;
    if (validItems.length < 2 || _spinning) return;

    final rng = Random();

    // 가중치 기반 당첨자 선택
    final totalWeight = validItems.fold(0, (sum, item) => sum + item.weight);
    final pick = rng.nextInt(totalWeight);
    int cumulative = 0;
    int winnerIndex = 0;
    for (var i = 0; i < validItems.length; i++) {
      cumulative += validItems[i].weight;
      if (pick < cumulative) {
        winnerIndex = i;
        break;
      }
    }

    // 당첨 칸 내 랜덤 위치 계산 (가장자리 10% 제외해서 극적으로 보이게)
    final startAngle = _sliceStartAngle(validItems, winnerIndex);
    final sliceAngle = (validItems[winnerIndex].weight / totalWeight) * 2 * pi;
    final margin = sliceAngle * 0.1;
    final randomOffset = margin + rng.nextDouble() * (sliceAngle - margin * 2);
    final landAngle = startAngle + randomOffset;

    final baseRotations = (6 + rng.nextInt(4)) * 2 * pi;
    // landAngle이 12시(0rad)에 오도록 보정
    final correction = -landAngle;
    final totalRotation =
        baseRotations + correction - (_currentAngle % (2 * pi));

    _winner = null;
    _spinning = true;
    _spinStartAngle = _currentAngle;
    _spinDelta = totalRotation;

    _spinController.reset();
    _spinController.forward();

    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted) {
        setState(() => _winner = validItems[winnerIndex].name);
      }
    });
  }

  /// 인덱스 i 슬라이스의 시작 각도 (12시 기준, 반시계 0)
  double _sliceStartAngle(List<_RouletteItem> items, int index) {
    final total = items.fold(0, (sum, item) => sum + item.weight);
    double angle = 0;
    for (var i = 0; i < index; i++) {
      angle += (items[i].weight / total) * 2 * pi;
    }
    return angle;
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

    ref
        .read(minigameManagementProvider.notifier)
        .saveResult(
          SaveMinigameResultDto(
            groupId: groupId,
            gameType: MinigameType.roulette,
            title: _titleController.text.trim(),
            participants: [],
            options: _validItems.map((item) => item.name).toList(),
            result: {'winner': _winner},
          ),
        )
        .then((saved) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(saved != null ? '게임 결과가 저장되었습니다' : '저장 실패')),
        );
      }
    });
  }
}

// ─── 항목 편집기 ──────────────────────────────────────────────────────────────

class _ItemsEditor extends StatelessWidget {
  final List<_RouletteItem> items;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final VoidCallback onChanged;

  const _ItemsEditor({
    required this.items,
    required this.onAdd,
    required this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('항목',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              width: 60,
              child: Text(
                '비율',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600]),
              ),
            ),
            if (items.length > 2) const SizedBox(width: 40),
          ],
        ),
        const SizedBox(height: 8),
        ...items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
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
                    controller: item.nameController,
                    onChanged: (_) => onChanged(),
                    decoration: InputDecoration(
                      hintText: '항목 ${i + 1}',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: item.weightController,
                    onChanged: (_) => onChanged(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    ),
                  ),
                ),
                if (items.length > 2)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () => onRemove(i),
                    padding: EdgeInsets.zero,
                  )
                else
                  const SizedBox(width: 40),
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
  final List<_RouletteItem> items;

  _RoulettePainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final totalWeight = items.fold(0, (sum, item) => sum + item.weight);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    double startAngle = -pi / 2; // 12시 방향부터 시작

    for (var i = 0; i < items.length; i++) {
      final sliceAngle = (items[i].weight / totalWeight) * 2 * pi;

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
        text: items[i].name,
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

      startAngle += sliceAngle;
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

// ─── 스핀 커브 ────────────────────────────────────────────────────────────────
// 앞 60%: 선형 등속, 뒤 40%: 기울기 (1-u)^5 로 급감속
// F(u) = 6/5 * (u - u^6/6), F(1)=1, F'(0)=1 → 연결 연속
class _SpinCurve extends Curve {
  @override
  double transformInternal(double t) {
    if (t < 0.6) {
      return t;
    } else {
      final u = (t - 0.6) / 0.4;
      final pos = (6 / 5) * (u - pow(u, 6) / 6);
      return 0.6 + pos.toDouble() * 0.4;
    }
  }
}
