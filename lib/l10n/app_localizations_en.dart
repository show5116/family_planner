// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Planner';

  @override
  String get appDescription => 'Daily life management planner with family';

  @override
  String get common_ok => 'OK';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_confirm => 'Confirm';

  @override
  String get common_save => 'Save';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_add => 'Add';

  @override
  String get common_create => 'Create';

  @override
  String get common_search => 'Search';

  @override
  String get common_loading => 'Loading...';

  @override
  String get common_optional => 'Optional';

  @override
  String get common_error => 'Error';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_close => 'Close';

  @override
  String get common_done => 'Done';

  @override
  String get common_undo => 'Undo';

  @override
  String get common_add_to_list => 'Add to list';

  @override
  String get cart_unsaved_changes => 'You have unsaved changes';

  @override
  String get common_next => 'Next';

  @override
  String get common_back => 'Back';

  @override
  String get common_previous => 'Previous';

  @override
  String get common_all => 'All';

  @override
  String get common_apply => 'Apply';

  @override
  String get auth_login => 'Log in';

  @override
  String get auth_signup => 'Sign up';

  @override
  String get auth_logout => 'Log out';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_passwordConfirm => 'Confirm Password';

  @override
  String get auth_name => 'Name';

  @override
  String get auth_forgotPassword => 'Forgot your password?';

  @override
  String get auth_noAccount => 'Don\'t have an account?';

  @override
  String get auth_haveAccount => 'Already have an account?';

  @override
  String get auth_continueWithGoogle => 'Continue with Google';

  @override
  String get auth_continueWithKakao => 'Continue with Kakao';

  @override
  String get auth_continueWithApple => 'Continue with Apple';

  @override
  String get auth_or => 'or';

  @override
  String get auth_emailHint => 'Enter your email';

  @override
  String get auth_passwordHint => 'Enter your password';

  @override
  String get auth_nameHint => 'Enter your name';

  @override
  String get auth_emailError => 'Invalid email format';

  @override
  String get auth_passwordError => 'Password must be at least 6 characters';

  @override
  String get auth_passwordMismatch => 'Passwords do not match';

  @override
  String get auth_nameError => 'Please enter your name';

  @override
  String get auth_loginSuccess => 'Login successful';

  @override
  String get auth_loginFailed => 'Login failed';

  @override
  String get auth_loginFailedInvalidCredentials => 'Invalid email or password';

  @override
  String get auth_googleLoginFailed => 'Google login failed';

  @override
  String get auth_kakaoLoginFailed => 'Kakao login failed';

  @override
  String get auth_signupSuccess => 'Sign up successful';

  @override
  String get auth_signupFailed => 'Sign up failed';

  @override
  String get auth_logoutSuccess => 'You have been logged out';

  @override
  String get auth_emailVerification => 'Email Verification';

  @override
  String get auth_emailVerificationMessage =>
      'A verification code has been sent to your email.';

  @override
  String get auth_verificationCode => 'Verification Code';

  @override
  String get auth_verificationCodeHint => 'Enter verification code';

  @override
  String get auth_resendCode => 'Resend Code';

  @override
  String get auth_verify => 'Verify';

  @override
  String get auth_resetPassword => 'Reset Password';

  @override
  String get auth_resetPasswordMessage =>
      'Enter your email address.\nWe\'ll send you a verification code.';

  @override
  String get auth_newPassword => 'New Password';

  @override
  String get auth_sendCode => 'Send Code';

  @override
  String get auth_resetPasswordSuccess =>
      'Password has been reset. Please log in.';

  @override
  String get auth_signupEmailVerificationMessage =>
      'Sign up successful. Please check your email.';

  @override
  String get auth_signupNameLabel => 'Name';

  @override
  String get auth_signupNameMinLengthError =>
      'Name must be at least 2 characters';

  @override
  String get auth_signupPasswordHelperText => 'At least 8 characters';

  @override
  String get auth_signupConfirmPasswordLabel => 'Confirm Password';

  @override
  String get auth_signupConfirmPasswordError => 'Please confirm your password';

  @override
  String get auth_signupButton => 'Sign up';

  @override
  String get auth_forgotPasswordTitle => 'Forgot Password';

  @override
  String get auth_setPasswordTitle => 'Set Password';

  @override
  String get auth_forgotPasswordGuide =>
      'Enter your email address.\nWe\'ll send you a verification code.';

  @override
  String get auth_forgotPasswordGuideWithCode =>
      'Enter the verification code sent to your email\nand set a new password.';

  @override
  String get auth_setPasswordGuide =>
      'Set a password for account security.\nEnter your registered email address and\nwe\'ll send you a verification code.';

  @override
  String get auth_setPasswordGuideWithCode =>
      'Enter the verification code sent to your email\nand set a password.';

  @override
  String get auth_verificationCodeLabel => 'Verification Code (6 digits)';

  @override
  String get auth_verificationCodeError => 'Please enter the verification code';

  @override
  String get auth_verificationCodeLengthError =>
      'Verification code must be 6 digits';

  @override
  String get auth_codeSentMessage =>
      'Verification code has been sent to your email';

  @override
  String get auth_codeSentError => 'Failed to send verification code';

  @override
  String get auth_passwordResetButton => 'Reset Password';

  @override
  String get auth_passwordSetButton => 'Set Password';

  @override
  String get auth_resendCodeButton => 'Resend verification code';

  @override
  String get auth_passwordSetSuccess =>
      'Password has been set. You can now log in.';

  @override
  String get auth_passwordResetError => 'Failed to reset password';

  @override
  String get auth_rememberPassword => 'Remember your password?';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_assets => 'Assets';

  @override
  String get nav_calendar => 'Calendar';

  @override
  String get nav_todo => 'To-Do';

  @override
  String get nav_more => 'More';

  @override
  String get nav_household => 'Household';

  @override
  String get nav_childPoints => 'Child Points';

  @override
  String get nav_memo => 'Memo';

  @override
  String get nav_miniGames => 'Mini Games';

  @override
  String get nav_investmentIndicators => 'Investment Indicators';

  @override
  String get nav_savings => 'Group Piggy Bank';

  @override
  String get nav_votes => 'Votes';

  @override
  String get more_coach_groupDesc =>
      'Create groups for family, couples, friends, and more.\nInvite members with an invitation code.';

  @override
  String get more_coach_settingsDesc =>
      'Customize the app with themes, language, notifications,\nbottom tab layout, and more.';

  @override
  String get home_greeting_morning => 'Good morning!';

  @override
  String get home_greeting_afternoon => 'Good afternoon!';

  @override
  String get home_greeting_evening => 'Good evening!';

  @override
  String get home_greeting_night => 'It\'s late!';

  @override
  String get home_todaySchedule => 'Today\'s Schedule';

  @override
  String get home_noSchedule => 'No scheduled events';

  @override
  String get home_investmentSummary => 'Investment Summary';

  @override
  String get home_todoSummary => 'To-Do Summary';

  @override
  String get home_assetSummary => 'Asset Summary';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_theme => 'Theme';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_homeWidgets => 'Home Widgets';

  @override
  String get settings_profile => 'Profile';

  @override
  String get settings_family => 'Family Management';

  @override
  String get settings_notifications => 'Notifications';

  @override
  String get settings_about => 'About';

  @override
  String get settings_bottomNavigation => 'Bottom Navigation';

  @override
  String get bottomNav_title => 'Bottom Navigation Settings';

  @override
  String get bottomNav_reset => 'Reset to Default';

  @override
  String get bottomNav_resetConfirmTitle => 'Reset Confirmation';

  @override
  String get bottomNav_resetConfirmMessage =>
      'Reset bottom navigation settings to default?';

  @override
  String get bottomNav_resetSuccess => 'Reset to default settings';

  @override
  String get bottomNav_guideMessage =>
      'Home and More are fixed.\nTap the middle 3 slots to select menus.';

  @override
  String get bottomNav_preview => 'Bottom Navigation Preview';

  @override
  String get bottomNav_howToUse => 'How to Use';

  @override
  String get bottomNav_instructions =>
      '• Tap slots 2, 3, 4 to change to desired menus.\n• Slot 1 (Home) and Slot 5 (More) are fixed.\n• Menus not in bottom navigation are shown in \"More\" tab.';

  @override
  String get bottomNav_availableMenus => 'Available Menus';

  @override
  String get bottomNav_slot => 'Slot';

  @override
  String get bottomNav_unused => 'Unused';

  @override
  String bottomNav_selectMenuTitle(Object slot) {
    return 'Select Menu for Slot';
  }

  @override
  String get bottomNav_usedInOtherSlot =>
      'Used in other slot (will swap if selected)';

  @override
  String get widgetSettings_saveSuccess => 'Settings saved';

  @override
  String get widgetSettings_guide =>
      'Select widgets to display on home screen and change their order';

  @override
  String get widgetSettings_widgetOrder => 'Widget Order';

  @override
  String get widgetSettings_dragToReorder =>
      'Long press and drag widgets to change order';

  @override
  String get widgetSettings_restoreDefaults => 'Restore Default Settings';

  @override
  String get widgetSettings_todayScheduleDesc => 'Display today\'s events';

  @override
  String get widgetSettings_investmentSummaryDesc =>
      'Display KOSPI, NASDAQ, and exchange rate information';

  @override
  String get widgetSettings_todoSummaryDesc => 'Display in-progress tasks';

  @override
  String get widgetSettings_assetSummaryDesc =>
      'Display total assets and return rate';

  @override
  String get widgetSettings_memoSummary => 'Memo Summary';

  @override
  String get widgetSettings_memoSummaryDesc => 'Display recently written memos';

  @override
  String get widgetSettings_householdSummary => 'Household Budget';

  @override
  String get widgetSettings_householdSummaryDesc =>
      'Monthly expense summary and budget achievement rate';

  @override
  String get widgetSettings_childcareSummary => 'Childcare Points';

  @override
  String get widgetSettings_childcareSummaryDesc =>
      'Point balance status per child';

  @override
  String get widgetSettings_savingsSummary => 'Savings';

  @override
  String get widgetSettings_savingsSummaryDesc =>
      'Savings goal and achievement status per group';

  @override
  String get widgetSettings_fridgeSummary => 'Expiring Soon';

  @override
  String get widgetSettings_fridgeSummaryDesc =>
      'List of items in the fridge with upcoming expiry dates';

  @override
  String get widgetSettings_viewToday => 'Today';

  @override
  String get widgetSettings_viewWeek => 'This Week';

  @override
  String get widgetSettings_viewMonth => 'This Month';

  @override
  String get widgetSettings_viewBudget => 'Budget Overview';

  @override
  String get widgetSettings_viewCategory => 'By Category';

  @override
  String get widgetSettings_savingsEmpty => 'No savings registered';

  @override
  String get widgetSettings_fridgeExpiryEmpty => 'No items expiring soon';

  @override
  String get widgetSettings_scheduleWeek => 'This Week\'s Schedule';

  @override
  String get widgetSettings_scheduleMonth => 'This Month\'s Schedule';

  @override
  String get widgetSettings_scheduleEmptyToday => 'No schedule for today';

  @override
  String get widgetSettings_scheduleEmptyWeek => 'No schedule this week';

  @override
  String get widgetSettings_scheduleEmptyMonth => 'No schedule this month';

  @override
  String get widgetSettings_weather => 'Weather';

  @override
  String get widgetSettings_weatherDesc =>
      'Display current location weather information';

  @override
  String get themeSettings_title => 'Theme Settings';

  @override
  String get themeSettings_selectTheme => 'Select Theme';

  @override
  String get themeSettings_description =>
      'Choose your app\'s brightness theme. You can follow system settings or choose manually.';

  @override
  String get themeSettings_lightMode => 'Light Mode';

  @override
  String get themeSettings_lightModeDesc => 'Use bright theme';

  @override
  String get themeSettings_darkMode => 'Dark Mode';

  @override
  String get themeSettings_darkModeDesc => 'Use dark theme';

  @override
  String get themeSettings_systemMode => 'System Settings';

  @override
  String get themeSettings_systemModeDesc => 'Follow device system settings';

  @override
  String get themeSettings_colorTitle => 'Color Theme';

  @override
  String get themeSettings_brightnessTitle => 'Brightness Mode';

  @override
  String get themeSettings_currentThemePreview => 'Current Theme Preview';

  @override
  String get themeSettings_currentTheme => 'Current Theme';

  @override
  String get profile_title => 'Profile Settings';

  @override
  String get profile_save => 'Save';

  @override
  String get profile_name => 'Name';

  @override
  String get profile_nameRequired => 'Please enter your name';

  @override
  String get profile_phoneNumber => 'Phone Number (Optional)';

  @override
  String get profile_phoneNumberHint => 'e.g., 010-1234-5678';

  @override
  String get profile_uploadSuccess => 'Profile photo uploaded successfully';

  @override
  String get profile_uploadFailed => 'Profile photo upload failed';

  @override
  String get profile_changePassword => 'Change Password';

  @override
  String get profile_currentPassword => 'Current Password';

  @override
  String get profile_currentPasswordRequired => 'Please enter current password';

  @override
  String get profile_newPassword => 'New Password';

  @override
  String get profile_newPasswordRequired => 'Please enter new password';

  @override
  String get profile_newPasswordMinLength =>
      'Password must be at least 6 characters';

  @override
  String get profile_confirmNewPassword => 'Confirm New Password';

  @override
  String get profile_confirmNewPasswordRequired =>
      'Please confirm new password';

  @override
  String get profile_passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get profile_updateSuccess => 'Profile updated';

  @override
  String get profile_updateFailed => 'Profile update failed';

  @override
  String get theme_light => 'Light Mode';

  @override
  String get theme_dark => 'Dark Mode';

  @override
  String get theme_system => 'System Default';

  @override
  String get language_korean => '한국어';

  @override
  String get language_english => 'English';

  @override
  String get language_japanese => '日本語';

  @override
  String get language_chinese => 'Chinese';

  @override
  String get language_selectDescription => 'Select the language for the app';

  @override
  String get language_useSystemLanguage => 'Use System Language';

  @override
  String get language_useSystemLanguageDescription =>
      'Follow device language settings';

  @override
  String get widgetSettings_title => 'Home Widget Settings';

  @override
  String get widgetSettings_description =>
      'Select widgets to display on home screen';

  @override
  String get widgetSettings_todaySchedule => 'Today\'s Schedule';

  @override
  String get widgetSettings_investmentSummary => 'Investment Summary';

  @override
  String get widgetSettings_todoSummary => 'To-Do Summary';

  @override
  String get widgetSettings_assetSummary => 'Asset Summary';

  @override
  String get settings_screenSettings => 'Screen Settings';

  @override
  String get settings_bottomNavigationTitle => 'Bottom Navigation Settings';

  @override
  String get settings_bottomNavigationSubtitle =>
      'Configure bottom menu order and visibility';

  @override
  String get settings_homeWidgetsTitle => 'Home Widget Settings';

  @override
  String get settings_homeWidgetsSubtitle =>
      'Select widgets to display on home screen';

  @override
  String get settings_themeTitle => 'Theme Settings';

  @override
  String get settings_themeSubtitle => 'Change between light/dark mode';

  @override
  String get settings_languageTitle => 'Language Settings';

  @override
  String get settings_languageSubtitle => 'Change the language used in the app';

  @override
  String get settings_userSettings => 'User Settings';

  @override
  String get settings_profileTitle => 'Profile Settings';

  @override
  String get settings_profileSubtitle => 'Edit your profile information';

  @override
  String get settings_groupManagementTitle => 'Group Management';

  @override
  String get settings_groupManagementSubtitle => 'Manage groups and members';

  @override
  String get settings_notificationSettings => 'Notification Settings';

  @override
  String get settings_notificationTitle => 'Notifications';

  @override
  String get settings_notificationSubtitle => 'Change notification preferences';

  @override
  String get settings_information => 'Information';

  @override
  String get settings_appInfoTitle => 'App Info';

  @override
  String get settings_appInfoSubtitle => 'Version 1.0.0';

  @override
  String get settings_appDescription => 'Daily planner for families';

  @override
  String get settings_helpTitle => 'Help';

  @override
  String get settings_helpSubtitle => 'View usage instructions';

  @override
  String get settings_user => 'User';

  @override
  String get settings_logout => 'Logout';

  @override
  String get settings_logoutConfirmTitle => 'Logout';

  @override
  String get settings_logoutConfirmMessage =>
      'Are you sure you want to logout?';

  @override
  String get settings_passwordSetupRequired => 'Password Setup Required';

  @override
  String get settings_passwordSetupMessage1 =>
      'You signed up using only social login and haven\'t set a password yet.';

  @override
  String get settings_passwordSetupMessage2 =>
      'We recommend setting a password to edit your profile or enhance account security.';

  @override
  String get settings_passwordSetupMessage3 =>
      'Would you like to go to the password setup screen?';

  @override
  String get settings_passwordSetupLater => 'Later';

  @override
  String get settings_passwordSetupNow => 'Set Password';

  @override
  String get settings_adminMenu => 'Admin Only';

  @override
  String get settings_permissionManagementTitle => 'Permission Management';

  @override
  String get settings_permissionManagementSubtitle =>
      'Manage permission types for Roles';

  @override
  String get permission_title => 'Permission Management';

  @override
  String get permission_search =>
      'Search permissions (code, name, description)';

  @override
  String get permission_allCategories => 'All';

  @override
  String get permission_create => 'Create Permission';

  @override
  String get permission_code => 'Code';

  @override
  String get permission_category => 'Category';

  @override
  String get permission_description => 'Description';

  @override
  String get permission_status => 'Status';

  @override
  String get permission_active => 'Active';

  @override
  String get permission_inactive => 'Inactive';

  @override
  String get permission_count => '';

  @override
  String get permission_noPermissions => 'No permissions found';

  @override
  String get permission_loadFailed => 'Failed to load permissions';

  @override
  String get permission_deleteConfirm => 'Delete Permission';

  @override
  String permission_deleteMessage(String name) {
    return 'Delete $name permission?';
  }

  @override
  String get permission_deleteSoftDescription =>
      'Soft delete: Deactivate but keep data';

  @override
  String get permission_deleteHardDescription =>
      'Hard delete: Permanently remove from database (Warning!)';

  @override
  String get permission_softDelete => 'Soft Delete';

  @override
  String get permission_hardDelete => 'Hard Delete';

  @override
  String get permission_deleteSuccess => 'Permission deleted successfully';

  @override
  String get permission_deleteFailed => 'Failed to delete permission';

  @override
  String get permission_name => 'Permission Name';

  @override
  String get permission_codeAndNameRequired => 'Code and name are required';

  @override
  String get permission_createSuccess => 'Permission created successfully';

  @override
  String get permission_createFailed => 'Failed to create permission';

  @override
  String get permission_updateSuccess => 'Permission updated successfully';

  @override
  String get permission_updateFailed => 'Failed to update permission';

  @override
  String get group_title => 'Group Management';

  @override
  String get group_myGroups => 'My Groups';

  @override
  String get group_createGroup => 'Create Group';

  @override
  String get group_joinGroup => 'Join Group';

  @override
  String get group_groupName => 'Group Name';

  @override
  String get group_groupDescription => 'Description';

  @override
  String get group_groupColor => 'Group Color';

  @override
  String get group_defaultColor => 'Default Color';

  @override
  String get group_customColor => 'Custom Color';

  @override
  String get group_inviteCode => 'Invite Code';

  @override
  String get group_members => 'Members';

  @override
  String get group_pending => 'Pending';

  @override
  String get group_noPendingRequests => 'No pending join requests';

  @override
  String group_memberCount(int count) {
    return '$count members';
  }

  @override
  String get group_role => 'Role';

  @override
  String get group_owner => 'Owner';

  @override
  String get group_admin => 'Admin';

  @override
  String get group_member => 'Member';

  @override
  String get group_joinedAt => 'Joined';

  @override
  String get group_createdAt => 'Created';

  @override
  String get group_settings => 'Group Settings';

  @override
  String get group_editGroup => 'Edit Group';

  @override
  String get group_deleteGroup => 'Delete Group';

  @override
  String get group_leaveGroup => 'Leave Group';

  @override
  String get group_inviteMembers => 'Invite Members';

  @override
  String get group_manageMembers => 'Manage Members';

  @override
  String get group_regenerateCode => 'Regenerate Code';

  @override
  String get group_copyCode => 'Copy Code';

  @override
  String get group_enterInviteCode => 'Enter Invite Code';

  @override
  String get group_inviteByEmail => 'Invite by Email';

  @override
  String get group_email => 'Email';

  @override
  String get group_send => 'Send';

  @override
  String get group_join => 'Join';

  @override
  String get group_cancel => 'Cancel';

  @override
  String get group_save => 'Save';

  @override
  String get group_delete => 'Delete';

  @override
  String get group_leave => 'Leave';

  @override
  String get group_create => 'Create';

  @override
  String get group_edit => 'Edit';

  @override
  String get group_confirm => 'Confirm';

  @override
  String get group_accept => 'Accept';

  @override
  String get group_reject => 'Reject';

  @override
  String get group_requestedAt => 'Requested';

  @override
  String get group_invitedAt => 'Invited';

  @override
  String get group_acceptSuccess => 'Join request has been accepted';

  @override
  String get group_rejectSuccess => 'Join request has been rejected';

  @override
  String get group_rejectConfirmMessage =>
      'Are you sure you want to reject this join request?';

  @override
  String get group_groupNameRequired => 'Please enter group name';

  @override
  String get group_inviteCodeRequired => 'Please enter invite code';

  @override
  String get group_emailRequired => 'Please enter email';

  @override
  String get group_deleteConfirmTitle => 'Delete Group';

  @override
  String get group_deleteConfirmMessage =>
      'Are you sure you want to delete this group?\nAll data will be deleted and cannot be recovered.';

  @override
  String get group_leaveConfirmTitle => 'Leave Group';

  @override
  String get group_leaveConfirmMessage =>
      'Are you sure you want to leave this group?';

  @override
  String get group_ownerCannotLeave =>
      'Owner cannot leave the group.\nPlease transfer ownership or delete the group.';

  @override
  String get group_createSuccess => 'Group created successfully';

  @override
  String get group_joinSuccess => 'Joined group successfully';

  @override
  String get group_updateSuccess => 'Group updated successfully';

  @override
  String get group_deleteSuccess => 'Group deleted successfully';

  @override
  String get group_leaveSuccess => 'You have left the group';

  @override
  String get group_inviteSent => 'Invitation email sent';

  @override
  String get group_codeRegenerated => 'Invite code regenerated';

  @override
  String get group_codeCopied => 'Invite code copied';

  @override
  String get group_codeExpired => 'Invite code expired';

  @override
  String group_codeExpiresInDays(int count) {
    return 'Expires in $count days';
  }

  @override
  String group_codeExpiresInHours(int count) {
    return 'Expires in $count hours';
  }

  @override
  String group_codeExpiresInMinutes(int count) {
    return 'Expires in $count minutes';
  }

  @override
  String get group_noGroups => 'No groups yet';

  @override
  String get group_noGroupsDescription =>
      'Create a new group or\njoin one with an invite code';

  @override
  String get group_myJoinRequests => 'My Join Requests';

  @override
  String get group_noJoinRequests => 'No join requests found';

  @override
  String get group_joinRequestStatusAll => 'All';

  @override
  String get group_joinRequestStatusPending => 'Pending';

  @override
  String get group_joinRequestStatusDone => 'Done';

  @override
  String get group_joinRequestAccepted => 'Accepted';

  @override
  String get group_joinRequestRejected => 'Rejected';

  @override
  String get group_codeExpiredLabel => 'Invite code expired';

  @override
  String get group_defaultGroupTooltip => 'Default group';

  @override
  String get group_setDefaultGroupTooltip => 'Set as default group';

  @override
  String get group_unsetDefaultGroupTooltip => 'Unset default group';

  @override
  String group_setDefaultSuccess(String name) {
    return '\'$name\' set as default group';
  }

  @override
  String get group_unsetDefaultSuccess => 'Default group unset';

  @override
  String get group_myColorTitle => 'My Group Color';

  @override
  String get group_myColorNotSet => 'Not set (using group default color)';

  @override
  String get group_myColorSet => 'Set';

  @override
  String get group_myColorReset => 'Reset';

  @override
  String get group_dangerZone => 'Danger Zone';

  @override
  String get group_dangerZoneDesc =>
      'Deleting the group will permanently remove all data.';

  @override
  String get group_leaveTitle => 'Leave Group';

  @override
  String get group_leaveDesc =>
      'You will no longer have access to the group\'s data.';

  @override
  String group_leaveConfirmBody(String name) {
    return 'Are you sure you want to leave \"$name\"?\n\nYou will lose access to the group\'s data and will need an invite code to rejoin.';
  }

  @override
  String get group_leaveButton => 'Leave';

  @override
  String get group_roleManagementTitle => 'Role Management';

  @override
  String get group_roleManagementDesc => 'List of roles in this group.';

  @override
  String get group_roleEmpty => 'No roles';

  @override
  String get group_roleDefaultBadge => 'Default';

  @override
  String group_rolePermissionCount(int count) {
    return '$count permissions';
  }

  @override
  String get group_roleEdit => 'Edit Role';

  @override
  String get group_roleDelete => 'Delete Role';

  @override
  String get group_roleSortSaved => 'Sort order saved';

  @override
  String get group_roleLoadError => 'Unable to load roles';

  @override
  String get group_roleInfoTitle => 'Info';

  @override
  String get group_roleInfoBullet1 =>
      'Common roles (OWNER, ADMIN, MEMBER) are provided by default in all groups.';

  @override
  String get group_roleInfoBullet2 =>
      'Custom roles can only be created, edited, or deleted by the group OWNER.';

  @override
  String get group_roleInfoBullet3 =>
      'OWNER permission is required to manage roles.';

  @override
  String get group_roleCreateTitle => 'Create Role';

  @override
  String get group_roleEditTitle => 'Edit Role';

  @override
  String get group_roleDeleteTitle => 'Delete Role';

  @override
  String get group_roleNameLabel => 'Role name';

  @override
  String get group_roleNameRequired => 'Please enter a role name';

  @override
  String get group_roleDefaultSwitch => 'Default role';

  @override
  String get group_roleDefaultSwitchSub =>
      'Automatically assigned to new members';

  @override
  String get group_roleColorLabel => 'Role color';

  @override
  String get group_rolePermissionsLabel => 'Select permissions';

  @override
  String get group_rolePermissionsViewLabel => 'Permissions';

  @override
  String get group_rolePermissionNone => 'No permissions';

  @override
  String get group_roleDefaultLabel =>
      'Default role (automatically assigned to new members)';

  @override
  String group_roleDeleteConfirm(String name) {
    return 'Delete the role \"$name\"?';
  }

  @override
  String get group_roleDeleteWarning =>
      '⚠️ Roles assigned to members cannot be deleted.';

  @override
  String get group_roleCreateSuccess => 'Role created';

  @override
  String group_roleCreateFail(String error) {
    return 'Failed to create role: $error';
  }

  @override
  String get group_roleEditSuccess => 'Role updated';

  @override
  String group_roleEditFail(String error) {
    return 'Failed to update role: $error';
  }

  @override
  String get group_roleDeleteSuccess => 'Role deleted';

  @override
  String group_roleDeleteFail(String error) {
    return 'Failed to delete role: $error';
  }

  @override
  String get group_settings_groupManagementTitle => 'Group Management';

  @override
  String get error_network => 'Please check your network connection';

  @override
  String get error_server => 'Server error occurred';

  @override
  String get error_unknown => 'An unknown error occurred';

  @override
  String get common_comingSoon => 'Coming Soon';

  @override
  String get common_logoutFailed => 'Logout Failed';

  @override
  String get announcement_title => 'Announcements';

  @override
  String get announcement_list => 'Announcement List';

  @override
  String get announcement_detail => 'Announcement Detail';

  @override
  String get announcement_create => 'Create Announcement';

  @override
  String get announcement_edit => 'Edit Announcement';

  @override
  String get announcement_delete => 'Delete Announcement';

  @override
  String get announcement_pin => 'Pin to Top';

  @override
  String get announcement_unpin => 'Unpin';

  @override
  String get announcement_pinned => 'Pinned';

  @override
  String get announcement_pinDescription =>
      'Pin important announcements to the top of the list';

  @override
  String get announcement_category => 'Category';

  @override
  String get announcement_category_none => 'No Category';

  @override
  String get announcement_category_announcement => 'Announcement';

  @override
  String get announcement_category_event => 'Event';

  @override
  String get announcement_category_update => 'Update';

  @override
  String get announcement_content => 'Content';

  @override
  String get announcement_author => 'Author';

  @override
  String get announcement_createdAt => 'Created';

  @override
  String get announcement_updatedAt => 'Updated';

  @override
  String announcement_readCount(int count) {
    return '$count read';
  }

  @override
  String get announcement_createSuccess => 'Announcement created';

  @override
  String get announcement_createError => 'Failed to create announcement';

  @override
  String get announcement_updateSuccess => 'Announcement updated';

  @override
  String get announcement_updateError => 'Failed to update announcement';

  @override
  String get announcement_deleteSuccess => 'Announcement deleted';

  @override
  String get announcement_deleteError => 'Failed to delete announcement';

  @override
  String get announcement_deleteDialogTitle => 'Delete Announcement';

  @override
  String get announcement_deleteDialogMessage =>
      'Are you sure you want to delete this announcement?\nThis cannot be undone.';

  @override
  String get announcement_pinSuccess => 'Announcement pinned';

  @override
  String get announcement_unpinSuccess => 'Announcement unpinned';

  @override
  String get announcement_deleteConfirm =>
      'Delete this announcement?\nThis cannot be undone.';

  @override
  String get announcement_loadError => 'Failed to load announcement';

  @override
  String get announcement_empty => 'No announcements yet';

  @override
  String get announcement_titleHint => 'Enter announcement title';

  @override
  String get announcement_contentHint => 'Enter announcement content';

  @override
  String get announcement_categoryHint => 'Select category (optional)';

  @override
  String get announcement_titleRequired => 'Please enter a title';

  @override
  String get announcement_titleMinLength =>
      'Title must be at least 3 characters';

  @override
  String get announcement_contentRequired => 'Please enter content';

  @override
  String get announcement_contentMinLength =>
      'Content must be at least 10 characters';

  @override
  String get announcement_attachmentComingSoon =>
      'File attachment feature coming soon';

  @override
  String get qna_title => 'Q&A';

  @override
  String get qna_publicQuestions => 'Public Q&A';

  @override
  String get qna_myQuestions => 'My Questions';

  @override
  String get qna_askQuestion => 'Ask Question';

  @override
  String get qna_question => 'Question';

  @override
  String get qna_answer => 'Answer';

  @override
  String get qna_category => 'Category';

  @override
  String get qna_categoryFilter => 'Category Filter';

  @override
  String get qna_categoryAll => 'All';

  @override
  String get qna_categoryNone => 'No Category';

  @override
  String get qna_status => 'Status';

  @override
  String get qna_statusAll => 'All';

  @override
  String get qna_statusPending => 'Pending';

  @override
  String get qna_statusAnswered => 'Answered';

  @override
  String get qna_statusResolved => 'Resolved';

  @override
  String get qna_search => 'Search Questions';

  @override
  String get qna_searchHint => 'Search for questions';

  @override
  String get qna_questionTitle => 'Question Title';

  @override
  String get qna_questionTitleHint => 'Enter question title';

  @override
  String get qna_questionContent => 'Question Content';

  @override
  String get qna_questionContentHint => 'Enter your question';

  @override
  String get qna_answerContent => 'Answer Content';

  @override
  String get qna_answerContentHint => 'Enter your answer';

  @override
  String get qna_isPublic => 'Visibility';

  @override
  String get qna_publicQuestion => 'Public Question';

  @override
  String get qna_privateQuestion => 'Private Question';

  @override
  String get qna_author => 'Author';

  @override
  String get qna_answerer => 'Answered by';

  @override
  String get qna_createdAt => 'Created';

  @override
  String get qna_answeredAt => 'Answered';

  @override
  String qna_viewCount(int count) {
    return '$count views';
  }

  @override
  String qna_answerCount(int count) {
    return '$count answers';
  }

  @override
  String get qna_empty => 'No questions yet';

  @override
  String get qna_noAnswer => 'No answer yet';

  @override
  String get qna_loadError => 'Failed to load questions';

  @override
  String get qna_createSuccess => 'Question created';

  @override
  String get qna_createError => 'Failed to create question';

  @override
  String get qna_updateSuccess => 'Question updated';

  @override
  String get qna_updateError => 'Failed to update question';

  @override
  String get qna_deleteSuccess => 'Question deleted';

  @override
  String get qna_deleteError => 'Failed to delete question';

  @override
  String get qna_deleteDialogTitle => 'Delete Question';

  @override
  String get qna_deleteDialogMessage =>
      'Are you sure you want to delete this question?\nThis cannot be undone.';

  @override
  String get qna_answerSuccess => 'Answer posted';

  @override
  String get qna_answerError => 'Failed to post answer';

  @override
  String get qna_answerUpdateSuccess => 'Answer updated';

  @override
  String get qna_answerUpdateError => 'Failed to update answer';

  @override
  String get qna_answerDeleteSuccess => 'Answer deleted';

  @override
  String get qna_answerDeleteError => 'Failed to delete answer';

  @override
  String get qna_markResolved => 'Mark as Resolved';

  @override
  String get qna_markUnresolved => 'Mark as Unresolved';

  @override
  String get qna_resolveSuccess => 'Question marked as resolved';

  @override
  String get qna_resolveError => 'Failed to change status';

  @override
  String get qna_titleRequired => 'Please enter a title';

  @override
  String get qna_titleMinLength => 'Title must be at least 3 characters';

  @override
  String get qna_contentRequired => 'Please enter content';

  @override
  String get qna_contentMinLength => 'Content must be at least 10 characters';

  @override
  String get qna_answerRequired => 'Please enter an answer';

  @override
  String get schedule_today => 'Today';

  @override
  String get schedule_add => 'Add Schedule';

  @override
  String get schedule_edit => 'Edit Schedule';

  @override
  String get schedule_delete => 'Delete Schedule';

  @override
  String get schedule_detail => 'Schedule Details';

  @override
  String get schedule_allDay => 'All Day';

  @override
  String get schedule_loadError => 'Failed to load schedules';

  @override
  String get schedule_empty => 'No schedules';

  @override
  String get schedule_createSuccess => 'Schedule created';

  @override
  String get schedule_createError => 'Failed to create schedule';

  @override
  String get schedule_updateSuccess => 'Schedule updated';

  @override
  String get schedule_updateError => 'Failed to update schedule';

  @override
  String get schedule_deleteSuccess => 'Schedule deleted';

  @override
  String get schedule_deleteError => 'Failed to delete schedule';

  @override
  String get schedule_deleteDialogTitle => 'Delete Schedule';

  @override
  String get schedule_deleteDialogMessage =>
      'Are you sure you want to delete this schedule?';

  @override
  String get schedule_title => 'Title';

  @override
  String get schedule_titleHint => 'Enter schedule title';

  @override
  String get schedule_titleRequired => 'Please enter a title';

  @override
  String get schedule_description => 'Description';

  @override
  String get schedule_descriptionHint => 'Enter description (optional)';

  @override
  String get schedule_location => 'Location';

  @override
  String get schedule_locationHint => 'Enter location (optional)';

  @override
  String get schedule_startDate => 'Start Date';

  @override
  String get schedule_endDate => 'End Date';

  @override
  String get schedule_startTime => 'Start Time';

  @override
  String get schedule_endTime => 'End Time';

  @override
  String get schedule_dueDate => 'Set Due Date';

  @override
  String get schedule_dueDateSelect => 'Due Date';

  @override
  String get schedule_dueTime => 'Due Time';

  @override
  String get schedule_color => 'Color';

  @override
  String get schedule_share => 'Sharing';

  @override
  String get schedule_sharePrivate => 'Private';

  @override
  String get schedule_shareGroup => 'Specific Group';

  @override
  String get schedule_reminder => 'Reminder';

  @override
  String get schedule_reminderNone => 'None';

  @override
  String get schedule_reminderAtTime => 'At time';

  @override
  String get schedule_reminder5Min => '5 minutes before';

  @override
  String get schedule_reminder15Min => '15 minutes before';

  @override
  String get schedule_reminder30Min => '30 minutes before';

  @override
  String get schedule_reminder1Hour => '1 hour before';

  @override
  String get schedule_reminder1Day => '1 day before';

  @override
  String get schedule_recurrence => 'Repeat';

  @override
  String get schedule_recurrenceNone => 'No repeat';

  @override
  String get schedule_recurrenceDaily => 'Daily';

  @override
  String get schedule_recurrenceWeekly => 'Weekly';

  @override
  String get schedule_recurrenceMonthly => 'Monthly';

  @override
  String get schedule_recurrenceYearly => 'Yearly';

  @override
  String get schedule_personal => 'Personal';

  @override
  String get schedule_group => 'Group';

  @override
  String get schedule_taskType => 'Schedule Type';

  @override
  String get schedule_taskTypeCalendarOnly => 'Calendar Only';

  @override
  String get schedule_taskTypeCalendarOnlyDesc => 'Shown only on calendar';

  @override
  String get schedule_taskTypeTodoLinked => 'Todo Linked';

  @override
  String get schedule_taskTypeTodoLinkedDesc =>
      'Shown on both calendar and todo list';

  @override
  String get schedule_taskTypeTodoOnly => 'Todo Only';

  @override
  String get schedule_taskTypeTodoOnlyDesc =>
      'Show in todo list only (not in calendar)';

  @override
  String get schedule_priority => 'Priority';

  @override
  String get schedule_priorityLow => 'Low';

  @override
  String get schedule_priorityMedium => 'Medium';

  @override
  String get schedule_priorityHigh => 'High';

  @override
  String get schedule_priorityUrgent => 'Urgent';

  @override
  String get schedule_participants => 'Participants';

  @override
  String get schedule_participantsHint =>
      'Select group members to participate in this schedule';

  @override
  String get schedule_noMembers => 'No group members';

  @override
  String get schedule_participantsLoadError => 'Failed to load members';

  @override
  String get schedule_participantsSelectAll => 'Select All';

  @override
  String get schedule_participantsDeselectAll => 'Deselect All';

  @override
  String get schedule_reminderCustom => 'Custom';

  @override
  String get schedule_reminderCustomTitle => 'Set Reminder Time';

  @override
  String get schedule_reminderCustomHint =>
      'Set when to be reminded before the event';

  @override
  String get schedule_reminderDays => 'Days';

  @override
  String get schedule_reminderHours => 'Hours';

  @override
  String get schedule_reminderMinutes => 'Min';

  @override
  String schedule_reminderMinutesBefore(int minutes) {
    return '$minutes min before';
  }

  @override
  String schedule_reminderHoursBefore(int hours) {
    return '$hours hour(s) before';
  }

  @override
  String schedule_reminderHoursMinutesBefore(int hours, int minutes) {
    return '${hours}h ${minutes}m before';
  }

  @override
  String schedule_reminderDaysBefore(int days) {
    return '$days day(s) before';
  }

  @override
  String schedule_reminderDaysHoursBefore(int days, int hours) {
    return '${days}d ${hours}h before';
  }

  @override
  String get category_management => 'Manage Categories';

  @override
  String get category_add => 'Add Category';

  @override
  String get category_edit => 'Edit Category';

  @override
  String get category_empty => 'No categories';

  @override
  String get category_emptyHint => 'Add categories to organize your schedules';

  @override
  String get category_loadError => 'Failed to load categories';

  @override
  String get category_name => 'Category Name';

  @override
  String get category_nameHint => 'e.g., Work, Personal, Family';

  @override
  String get category_nameRequired => 'Please enter a category name';

  @override
  String get category_description => 'Description';

  @override
  String get category_descriptionHint =>
      'Description of the category (optional)';

  @override
  String get category_emoji => 'Emoji';

  @override
  String get category_color => 'Color';

  @override
  String get category_createSuccess => 'Category created';

  @override
  String get category_createError => 'Failed to create category';

  @override
  String get category_updateSuccess => 'Category updated';

  @override
  String get category_updateError => 'Failed to update category';

  @override
  String get category_deleteSuccess => 'Category deleted';

  @override
  String get category_deleteError => 'Failed to delete category';

  @override
  String get category_deleteDialogTitle => 'Delete Category';

  @override
  String get category_deleteDialogMessage =>
      'Are you sure you want to delete this category?\nCategories with linked schedules cannot be deleted.';

  @override
  String get schedule_recurringEvery => 'Every';

  @override
  String get schedule_recurringIntervalDay => 'day(s)';

  @override
  String get schedule_recurringIntervalWeek => 'week(s)';

  @override
  String get schedule_recurringIntervalMonth => 'month(s)';

  @override
  String get schedule_recurringIntervalYear => 'year(s)';

  @override
  String get schedule_recurringDaysOfWeek => 'Repeat on';

  @override
  String get schedule_daySun => 'Sun';

  @override
  String get schedule_dayMon => 'Mon';

  @override
  String get schedule_dayTue => 'Tue';

  @override
  String get schedule_dayWed => 'Wed';

  @override
  String get schedule_dayThu => 'Thu';

  @override
  String get schedule_dayFri => 'Fri';

  @override
  String get schedule_daySat => 'Sat';

  @override
  String get schedule_daySunday => 'Sunday';

  @override
  String get schedule_dayMonday => 'Monday';

  @override
  String get schedule_dayTuesday => 'Tuesday';

  @override
  String get schedule_dayWednesday => 'Wednesday';

  @override
  String get schedule_dayThursday => 'Thursday';

  @override
  String get schedule_dayFriday => 'Friday';

  @override
  String get schedule_daySaturday => 'Saturday';

  @override
  String get schedule_recurringMonthlyType => 'Monthly repeat type';

  @override
  String get schedule_recurringMonthlyDayOfMonth => 'Day of month';

  @override
  String get schedule_recurringMonthlyWeekOfMonth => 'Day of week';

  @override
  String get schedule_recurringMonthlyEveryMonth => 'Every month on';

  @override
  String get schedule_recurringDay => '';

  @override
  String get schedule_recurringWeek1 => 'First';

  @override
  String get schedule_recurringWeek2 => 'Second';

  @override
  String get schedule_recurringWeek3 => 'Third';

  @override
  String get schedule_recurringWeek4 => 'Fourth';

  @override
  String get schedule_recurringWeekLast => 'Last';

  @override
  String get schedule_recurringYearlyType => 'Yearly repeat type';

  @override
  String get schedule_recurringYearlyDayOfMonth => 'Day of month';

  @override
  String get schedule_recurringYearlyWeekOfMonth => 'Day of week';

  @override
  String get schedule_recurringYearlyEveryYear => 'Every year on';

  @override
  String get schedule_month1 => 'January';

  @override
  String get schedule_month2 => 'February';

  @override
  String get schedule_month3 => 'March';

  @override
  String get schedule_month4 => 'April';

  @override
  String get schedule_month5 => 'May';

  @override
  String get schedule_month6 => 'June';

  @override
  String get schedule_month7 => 'July';

  @override
  String get schedule_month8 => 'August';

  @override
  String get schedule_month9 => 'September';

  @override
  String get schedule_month10 => 'October';

  @override
  String get schedule_month11 => 'November';

  @override
  String get schedule_month12 => 'December';

  @override
  String get schedule_recurringEndCondition => 'End condition';

  @override
  String get schedule_recurringEndNever => 'Never';

  @override
  String get schedule_recurringEndDate => 'Until date';

  @override
  String get schedule_recurringEndCount => 'After count';

  @override
  String get schedule_recurringCountTimes => 'times';

  @override
  String get schedule_searchHint => 'Search by title, description, location';

  @override
  String get schedule_searchNoResults => 'No search results';

  @override
  String schedule_searchResultCount(int count) {
    return '$count results found';
  }

  @override
  String get todo_add => 'Add Todo';

  @override
  String get todo_edit => 'Edit Todo';

  @override
  String get todo_delete => 'Delete Todo';

  @override
  String get todo_detail => 'Todo Detail';

  @override
  String get todo_showCompleted => 'Show Completed';

  @override
  String get todo_priority => 'Priority';

  @override
  String get todo_priorityLow => 'Low';

  @override
  String get todo_priorityMedium => 'Medium';

  @override
  String get todo_priorityHigh => 'High';

  @override
  String get todo_priorityUrgent => 'Urgent';

  @override
  String get todo_noTodos => 'No todos registered';

  @override
  String get todo_allCompleted => 'All todos completed!';

  @override
  String get todo_loadError => 'Failed to load todos';

  @override
  String get todo_noDueDate => 'No due date';

  @override
  String get todo_viewKanban => 'Kanban Board';

  @override
  String get todo_viewList => 'List View';

  @override
  String get todo_statusPending => 'Pending';

  @override
  String get todo_statusInProgress => 'In Progress';

  @override
  String get todo_statusCompleted => 'Completed';

  @override
  String get todo_statusHold => 'Hold';

  @override
  String get todo_statusDrop => 'Drop';

  @override
  String get todo_statusFailed => 'Failed';

  @override
  String get todo_prevWeek => 'Previous week';

  @override
  String get todo_nextWeek => 'Next week';

  @override
  String get todo_changeStatus => 'Change status';

  @override
  String get todo_viewByDate => 'By Date';

  @override
  String get todo_viewOverview => 'Overview';

  @override
  String get todo_overviewOverdue => 'Overdue';

  @override
  String get todo_overviewToday => 'Today';

  @override
  String get todo_overviewTomorrow => 'Tomorrow';

  @override
  String get todo_overviewThisWeek => 'This Week';

  @override
  String get todo_overviewNextWeek => 'Next Week';

  @override
  String get todo_overviewLater => 'Later';

  @override
  String get todo_overviewNoDueDate => 'No Due Date';

  @override
  String get todo_filter => 'Filter';

  @override
  String get todo_filterAll => 'All';

  @override
  String get todo_filterStatus => 'Status';

  @override
  String get todo_filterPriority => 'Priority';

  @override
  String get todo_sortBy => 'Sort';

  @override
  String get todo_sortByStatus => 'By Status';

  @override
  String get todo_sortByPriority => 'By Priority';

  @override
  String get todo_sortByDueDate => 'By Due Date';

  @override
  String get todo_sortByCreatedAt => 'By Created';

  @override
  String get todo_filterApplied => 'Filter applied';

  @override
  String get todo_clearFilter => 'Clear filter';

  @override
  String get todo_filterTooltip => 'Task filter';

  @override
  String get todo_widgetTitleToday => 'Today\'s Tasks';

  @override
  String get todo_widgetTitleWeek => 'This Week\'s Tasks';

  @override
  String get todo_widgetTitleMonth => 'This Month\'s Tasks';

  @override
  String get todo_emptyToday => 'No tasks for today';

  @override
  String get todo_emptyWeek => 'No tasks this week';

  @override
  String get todo_emptyMonth => 'No tasks this month';

  @override
  String get todo_searchHint => 'Search by title, description';

  @override
  String get todo_searchNoResults => 'No search results';

  @override
  String todo_searchResultCount(int count) {
    return '$count results found';
  }

  @override
  String get memo_title => 'Memo';

  @override
  String get memo_list => 'Memo List';

  @override
  String get memo_detail => 'Memo Detail';

  @override
  String get memo_create => 'Create Memo';

  @override
  String get memo_edit => 'Edit Memo';

  @override
  String get memo_delete => 'Delete Memo';

  @override
  String get memo_content => 'Content';

  @override
  String get memo_category => 'Category';

  @override
  String get memo_categoryHint => 'Enter category (optional)';

  @override
  String get memo_tags => 'Tags';

  @override
  String get memo_tagsHint => 'Add tags';

  @override
  String get memo_author => 'Author';

  @override
  String get memo_createdAt => 'Created';

  @override
  String get memo_updatedAt => 'Updated';

  @override
  String get memo_createSuccess => 'Memo created';

  @override
  String get memo_createError => 'Failed to create memo';

  @override
  String get memo_updateSuccess => 'Memo updated';

  @override
  String get memo_updateError => 'Failed to update memo';

  @override
  String get memo_deleteSuccess => 'Memo deleted';

  @override
  String get memo_deleteError => 'Failed to delete memo';

  @override
  String get memo_deleteDialogTitle => 'Delete Memo';

  @override
  String get memo_deleteDialogMessage =>
      'Are you sure you want to delete this memo?\nThis cannot be undone.';

  @override
  String get memo_loadError => 'Failed to load memo';

  @override
  String get memo_empty => 'No memos yet';

  @override
  String get memo_titleHint => 'Enter memo title';

  @override
  String get memo_contentHint => 'Enter memo content';

  @override
  String get memo_titleRequired => 'Please enter a title';

  @override
  String get memo_titleMinLength => 'Title must be at least 2 characters';

  @override
  String get memo_contentRequired => 'Please enter content';

  @override
  String get memo_searchHint => 'Search by title, content';

  @override
  String get memo_searchNoResults => 'No search results';

  @override
  String get memo_tagAdd => 'Add Tag';

  @override
  String get memo_tagName => 'Tag Name';

  @override
  String get memo_tagNameHint => 'Enter tag name';

  @override
  String get memo_visibility => 'Visibility';

  @override
  String get memo_visibilityPrivate => 'Only Me';

  @override
  String get memo_visibilityGroup => 'Specific Group';

  @override
  String get memo_groupSelect => 'Select Group';

  @override
  String get memo_typeNote => 'Note';

  @override
  String get memo_typeChecklist => 'Checklist';

  @override
  String get memo_typeSelect => 'Memo Type';

  @override
  String get memo_checklist => 'Checklist';

  @override
  String get memo_checklistAdd => 'Add Item';

  @override
  String get memo_checklistAddHint => 'Enter new item';

  @override
  String get memo_checklistEmpty => 'No checklist items';

  @override
  String get memo_checklistReset => 'Uncheck All';

  @override
  String get memo_checklistSelectAll => 'Select All';

  @override
  String get memo_checklistDeleteItem => 'Delete Item';

  @override
  String get memo_checklistEditItem => 'Edit Item';

  @override
  String memo_checklistProgress(int checked, int total) {
    return '$checked/$total done';
  }

  @override
  String get household_title => 'Household';

  @override
  String get household_expense => 'Expense';

  @override
  String get household_no_group_selected => 'Please select a group';

  @override
  String get household_personal_mode => 'Personal';

  @override
  String get household_add_expense => 'Add Expense';

  @override
  String get household_view_shopping_history => 'View Shopping History';

  @override
  String get household_edit_expense => 'Edit Expense';

  @override
  String get household_delete_expense => 'Delete Expense';

  @override
  String get household_delete_confirm =>
      'Are you sure you want to delete this expense?';

  @override
  String get household_amount => 'Amount';

  @override
  String get household_category => 'Category';

  @override
  String get household_payment_method => 'Payment Method';

  @override
  String get household_description => 'Description';

  @override
  String get household_date => 'Date';

  @override
  String get household_recurring => 'Fixed Expense';

  @override
  String get household_total_income => 'Total Income';

  @override
  String get household_total_expense => 'Total Expense';

  @override
  String get household_balance => 'Balance';

  @override
  String get household_income => 'Income';

  @override
  String get household_type => 'Type';

  @override
  String get household_total_budget => 'Total Budget';

  @override
  String get household_statistics => 'Statistics';

  @override
  String get household_monthly_statistics => 'Monthly Statistics';

  @override
  String get household_no_expenses => 'No expenses found';

  @override
  String get household_category_food => 'Food';

  @override
  String get household_category_transport => 'Transport';

  @override
  String get household_category_leisure => 'Leisure';

  @override
  String get household_category_living => 'Living';

  @override
  String get household_category_health => 'Health';

  @override
  String get household_category_education => 'Education';

  @override
  String get household_category_clothing => 'Clothing';

  @override
  String get household_category_allowance => 'Allowance';

  @override
  String get household_category_celebration => 'Celebration';

  @override
  String get household_category_asset_transfer => 'Asset Transfer';

  @override
  String get household_category_childcare => 'Childcare';

  @override
  String get household_category_communication => 'Communication';

  @override
  String get household_category_groceries => 'Groceries';

  @override
  String get household_category_other => 'Other';

  @override
  String get household_payment_cash => 'Cash';

  @override
  String get household_payment_card => 'Card';

  @override
  String get household_payment_transfer => 'Transfer';

  @override
  String get household_payment_other => 'Other';

  @override
  String get household_budget_settings => 'Budget Settings';

  @override
  String get household_budget_amount => 'Budget Amount';

  @override
  String get household_set_budget => 'Set Budget';

  @override
  String get household_amount_hint => 'Enter amount';

  @override
  String get household_description_hint => 'Enter description';

  @override
  String get household_amount_required => 'Amount is required';

  @override
  String get household_save_success => 'Saved successfully';

  @override
  String get household_delete_success => 'Deleted successfully';

  @override
  String get household_budget_saved => 'Budget has been set';

  @override
  String get household_recurring_expenses => 'Fixed Expenses';

  @override
  String get household_recurring_no_expenses => 'No fixed expenses';

  @override
  String get household_budget_set => 'Budget Settings';

  @override
  String get household_budget_total_label => 'Total Budget';

  @override
  String get household_budget_category_label => 'Budget by Category';

  @override
  String get household_budget_not_set => 'Not set';

  @override
  String get household_budget_tab_monthly => 'This Month';

  @override
  String get household_budget_tab_template => 'Auto Monthly';

  @override
  String get household_budget_template_info =>
      'Budget is automatically set on the 1st of each month based on the template. Existing budgets for that month will be skipped.';

  @override
  String get household_budget_template_saved =>
      'Auto budget template has been saved';

  @override
  String get household_budget_template_delete_title => 'Delete Template';

  @override
  String get household_budget_template_delete_confirm =>
      'Are you sure you want to delete the auto budget template for this category?';

  @override
  String get household_budget_template_deleted =>
      'Auto budget template has been deleted';

  @override
  String household_budget_category_sum_exceeds(String sum, String total) {
    return 'Category budget total (₩$sum) exceeds the overall budget (₩$total)';
  }

  @override
  String household_budget_category_sum(String amount) {
    return 'Total ₩$amount';
  }

  @override
  String get asset_title => 'Assets';

  @override
  String get asset_statistics => 'Statistics';

  @override
  String get asset_no_group_selected => 'Please select a group';

  @override
  String get asset_no_accounts => 'No accounts registered';

  @override
  String get asset_total_balance => 'Total Balance';

  @override
  String get asset_total_principal => 'Total Principal';

  @override
  String get asset_total_profit => 'Total Profit';

  @override
  String get asset_profit_rate => 'Return Rate';

  @override
  String get asset_account_name => 'Account Name';

  @override
  String get asset_account_name_hint => 'e.g., Main Savings';

  @override
  String get asset_account_name_required => 'Please enter account name';

  @override
  String get asset_institution => 'Institution';

  @override
  String get asset_institution_hint => 'e.g., Kookmin Bank';

  @override
  String get asset_institution_required => 'Please enter institution name';

  @override
  String get asset_account_number => 'Account Number (Optional)';

  @override
  String get asset_account_number_hint => 'e.g., 123-456-789';

  @override
  String get asset_account_type => 'Account Type';

  @override
  String get asset_type_savings => 'Savings';

  @override
  String get asset_type_deposit => 'Deposit';

  @override
  String get asset_type_stock => 'Stock';

  @override
  String get asset_type_fund => 'Fund';

  @override
  String get asset_type_real_estate => 'Real Estate';

  @override
  String get asset_type_gold => 'Physical Gold';

  @override
  String get asset_type_other => 'Other';

  @override
  String get asset_gold_gram_weight => 'Weight';

  @override
  String get asset_gold_gram_weight_hint => 'e.g. 37.5';

  @override
  String get asset_gold_unit_gram => 'g (gram)';

  @override
  String get asset_gold_unit_don => 'don';

  @override
  String get asset_gold_don_hint => 'e.g. 10';

  @override
  String get asset_gold_gram_converted => 'g equiv.';

  @override
  String get asset_gold_estimated_principal => 'Est. Principal';

  @override
  String get asset_gold_gram_weight_required => 'Please enter the weight';

  @override
  String get asset_gold_gram_weight_invalid => 'Please enter a valid number';

  @override
  String get asset_gold_current_price_label => 'Current Gold Price';

  @override
  String get asset_gold_price_loading => 'Fetching gold price…';

  @override
  String get asset_gold_price_error => 'Unable to load gold price';

  @override
  String get asset_add_account => 'Add Account';

  @override
  String get asset_edit_account => 'Edit Account';

  @override
  String get asset_delete_account => 'Delete Account';

  @override
  String get asset_delete_account_confirm =>
      'Are you sure you want to delete this account?\nAll related records will also be deleted.';

  @override
  String get asset_delete_success => 'Deleted successfully';

  @override
  String get asset_save_success => 'Saved successfully';

  @override
  String get asset_account_detail => 'Account Detail';

  @override
  String get asset_records => 'Records';

  @override
  String get asset_holdings => 'Portfolio Allocation';

  @override
  String get asset_holdings_empty => 'No holdings registered';

  @override
  String get asset_holding_add => 'Add Holding';

  @override
  String get asset_holding_edit => 'Edit Holding';

  @override
  String get asset_holding_delete => 'Delete Holding';

  @override
  String get asset_holding_name => 'Name';

  @override
  String get asset_holding_name_hint => 'e.g. NASDAQ ETF';

  @override
  String get asset_holding_name_required => 'Please enter a name';

  @override
  String get asset_holding_ticker => 'Ticker (optional)';

  @override
  String get asset_holding_ticker_hint => 'e.g. QQQ';

  @override
  String get asset_holding_ratio => 'Ratio (%)';

  @override
  String get asset_holding_ratio_hint => 'e.g. 40';

  @override
  String get asset_holding_ratio_required => 'Please enter a ratio';

  @override
  String get asset_holding_ratio_invalid =>
      'Enter a number between 0.01 and 100';

  @override
  String get asset_holding_ratio_exceeded => 'Total ratio exceeds 100%';

  @override
  String get asset_holding_delete_confirm => 'Delete this holding?';

  @override
  String get asset_holding_total_ratio => 'Total';

  @override
  String get asset_gold_record_info_title => 'About Gold Account';

  @override
  String get asset_gold_record_info_body =>
      'This is a physical gold account managed automatically:\n\n• When you add a record, the balance is calculated as weight × current GOLD_KRW_SPOT price.\n\n• On the 1st of every month, the balance, profit, and profit rate are automatically updated using the latest gold spot price.\n\n• You can manually adjust the principal; otherwise, the value calculated at the first record is retained.';

  @override
  String get asset_no_records => 'No records yet';

  @override
  String get asset_add_record => 'Add Record';

  @override
  String get asset_record_date => 'Record Date';

  @override
  String get asset_balance => 'Balance';

  @override
  String get asset_principal => 'Principal';

  @override
  String get asset_profit => 'Profit';

  @override
  String get asset_note => 'Note (Optional)';

  @override
  String get asset_note_hint => 'e.g., Interest received';

  @override
  String get asset_amount_hint => 'Enter amount';

  @override
  String get asset_amount_required => 'Please enter amount';

  @override
  String get asset_record_date_required => 'Please select record date';

  @override
  String get asset_record_save_success => 'Record saved';

  @override
  String get asset_statistics_title => 'Asset Statistics';

  @override
  String get asset_by_type => 'By Type';

  @override
  String asset_account_count(int count) {
    return '$count accounts';
  }

  @override
  String get asset_savings_total => 'Savings Total';

  @override
  String get asset_savings_goals => 'Linked Savings';

  @override
  String get asset_trend => 'Asset Trend';

  @override
  String get asset_trend_monthly => 'Monthly';

  @override
  String get asset_trend_yearly => 'Yearly';

  @override
  String get asset_trend_balance => 'Balance';

  @override
  String get asset_trend_profit_rate => 'Cumulative Return';

  @override
  String get asset_trend_period_return => 'Period Return';

  @override
  String get asset_trend_no_data => 'No data available';

  @override
  String asset_trend_year_label(String year) {
    return '$year';
  }

  @override
  String get asset_input_mode => 'Input Mode';

  @override
  String get asset_input_mode_manual => 'Manual';

  @override
  String get asset_input_mode_auto => 'Auto Calculate';

  @override
  String get asset_additional_principal => 'Additional Principal';

  @override
  String get asset_additional_principal_hint =>
      'Enter the full initial principal for the first record';

  @override
  String get asset_current_balance => 'Current Balance';

  @override
  String get asset_duplicate_date_error =>
      'A record already exists for this date';

  @override
  String get asset_delete_record => 'Delete Record';

  @override
  String get asset_delete_record_confirm =>
      'Are you sure you want to delete this record?';

  @override
  String get asset_stat_account_filter => 'Account Filter';

  @override
  String get asset_stat_filter_all => 'All';

  @override
  String get asset_trend_principal => 'Principal';

  @override
  String get asset_trend_profit => 'Profit';

  @override
  String get childcare_title => 'Child Points';

  @override
  String get childcare_accounts => 'Child Accounts';

  @override
  String get childcare_add_account => 'Add Account';

  @override
  String get childcare_balance => 'Points Balance';

  @override
  String get childcare_monthly_allowance => 'Monthly Allowance';

  @override
  String get childcare_savings_balance => 'Savings Balance';

  @override
  String get childcare_savings_interest_rate => 'Interest Rate';

  @override
  String get childcare_tab_points => 'Points';

  @override
  String get childcare_tab_rewards => 'Shop';

  @override
  String get childcare_tab_rules => 'Rules';

  @override
  String get childcare_tab_history => 'History';

  @override
  String get childcare_add_transaction => 'Give/Deduct Points';

  @override
  String get childcare_add_reward => 'Add Reward';

  @override
  String get childcare_add_rule => 'Add Rule';

  @override
  String get childcare_transaction_type_earn => 'Earn Points';

  @override
  String get childcare_transaction_type_spend => 'Spend Points';

  @override
  String get childcare_transaction_type_penalty => 'Rule Penalty';

  @override
  String get childcare_transaction_type_monthly => 'Monthly Allowance';

  @override
  String get childcare_transaction_type_savings_deposit => 'Savings Deposit';

  @override
  String get childcare_transaction_type_savings_withdraw => 'Savings Withdraw';

  @override
  String get childcare_transaction_type_interest => 'Interest Payment';

  @override
  String childcare_reward_points_cost(int points) {
    return '$points pts';
  }

  @override
  String childcare_rule_penalty(int penalty) {
    return '-$penalty pts';
  }

  @override
  String get childcare_savings_deposit => 'Deposit';

  @override
  String get childcare_savings_withdraw => 'Withdraw';

  @override
  String get childcare_empty_accounts =>
      'No child accounts.\nAdd an account to get started.';

  @override
  String get childcare_empty_transactions => 'No transactions yet.';

  @override
  String get childcare_empty_rewards =>
      'No rewards yet.\nAdd a reward for your child.';

  @override
  String get childcare_empty_rules =>
      'No rules yet.\nAdd rules to manage behavior.';

  @override
  String get childcare_account_child_id => 'Child User ID';

  @override
  String get childcare_account_monthly_allowance => 'Monthly Allowance (pts)';

  @override
  String get childcare_account_savings_rate => 'Savings Interest Rate (%)';

  @override
  String get childcare_transaction_amount => 'Amount';

  @override
  String get childcare_transaction_description => 'Description';

  @override
  String get childcare_transaction_type => 'Transaction Type';

  @override
  String get childcare_reward_name => 'Reward Name';

  @override
  String get childcare_reward_description => 'Description (optional)';

  @override
  String get childcare_reward_points => 'Points Cost';

  @override
  String get childcare_rule_name => 'Rule Name';

  @override
  String get childcare_rule_description => 'Description (optional)';

  @override
  String get childcare_rule_penalty_points => 'Penalty Points';

  @override
  String get childcare_savings_amount => 'Amount';

  @override
  String get childcare_delete_confirm => 'Are you sure you want to delete?';

  @override
  String get childcare_select_group => 'Please select a group';

  @override
  String get childcare_no_group => 'Join a group to use Child Points.';

  @override
  String get childcare_no_child =>
      'No children registered.\nTap the button in the top right to add a child.';

  @override
  String get household_settings_title => 'Household Settings';

  @override
  String get household_settings_group_section => 'Default Group';

  @override
  String get household_settings_auto_section => 'Push Auto-Register';

  @override
  String get household_settings_auto_toggle =>
      'Auto-register payment notifications';

  @override
  String get household_settings_auto_toggle_desc =>
      'Detects card/bank payment notifications and records them in your household ledger automatically';

  @override
  String get household_settings_permission_required =>
      'Notification access permission is required. Tap \'Allow\' to grant it in Settings.';

  @override
  String get household_settings_permission_grant => 'Allow';

  @override
  String get household_settings_privacy_section => 'Privacy Policy';

  @override
  String get household_settings_privacy_title => 'View collected data & policy';

  @override
  String get household_settings_privacy_subtitle =>
      'See what information the push auto-register feature collects';

  @override
  String get household_settings_privacy_dialog_title => 'Privacy Policy';

  @override
  String get household_settings_auto_scope_notice =>
      'Works only while the app is running (foreground or background). Auto-registration stops when the app is fully closed.';

  @override
  String get household_settings_privacy_content =>
      '■ Data collected\nThe app temporarily reads the following information from payment-complete notifications sent by card/bank apps displayed on your device:\n  · Notification title and body text (e.g. \"KB Card ₩12,000 approved\")\n  · Package name of the sending app (e.g. com.kbcard.kbkookmincard)\n\n■ Purpose\nThe data is used solely to extract payment amount, payment method, and category from the notification text and automatically record it in your household ledger.\n\n■ Retention & disposal\nNotification text is parsed on-device and discarded immediately; the raw text is never transmitted to or stored on a server. Only the converted ledger entry is saved to your account.\n\n■ Third-party sharing\nCollected notification information is never provided, sold, or shared with any third party.\n\n■ Withdrawing consent\nYou can turn off auto-register at any time in this settings screen, or revoke Family Planner\'s notification access permission under device Settings > Notification Access.';

  @override
  String get fridge_title => 'Fridge';

  @override
  String get shopping_title => 'Shopping';

  @override
  String get fridge_tab_fridge => 'Fridge';

  @override
  String get fridge_tab_cart => 'Cart';

  @override
  String get fridge_tab_frequent => 'Frequent';

  @override
  String get fridge_tab_history => 'History';

  @override
  String get fridge_storage_add => 'Add storage';

  @override
  String get fridge_storage_edit => 'Edit storage';

  @override
  String get fridge_storage_delete => 'Delete storage';

  @override
  String get fridge_storage_delete_confirm =>
      'Deleting this storage will also delete all items inside. Continue?';

  @override
  String get fridge_storage_name_hint => 'e.g. Kitchen Fridge';

  @override
  String get fridge_storage_type_fridge => 'Fridge';

  @override
  String get fridge_storage_type_freezer => 'Freezer';

  @override
  String get fridge_storage_type_pantry => 'Pantry';

  @override
  String get fridge_item_add => 'Add item';

  @override
  String get fridge_item_edit => 'Edit item';

  @override
  String get fridge_item_delete_title => 'Delete item';

  @override
  String fridge_item_delete_confirm(String name) {
    return 'Delete $name?';
  }

  @override
  String get fridge_item_name => 'Item name';

  @override
  String get fridge_item_quantity => 'Quantity';

  @override
  String get fridge_item_unit => 'Unit (optional)';

  @override
  String get fridge_item_expires_at => 'Expiry date (optional)';

  @override
  String fridge_item_alert_days(int days) {
    return 'Alert $days days before expiry';
  }

  @override
  String get fridge_item_memo => 'Memo (optional)';

  @override
  String get fridge_item_dday_today => 'D-Day';

  @override
  String fridge_item_dday_expired(int days) {
    return 'D+$days';
  }

  @override
  String fridge_item_dday_remaining(int days) {
    return 'D-$days';
  }

  @override
  String get fridge_item_no_expiry => 'No expiry';

  @override
  String get fridge_empty_storage => 'No storages yet. Add one!';

  @override
  String get fridge_empty_items => 'No items';

  @override
  String get fridge_item_count => '';

  @override
  String get fridge_sort_expiry => 'Expiry';

  @override
  String get fridge_sort_name => 'Name';

  @override
  String get fridge_sort_registered => 'Added';

  @override
  String get fridge_item_elapsed_days => 'd';

  @override
  String get fridge_frequent_add => 'Add item';

  @override
  String get fridge_frequent_auto_add => 'Auto-add when depleted';

  @override
  String get fridge_frequent_empty => 'No frequent items yet';

  @override
  String get fridge_frequent_add_to_cart => 'Add to cart';

  @override
  String fridge_frequent_added_snackbar(String name) {
    return '$name added to cart';
  }

  @override
  String fridge_frequent_delete_confirm(String name) {
    return 'Delete $name?';
  }

  @override
  String get fridge_frequent_autoAddInfo_title => 'What is Auto-Add?';

  @override
  String get fridge_frequent_autoAddInfo_body =>
      'When this item\'s quantity reaches 0 in the fridge, it will be automatically added to your cart.\nWith the switch on, your shopping list will be filled in automatically when the fridge is empty.';

  @override
  String get fridge_frequent_autoAddInfo_hint =>
      'Syncs when you manage quantities in the Fridge tab';

  @override
  String get fridge_frequent_coach_fabTitle => 'Add Frequent Items';

  @override
  String get fridge_frequent_coach_fabDesc =>
      'Register items you buy often\nto add them quickly next time you shop.';

  @override
  String get fridge_frequent_coach_itemTitle => 'Manage Items';

  @override
  String get fridge_frequent_coach_itemDesc =>
      'Set item name and default unit.\nTap to edit, long press to delete.';

  @override
  String get fridge_frequent_coach_autoAddTitle => 'Auto-Add';

  @override
  String get fridge_frequent_coach_autoAddDesc =>
      'When this item\'s quantity reaches 0 in the fridge,\nit will be automatically added to your cart.\nA smart feature linked to the Fridge tab.';

  @override
  String get fridge_frequent_coach_addToCartTitle => 'Add to Cart Instantly';

  @override
  String get fridge_frequent_coach_addToCartDesc =>
      'Add to your current cart\ninstantly with one tap.';

  @override
  String get fridge_frequent_coach_skip => 'Skip';

  @override
  String get fridge_cart_empty => 'Your cart is empty';

  @override
  String get fridge_cart_add_item => 'Add item';

  @override
  String get fridge_cart_complete => 'Complete shopping';

  @override
  String get fridge_cart_complete_title => 'Complete shopping';

  @override
  String get fridge_cart_complete_step2_title => 'Fridge transfer details';

  @override
  String get fridge_cart_complete_transfer_hint =>
      'Select a storage to transfer items to';

  @override
  String get fridge_cart_complete_add_expense => 'Record in ledger';

  @override
  String get fridge_cart_complete_amount =>
      'Total (optional — auto-sum if empty)';

  @override
  String get fridge_cart_item_price => 'Price (optional)';

  @override
  String get fridge_cart_complete_description => 'Note (optional)';

  @override
  String get fridge_cart_skip_transfer => 'Don\'t transfer';

  @override
  String get fridge_history_empty => 'No purchase history yet';

  @override
  String fridge_history_items_count(int count) {
    return '$count items';
  }

  @override
  String get fridge_history_linked_expense => 'Linked to ledger';

  @override
  String get fridge_history_view_expense => 'View in ledger';

  @override
  String get fridge_group_selector_personal => 'Personal';

  @override
  String get dashboard_greetingMorning => 'Good Morning';

  @override
  String get dashboard_greetingAfternoon => 'Good Afternoon';

  @override
  String get dashboard_greetingEvening => 'Good Evening';

  @override
  String get dashboard_greetingSubtitle => 'Have a wonderful day!';

  @override
  String get dashboard_emptyWidgets => 'No widgets to display';

  @override
  String get dashboard_emptyWidgetsHint => 'Enable widgets in settings';

  @override
  String get dashboard_widgetSettings => 'Widget Settings';

  @override
  String get dashboard_notifications => 'Notifications';

  @override
  String get weather_widgetTitle => 'Today\'s Weather';

  @override
  String get weather_refresh => 'Refresh Weather';

  @override
  String get weather_detail => 'Details';

  @override
  String get weather_errorMessage => 'Unable to load weather information';

  @override
  String get weather_dustFine => 'PM10';

  @override
  String get weather_dustUltraFine => 'PM2.5';

  @override
  String get investment_widgetTitle => 'Investment Indicators';

  @override
  String get investment_errorMessage => 'Unable to load data';

  @override
  String get investment_emptyBookmarks => 'No bookmarked indicators';

  @override
  String get householdWidget_groupTooltip => 'Select Group';

  @override
  String householdWidget_incomeLabel(String month) {
    return '$month Income';
  }

  @override
  String householdWidget_expenseLabel(String month) {
    return '$month Expense';
  }

  @override
  String get householdWidget_balance => 'Balance';

  @override
  String householdWidget_budget(String amount) {
    return 'Budget $amount';
  }

  @override
  String householdWidget_budgetUsed(int percent) {
    return '$percent% used';
  }

  @override
  String householdWidget_budgetOver(String amount) {
    return '$amount over budget';
  }

  @override
  String householdWidget_budgetRemaining(String amount) {
    return '$amount remaining';
  }

  @override
  String get householdWidget_filterTitle => 'Select Filter';

  @override
  String get householdWidget_filterPersonal => 'Personal';

  @override
  String get householdWidget_filterPersonalSub => 'Personal expenses only';

  @override
  String get householdWidget_applyButton => 'Apply';

  @override
  String get householdWidget_categoryTitle => 'Expense by Category';

  @override
  String householdWidget_categoryOver(String amount) {
    return '$amount over';
  }

  @override
  String householdWidget_categoryUsed(int percent) {
    return '$percent% used';
  }

  @override
  String get householdWidget_catTransportation => 'Transportation';

  @override
  String get householdWidget_catFood => 'Food';

  @override
  String get householdWidget_catLeisure => 'Leisure';

  @override
  String get householdWidget_catLiving => 'Living';

  @override
  String get householdWidget_catMedical => 'Medical';

  @override
  String get householdWidget_catEducation => 'Education';

  @override
  String get householdWidget_catAllowance => 'Allowance';

  @override
  String get householdWidget_catCelebration => 'Celebration';

  @override
  String get householdWidget_catAssetTransfer => 'Asset Transfer';

  @override
  String get householdWidget_catChildcare => 'Childcare';

  @override
  String get householdWidget_catOther => 'Other';

  @override
  String get assetWidget_title => 'Asset Overview';

  @override
  String assetWidget_groupTitle(String groupName) {
    return '$groupName Assets';
  }

  @override
  String get assetWidget_groupTooltip => 'Select Group';

  @override
  String get assetWidget_totalAsset => 'Total Assets';

  @override
  String get assetWidget_totalProfit => 'Total Profit';

  @override
  String get assetWidget_profitRate => 'Return Rate';

  @override
  String get assetWidget_distribution => 'Asset Distribution';

  @override
  String get assetWidget_groupPickerTitle => 'Select Group';

  @override
  String get assetWidget_applyButton => 'Apply';

  @override
  String get assetWidget_typeSavings => 'Savings';

  @override
  String get assetWidget_typeDeposit => 'Deposit';

  @override
  String get assetWidget_typeStock => 'Stocks';

  @override
  String get assetWidget_typeFund => 'Fund';

  @override
  String get assetWidget_typeRealEstate => 'Real Estate';

  @override
  String get assetWidget_typeGold => 'Gold';

  @override
  String get assetWidget_typeOther => 'Other';
}
