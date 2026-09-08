part of 'memo_list_screen.dart';

// ── 온보딩용 샘플 메모 ────────────────────────────────────────────────────────

final _demoNow = DateTime(2025, 5, 10, 9, 0);

// 데모 일반 메모 Delta JSON (굵은 첫 줄 + 일반 텍스트).
// 번역이 필요해 상수로 둘 수 없어 l10n에서 만든다.
String _demoNoteDelta(AppLocalizations l10n) {
  final lines = l10n.demo_memo_trip_body.split('\n');
  return jsonEncode([
    {
      'insert': lines.first,
      'attributes': {'bold': true},
    },
    {'insert': '\n${lines.skip(1).join('\n')}\n'},
  ]);
}

MemoModel _demoNoteMemo(AppLocalizations l10n) => MemoModel(
  id: '__demo_note__',
  title: l10n.demo_memo_trip,
  content: _demoNoteDelta(l10n),
  format: MemoFormat.delta,
  visibility: MemoVisibility.private_,
  user: MemoAuthor(id: '__demo_user__', name: l10n.common_me),
  tags: [
    MemoTag(id: '__t1__', name: l10n.demo_tag_travel),
    MemoTag(id: '__t2__', name: l10n.demo_tag_jeju),
  ],
  createdAt: _demoNow,
  updatedAt: _demoNow,
);

// 데모 체크리스트 Delta JSON (앞의 두 항목만 체크된 상태)
String _demoChecklistDelta(AppLocalizations l10n) {
  final items = <(String, bool)>[
    (l10n.demo_check_passport, true),
    (l10n.demo_check_toiletries, true),
    (l10n.demo_check_clothes, false),
    (l10n.demo_check_charger, false),
    (l10n.demo_check_meds, false),
  ];
  return jsonEncode([
    for (final (text, checked) in items)
      {
        'insert': '$text\n',
        'attributes': {'list': checked ? 'checked' : 'unchecked'},
      },
  ]);
}

MemoModel _demoChecklistMemo(AppLocalizations l10n) => MemoModel(
  id: '__demo_checklist__',
  title: l10n.demo_memo_packing,
  content: _demoChecklistDelta(l10n),
  format: MemoFormat.delta,
  visibility: MemoVisibility.private_,
  user: MemoAuthor(id: '__demo_user__', name: l10n.common_me),
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
    setState(() => _isDemo = true); // ignore: invalid_use_of_protected_member
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
    if (mounted) setState(() => _isDemo = false); // ignore: invalid_use_of_protected_member
  }

  void _replayOnboarding() {
    OnboardingService.resetCoachMark(CoachMarkKeys.memo);
    _startDemo();
  }

  // ── 1단계: 일반 메모 설명 ────────────────────────────────────────────────

  Future<void> _showPhase1() async {
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_memo_richtext,
              description: l10n.coach_memo_richtext_desc,
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
      textSkip: l10n.common_skip,
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
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_memo_checklist,
              description: l10n.coach_memo_checklist_desc,
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
      textSkip: l10n.common_skip,
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
    final l10n = AppLocalizations.of(context)!;
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _DemoChecklistDetailScreen(
          memo: _demoChecklistMemo(l10n),
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

  Widget get _skipWidget {
    final l10n = AppLocalizations.of(context)!;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.common_skip,
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
  }

  Widget _buildDemoList() {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(AppSizes.spaceM),
      children: [
        MemoCard(key: _noteCardKey, memo: _demoNoteMemo(l10n), isDemo: true),
        const SizedBox(height: AppSizes.spaceM),
        MemoCard(
            key: _checklistCardKey, memo: _demoChecklistMemo(l10n), isDemo: true),
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
    final l10n = AppLocalizations.of(context)!;
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
              title: l10n.coach_memo_progress,
              description: l10n.coach_memo_progress_desc,
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
              title: l10n.coach_memo_check,
              description: l10n.coach_memo_check_desc,
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
              title: l10n.coach_memo_edit,
              description: l10n.coach_memo_edit_desc,
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
      textSkip: l10n.common_skip,
      alignSkip: Alignment.bottomRight,
      skipWidget: _skipWidget,
      onFinish: () => Navigator.of(context).pop(),
      onSkip: () { Navigator.of(context).pop(); return true; },
      paddingFocus: 8,
      focusAnimationDuration: const Duration(milliseconds: 300),
      pulseAnimationDuration: const Duration(milliseconds: 800),
    ).show(context: context);
  }

  Widget get _skipWidget {
    final l10n = AppLocalizations.of(context)!;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Text(
          l10n.common_skip,
          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final checked = widget.memo.checklistMeta.checked;
    final total = widget.memo.checklistMeta.total;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memo_detail),
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
                    l10n.memo_checklistProgress(checked, total),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.check_box, size: AppSizes.iconSmall),
                    label: Text(l10n.memo_checklistSelectAll),
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
