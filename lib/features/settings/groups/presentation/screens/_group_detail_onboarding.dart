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
            '멤버를 초대해보세요',
            '설정 탭에서 초대 코드를 공유하거나\n이메일로 직접 멤버를 초대할 수 있어요.\n\n탭을 눌러 설정으로 이동하세요.',
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
                  title: '초대 코드로 멤버 초대',
                  description: '코드를 복사해 공유하거나\n이메일로 직접 초대장을 보낼 수 있어요.',
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
                  title: '역할로 권한을 관리하세요',
                  description: '역할 탭에서 새로운 역할을 만들고\n멤버별 권한을 세밀하게 설정할 수 있어요.\n\n탭을 눌러 역할 관리로 이동하세요.',
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
                  title: '새 역할 만들기',
                  description: '버튼을 눌러 역할을 만들고\n이름, 색상, 권한을 자유롭게 설정하세요.',
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
            '나만의 그룹 색상을 설정하세요',
            '설정 탭에서 이 그룹의 색상을 지정할 수 있어요.\n설정한 색상은 일정 등 다양한 메뉴에서\n이 그룹의 항목을 구분하는 데 사용돼요.\n\n탭을 눌러 설정으로 이동하세요.',
            Icons.palette_outlined,
            Colors.purple,
          ),
        ],
      );
    }
  }
}
