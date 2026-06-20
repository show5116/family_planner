part of 'memo_list_screen.dart';

// ── 온보딩용 샘플 메모 ────────────────────────────────────────────────────────

final _demoNow = DateTime(2025, 5, 10, 9, 0);

// 데모 일반 메모 Delta JSON (굵은 제목 + 일반 텍스트 혼합)
const _demoNoteDelta =
    '[{"insert":"항공권 예약 완료","attributes":{"bold":true}},'
    '{"insert":"\\n숙소는 한림읍 게스트하우스로 결정.\\n렌터카 예약 필요. 우도, 성산일출봉 방문 예정.\\n"}]';

final _demoNoteMemo = MemoModel(
  id: '__demo_note__',
  title: '제주도 여행 준비',
  content: _demoNoteDelta,
  format: MemoFormat.delta,
  visibility: MemoVisibility.private_,
  user: const MemoAuthor(id: '__demo_user__', name: '나'),
  tags: const [MemoTag(id: '__t1__', name: '여행'), MemoTag(id: '__t2__', name: '제주')],
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

// 데모 체크리스트 Delta JSON (우유 2개✓, 달걀 한 판✓, 두부, 사과 1kg)
const _demoChecklistDelta =
    '[{"insert":"여권 / 신분증\\n","attributes":{"list":"checked"}},'
    '{"insert":"세면도구\\n","attributes":{"list":"checked"}},'
    '{"insert":"여벌 옷\\n","attributes":{"list":"unchecked"}},'
    '{"insert":"충전기\\n","attributes":{"list":"unchecked"}},'
    '{"insert":"상비약\\n","attributes":{"list":"unchecked"}}]';

final _demoChecklistMemo = MemoModel(
  id: '__demo_checklist__',
  title: '외박 준비물',
  content: _demoChecklistDelta,
  format: MemoFormat.delta,
  visibility: MemoVisibility.private_,
  user: const MemoAuthor(id: '__demo_user__', name: '나'),
  checklistMeta: const ChecklistMeta(total: 5, checked: 2),
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

extension _MemoListOnboarding on _MemoListScreenState {
  Future<void> _maybeStartOnboarding() async {
    final completed = await OnboardingService.isCoachMarkCompleted(CoachMarkKeys.memo);
    if (!mounted || completed) return;
    _startDemo();
  }

  void _startDemo() {
    setState(() => _isDemo = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showPhase1();
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animation.removeStatusListener(listener);
            if (mounted) _showPhase1();
          }
        }
        animation.addStatusListener(listener);
      }
    });
  }

  void _endDemo() {
    if (mounted) setState(() => _isDemo = false);
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.memo);
    _startDemo();
  }

  // ── 1단계: 일반 메모 설명 ────────────────────────────────────────────────

  Future<void> _showPhase1() async {
    if (!mounted) return;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'note_card',
        keyTarget: _noteCardKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '리치 텍스트 메모',
              description: '굵게, 기울임, 제목 등 서식을 자유롭게 적용할 수 있어요.\n태그로 분류하고 URL을 붙여넣으면\n링크 카드가 자동으로 생성됩니다.',
              icon: Icons.edit_note,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomRight,
      skipWidget: _skipWidget,
      onFinish: _showPhase2,
      onSkip: () { _completeOnboarding(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  // ── 2단계: 체크리스트 메모 설명 ──────────────────────────────────────────

  Future<void> _showPhase2() async {
    if (!mounted) return;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'checklist_card',
        keyTarget: _checklistCardKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '체크리스트',
              description: '메모 중간 어디에든 체크리스트를 삽입할 수 있어요.\n완료된 항목 수가 카드에 바로 표시되고\n상세 화면에서 탭해 체크할 수 있습니다.',
              icon: Icons.checklist,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    ];
    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomRight,
      skipWidget: _skipWidget,
      onFinish: _showPhase3Detail,
      onSkip: () { _completeOnboarding(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  // ── 3단계: 체크리스트 상세 화면 데모 ─────────────────────────────────────

  Future<void> _showPhase3Detail() async {
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _DemoChecklistDetailScreen(
          memo: _demoChecklistMemo,
          onDone: _completeOnboarding,
        ),
      ),
    );
    _completeOnboarding();
  }

  void _completeOnboarding() {
    OnboardingService.completeCoachMark(CoachMarkKeys.memo);
    _endDemo();
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

  Widget _buildDemoList() {
    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        MemoCard(key: _noteCardKey, memo: _demoNoteMemo, isDemo: true),
        const SizedBox(height: AppSizes.spaceM),
        MemoCard(key: _checklistCardKey, memo: _demoChecklistMemo, isDemo: true),
      ],
    );
  }
}

// ── 데모 체크리스트 상세 화면 (실제 MemoDetailScreen과 동일한 구조) ──────────

class _DemoChecklistDetailScreen extends StatefulWidget {
  const _DemoChecklistDetailScreen({required this.memo, required this.onDone});

  final MemoModel memo;
  final VoidCallback onDone;

  @override
  State<_DemoChecklistDetailScreen> createState() =>
      _DemoChecklistDetailScreenState();
}

class _DemoChecklistDetailScreenState
    extends State<_DemoChecklistDetailScreen> {
  late QuillController _quillController;
  final _progressKey = GlobalKey();
  final _checkItemKey = GlobalKey();
  final _editBtnKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final doc = MemoEditorConverter.toDocument(widget.memo.content);
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showCoachMark();
      } else {
        void listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            animation.removeStatusListener(listener);
            if (mounted) _showCoachMark();
          }
        }
        animation.addStatusListener(listener);
      }
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  Future<void> _showCoachMark() async {
    if (!mounted) return;
    final targets = <TargetFocus>[
      TargetFocus(
        identify: 'checklist_progress',
        keyTarget: _progressKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '진행률',
              description: '완료된 항목 수를 한눈에 볼 수 있어요.\n전체 선택/초기화 버튼도 있습니다.',
              icon: Icons.checklist,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'checklist_item',
        keyTarget: _checkItemKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '항목 체크',
              description: '체크박스를 탭하면 완료 처리돼요.\n저장 버튼을 누르면 변경사항이 한 번에 저장됩니다.',
              icon: Icons.check_circle_outline,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: 'edit_btn',
        keyTarget: _editBtnKey,
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: '수정 모드',
              description: '수정 버튼을 누르면 에디터가 열려요.\n툴바의 체크리스트 버튼으로 항목을 자유롭게 추가·수정할 수 있습니다.',
              icon: Icons.edit_outlined,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    ];

    await FeatureCoachMark.waitForTargets(targets, context);
    if (!mounted) return;
    TutorialCoachMark(
      targets: FeatureCoachMark.refreshPositions(targets),
      colorShadow: const Color(0xFF212121),
      opacityShadow: 0.85,
      textSkip: '건너뛰기',
      alignSkip: Alignment.bottomRight,
      skipWidget: _skipWidget,
      onFinish: () => Navigator.of(context).pop(),
      onSkip: () { Navigator.of(context).pop(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  Widget get _skipWidget => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: const Text(
          '건너뛰기',
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final checked = widget.memo.checklistMeta.checked;
    final total = widget.memo.checklistMeta.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 상세'),
        actions: [
          // 실제 MemoDetailScreen의 수정 메뉴 버튼과 동일한 위치에 key 부착
          IconButton(
            key: _editBtnKey,
            icon: const Icon(Icons.more_vert),
            onPressed: null, // 데모 — 비활성
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 (실제 상세 화면과 동일)
              Text(
                widget.memo.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSizes.spaceS),

              // 작성자 · 날짜
              Row(
                children: [
                  Icon(Icons.person_outline,
                      size: AppSizes.iconSmall, color: AppColors.textSecondary),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(widget.memo.user.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          )),
                ],
              ),

              const SizedBox(height: AppSizes.spaceM),

              // 체크리스트 진행률 바 (실제 _ChecklistProgressBar와 동일 구조)
              Row(
                key: _progressKey,
                children: [
                  Icon(Icons.checklist,
                      size: AppSizes.iconSmall, color: AppColors.primary),
                  const SizedBox(width: AppSizes.spaceXS),
                  Text(
                    '$checked/$total 완료',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.check_box, size: AppSizes.iconSmall),
                    label: const Text('전체 선택'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary),
                  ),
                ],
              ),

              const SizedBox(height: AppSizes.spaceL),
              const Divider(),
              const SizedBox(height: AppSizes.spaceM),

              // Quill 읽기 전용 뷰어 (실제 _MemoViewer와 동일)
              QuillEditor(
                key: _checkItemKey,
                controller: _quillController,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                config: const QuillEditorConfig(
                  autoFocus: false,
                  expands: false,
                  scrollable: false,
                  padding: EdgeInsets.zero,
                  showCursor: false,
                  checkBoxReadOnly: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
