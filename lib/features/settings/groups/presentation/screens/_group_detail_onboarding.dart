part of 'group_detail_screen.dart';

extension _GroupDetailOnboarding on _GroupDetailScreenState {
  TargetPosition? _keyToPosition(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return null;
    final offset = box.localToGlobal(Offset.zero);
    return TargetPosition(box.size, offset);
  }

  void _maybeShowCoachMark(bool isOwner) {
    if (_isOwner != null) return;
    _isOwner = isOwner;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final animation = ModalRoute.of(context)?.animation;
      if (animation == null || animation.isCompleted) {
        _showCoachMark(isOwner);
        return;
      }
      var called = false;
      void fire() {
        if (called || !mounted) return;
        called = true;
        _showCoachMark(isOwner);
      }
      void listener(AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          animation.removeStatusListener(listener);
          fire();
        }
      }
      animation.addStatusListener(listener);
      // iOS spring 애니메이션이 status listener를 미스하는 경우 대비 fallback
      Future.delayed(const Duration(milliseconds: 700), fire);
    });
  }

  Future<void> _showCoachMark(bool isOwner) async {
    final l10n = AppLocalizations.of(context)!;
    final featureKey = CoachMarkKeys.groupDetail(widget.groupId);

    final screenWidth = MediaQuery.of(context).size.width;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    const appBarHeight = kToolbarHeight;
    const tabBarHeight = kToolbarHeight;
    final tabTop = statusBarHeight + appBarHeight;
    final tabWidth = screenWidth / 3;

    TargetFocus settingsTabTarget(String title, String description, IconData icon, Color color) {
      return TargetFocus(
        identify: 'group_settings_tab',
        targetPosition: TargetPosition(
          Size(tabWidth, tabBarHeight),
          Offset(tabWidth * 1, tabTop),
        ),
        shape: ShapeLightFocus.RRect,
        radius: 8,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (_, _) => FeatureCoachMark.buildContent(
              title: title,
              description: description,
              icon: icon,
              color: color,
            ),
          ),
        ],
      );
    }

    if (isOwner) {
      await FeatureCoachMark.show(
        context: context,
        featureKey: featureKey,
        onClickTarget: (target) async {
          if (!mounted) return;
          if (target.identify == 'group_settings_tab') {
            _tabController.animateTo(1);
            await Future.delayed(const Duration(milliseconds: 600));
          } else if (target.identify == 'group_roles_tab') {
            _tabController.animateTo(2);
            await Future.delayed(const Duration(milliseconds: 500));
          }
        },
        beforeFocus: (target) async {
          if (!mounted) return;
          if (target.identify == 'group_role_fab') {
            _tabController.animateTo(2);
            await Future.delayed(const Duration(milliseconds: 500));
          }
        },
        targets: [
          settingsTabTarget(
            l10n.coach_group_invite,
            l10n.coach_group_invite_desc,
            Icons.person_add_outlined,
            Colors.blue,
          ),
          TargetFocus(
            identify: 'group_invite_code',
            targetPosition: _keyToPosition(_inviteCodeKey),
            keyTarget: _keyToPosition(_inviteCodeKey) == null ? _inviteCodeKey : null,
            shape: ShapeLightFocus.RRect,
            radius: 12,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                builder: (_, _) => FeatureCoachMark.buildContent(
                  title: l10n.coach_group_invite_code,
                  description: l10n.coach_group_invite_code_desc,
                  icon: Icons.vpn_key_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          TargetFocus(
            identify: 'group_roles_tab',
            targetPosition: TargetPosition(
              Size(tabWidth, tabBarHeight),
              Offset(tabWidth * 2, tabTop),
            ),
            shape: ShapeLightFocus.RRect,
            radius: 8,
            contents: [
              TargetContent(
                align: ContentAlign.bottom,
                builder: (_, _) => FeatureCoachMark.buildContent(
                  title: l10n.coach_group_roles,
                  description: l10n.coach_group_roles_desc,
                  icon: Icons.manage_accounts_outlined,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          TargetFocus(
            identify: 'group_role_fab',
            targetPosition: _keyToPosition(_fabKey),
            keyTarget: _keyToPosition(_fabKey) == null ? _fabKey : null,
            shape: ShapeLightFocus.RRect,
            radius: 16,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                builder: (_, _) => FeatureCoachMark.buildContent(
                  title: l10n.coach_group_role_new,
                  description: l10n.coach_group_role_new_desc,
                  icon: Icons.add_circle_outline,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      await FeatureCoachMark.show(
        context: context,
        featureKey: featureKey,
        onClickTarget: (target) {
          if (!mounted) return;
          if (target.identify == 'group_settings_tab') {
            _tabController.animateTo(1);
          }
        },
        targets: [
          settingsTabTarget(
            l10n.coach_group_color,
            l10n.coach_group_color_desc,
            Icons.palette_outlined,
            Colors.purple,
          ),
        ],
      );
    }
  }
}
