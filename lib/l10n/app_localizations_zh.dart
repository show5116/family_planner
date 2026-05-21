// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Family Planner';

  @override
  String get appDescription => '与家人一起管理日常生活的规划工具';

  @override
  String get common_ok => '确定';

  @override
  String get common_cancel => '取消';

  @override
  String get common_confirm => '确认';

  @override
  String get common_save => '保存';

  @override
  String get common_delete => '删除';

  @override
  String get common_edit => '编辑';

  @override
  String get common_add => '添加';

  @override
  String get common_create => '创建';

  @override
  String get common_search => '搜索';

  @override
  String get common_loading => '加载中...';

  @override
  String get common_optional => '可选';

  @override
  String get common_error => '错误';

  @override
  String get common_retry => '重试';

  @override
  String get common_close => '关闭';

  @override
  String get common_done => '完成';

  @override
  String get common_undo => '撤销';

  @override
  String get common_add_to_list => '添加到列表';

  @override
  String get common_view_all => '전체보기';

  @override
  String get memo_filter_personal_only => '개인 메모만';

  @override
  String get common_all_groups => '전체 그룹';

  @override
  String get schedule_filter_group_schedule => '그룹 일정';

  @override
  String common_date_format(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get cart_unsaved_changes => '有未保存的更改';

  @override
  String get common_next => '下一步';

  @override
  String get common_back => '返回';

  @override
  String get common_previous => '上一步';

  @override
  String get common_all => '全部';

  @override
  String get common_apply => '应用';

  @override
  String get auth_login => '登录';

  @override
  String get auth_signup => '注册';

  @override
  String get auth_logout => '退出登录';

  @override
  String get auth_email => '邮箱';

  @override
  String get auth_password => '密码';

  @override
  String get auth_passwordConfirm => '确认密码';

  @override
  String get auth_name => '姓名';

  @override
  String get auth_forgotPassword => '忘记密码？';

  @override
  String get auth_noAccount => '没有账号？';

  @override
  String get auth_haveAccount => '已有账号？';

  @override
  String get auth_continueWithGoogle => '使用Google继续';

  @override
  String get auth_continueWithKakao => '使用Kakao继续';

  @override
  String get auth_continueWithApple => '使用Apple继续';

  @override
  String get auth_or => '或';

  @override
  String get auth_emailHint => '请输入邮箱';

  @override
  String get auth_passwordHint => '请输入密码';

  @override
  String get auth_nameHint => '请输入姓名';

  @override
  String get auth_emailError => '邮箱格式不正确';

  @override
  String get auth_passwordError => '密码至少需要6个字符';

  @override
  String get auth_passwordMismatch => '密码不一致';

  @override
  String get auth_nameError => '请输入姓名';

  @override
  String get auth_loginSuccess => '登录成功';

  @override
  String get auth_loginFailed => '登录失败';

  @override
  String get auth_loginFailedInvalidCredentials => '邮箱或密码不正确';

  @override
  String get auth_googleLoginFailed => 'Google登录失败';

  @override
  String get auth_kakaoLoginFailed => 'Kakao登录失败';

  @override
  String get auth_signupSuccess => '注册成功';

  @override
  String get auth_signupFailed => '注册失败';

  @override
  String get auth_logoutSuccess => '已退出登录';

  @override
  String get auth_emailVerification => '邮箱验证';

  @override
  String get auth_emailVerificationMessage => '验证码已发送至您的邮箱。';

  @override
  String get auth_verificationCode => '验证码';

  @override
  String get auth_verificationCodeHint => '请输入验证码';

  @override
  String get auth_resendCode => '重新发送';

  @override
  String get auth_verify => '验证';

  @override
  String get auth_resetPassword => '重置密码';

  @override
  String get auth_resetPasswordMessage => '请输入您的邮箱地址。\n我们将向您发送验证码。';

  @override
  String get auth_newPassword => '新密码';

  @override
  String get auth_sendCode => '发送验证码';

  @override
  String get auth_resetPasswordSuccess => '密码已重置，请重新登录。';

  @override
  String get auth_signupEmailVerificationMessage => '注册成功，请检查您的邮箱。';

  @override
  String get auth_signupNameLabel => '姓名';

  @override
  String get auth_signupNameMinLengthError => '姓名至少需要2个字符';

  @override
  String get auth_signupPasswordHelperText => '至少8个字符';

  @override
  String get auth_signupConfirmPasswordLabel => '确认密码';

  @override
  String get auth_signupConfirmPasswordError => '请确认密码';

  @override
  String get auth_signupButton => '注册';

  @override
  String get auth_forgotPasswordTitle => '忘记密码';

  @override
  String get auth_setPasswordTitle => '设置密码';

  @override
  String get auth_forgotPasswordGuide => '请输入您的邮箱地址。\n我们将向您发送验证码。';

  @override
  String get auth_forgotPasswordGuideWithCode => '请输入发送至邮箱的验证码\n并设置新密码。';

  @override
  String get auth_setPasswordGuide => '请设置密码以保护您的账号。\n请输入注册邮箱，\n我们将向您发送验证码。';

  @override
  String get auth_setPasswordGuideWithCode => '请输入发送至邮箱的验证码\n并设置密码。';

  @override
  String get auth_verificationCodeLabel => '验证码（6位数字）';

  @override
  String get auth_verificationCodeError => '请输入验证码';

  @override
  String get auth_verificationCodeLengthError => '验证码必须为6位数字';

  @override
  String get auth_codeSentMessage => '验证码已发送至您的邮箱';

  @override
  String get auth_codeSentError => '验证码发送失败';

  @override
  String get auth_passwordResetButton => '重置密码';

  @override
  String get auth_passwordSetButton => '设置密码';

  @override
  String get auth_resendCodeButton => '重新发送验证码';

  @override
  String get auth_passwordSetSuccess => '密码已设置，现在可以登录。';

  @override
  String get auth_passwordResetError => '密码重置失败';

  @override
  String get auth_rememberPassword => '记住密码？';

  @override
  String get nav_home => '主页';

  @override
  String get nav_assets => '资产';

  @override
  String get nav_calendar => '日程';

  @override
  String get nav_todo => '待办';

  @override
  String get nav_more => '更多';

  @override
  String get nav_household => '家计管理';

  @override
  String get nav_childPoints => '育儿积分';

  @override
  String get nav_memo => '备忘录';

  @override
  String get nav_miniGames => '小游戏';

  @override
  String get nav_investmentIndicators => '投资指标';

  @override
  String get nav_savings => '团体储蓄';

  @override
  String get nav_votes => '投票';

  @override
  String get more_coach_groupDesc => '创建家庭、伴侣、朋友等群组，\n使用邀请码邀请成员。';

  @override
  String get more_coach_settingsDesc => '通过主题、语言、通知、\n底部标签栏等自定义应用。';

  @override
  String get home_greeting_morning => '早上好！';

  @override
  String get home_greeting_afternoon => '下午好！';

  @override
  String get home_greeting_evening => '晚上好！';

  @override
  String get home_greeting_night => '这么晚了！';

  @override
  String get home_todaySchedule => '今天的日程';

  @override
  String get home_noSchedule => '暂无日程';

  @override
  String get home_investmentSummary => '投资指标摘要';

  @override
  String get home_todoSummary => '待办摘要';

  @override
  String get home_assetSummary => '资产摘要';

  @override
  String get settings_title => '设置';

  @override
  String get settings_theme => '主题设置';

  @override
  String get settings_language => '语言设置';

  @override
  String get settings_homeWidgets => '首页小部件';

  @override
  String get settings_profile => '个人资料';

  @override
  String get settings_family => '家庭管理';

  @override
  String get settings_notifications => '通知';

  @override
  String get settings_about => '关于';

  @override
  String get settings_bottomNavigation => '底部导航栏';

  @override
  String get bottomNav_title => '底部导航栏设置';

  @override
  String get bottomNav_reset => '恢复默认';

  @override
  String get bottomNav_resetConfirmTitle => '确认重置';

  @override
  String get bottomNav_resetConfirmMessage => '将底部导航栏设置恢复为默认值？';

  @override
  String get bottomNav_resetSuccess => '已恢复默认设置';

  @override
  String get bottomNav_guideMessage => '主页和更多为固定项。\n点击中间3个位置选择菜单。';

  @override
  String get bottomNav_preview => '底部导航栏预览';

  @override
  String get bottomNav_howToUse => '使用方法';

  @override
  String get bottomNav_instructions =>
      '• 点击第2、3、4个位置可更改菜单。\n• 第1位（主页）和第5位（更多）为固定项。\n• 不在底部导航栏中的菜单显示在「更多」标签中。';

  @override
  String get bottomNav_availableMenus => '可用菜单';

  @override
  String get bottomNav_slot => '位置';

  @override
  String get bottomNav_unused => '未使用';

  @override
  String bottomNav_selectMenuTitle(Object slot) {
    return '选择第$slot位菜单';
  }

  @override
  String get bottomNav_usedInOtherSlot => '已在其他位置使用（选择后将互换）';

  @override
  String get widgetSettings_saveSuccess => '设置已保存';

  @override
  String get widgetSettings_guide => '选择在主页显示的小部件并更改顺序';

  @override
  String get widgetSettings_widgetOrder => '小部件顺序';

  @override
  String get widgetSettings_dragToReorder => '长按并拖动小部件更改顺序';

  @override
  String get widgetSettings_restoreDefaults => '恢复默认设置';

  @override
  String get widgetSettings_todayScheduleDesc => '显示今天的日程';

  @override
  String get widgetSettings_investmentSummaryDesc => '显示KOSPI、NASDAQ和汇率信息';

  @override
  String get widgetSettings_todoSummaryDesc => '显示进行中的待办事项';

  @override
  String get widgetSettings_assetSummaryDesc => '显示总资产和收益率';

  @override
  String get widgetSettings_memoSummary => '备忘录摘要';

  @override
  String get widgetSettings_memoSummaryDesc => '显示最近写的备忘录';

  @override
  String get widgetSettings_householdSummary => '家计状况';

  @override
  String get widgetSettings_householdSummaryDesc => '月支出摘要和预算达成率';

  @override
  String get widgetSettings_childcareSummary => '育儿积分';

  @override
  String get widgetSettings_childcareSummaryDesc => '每个孩子的积分余额状态';

  @override
  String get widgetSettings_savingsSummary => '储蓄';

  @override
  String get widgetSettings_savingsSummaryDesc => '每个群组的储蓄目标和达成状态';

  @override
  String get widgetSettings_fridgeSummary => '即将过期';

  @override
  String get widgetSettings_fridgeSummaryDesc => '冰箱中即将过期的食材列表';

  @override
  String get widgetSettings_viewToday => '今天';

  @override
  String get widgetSettings_viewWeek => '本周';

  @override
  String get widgetSettings_viewMonth => '本月';

  @override
  String get widgetSettings_viewBudget => '预算概览';

  @override
  String get widgetSettings_viewCategory => '按类别';

  @override
  String get widgetSettings_savingsEmpty => '暂无储蓄';

  @override
  String get widgetSettings_fridgeExpiryEmpty => '暂无即将过期的食材';

  @override
  String get widgetSettings_scheduleWeek => '本周日程';

  @override
  String get widgetSettings_scheduleMonth => '本月日程';

  @override
  String get widgetSettings_scheduleEmptyToday => '今天没有日程';

  @override
  String get widgetSettings_scheduleEmptyWeek => '本周没有日程';

  @override
  String get widgetSettings_scheduleEmptyMonth => '本月没有日程';

  @override
  String get widgetSettings_weather => '天气';

  @override
  String get widgetSettings_weatherDesc => '显示当前位置的天气信息';

  @override
  String get themeSettings_title => '主题设置';

  @override
  String get themeSettings_selectTheme => '选择主题';

  @override
  String get themeSettings_description => '选择应用的亮度主题。您可以跟随系统设置或手动选择。';

  @override
  String get themeSettings_lightMode => '浅色模式';

  @override
  String get themeSettings_lightModeDesc => '使用亮色主题';

  @override
  String get themeSettings_darkMode => '深色模式';

  @override
  String get themeSettings_darkModeDesc => '使用暗色主题';

  @override
  String get themeSettings_systemMode => '跟随系统';

  @override
  String get themeSettings_systemModeDesc => '跟随设备系统设置';

  @override
  String get themeSettings_colorTitle => '颜色主题';

  @override
  String get themeSettings_brightnessTitle => '亮度模式';

  @override
  String get themeSettings_currentThemePreview => '当前主题预览';

  @override
  String get themeSettings_currentTheme => '当前主题';

  @override
  String get profile_title => '个人资料设置';

  @override
  String get profile_save => '保存';

  @override
  String get profile_name => '姓名';

  @override
  String get profile_nameRequired => '请输入姓名';

  @override
  String get profile_phoneNumber => '电话号码（可选）';

  @override
  String get profile_phoneNumberHint => '例：010-1234-5678';

  @override
  String get profile_uploadSuccess => '头像上传成功';

  @override
  String get profile_uploadFailed => '头像上传失败';

  @override
  String get profile_changePassword => '修改密码';

  @override
  String get profile_currentPassword => '当前密码';

  @override
  String get profile_currentPasswordRequired => '请输入当前密码';

  @override
  String get profile_newPassword => '新密码';

  @override
  String get profile_newPasswordRequired => '请输入新密码';

  @override
  String get profile_newPasswordMinLength => '密码至少需要6个字符';

  @override
  String get profile_confirmNewPassword => '确认新密码';

  @override
  String get profile_confirmNewPasswordRequired => '请确认新密码';

  @override
  String get profile_passwordsDoNotMatch => '密码不一致';

  @override
  String get profile_updateSuccess => '个人资料已更新';

  @override
  String get profile_updateFailed => '个人资料更新失败';

  @override
  String get theme_light => '浅色模式';

  @override
  String get theme_dark => '深色模式';

  @override
  String get theme_system => '跟随系统';

  @override
  String get language_korean => '한국어';

  @override
  String get language_english => 'English';

  @override
  String get language_japanese => '日本語';

  @override
  String get language_chinese => '中文';

  @override
  String get language_selectDescription => '选择应用使用的语言';

  @override
  String get language_useSystemLanguage => '使用系统语言';

  @override
  String get language_useSystemLanguageDescription => '跟随设备语言设置';

  @override
  String get widgetSettings_title => '首页小部件设置';

  @override
  String get widgetSettings_description => '选择在主页显示的小部件';

  @override
  String get widgetSettings_todaySchedule => '今天的日程';

  @override
  String get widgetSettings_investmentSummary => '投资指标摘要';

  @override
  String get widgetSettings_todoSummary => '待办摘要';

  @override
  String get widgetSettings_assetSummary => '资产摘要';

  @override
  String get settings_screenSettings => '界面设置';

  @override
  String get settings_bottomNavigationTitle => '底部导航栏设置';

  @override
  String get settings_bottomNavigationSubtitle => '配置底部菜单顺序和显示';

  @override
  String get settings_homeWidgetsTitle => '首页小部件设置';

  @override
  String get settings_homeWidgetsSubtitle => '选择在主页显示的小部件';

  @override
  String get settings_themeTitle => '主题设置';

  @override
  String get settings_themeSubtitle => '切换浅色/深色模式';

  @override
  String get settings_languageTitle => '语言设置';

  @override
  String get settings_languageSubtitle => '更改应用使用的语言';

  @override
  String get settings_userSettings => '用户设置';

  @override
  String get settings_profileTitle => '个人资料设置';

  @override
  String get settings_profileSubtitle => '编辑个人资料信息';

  @override
  String get settings_groupManagementTitle => '群组管理';

  @override
  String get settings_groupManagementSubtitle => '管理群组和成员';

  @override
  String get settings_notificationSettings => '通知设置';

  @override
  String get settings_notificationTitle => '通知';

  @override
  String get settings_notificationSubtitle => '更改通知偏好';

  @override
  String get settings_information => '信息';

  @override
  String get settings_appInfoTitle => '应用信息';

  @override
  String get settings_appInfoSubtitle => '版本 1.0.0';

  @override
  String get settings_appDescription => '家庭每日规划工具';

  @override
  String get settings_helpTitle => '帮助';

  @override
  String get settings_helpSubtitle => '查看使用说明';

  @override
  String get settings_user => '用户';

  @override
  String get settings_logout => '退出登录';

  @override
  String get settings_logoutConfirmTitle => '退出登录';

  @override
  String get settings_logoutConfirmMessage => '确定要退出登录吗？';

  @override
  String get settings_passwordSetupRequired => '需要设置密码';

  @override
  String get settings_passwordSetupMessage1 => '您仅通过社交登录注册，尚未设置密码。';

  @override
  String get settings_passwordSetupMessage2 => '建议设置密码以编辑个人资料或增强账号安全性。';

  @override
  String get settings_passwordSetupMessage3 => '是否前往密码设置页面？';

  @override
  String get settings_passwordSetupLater => '稍后';

  @override
  String get settings_passwordSetupNow => '设置密码';

  @override
  String get settings_adminMenu => '仅管理员';

  @override
  String get settings_permissionManagementTitle => '权限管理';

  @override
  String get settings_permissionManagementSubtitle => '管理角色的权限类型';

  @override
  String get permission_title => '权限管理';

  @override
  String get permission_search => '搜索权限（代码、名称、描述）';

  @override
  String get permission_allCategories => '全部';

  @override
  String get permission_create => '创建权限';

  @override
  String get permission_code => '代码';

  @override
  String get permission_category => '类别';

  @override
  String get permission_description => '描述';

  @override
  String get permission_status => '状态';

  @override
  String get permission_active => '启用';

  @override
  String get permission_inactive => '停用';

  @override
  String get permission_count => '';

  @override
  String get permission_noPermissions => '未找到权限';

  @override
  String get permission_loadFailed => '权限加载失败';

  @override
  String get permission_deleteConfirm => '删除权限';

  @override
  String permission_deleteMessage(String name) {
    return '删除 $name 权限？';
  }

  @override
  String get permission_deleteSoftDescription => '软删除：停用但保留数据';

  @override
  String get permission_deleteHardDescription => '硬删除：从数据库永久删除（警告！）';

  @override
  String get permission_softDelete => '软删除';

  @override
  String get permission_hardDelete => '硬删除';

  @override
  String get permission_deleteSuccess => '权限删除成功';

  @override
  String get permission_deleteFailed => '权限删除失败';

  @override
  String get permission_name => '权限名称';

  @override
  String get permission_codeAndNameRequired => '代码和名称为必填项';

  @override
  String get permission_createSuccess => '权限创建成功';

  @override
  String get permission_createFailed => '权限创建失败';

  @override
  String get permission_updateSuccess => '权限更新成功';

  @override
  String get permission_updateFailed => '权限更新失败';

  @override
  String get group_title => '群组管理';

  @override
  String get group_myGroups => '我的群组';

  @override
  String get group_createGroup => '创建群组';

  @override
  String get group_joinGroup => '加入群组';

  @override
  String get group_groupName => '群组名称';

  @override
  String get group_groupDescription => '描述';

  @override
  String get group_groupColor => '群组颜色';

  @override
  String get group_defaultColor => '默认颜色';

  @override
  String get group_customColor => '自定义颜色';

  @override
  String get group_inviteCode => '邀请码';

  @override
  String get group_members => '成员';

  @override
  String get group_pending => '待审核';

  @override
  String get group_noPendingRequests => '暂无待审核的加入申请';

  @override
  String group_memberCount(int count) {
    return '$count人';
  }

  @override
  String get group_role => '角色';

  @override
  String get group_owner => '群主';

  @override
  String get group_admin => '管理员';

  @override
  String get group_member => '成员';

  @override
  String get group_joinedAt => '加入日期';

  @override
  String get group_createdAt => '创建日期';

  @override
  String get group_settings => '群组设置';

  @override
  String get group_editGroup => '编辑群组';

  @override
  String get group_deleteGroup => '删除群组';

  @override
  String get group_leaveGroup => '退出群组';

  @override
  String get group_inviteMembers => '邀请成员';

  @override
  String get group_manageMembers => '管理成员';

  @override
  String get group_regenerateCode => '重新生成邀请码';

  @override
  String get group_copyCode => '复制邀请码';

  @override
  String get group_enterInviteCode => '输入邀请码';

  @override
  String get group_inviteByEmail => '通过邮箱邀请';

  @override
  String get group_email => '邮箱';

  @override
  String get group_send => '发送';

  @override
  String get group_join => '加入';

  @override
  String get group_cancel => '取消';

  @override
  String get group_save => '保存';

  @override
  String get group_delete => '删除';

  @override
  String get group_leave => '退出';

  @override
  String get group_create => '创建';

  @override
  String get group_edit => '编辑';

  @override
  String get group_confirm => '确认';

  @override
  String get group_accept => '接受';

  @override
  String get group_reject => '拒绝';

  @override
  String get group_requestedAt => '申请日期';

  @override
  String get group_invitedAt => '邀请日期';

  @override
  String get group_acceptSuccess => '加入申请已接受';

  @override
  String get group_rejectSuccess => '加入申请已拒绝';

  @override
  String get group_rejectConfirmMessage => '确定要拒绝这个加入申请吗？';

  @override
  String get group_groupNameRequired => '请输入群组名称';

  @override
  String get group_inviteCodeRequired => '请输入邀请码';

  @override
  String get group_emailRequired => '请输入邮箱';

  @override
  String get group_deleteConfirmTitle => '删除群组';

  @override
  String get group_deleteConfirmMessage => '确定要删除这个群组吗？\n所有数据将被删除且无法恢复。';

  @override
  String get group_leaveConfirmTitle => '退出群组';

  @override
  String get group_leaveConfirmMessage => '确定要退出这个群组吗？';

  @override
  String get group_ownerCannotLeave => '群主无法退出群组。\n请转让群主权限或删除群组。';

  @override
  String get group_createSuccess => '群组创建成功';

  @override
  String get group_joinSuccess => '已成功加入群组';

  @override
  String get group_updateSuccess => '群组信息已更新';

  @override
  String get group_deleteSuccess => '群组已删除';

  @override
  String get group_leaveSuccess => '已退出群组';

  @override
  String get group_inviteSent => '邀请邮件已发送';

  @override
  String get group_codeRegenerated => '邀请码已重新生成';

  @override
  String get group_codeCopied => '邀请码已复制';

  @override
  String get group_codeExpired => '邀请码已过期';

  @override
  String group_codeExpiresInDays(int count) {
    return '$count天后过期';
  }

  @override
  String group_codeExpiresInHours(int count) {
    return '$count小时后过期';
  }

  @override
  String group_codeExpiresInMinutes(int count) {
    return '$count分钟后过期';
  }

  @override
  String get group_noGroups => '暂无群组';

  @override
  String get group_noGroupsDescription => '创建新群组或\n使用邀请码加入群组';

  @override
  String get group_myJoinRequests => '我的加入申请';

  @override
  String get group_noJoinRequests => '暂无加入申请记录';

  @override
  String get group_joinRequestStatusAll => '全部';

  @override
  String get group_joinRequestStatusPending => '待审核';

  @override
  String get group_joinRequestStatusDone => '已处理';

  @override
  String get group_joinRequestAccepted => '已接受';

  @override
  String get group_joinRequestRejected => '已拒绝';

  @override
  String get group_codeExpiredLabel => '邀请码已过期';

  @override
  String get group_defaultGroupTooltip => '默认群组';

  @override
  String get group_setDefaultGroupTooltip => '设为默认群组';

  @override
  String get group_unsetDefaultGroupTooltip => '取消默认群组';

  @override
  String group_setDefaultSuccess(String name) {
    return '已将\'$name\'设为默认群组';
  }

  @override
  String get group_unsetDefaultSuccess => '已取消默认群组';

  @override
  String get group_myColorTitle => '我的群组颜色';

  @override
  String get group_myColorNotSet => '未设置（使用群组默认颜色）';

  @override
  String get group_myColorSet => '已设置';

  @override
  String get group_myColorReset => '重置';

  @override
  String get group_dangerZone => '危险区域';

  @override
  String get group_dangerZoneDesc => '删除群组后，所有数据将永久删除。';

  @override
  String get group_leaveTitle => '退出群组';

  @override
  String get group_leaveDesc => '退出后将无法访问群组数据。';

  @override
  String group_leaveConfirmBody(String name) {
    return '确定要退出\'$name\'群组吗？\n\n退出后将无法访问群组数据，重新加入需要邀请码。';
  }

  @override
  String get group_leaveButton => '退出';

  @override
  String get group_roleManagementTitle => '角色管理';

  @override
  String get group_roleManagementDesc => '该群组的角色列表。';

  @override
  String get group_roleEmpty => '暂无角色';

  @override
  String get group_roleDefaultBadge => '默认';

  @override
  String group_rolePermissionCount(int count) {
    return '$count个权限';
  }

  @override
  String get group_roleEdit => '编辑角色';

  @override
  String get group_roleDelete => '删除角色';

  @override
  String get group_roleSortSaved => '排序已保存';

  @override
  String get group_roleLoadError => '无法加载角色列表';

  @override
  String get group_roleInfoTitle => '说明';

  @override
  String get group_roleInfoBullet1 => '通用角色（OWNER、ADMIN、MEMBER）在所有群组中默认提供。';

  @override
  String get group_roleInfoBullet2 => '自定义角色只能由群组OWNER创建、编辑或删除。';

  @override
  String get group_roleInfoBullet3 => '管理角色需要群组OWNER权限。';

  @override
  String get group_roleCreateTitle => '创建角色';

  @override
  String get group_roleEditTitle => '编辑角色';

  @override
  String get group_roleDeleteTitle => '删除角色';

  @override
  String get group_roleNameLabel => '角色名称';

  @override
  String get group_roleNameRequired => '请输入角色名称';

  @override
  String get group_roleDefaultSwitch => '默认角色';

  @override
  String get group_roleDefaultSwitchSub => '新成员加入时自动分配';

  @override
  String get group_roleColorLabel => '角色颜色';

  @override
  String get group_rolePermissionsLabel => '选择权限';

  @override
  String get group_rolePermissionsViewLabel => '权限列表';

  @override
  String get group_rolePermissionNone => '暂无权限';

  @override
  String get group_roleDefaultLabel => '默认角色（新成员加入时自动分配）';

  @override
  String group_roleDeleteConfirm(String name) {
    return '删除\'$name\'角色？';
  }

  @override
  String get group_roleDeleteWarning => '⚠️ 正在使用此角色的成员存在时无法删除。';

  @override
  String get group_roleCreateSuccess => '角色已创建';

  @override
  String group_roleCreateFail(String error) {
    return '角色创建失败：$error';
  }

  @override
  String get group_roleEditSuccess => '角色已更新';

  @override
  String group_roleEditFail(String error) {
    return '角色更新失败：$error';
  }

  @override
  String get group_roleDeleteSuccess => '角色已删除';

  @override
  String group_roleDeleteFail(String error) {
    return '角色删除失败：$error';
  }

  @override
  String get group_settings_groupManagementTitle => '群组管理';

  @override
  String get error_network => '请检查网络连接';

  @override
  String get error_server => '服务器发生错误';

  @override
  String get error_unknown => '发生未知错误';

  @override
  String get common_comingSoon => '即将推出';

  @override
  String get common_logoutFailed => '退出登录失败';

  @override
  String get announcement_title => '公告';

  @override
  String get announcement_list => '公告列表';

  @override
  String get announcement_detail => '公告详情';

  @override
  String get announcement_create => '创建公告';

  @override
  String get announcement_edit => '编辑公告';

  @override
  String get announcement_delete => '删除公告';

  @override
  String get announcement_pin => '置顶';

  @override
  String get announcement_unpin => '取消置顶';

  @override
  String get announcement_pinned => '已置顶';

  @override
  String get announcement_pinDescription => '将重要公告置顶显示';

  @override
  String get announcement_category => '类别';

  @override
  String get announcement_category_none => '无类别';

  @override
  String get announcement_category_announcement => '公告';

  @override
  String get announcement_category_event => '活动';

  @override
  String get announcement_category_update => '更新';

  @override
  String get announcement_content => '内容';

  @override
  String get announcement_author => '作者';

  @override
  String get announcement_createdAt => '创建日期';

  @override
  String get announcement_updatedAt => '更新日期';

  @override
  String announcement_readCount(int count) {
    return '$count次阅读';
  }

  @override
  String get announcement_createSuccess => '公告已创建';

  @override
  String get announcement_createError => '公告创建失败';

  @override
  String get announcement_updateSuccess => '公告已更新';

  @override
  String get announcement_updateError => '公告更新失败';

  @override
  String get announcement_deleteSuccess => '公告已删除';

  @override
  String get announcement_deleteError => '公告删除失败';

  @override
  String get announcement_deleteDialogTitle => '删除公告';

  @override
  String get announcement_deleteDialogMessage => '确定要删除这条公告吗？\n此操作无法撤销。';

  @override
  String get announcement_pinSuccess => '公告已置顶';

  @override
  String get announcement_unpinSuccess => '公告已取消置顶';

  @override
  String get announcement_deleteConfirm => '删除这条公告？\n此操作无法撤销。';

  @override
  String get announcement_loadError => '公告加载失败';

  @override
  String get announcement_empty => '暂无公告';

  @override
  String get announcement_titleHint => '请输入公告标题';

  @override
  String get announcement_contentHint => '请输入公告内容';

  @override
  String get announcement_categoryHint => '选择类别（可选）';

  @override
  String get announcement_titleRequired => '请输入标题';

  @override
  String get announcement_titleMinLength => '标题至少需要3个字符';

  @override
  String get announcement_contentRequired => '请输入内容';

  @override
  String get announcement_contentMinLength => '内容至少需要10个字符';

  @override
  String get announcement_attachmentComingSoon => '文件附件功能即将推出';

  @override
  String get qna_title => '问答';

  @override
  String get qna_publicQuestions => '公开问答';

  @override
  String get qna_myQuestions => '我的问题';

  @override
  String get qna_askQuestion => '提问';

  @override
  String get qna_question => '问题';

  @override
  String get qna_answer => '回答';

  @override
  String get qna_category => '类别';

  @override
  String get qna_categoryFilter => '类别筛选';

  @override
  String get qna_categoryAll => '全部';

  @override
  String get qna_categoryNone => '无类别';

  @override
  String get qna_status => '状态';

  @override
  String get qna_statusAll => '全部';

  @override
  String get qna_statusPending => '待回答';

  @override
  String get qna_statusAnswered => '已回答';

  @override
  String get qna_statusResolved => '已解决';

  @override
  String get qna_search => '搜索问题';

  @override
  String get qna_searchHint => '搜索问题';

  @override
  String get qna_questionTitle => '问题标题';

  @override
  String get qna_questionTitleHint => '请输入问题标题';

  @override
  String get qna_questionContent => '问题内容';

  @override
  String get qna_questionContentHint => '请输入您的问题';

  @override
  String get qna_answerContent => '回答内容';

  @override
  String get qna_answerContentHint => '请输入您的回答';

  @override
  String get qna_isPublic => '可见性';

  @override
  String get qna_publicQuestion => '公开问题';

  @override
  String get qna_privateQuestion => '私人问题';

  @override
  String get qna_author => '作者';

  @override
  String get qna_answerer => '回答者';

  @override
  String get qna_createdAt => '创建日期';

  @override
  String get qna_answeredAt => '回答日期';

  @override
  String qna_viewCount(int count) {
    return '$count次查看';
  }

  @override
  String qna_answerCount(int count) {
    return '$count个回答';
  }

  @override
  String get qna_empty => '暂无问题';

  @override
  String get qna_noAnswer => '暂无回答';

  @override
  String get qna_loadError => '问题加载失败';

  @override
  String get qna_createSuccess => '问题已创建';

  @override
  String get qna_createError => '问题创建失败';

  @override
  String get qna_updateSuccess => '问题已更新';

  @override
  String get qna_updateError => '问题更新失败';

  @override
  String get qna_deleteSuccess => '问题已删除';

  @override
  String get qna_deleteError => '问题删除失败';

  @override
  String get qna_deleteDialogTitle => '删除问题';

  @override
  String get qna_deleteDialogMessage => '确定要删除这个问题吗？\n此操作无法撤销。';

  @override
  String get qna_answerSuccess => '回答已发布';

  @override
  String get qna_answerError => '回答发布失败';

  @override
  String get qna_answerUpdateSuccess => '回答已更新';

  @override
  String get qna_answerUpdateError => '回答更新失败';

  @override
  String get qna_answerDeleteSuccess => '回答已删除';

  @override
  String get qna_answerDeleteError => '回答删除失败';

  @override
  String get qna_markResolved => '标记为已解决';

  @override
  String get qna_markUnresolved => '标记为未解决';

  @override
  String get qna_resolveSuccess => '问题已标记为已解决';

  @override
  String get qna_resolveError => '状态更改失败';

  @override
  String get qna_titleRequired => '请输入标题';

  @override
  String get qna_titleMinLength => '标题至少需要3个字符';

  @override
  String get qna_contentRequired => '请输入内容';

  @override
  String get qna_contentMinLength => '内容至少需要10个字符';

  @override
  String get qna_answerRequired => '请输入回答';

  @override
  String get schedule_today => '今天';

  @override
  String get schedule_add => '添加日程';

  @override
  String get schedule_edit => '编辑日程';

  @override
  String get schedule_delete => '删除日程';

  @override
  String get schedule_detail => '日程详情';

  @override
  String get schedule_allDay => '全天';

  @override
  String get schedule_loadError => '日程加载失败';

  @override
  String get schedule_empty => '暂无日程';

  @override
  String get schedule_createSuccess => '日程已创建';

  @override
  String get schedule_createError => '日程创建失败';

  @override
  String get schedule_updateSuccess => '日程已更新';

  @override
  String get schedule_updateError => '日程更新失败';

  @override
  String get schedule_deleteSuccess => '日程已删除';

  @override
  String get schedule_deleteError => '日程删除失败';

  @override
  String get schedule_deleteDialogTitle => '删除日程';

  @override
  String get schedule_deleteDialogMessage => '确定要删除这个日程吗？';

  @override
  String get schedule_title => '标题';

  @override
  String get schedule_titleHint => '请输入日程标题';

  @override
  String get schedule_titleRequired => '请输入标题';

  @override
  String get schedule_description => '描述';

  @override
  String get schedule_descriptionHint => '请输入描述（可选）';

  @override
  String get schedule_location => '地点';

  @override
  String get schedule_locationHint => '请输入地点（可选）';

  @override
  String get schedule_startDate => '开始日期';

  @override
  String get schedule_endDate => '结束日期';

  @override
  String get schedule_startTime => '开始时间';

  @override
  String get schedule_endTime => '结束时间';

  @override
  String get schedule_dueDate => '设置截止日期';

  @override
  String get schedule_dueDateSelect => '截止日期';

  @override
  String get schedule_dueTime => '截止时间';

  @override
  String get schedule_color => '颜色';

  @override
  String get schedule_share => '共享';

  @override
  String get schedule_sharePrivate => '私人';

  @override
  String get schedule_shareGroup => '指定群组';

  @override
  String get schedule_reminder => '提醒';

  @override
  String get schedule_reminderNone => '无';

  @override
  String get schedule_reminderAtTime => '准时';

  @override
  String get schedule_reminder5Min => '提前5分钟';

  @override
  String get schedule_reminder15Min => '提前15分钟';

  @override
  String get schedule_reminder30Min => '提前30分钟';

  @override
  String get schedule_reminder1Hour => '提前1小时';

  @override
  String get schedule_reminder1Day => '提前1天';

  @override
  String get schedule_recurrence => '重复';

  @override
  String get schedule_recurrenceNone => '不重复';

  @override
  String get schedule_recurrenceDaily => '每天';

  @override
  String get schedule_recurrenceWeekly => '每周';

  @override
  String get schedule_recurrenceMonthly => '每月';

  @override
  String get schedule_recurrenceYearly => '每年';

  @override
  String get schedule_personal => '个人';

  @override
  String get schedule_group => '群组';

  @override
  String get schedule_taskType => '日程类型';

  @override
  String get schedule_taskTypeCalendarOnly => '仅日历';

  @override
  String get schedule_taskTypeCalendarOnlyDesc => '仅显示在日历中';

  @override
  String get schedule_taskTypeTodoLinked => '关联待办';

  @override
  String get schedule_taskTypeTodoLinkedDesc => '同时显示在日历和待办列表中';

  @override
  String get schedule_taskTypeTodoOnly => '仅待办';

  @override
  String get schedule_taskTypeTodoOnlyDesc => '仅显示在待办列表中（不显示在日历）';

  @override
  String get schedule_priority => '优先级';

  @override
  String get schedule_priorityLow => '低';

  @override
  String get schedule_priorityMedium => '中';

  @override
  String get schedule_priorityHigh => '高';

  @override
  String get schedule_priorityUrgent => '紧急';

  @override
  String get schedule_participants => '参与者';

  @override
  String get schedule_participantsHint => '选择参与此日程的群组成员';

  @override
  String get schedule_noMembers => '暂无群组成员';

  @override
  String get schedule_participantsLoadError => '成员加载失败';

  @override
  String get schedule_participantsSelectAll => '全选';

  @override
  String get schedule_participantsDeselectAll => '取消全选';

  @override
  String get schedule_reminderCustom => '自定义';

  @override
  String get schedule_reminderCustomTitle => '设置提醒时间';

  @override
  String get schedule_reminderCustomHint => '设置事件前多久提醒';

  @override
  String get schedule_reminderDays => '天';

  @override
  String get schedule_reminderHours => '小时';

  @override
  String get schedule_reminderMinutes => '分钟';

  @override
  String schedule_reminderMinutesBefore(int minutes) {
    return '提前$minutes分钟';
  }

  @override
  String schedule_reminderHoursBefore(int hours) {
    return '提前$hours小时';
  }

  @override
  String schedule_reminderHoursMinutesBefore(int hours, int minutes) {
    return '提前$hours小时$minutes分钟';
  }

  @override
  String schedule_reminderDaysBefore(int days) {
    return '提前$days天';
  }

  @override
  String schedule_reminderDaysHoursBefore(int days, int hours) {
    return '提前$days天$hours小时';
  }

  @override
  String get category_management => '管理类别';

  @override
  String get category_add => '添加类别';

  @override
  String get category_edit => '编辑类别';

  @override
  String get category_empty => '暂无类别';

  @override
  String get category_emptyHint => '添加类别以整理您的日程';

  @override
  String get category_loadError => '类别加载失败';

  @override
  String get category_name => '类别名称';

  @override
  String get category_nameHint => '例：工作、个人、家庭';

  @override
  String get category_nameRequired => '请输入类别名称';

  @override
  String get category_description => '描述';

  @override
  String get category_descriptionHint => '类别描述（可选）';

  @override
  String get category_emoji => '表情符号';

  @override
  String get category_color => '颜色';

  @override
  String get category_createSuccess => '类别已创建';

  @override
  String get category_createError => '类别创建失败';

  @override
  String get category_updateSuccess => '类别已更新';

  @override
  String get category_updateError => '类别更新失败';

  @override
  String get category_deleteSuccess => '类别已删除';

  @override
  String get category_deleteError => '类别删除失败';

  @override
  String get category_deleteDialogTitle => '删除类别';

  @override
  String get category_deleteDialogMessage => '确定要删除这个类别吗？\n有关联日程的类别无法删除。';

  @override
  String get schedule_recurringEvery => '每';

  @override
  String get schedule_recurringIntervalDay => '天';

  @override
  String get schedule_recurringIntervalWeek => '周';

  @override
  String get schedule_recurringIntervalMonth => '月';

  @override
  String get schedule_recurringIntervalYear => '年';

  @override
  String get schedule_recurringDaysOfWeek => '重复日';

  @override
  String get schedule_daySun => '日';

  @override
  String get schedule_dayMon => '一';

  @override
  String get schedule_dayTue => '二';

  @override
  String get schedule_dayWed => '三';

  @override
  String get schedule_dayThu => '四';

  @override
  String get schedule_dayFri => '五';

  @override
  String get schedule_daySat => '六';

  @override
  String get schedule_daySunday => '星期日';

  @override
  String get schedule_dayMonday => '星期一';

  @override
  String get schedule_dayTuesday => '星期二';

  @override
  String get schedule_dayWednesday => '星期三';

  @override
  String get schedule_dayThursday => '星期四';

  @override
  String get schedule_dayFriday => '星期五';

  @override
  String get schedule_daySaturday => '星期六';

  @override
  String get schedule_recurringMonthlyType => '每月重复类型';

  @override
  String get schedule_recurringMonthlyDayOfMonth => '每月某日';

  @override
  String get schedule_recurringMonthlyWeekOfMonth => '每月某周几';

  @override
  String get schedule_recurringMonthlyEveryMonth => '每月';

  @override
  String get schedule_recurringDay => '';

  @override
  String get schedule_recurringWeek1 => '第一';

  @override
  String get schedule_recurringWeek2 => '第二';

  @override
  String get schedule_recurringWeek3 => '第三';

  @override
  String get schedule_recurringWeek4 => '第四';

  @override
  String get schedule_recurringWeekLast => '最后';

  @override
  String get schedule_recurringYearlyType => '每年重复类型';

  @override
  String get schedule_recurringYearlyDayOfMonth => '每年某日';

  @override
  String get schedule_recurringYearlyWeekOfMonth => '每年某周几';

  @override
  String get schedule_recurringYearlyEveryYear => '每年';

  @override
  String get schedule_month1 => '1月';

  @override
  String get schedule_month2 => '2月';

  @override
  String get schedule_month3 => '3月';

  @override
  String get schedule_month4 => '4月';

  @override
  String get schedule_month5 => '5月';

  @override
  String get schedule_month6 => '6月';

  @override
  String get schedule_month7 => '7月';

  @override
  String get schedule_month8 => '8月';

  @override
  String get schedule_month9 => '9月';

  @override
  String get schedule_month10 => '10月';

  @override
  String get schedule_month11 => '11月';

  @override
  String get schedule_month12 => '12月';

  @override
  String get schedule_recurringEndCondition => '结束条件';

  @override
  String get schedule_recurringEndNever => '永不';

  @override
  String get schedule_recurringEndDate => '到某日期';

  @override
  String get schedule_recurringEndCount => '执行次数';

  @override
  String get schedule_recurringCountTimes => '次';

  @override
  String get schedule_searchHint => '按标题、描述、地点搜索';

  @override
  String get schedule_searchNoResults => '无搜索结果';

  @override
  String schedule_searchResultCount(int count) {
    return '找到$count个结果';
  }

  @override
  String get todo_add => '添加待办';

  @override
  String get todo_edit => '编辑待办';

  @override
  String get todo_delete => '删除待办';

  @override
  String get todo_detail => '待办详情';

  @override
  String get todo_showCompleted => '显示已完成';

  @override
  String get todo_priority => '优先级';

  @override
  String get todo_priorityLow => '低';

  @override
  String get todo_priorityMedium => '中';

  @override
  String get todo_priorityHigh => '高';

  @override
  String get todo_priorityUrgent => '紧急';

  @override
  String get todo_noTodos => '暂无待办';

  @override
  String get todo_allCompleted => '所有待办已完成！';

  @override
  String get todo_loadError => '待办加载失败';

  @override
  String get todo_noDueDate => '无截止日期';

  @override
  String get todo_viewKanban => '看板视图';

  @override
  String get todo_viewList => '列表视图';

  @override
  String get todo_statusPending => '待处理';

  @override
  String get todo_statusInProgress => '进行中';

  @override
  String get todo_statusCompleted => '已完成';

  @override
  String get todo_statusHold => '暂停';

  @override
  String get todo_statusDrop => '放弃';

  @override
  String get todo_statusFailed => '失败';

  @override
  String get todo_prevWeek => '上周';

  @override
  String get todo_nextWeek => '下周';

  @override
  String get todo_changeStatus => '更改状态';

  @override
  String get todo_viewByDate => '按日期';

  @override
  String get todo_viewOverview => '概览';

  @override
  String get todo_overviewOverdue => '已逾期';

  @override
  String get todo_overviewToday => '今天';

  @override
  String get todo_overviewTomorrow => '明天';

  @override
  String get todo_overviewThisWeek => '本周';

  @override
  String get todo_overviewNextWeek => '下周';

  @override
  String get todo_overviewLater => '之后';

  @override
  String get todo_overviewNoDueDate => '无截止日期';

  @override
  String get todo_filter => '筛选';

  @override
  String get todo_filterAll => '全部';

  @override
  String get todo_filterStatus => '状态';

  @override
  String get todo_filterPriority => '优先级';

  @override
  String get todo_sortBy => '排序';

  @override
  String get todo_sortByStatus => '按状态';

  @override
  String get todo_sortByPriority => '按优先级';

  @override
  String get todo_sortByDueDate => '按截止日期';

  @override
  String get todo_sortByCreatedAt => '按创建日期';

  @override
  String get todo_filterApplied => '已应用筛选';

  @override
  String get todo_clearFilter => '清除筛选';

  @override
  String get todo_filterTooltip => '任务筛选';

  @override
  String get todo_widgetTitleToday => '今日任务';

  @override
  String get todo_widgetTitleWeek => '本周任务';

  @override
  String get todo_widgetTitleMonth => '本月任务';

  @override
  String get todo_emptyToday => '今天没有任务';

  @override
  String get todo_emptyWeek => '本周没有任务';

  @override
  String get todo_emptyMonth => '本月没有任务';

  @override
  String get todo_searchHint => '按标题、描述搜索';

  @override
  String get todo_searchNoResults => '无搜索结果';

  @override
  String todo_searchResultCount(int count) {
    return '找到$count个结果';
  }

  @override
  String get memo_title => '备忘录';

  @override
  String get memo_list => '备忘录列表';

  @override
  String get memo_detail => '备忘录详情';

  @override
  String get memo_create => '创建备忘录';

  @override
  String get memo_edit => '编辑备忘录';

  @override
  String get memo_delete => '删除备忘录';

  @override
  String get memo_content => '内容';

  @override
  String get memo_category => '类别';

  @override
  String get memo_categoryHint => '请输入类别（可选）';

  @override
  String get memo_tags => '标签';

  @override
  String get memo_tagsHint => '添加标签';

  @override
  String get memo_author => '作者';

  @override
  String get memo_createdAt => '创建日期';

  @override
  String get memo_updatedAt => '更新日期';

  @override
  String get memo_createSuccess => '备忘录已创建';

  @override
  String get memo_createError => '备忘录创建失败';

  @override
  String get memo_updateSuccess => '备忘录已更新';

  @override
  String get memo_updateError => '备忘录更新失败';

  @override
  String get memo_deleteSuccess => '备忘录已删除';

  @override
  String get memo_deleteError => '备忘录删除失败';

  @override
  String get memo_deleteDialogTitle => '删除备忘录';

  @override
  String get memo_deleteDialogMessage => '确定要删除这个备忘录吗？\n此操作无法撤销。';

  @override
  String get memo_loadError => '备忘录加载失败';

  @override
  String get memo_empty => '暂无备忘录';

  @override
  String get memo_titleHint => '请输入备忘录标题';

  @override
  String get memo_contentHint => '请输入备忘录内容';

  @override
  String get memo_titleRequired => '请输入标题';

  @override
  String get memo_titleMinLength => '标题至少需要2个字符';

  @override
  String get memo_contentRequired => '请输入内容';

  @override
  String get memo_searchHint => '按标题、内容搜索';

  @override
  String get memo_searchNoResults => '无搜索结果';

  @override
  String get memo_tagAdd => '添加标签';

  @override
  String get memo_tagName => '标签名称';

  @override
  String get memo_tagNameHint => '请输入标签名称';

  @override
  String get memo_visibility => '可见性';

  @override
  String get memo_visibilityPrivate => '仅自己';

  @override
  String get memo_visibilityGroup => '指定群组';

  @override
  String get memo_groupSelect => '选择群组';

  @override
  String get memo_typeNote => '笔记';

  @override
  String get memo_typeChecklist => '清单';

  @override
  String get memo_typeSelect => '备忘录类型';

  @override
  String get memo_checklist => '清单';

  @override
  String get memo_checklistAdd => '添加项目';

  @override
  String get memo_checklistAddHint => '请输入新项目';

  @override
  String get memo_checklistEmpty => '暂无清单项目';

  @override
  String get memo_checklistReset => '取消全选';

  @override
  String get memo_checklistSelectAll => '全选';

  @override
  String get memo_checklistDeleteItem => '删除项目';

  @override
  String get memo_checklistEditItem => '编辑项目';

  @override
  String memo_checklistProgress(int checked, int total) {
    return '$checked/$total已完成';
  }

  @override
  String get household_title => '家计管理';

  @override
  String get household_expense => '支出';

  @override
  String get household_no_group_selected => '请选择群组';

  @override
  String get household_personal_mode => '个人';

  @override
  String get household_add_expense => '添加支出';

  @override
  String get household_view_shopping_history => '查看购物记录';

  @override
  String get household_edit_expense => '编辑支出';

  @override
  String get household_delete_expense => '删除支出';

  @override
  String get household_delete_confirm => '确定要删除这笔支出吗？';

  @override
  String get household_amount => '金额';

  @override
  String get household_category => '类别';

  @override
  String get household_payment_method => '支付方式';

  @override
  String get household_description => '描述';

  @override
  String get household_date => '日期';

  @override
  String get household_recurring => '固定支出';

  @override
  String get household_total_income => '总收入';

  @override
  String get household_total_expense => '总支出';

  @override
  String get household_balance => '余额';

  @override
  String get household_income => '收入';

  @override
  String get household_type => '类型';

  @override
  String get household_total_budget => '总预算';

  @override
  String get household_statistics => '统计';

  @override
  String get household_monthly_statistics => '月度统计';

  @override
  String get household_no_expenses => '暂无支出记录';

  @override
  String get household_category_food => '餐饮';

  @override
  String get household_category_transport => '交通';

  @override
  String get household_category_leisure => '娱乐';

  @override
  String get household_category_living => '生活';

  @override
  String get household_category_health => '医疗';

  @override
  String get household_category_education => '教育';

  @override
  String get household_category_clothing => '服装';

  @override
  String get household_category_allowance => '零花钱';

  @override
  String get household_category_celebration => '人情费';

  @override
  String get household_category_asset_transfer => '资产转移';

  @override
  String get household_category_childcare => '育儿费';

  @override
  String get household_category_communication => '通信';

  @override
  String get household_category_groceries => '食材';

  @override
  String get household_category_other => '其他';

  @override
  String get household_payment_cash => '现金';

  @override
  String get household_payment_card => '银行卡';

  @override
  String get household_payment_transfer => '转账';

  @override
  String get household_payment_other => '其他';

  @override
  String get household_budget_settings => '预算设置';

  @override
  String get household_budget_amount => '预算金额';

  @override
  String get household_set_budget => '设置预算';

  @override
  String get household_amount_hint => '请输入金额';

  @override
  String get household_description_hint => '请输入描述';

  @override
  String get household_amount_required => '金额为必填项';

  @override
  String get household_save_success => '保存成功';

  @override
  String get household_delete_success => '删除成功';

  @override
  String get household_budget_saved => '预算已设置';

  @override
  String get household_recurring_expenses => '固定支出';

  @override
  String get household_recurring_no_expenses => '暂无固定支出';

  @override
  String get household_budget_set => '预算设置';

  @override
  String get household_budget_total_label => '总预算';

  @override
  String get household_budget_category_label => '按类别预算';

  @override
  String get household_budget_not_set => '未设置';

  @override
  String get household_budget_tab_monthly => '本月';

  @override
  String get household_budget_tab_template => '自动每月';

  @override
  String get household_budget_template_info => '每月1日根据模板自动设置预算。该月已有预算的将跳过。';

  @override
  String get household_budget_template_saved => '自动预算模板已保存';

  @override
  String get household_budget_template_delete_title => '删除模板';

  @override
  String get household_budget_template_delete_confirm => '确定要删除此类别的自动预算模板吗？';

  @override
  String get household_budget_template_deleted => '自动预算模板已删除';

  @override
  String household_budget_category_sum_exceeds(String sum, String total) {
    return '类别预算总计（¥$sum）超过总预算（¥$total）';
  }

  @override
  String household_budget_category_sum(String amount) {
    return '合计 ¥$amount';
  }

  @override
  String get asset_title => '资产';

  @override
  String get asset_statistics => '统计';

  @override
  String get asset_no_group_selected => '请选择群组';

  @override
  String get asset_no_accounts => '暂无账户';

  @override
  String get asset_total_balance => '总余额';

  @override
  String get asset_total_principal => '总本金';

  @override
  String get asset_total_profit => '总收益';

  @override
  String get asset_profit_rate => '收益率';

  @override
  String get asset_account_name => '账户名称';

  @override
  String get asset_account_name_hint => '例：主要储蓄账户';

  @override
  String get asset_account_name_required => '请输入账户名称';

  @override
  String get asset_institution => '机构';

  @override
  String get asset_institution_hint => '例：工商银行';

  @override
  String get asset_institution_required => '请输入机构名称';

  @override
  String get asset_account_number => '账户号码（可选）';

  @override
  String get asset_account_number_hint => '例：123-456-789';

  @override
  String get asset_account_type => '账户类型';

  @override
  String get asset_type_savings => '储蓄';

  @override
  String get asset_type_deposit => '定期存款';

  @override
  String get asset_type_stock => '股票';

  @override
  String get asset_type_fund => '基金';

  @override
  String get asset_type_real_estate => '房产';

  @override
  String get asset_type_gold => '实物黄金';

  @override
  String get asset_type_other => '其他';

  @override
  String get asset_gold_gram_weight => '重量';

  @override
  String get asset_gold_gram_weight_hint => '例：37.5';

  @override
  String get asset_gold_unit_gram => 'g（克）';

  @override
  String get asset_gold_unit_don => '돈';

  @override
  String get asset_gold_don_hint => '例：10';

  @override
  String get asset_gold_gram_converted => '克换算';

  @override
  String get asset_gold_estimated_principal => '估算本金';

  @override
  String get asset_gold_gram_weight_required => '请输入重量';

  @override
  String get asset_gold_gram_weight_invalid => '请输入有效数字';

  @override
  String get asset_gold_current_price_label => '当前黄金价格';

  @override
  String get asset_gold_price_loading => '正在获取黄金价格…';

  @override
  String get asset_gold_price_error => '无法加载黄金价格';

  @override
  String get asset_add_account => '添加账户';

  @override
  String get asset_edit_account => '编辑账户';

  @override
  String get asset_delete_account => '删除账户';

  @override
  String get asset_delete_account_confirm => '确定要删除这个账户吗？\n所有相关记录也将被删除。';

  @override
  String get asset_delete_success => '删除成功';

  @override
  String get asset_save_success => '保存成功';

  @override
  String get asset_account_detail => '账户详情';

  @override
  String get asset_records => '记录';

  @override
  String get asset_holdings => '持仓配置';

  @override
  String get asset_holdings_empty => '暂无持仓';

  @override
  String get asset_holding_add => '添加持仓';

  @override
  String get asset_holding_edit => '编辑持仓';

  @override
  String get asset_holding_delete => '删除持仓';

  @override
  String get asset_holding_name => '名称';

  @override
  String get asset_holding_name_hint => '例：纳斯达克ETF';

  @override
  String get asset_holding_name_required => '请输入名称';

  @override
  String get asset_holding_ticker => '代码（可选）';

  @override
  String get asset_holding_ticker_hint => '例：QQQ';

  @override
  String get asset_holding_ratio => '比例（%）';

  @override
  String get asset_holding_ratio_hint => '例：40';

  @override
  String get asset_holding_ratio_required => '请输入比例';

  @override
  String get asset_holding_ratio_invalid => '请输入0.01到100之间的数字';

  @override
  String get asset_holding_ratio_exceeded => '总比例超过100%';

  @override
  String get asset_holding_delete_confirm => '删除这个持仓吗？';

  @override
  String get asset_holding_total_ratio => '合计';

  @override
  String get asset_gold_record_info_title => '关于黄金账户';

  @override
  String get asset_gold_record_info_body =>
      '这是自动管理的实物黄金账户：\n\n• 添加记录时，余额按重量×当前黄金现货价计算。\n\n• 每月1日使用最新黄金现货价自动更新余额、收益和收益率。\n\n• 您可以手动调整本金；否则将保留第一条记录时计算的值。';

  @override
  String get asset_no_records => '暂无记录';

  @override
  String get asset_add_record => '添加记录';

  @override
  String get asset_record_date => '记录日期';

  @override
  String get asset_balance => '余额';

  @override
  String get asset_principal => '本金';

  @override
  String get asset_profit => '收益';

  @override
  String get asset_note => '备注（可选）';

  @override
  String get asset_note_hint => '例：收到利息';

  @override
  String get asset_amount_hint => '请输入金额';

  @override
  String get asset_amount_required => '请输入金额';

  @override
  String get asset_record_date_required => '请选择记录日期';

  @override
  String get asset_record_save_success => '记录已保存';

  @override
  String get asset_statistics_title => '资产统计';

  @override
  String get asset_by_type => '按类型';

  @override
  String asset_account_count(int count) {
    return '$count个账户';
  }

  @override
  String get asset_savings_total => '储蓄合计';

  @override
  String get asset_savings_goals => '关联储蓄';

  @override
  String get asset_trend => '资产趋势';

  @override
  String get asset_trend_monthly => '月度';

  @override
  String get asset_trend_yearly => '年度';

  @override
  String get asset_trend_balance => '余额';

  @override
  String get asset_trend_profit_rate => '累计收益率';

  @override
  String get asset_trend_period_return => '阶段收益';

  @override
  String get asset_trend_no_data => '暂无数据';

  @override
  String asset_trend_year_label(String year) {
    return '$year';
  }

  @override
  String get asset_input_mode => '输入模式';

  @override
  String get asset_input_mode_manual => '手动';

  @override
  String get asset_input_mode_auto => '自动计算';

  @override
  String get asset_additional_principal => '追加本金';

  @override
  String get asset_additional_principal_hint => '第一条记录请输入初始本金全额';

  @override
  String get asset_current_balance => '当前余额';

  @override
  String get asset_duplicate_date_error => '该日期已有记录';

  @override
  String get asset_delete_record => '删除记录';

  @override
  String get asset_delete_record_confirm => '确定要删除这条记录吗？';

  @override
  String get asset_stat_account_filter => '账户筛选';

  @override
  String get asset_stat_filter_all => '全部';

  @override
  String get asset_trend_principal => '本金';

  @override
  String get asset_trend_profit => '收益';

  @override
  String get childcare_title => '育儿积分';

  @override
  String get childcare_accounts => '孩子账户';

  @override
  String get childcare_add_account => '添加账户';

  @override
  String get childcare_balance => '积分余额';

  @override
  String get childcare_monthly_allowance => '每月零花钱';

  @override
  String get childcare_savings_balance => '储蓄余额';

  @override
  String get childcare_savings_interest_rate => '利率';

  @override
  String get childcare_tab_points => '积分';

  @override
  String get childcare_tab_rewards => '商店';

  @override
  String get childcare_tab_rules => '规则';

  @override
  String get childcare_tab_history => '历史';

  @override
  String get childcare_add_transaction => '积分奖惩';

  @override
  String get childcare_add_reward => '添加奖励';

  @override
  String get childcare_add_rule => '添加规则';

  @override
  String get childcare_transaction_type_earn => '获得积分';

  @override
  String get childcare_transaction_type_spend => '使用积分';

  @override
  String get childcare_transaction_type_penalty => '违规扣分';

  @override
  String get childcare_transaction_type_monthly => '每月零花钱';

  @override
  String get childcare_transaction_type_savings_deposit => '存入储蓄';

  @override
  String get childcare_transaction_type_savings_withdraw => '取出储蓄';

  @override
  String get childcare_transaction_type_interest => '利息发放';

  @override
  String childcare_reward_points_cost(int points) {
    return '$points积分';
  }

  @override
  String childcare_rule_penalty(int penalty) {
    return '-$penalty积分';
  }

  @override
  String get childcare_savings_deposit => '存入';

  @override
  String get childcare_savings_withdraw => '取出';

  @override
  String get childcare_empty_accounts => '暂无孩子账户。\n添加账户开始使用。';

  @override
  String get childcare_empty_transactions => '暂无交易记录。';

  @override
  String get childcare_empty_rewards => '暂无奖励。\n为孩子添加奖励吧。';

  @override
  String get childcare_empty_rules => '暂无规则。\n添加规则管理行为。';

  @override
  String get childcare_account_child_id => '孩子用户ID';

  @override
  String get childcare_account_monthly_allowance => '每月零花钱（积分）';

  @override
  String get childcare_account_savings_rate => '储蓄利率（%）';

  @override
  String get childcare_transaction_amount => '金额';

  @override
  String get childcare_transaction_description => '描述';

  @override
  String get childcare_transaction_type => '交易类型';

  @override
  String get childcare_reward_name => '奖励名称';

  @override
  String get childcare_reward_description => '描述（可选）';

  @override
  String get childcare_reward_points => '所需积分';

  @override
  String get childcare_rule_name => '规则名称';

  @override
  String get childcare_rule_description => '描述（可选）';

  @override
  String get childcare_rule_penalty_points => '扣分分值';

  @override
  String get childcare_savings_amount => '金额';

  @override
  String get childcare_delete_confirm => '确定要删除吗？';

  @override
  String get childcare_select_group => '请选择群组';

  @override
  String get childcare_no_group => '请先加入群组以使用育儿积分。';

  @override
  String get childcare_no_child => '暂无孩子档案。\n点击右上角按钮添加孩子。';

  @override
  String get household_settings_title => '家计设置';

  @override
  String get household_settings_group_section => '默认群组';

  @override
  String get household_settings_auto_section => '推送自动记账';

  @override
  String get household_settings_auto_toggle => '自动记录支付通知';

  @override
  String get household_settings_auto_toggle_desc => '检测银行卡/银行支付通知并自动记录到家计账本';

  @override
  String get household_settings_permission_required =>
      '需要通知访问权限。请点击「允许」在设置中授权。';

  @override
  String get household_settings_permission_grant => '允许';

  @override
  String get household_settings_privacy_section => '隐私政策';

  @override
  String get household_settings_privacy_title => '查看收集数据和政策';

  @override
  String get household_settings_privacy_subtitle => '了解推送自动记账功能收集的信息';

  @override
  String get household_settings_privacy_dialog_title => '隐私政策';

  @override
  String get household_settings_auto_scope_notice =>
      '仅在应用运行时有效（前台或后台）。完全关闭应用后自动记账将停止。';

  @override
  String get household_settings_privacy_content =>
      '■ 收集的数据\n应用临时读取设备上银行卡/银行应用发送的支付完成通知中的以下信息：\n  · 通知标题和正文（例：「工商银行 ¥120 已扣款」）\n  · 发送应用的包名（例：com.icbc.icbcapp）\n\n■ 用途\n数据仅用于从通知文本中提取支付金额、支付方式和类别，并自动记录到家计账本。\n\n■ 保留和处置\n通知文本在设备上解析后立即丢弃；原始文本不会传输到服务器或存储。只有转换后的账本条目会保存到您的账户。\n\n■ 第三方共享\n收集的通知信息不会提供、出售或与任何第三方共享。\n\n■ 撤回同意\n您可以随时在此设置页面关闭自动记账，或在设备设置 > 通知访问中撤销Family Planner的通知访问权限。';

  @override
  String get fridge_title => '冰箱';

  @override
  String get shopping_title => '购物';

  @override
  String get fridge_tab_fridge => '冰箱';

  @override
  String get fridge_tab_cart => '购物车';

  @override
  String get fridge_tab_frequent => '常买';

  @override
  String get fridge_tab_history => '历史';

  @override
  String get fridge_storage_add => '添加储存区';

  @override
  String get fridge_storage_edit => '编辑储存区';

  @override
  String get fridge_storage_delete => '删除储存区';

  @override
  String get fridge_storage_delete_confirm => '删除此储存区将同时删除其中所有食材。确定继续吗？';

  @override
  String get fridge_storage_name_hint => '例：厨房冰箱';

  @override
  String get fridge_storage_type_fridge => '冰箱';

  @override
  String get fridge_storage_type_freezer => '冷冻室';

  @override
  String get fridge_storage_type_pantry => '储藏室';

  @override
  String get fridge_item_add => '添加食材';

  @override
  String get fridge_item_edit => '编辑食材';

  @override
  String get fridge_item_delete_title => '删除食材';

  @override
  String fridge_item_delete_confirm(String name) {
    return '删除$name？';
  }

  @override
  String get fridge_item_name => '食材名称';

  @override
  String get fridge_item_quantity => '数量';

  @override
  String get fridge_item_unit => '单位（可选）';

  @override
  String get fridge_item_expires_at => '过期日期（可选）';

  @override
  String fridge_item_alert_days(int days) {
    return '过期前$days天提醒';
  }

  @override
  String get fridge_item_memo => '备注（可选）';

  @override
  String get fridge_item_dday_today => '今天到期';

  @override
  String fridge_item_dday_expired(int days) {
    return '已过期$days天';
  }

  @override
  String fridge_item_dday_remaining(int days) {
    return '还剩$days天';
  }

  @override
  String get fridge_item_no_expiry => '无过期日期';

  @override
  String get fridge_empty_storage => '暂无储存区，请添加！';

  @override
  String get fridge_empty_items => '暂无食材';

  @override
  String get fridge_item_count => '个';

  @override
  String get fridge_sort_expiry => '按过期日期';

  @override
  String get fridge_sort_name => '按名称';

  @override
  String get fridge_sort_registered => '按添加日期';

  @override
  String get fridge_item_elapsed_days => '天';

  @override
  String get fridge_frequent_add => '添加食材';

  @override
  String get fridge_frequent_auto_add => '用完自动添加';

  @override
  String get fridge_frequent_empty => '暂无常买食材';

  @override
  String get fridge_frequent_add_to_cart => '加入购物车';

  @override
  String fridge_frequent_added_snackbar(String name) {
    return '已将$name加入购物车';
  }

  @override
  String fridge_frequent_delete_confirm(String name) {
    return '删除$name？';
  }

  @override
  String get fridge_frequent_autoAddInfo_title => '什么是自动添加？';

  @override
  String get fridge_frequent_autoAddInfo_body =>
      '当冰箱中此食材数量为0时，将自动添加到购物车。\n开启后，冰箱中没有时购物清单会自动填充。';

  @override
  String get fridge_frequent_autoAddInfo_hint => '在冰箱标签管理数量时同步';

  @override
  String get fridge_frequent_coach_fabTitle => '添加常买食材';

  @override
  String get fridge_frequent_coach_fabDesc => '注册经常购买的食材，\n下次购物时可快速添加。';

  @override
  String get fridge_frequent_coach_itemTitle => '管理食材';

  @override
  String get fridge_frequent_coach_itemDesc => '设置食材名称和默认单位。\n点击编辑，长按删除。';

  @override
  String get fridge_frequent_coach_autoAddTitle => '自动添加';

  @override
  String get fridge_frequent_coach_autoAddDesc =>
      '当冰箱中此食材数量为0时，\n将自动添加到购物车。\n与冰箱标签联动的智能功能。';

  @override
  String get fridge_frequent_coach_addToCartTitle => '一键加入购物车';

  @override
  String get fridge_frequent_coach_addToCartDesc => '一键将食材添加到\n当前购物车。';

  @override
  String get fridge_frequent_coach_skip => '跳过';

  @override
  String get fridge_cart_empty => '购物车为空';

  @override
  String get fridge_cart_add_item => '添加食材';

  @override
  String get fridge_cart_complete => '完成购物';

  @override
  String get fridge_cart_complete_title => '完成购物';

  @override
  String get fridge_cart_complete_step2_title => '冰箱转移详情';

  @override
  String get fridge_cart_complete_transfer_hint => '选择要转移食材的储存区';

  @override
  String get fridge_cart_complete_add_expense => '记录到账本';

  @override
  String get fridge_cart_complete_amount => '合计（可选—空白时自动求和）';

  @override
  String get fridge_cart_item_price => '价格（可选）';

  @override
  String get fridge_cart_complete_description => '备注（可选）';

  @override
  String get fridge_cart_skip_transfer => '不转移';

  @override
  String get fridge_history_empty => '暂无购物历史';

  @override
  String fridge_history_items_count(int count) {
    return '$count个食材';
  }

  @override
  String get fridge_history_linked_expense => '已关联账本';

  @override
  String get fridge_history_view_expense => '在账本中查看';

  @override
  String get fridge_group_selector_personal => '个人';

  @override
  String get dashboard_greetingMorning => '早上好';

  @override
  String get dashboard_greetingAfternoon => '下午好';

  @override
  String get dashboard_greetingEvening => '晚上好';

  @override
  String get dashboard_greetingSubtitle => '今天也是美好的一天！';

  @override
  String get dashboard_emptyWidgets => '没有要显示的小部件';

  @override
  String get dashboard_emptyWidgetsHint => '请在设置中启用小部件';

  @override
  String get dashboard_widgetSettings => '小部件设置';

  @override
  String get dashboard_notifications => '通知';

  @override
  String get weather_widgetTitle => '今日天气';

  @override
  String get weather_refresh => '刷新天气';

  @override
  String get weather_detail => '详情';

  @override
  String get weather_errorMessage => '无法加载天气信息';

  @override
  String get weather_dustFine => 'PM10';

  @override
  String get weather_dustUltraFine => 'PM2.5';

  @override
  String get investment_widgetTitle => '投资指标';

  @override
  String get investment_errorMessage => '无法加载数据';

  @override
  String get investment_emptyBookmarks => '没有收藏的指标';

  @override
  String get investment_screenTitle => '投资指标';

  @override
  String get investment_bookmarkSection => '收藏';

  @override
  String get investment_bookmarkReorderHint => '（长按排序）';

  @override
  String get investment_allSection => '全部指标';

  @override
  String get investment_noData => '暂无指标数据';

  @override
  String get investment_loadError => '数据加载失败';

  @override
  String get investment_retry => '重试';

  @override
  String get investment_adminTooltip => '重置历史数据（管理员）';

  @override
  String get investment_briefingTitle => 'AI市场简报';

  @override
  String investment_briefingError(String error) {
    return 'AI简报错误：$error';
  }

  @override
  String get investment_briefingMacro => '宏观';

  @override
  String get investment_briefingDomestic => '国内市场';

  @override
  String get investment_briefingGlobal => '全球市场';

  @override
  String investment_briefingUpdatedAt(String time) {
    return '更新：$time';
  }

  @override
  String get investment_adminDialogTitle => '重置历史数据';

  @override
  String get investment_adminDialogDesc =>
      '从Yahoo/CoinGecko/BOK收集历史价格并保存到数据库。\n可能需要一些时间。';

  @override
  String get investment_adminDaysLabel => '收集天数 (1~3650)';

  @override
  String get investment_adminDaysSuffix => '天';

  @override
  String get investment_adminExecute => '执行重置';

  @override
  String get investment_adminResultTitle => '重置完成';

  @override
  String get investment_adminResultYahoo => 'Yahoo（股票/外汇/大宗商品）';

  @override
  String get investment_adminResultCrypto => '加密货币（BTC/KRW）';

  @override
  String get investment_adminResultBond => '韩国债券';

  @override
  String get investment_adminResultGold => '国内黄金价格';

  @override
  String investment_adminResultCount(int count) {
    return '$count条';
  }

  @override
  String investment_adminInitError(String error) {
    return '重置失败：$error';
  }

  @override
  String get investment_adminLoading => '正在收集历史数据...';

  @override
  String get investment_prevPrice => '昨收价';

  @override
  String investment_spreadBadge(String value) {
    return '乖离率 $value%';
  }

  @override
  String get investment_spreadPremium => '相对国际价格溢价';

  @override
  String get investment_spreadDiscount => '相对国际价格折价';

  @override
  String get investment_chartTitle => '价格走势';

  @override
  String investment_chartDayChip(int days) {
    return '$days天';
  }

  @override
  String get investment_chartYearChip => '1年';

  @override
  String get investment_chartLoadError => '无法加载图表';

  @override
  String get investment_chartNoData => '暂无数据';

  @override
  String investment_marketClosed(String date) {
    return '休市中 · 最后交易日: $date';
  }

  @override
  String get investment_spreadChartTitle => '乖离率走势';

  @override
  String get investment_spreadChartSubtitle => '（相对国际价格）';

  @override
  String investment_spreadSummaryLabel(String label) {
    return '当前相对国际价格$label';
  }

  @override
  String get investment_spreadPremiumLabel => '溢价';

  @override
  String get investment_spreadDiscountLabel => '折价';

  @override
  String get investment_coachIndicatorTitle => '投资指标';

  @override
  String get investment_coachIndicatorDesc =>
      '一览主要股指、汇率、大宗商品、加密货币等实时指标。\n点击查看详细图表和历史走势。';

  @override
  String get investment_coachBookmarkTitle => '收藏';

  @override
  String get investment_coachBookmarkDesc =>
      '点击星标添加到收藏。\n收藏的指标置顶显示，\n并可在主页仪表板小部件中直接查看。';

  @override
  String get householdWidget_groupTooltip => '选择群组';

  @override
  String householdWidget_incomeLabel(String month) {
    return '$month收入';
  }

  @override
  String householdWidget_expenseLabel(String month) {
    return '$month支出';
  }

  @override
  String get householdWidget_balance => '余额';

  @override
  String householdWidget_budget(String amount) {
    return '预算 $amount';
  }

  @override
  String householdWidget_budgetUsed(int percent) {
    return '已使用$percent%';
  }

  @override
  String householdWidget_budgetOver(String amount) {
    return '超支$amount';
  }

  @override
  String householdWidget_budgetRemaining(String amount) {
    return '剩余$amount';
  }

  @override
  String get householdWidget_filterTitle => '选择筛选';

  @override
  String get householdWidget_filterPersonal => '个人';

  @override
  String get householdWidget_filterPersonalSub => '仅个人支出';

  @override
  String get householdWidget_applyButton => '应用';

  @override
  String get householdWidget_categoryTitle => '按类别支出';

  @override
  String householdWidget_categoryOver(String amount) {
    return '超支$amount';
  }

  @override
  String householdWidget_categoryUsed(int percent) {
    return '已使用$percent%';
  }

  @override
  String get householdWidget_catTransportation => '交通';

  @override
  String get householdWidget_catFood => '餐饮';

  @override
  String get householdWidget_catLeisure => '娱乐';

  @override
  String get householdWidget_catLiving => '生活';

  @override
  String get householdWidget_catMedical => '医疗';

  @override
  String get householdWidget_catEducation => '教育';

  @override
  String get householdWidget_catAllowance => '零花钱';

  @override
  String get householdWidget_catCelebration => '人情费';

  @override
  String get householdWidget_catAssetTransfer => '资产转移';

  @override
  String get householdWidget_catChildcare => '育儿费';

  @override
  String get householdWidget_catOther => '其他';

  @override
  String get assetWidget_title => '资产概览';

  @override
  String assetWidget_groupTitle(String groupName) {
    return '$groupName资产';
  }

  @override
  String get assetWidget_groupTooltip => '选择群组';

  @override
  String get assetWidget_totalAsset => '总资产';

  @override
  String get assetWidget_totalProfit => '总收益';

  @override
  String get assetWidget_profitRate => '收益率';

  @override
  String get assetWidget_distribution => '资产分布';

  @override
  String get assetWidget_groupPickerTitle => '选择群组';

  @override
  String get assetWidget_applyButton => '应用';

  @override
  String get assetWidget_typeSavings => '储蓄';

  @override
  String get assetWidget_typeDeposit => '定期存款';

  @override
  String get assetWidget_typeStock => '股票';

  @override
  String get assetWidget_typeFund => '基金';

  @override
  String get assetWidget_typeRealEstate => '房产';

  @override
  String get assetWidget_typeGold => '黄金';

  @override
  String get assetWidget_typeOther => '其他';
}
