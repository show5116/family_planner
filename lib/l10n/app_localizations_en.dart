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
  String get common_refresh => 'Refresh';

  @override
  String get investment_bookmarkAdd => 'Add to favorites';

  @override
  String get investment_bookmarkRemove => 'Remove from favorites';

  @override
  String get vote_create => 'Create vote';

  @override
  String get cart_item_add => 'Add item';

  @override
  String get savings_goal_add => 'Add goal';

  @override
  String get household_expense_add => 'Add entry';

  @override
  String get household_recurring_add => 'Add Fixed Expense';

  @override
  String get asset_account_add => 'Add account';

  @override
  String get group_role_add => 'Add role';

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
  String get common_view_all => 'View All';

  @override
  String get memo_filter_personal_only => 'Personal Only';

  @override
  String get common_all_groups => 'All Groups';

  @override
  String get schedule_filter_group_schedule => 'Group Schedule';

  @override
  String common_date_format(int month, int day) {
    return '$month/$day';
  }

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
  String get auth_testAccountLoginOwner =>
      'Log in as test account (group owner)';

  @override
  String get auth_testAccountLoginMember =>
      'Log in as test account (group member)';

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
  String get auth_appleLoginFailed => 'Apple login failed';

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
  String get settings_appInfoSubtitle => 'Version info';

  @override
  String get settings_appDescription => 'Daily planner for families';

  @override
  String get settings_termsOfServiceTitle => 'Terms of Service';

  @override
  String get settings_termsOfServiceSubtitle => 'View our terms of service';

  @override
  String get settings_privacyPolicyTitle => 'Privacy Policy';

  @override
  String get settings_privacyPolicySubtitle => 'View our privacy policy';

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
  String get announcement_markdownImport => 'Import Markdown';

  @override
  String get announcement_markdownImportTitle => 'Paste Markdown';

  @override
  String get announcement_markdownImportDescription =>
      'Paste raw Markdown and it will be converted into formatted content.';

  @override
  String get announcement_markdownImportHint =>
      '# Heading\n- List item\n**Bold**';

  @override
  String get announcement_markdownImportEmpty =>
      'Please enter Markdown to convert';

  @override
  String get announcement_markdownImportFailed => 'Failed to convert Markdown';

  @override
  String get announcement_markdownImportReplace => 'Replace existing content';

  @override
  String get announcement_markdownImportReplaceDescription =>
      'When off, inserts at the cursor position';

  @override
  String get announcement_markdownImportConvert => 'Convert';

  @override
  String get announcement_markdownImportSuccess => 'Markdown converted';

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
  String get category_filter => 'Category Filter';

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
  String get memo_personal => 'My Memo';

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
  String get memo_duplicate => 'Copy';

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
  String get household_refund => 'Register Refund';

  @override
  String get household_refund_badge => 'Refunded';

  @override
  String get household_refund_origin_badge => 'Refund';

  @override
  String get household_refund_amount_label => 'Refund Amount';

  @override
  String get household_refund_origin_label => 'Original Expense';

  @override
  String get household_view_refund_origin => 'View Original Expense';

  @override
  String get household_refund_total => 'Total Refunded';

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
  String get household_carry_over => 'Carry Over';

  @override
  String get household_carry_over_title => 'Carry Over Balance';

  @override
  String household_carry_over_desc(String amount) {
    return 'Carry over ₩$amount remaining balance to next month.\n\n· An \'Asset Transfer\' expense will be added on the last day of this month.\n· An income entry \'Carried Over\' will be added on the 1st of next month.';
  }

  @override
  String get household_carry_over_success =>
      'Balance carried over successfully';

  @override
  String get household_carry_over_no_balance => 'No balance to carry over';

  @override
  String get household_balance_transfer => 'Transfer Balance';

  @override
  String get household_carry_over_mode_next_month => 'Next Month';

  @override
  String get household_carry_over_mode_asset => 'Asset Account';

  @override
  String get household_carry_over_mode_savings => 'Piggy Bank';

  @override
  String get household_carry_over_amount_label => 'Amount';

  @override
  String get household_carry_over_amount_exceeded =>
      'Cannot exceed available balance';

  @override
  String get household_carry_over_select_account => 'Select an account';

  @override
  String get household_carry_over_select_savings => 'Select a piggy bank';

  @override
  String get household_carry_over_no_accounts => 'No accounts registered';

  @override
  String get household_carry_over_no_savings => 'No piggy banks registered';

  @override
  String get household_transfer_success => 'Transfer completed successfully';

  @override
  String get household_income => 'Income';

  @override
  String get household_revenue => 'Revenue';

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
  String get household_category_carryover => 'Carry Over';

  @override
  String get household_category_childcare => 'Childcare';

  @override
  String get household_category_communication => 'Communication';

  @override
  String get household_category_groceries => 'Groceries';

  @override
  String get household_category_other => 'Other';

  @override
  String get household_income_category => 'Income Type';

  @override
  String get household_income_category_salary => 'Salary';

  @override
  String get household_income_category_allowance => 'Allowance';

  @override
  String get household_income_category_carryover => 'Carry Over';

  @override
  String get household_income_category_bonus => 'Bonus';

  @override
  String get household_income_category_interest => 'Interest';

  @override
  String get household_income_category_rental => 'Rental';

  @override
  String get household_income_category_side_income => 'Side Income';

  @override
  String get household_income_category_transfer_in => 'Transfer In';

  @override
  String get household_income_category_other => 'Other Income';

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
  String get household_recurring_total => 'Monthly Total';

  @override
  String get household_recurring_count => 'Items';

  @override
  String household_recurring_count_unit(int count) {
    return '$count items';
  }

  @override
  String get household_recurring_expense_total => 'Total Expenses';

  @override
  String get household_recurring_income_total => 'Total Income';

  @override
  String household_unpaid_recurring_expense(int count, String amount) {
    return '$count expense(s) · ₩$amount';
  }

  @override
  String household_unpaid_recurring_income(int count, String amount) {
    return '$count income item(s) · ₩$amount';
  }

  @override
  String get household_recurring_top_category => 'By Category';

  @override
  String get household_recurring_fixed => 'Fixed';

  @override
  String get household_recurring_variable => 'Variable';

  @override
  String get household_recurring_type_label => 'Recurring Type';

  @override
  String get household_recurring_type_none => 'None';

  @override
  String get household_recurring_type_fixed => 'Fixed Amount';

  @override
  String get household_recurring_type_fixed_desc =>
      'The same amount is applied every month';

  @override
  String get household_recurring_type_variable => 'Variable Amount';

  @override
  String get household_recurring_type_variable_desc =>
      'Occurs monthly but the amount varies (e.g. maintenance fee)';

  @override
  String get household_recurring_amount_variable_label =>
      'Base Amount (Estimated)';

  @override
  String get household_recurring_amount_variable_hint =>
      'Amount may vary each month. Edit and confirm after the actual charge.';

  @override
  String get household_recurring_amount_fixed_hint =>
      'This amount will be automatically registered every month.';

  @override
  String get household_recurring_inactive => 'Inactive';

  @override
  String get household_recurring_edit => 'Edit Fixed Expense';

  @override
  String get household_recurring_title => 'Fixed Transactions';

  @override
  String get household_recurring_add_title => 'Add Fixed Transaction';

  @override
  String get household_recurring_edit_title => 'Edit Fixed Transaction';

  @override
  String get household_recurring_day_of_month => 'Day of Month';

  @override
  String household_recurring_day_of_month_value(int day) {
    return '${day}th of each month';
  }

  @override
  String get household_recurring_backfill_toggle =>
      'Also register past expenses';

  @override
  String get household_recurring_backfill_hint =>
      'Choosing a start month will also create expense records up to today';

  @override
  String get household_recurring_start_month => 'Start month';

  @override
  String get household_recurring_end_option => 'End recurrence';

  @override
  String get household_recurring_end_indefinite => 'Indefinite';

  @override
  String get household_recurring_end_fixed_months => 'Set number of months';

  @override
  String get household_recurring_total_months_label => 'Total months';

  @override
  String get household_recurring_total_months_hint => 'e.g. 24';

  @override
  String get household_recurring_total_months_required =>
      'Please enter the number of months';

  @override
  String household_recurring_end_date_info(
    String endMonth,
    int current,
    int total,
  ) {
    return 'Until $endMonth ($current/$total months)';
  }

  @override
  String get household_recurring_indefinite => 'Repeats indefinitely';

  @override
  String get household_recurring_edit_backfill_notice =>
      'Changing the start month or total months won\'t recreate past expenses. Backfilling only happens when the item is first created.';

  @override
  String get household_estimated_amount => 'Estimated Amount';

  @override
  String get household_estimated_amount_hint =>
      'Enter the estimated amount for this month';

  @override
  String get household_estimated_amount_required =>
      'Please enter an estimated amount';

  @override
  String get household_variable_badge => 'Variable';

  @override
  String get household_unconfirmed_badge => 'Unconfirmed';

  @override
  String get household_exclude_refunds => 'Exclude Refunds';

  @override
  String get household_exclude_carryover => 'Exclude Carry-over';

  @override
  String get household_unpaid_recurring_title => 'Remaining Fixed Transactions';

  @override
  String household_unpaid_recurring_subtitle(int count, String amount) {
    return '$count items · Est. ₩$amount';
  }

  @override
  String get household_merchants => 'Merchants';

  @override
  String get household_merchants_my => 'My Merchants';

  @override
  String get household_merchants_samples => 'Popular Merchants';

  @override
  String get household_merchants_empty => 'No merchants registered';

  @override
  String get household_merchants_add => 'Add Merchant';

  @override
  String get household_merchants_edit => 'Edit Merchant';

  @override
  String get household_merchants_name => 'Merchant name';

  @override
  String get household_merchants_delete => 'Delete Merchant';

  @override
  String household_merchants_delete_confirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get household_merchant_select => 'Select Merchant';

  @override
  String get household_merchant_none => 'None';

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
  String get asset_trend_profit_rate => 'Return';

  @override
  String get asset_trend_period_return => 'Period%';

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
  String get asset_pie_chart_title => 'Account Breakdown';

  @override
  String get asset_pie_mode_type => 'By Type';

  @override
  String get asset_pie_mode_account => 'By Account';

  @override
  String get asset_pie_mode_portfolio => 'Portfolio';

  @override
  String get asset_pie_no_portfolio => 'No portfolio data';

  @override
  String get asset_compare_my_asset => 'My Assets';

  @override
  String get asset_compare_usd_label => 'USD Value';

  @override
  String get asset_compare_button => 'Compare';

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
  String get fridge_storage_name => 'Storage name';

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
  String get fridge_coach_fabTitle => 'Add Storage';

  @override
  String get fridge_coach_fabDesc =>
      'Add storage locations like fridge, freezer, or pantry.\nTap + to create a new storage.';

  @override
  String get fridge_coach_sectionTitle => 'Storage Section';

  @override
  String get fridge_coach_sectionDesc =>
      'Tap the header to expand or collapse.\nUse the ⋮ menu to edit or delete the storage.';

  @override
  String get fridge_coach_itemTitle => 'Manage Items';

  @override
  String get fridge_coach_itemDesc =>
      '• Tap to edit name, expiry date, and memo\n• Use ± buttons to adjust quantity\n• Swipe left to mark for deletion\n• Press Save to apply changes';

  @override
  String get fridge_coach_ddayTitle => 'Expiry Alerts';

  @override
  String get fridge_coach_ddayDesc =>
      'Register an expiry date to see remaining days.\n• Blue: plenty of time\n• Orange: expiring within 3 days\n• Red: today or already expired\nYou\'ll receive push notifications before the alert day.';

  @override
  String get fridge_coach_addItemTitle => 'Add Items';

  @override
  String get fridge_coach_addItemDesc =>
      'Tap + next to a storage to add items.\nYou can add multiple items at once,\nwith expiry date, quantity, unit, and memo.';

  @override
  String get fridge_coach_suggestionTitle => 'Auto Expiry Suggestion';

  @override
  String get fridge_coach_suggestionDesc =>
      'Enter an item name and we\'ll suggest an expiry date automatically.\nIn Settings > Expiry Preset Management, you can add or edit\nper-item reference days to customize your own automation rules.';

  @override
  String get fridge_coach_skip => 'Skip';

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
      'Total (auto-calculated from item prices)';

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
  String get fridge_history_delete => 'Delete history';

  @override
  String get fridge_history_delete_confirm_title => 'Delete purchase history';

  @override
  String get fridge_history_delete_confirm_body =>
      'Delete this purchase history?';

  @override
  String get fridge_history_delete_expense_notice =>
      'Any linked expense in the ledger will remain even after this history is deleted.';

  @override
  String get fridge_group_selector_personal => 'Personal';

  @override
  String fridge_expiry_suggestion_label(
    String keyword,
    String storageType,
    int days,
  ) {
    return '$keyword based · $storageType $days days';
  }

  @override
  String get fridge_expiry_apply => 'Apply Suggestion';

  @override
  String get fridge_expiry_manual => 'Enter Manually';

  @override
  String get fridge_expiry_change_reference =>
      'Use different item as reference';

  @override
  String get fridge_expiry_reference_title => 'Select Reference Item';

  @override
  String get fridge_expiry_reference_search => 'Search items';

  @override
  String fridge_expiry_reference_days(int days) {
    return '$days days';
  }

  @override
  String get fridge_expiry_reference_empty => 'No results found';

  @override
  String get fridge_preset_management_title => 'Expiry Preset Management';

  @override
  String get fridge_preset_management_menu => 'Expiry Preset Management';

  @override
  String get fridge_preset_edit_shortcut => 'Edit Presets';

  @override
  String fridge_preset_days_label(int days) {
    return '$days days';
  }

  @override
  String get fridge_preset_custom_badge => 'Custom';

  @override
  String get fridge_preset_reset_confirm => 'Reset to default?';

  @override
  String get fridge_preset_edit_dialog_title => 'Edit Expiry Days';

  @override
  String get fridge_preset_add_dialog_title => 'Add New Preset';

  @override
  String get fridge_preset_days_input_label => 'Expiry days';

  @override
  String get fridge_preset_category_input_label => 'Category';

  @override
  String get fridge_preset_storage_type_label => 'Storage type';

  @override
  String get fridge_preset_delete_confirm =>
      'Delete custom setting and restore default?';

  @override
  String get fridge_preset_search_hint => 'Search category or item';

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
  String get dashboard_loadFailed => 'Couldn\'t load';

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
  String get weather_fallbackLocationNotice =>
      'Couldn\'t get your current location — showing weather for Seoul instead';

  @override
  String get weather_enableLocationAction => 'Allow location access';

  @override
  String get investment_widgetTitle => 'Investment Indicators';

  @override
  String get investment_errorMessage => 'Unable to load data';

  @override
  String get investment_emptyBookmarks => 'No bookmarked indicators';

  @override
  String get investment_screenTitle => 'Investment Indicators';

  @override
  String get investment_bookmarkSection => 'Bookmarks';

  @override
  String get investment_bookmarkReorderHint => '(Long press to reorder)';

  @override
  String get investment_allSection => 'All Indicators';

  @override
  String get investment_noData => 'No indicator data';

  @override
  String get investment_loadError => 'Failed to load data';

  @override
  String get investment_retry => 'Retry';

  @override
  String get investment_adminTooltip => 'Reset History (Admin)';

  @override
  String get investment_briefingTitle => 'AI Market Briefing';

  @override
  String investment_briefingError(String error) {
    return 'AI briefing error: $error';
  }

  @override
  String get investment_briefingMacro => 'Macro';

  @override
  String get investment_briefingDomestic => 'Domestic Market';

  @override
  String get investment_briefingGlobal => 'Global Market';

  @override
  String investment_briefingUpdatedAt(String time) {
    return 'Updated: $time';
  }

  @override
  String get investment_adminDialogTitle => 'Reset History Data';

  @override
  String get investment_adminDialogDesc =>
      'Collects historical prices from Yahoo/CoinGecko/BOK and saves to DB.\nThis may take a while.';

  @override
  String get investment_adminDaysLabel => 'Days to collect (1~3650)';

  @override
  String get investment_adminDaysSuffix => 'days';

  @override
  String get investment_adminExecute => 'Execute Reset';

  @override
  String get investment_adminResultTitle => 'Reset Complete';

  @override
  String get investment_adminResultYahoo => 'Yahoo (Stocks/FX/Commodities)';

  @override
  String get investment_adminResultCrypto => 'Crypto (BTC/KRW)';

  @override
  String get investment_adminResultBond => 'Korean Bonds';

  @override
  String get investment_adminResultGold => 'Domestic Gold';

  @override
  String investment_adminResultCount(int count) {
    return '$count items';
  }

  @override
  String investment_adminInitError(String error) {
    return 'Reset failed: $error';
  }

  @override
  String get investment_adminLoading => 'Collecting historical data...';

  @override
  String get investment_prevPrice => 'Prev. Close';

  @override
  String investment_spreadBadge(String value) {
    return 'Spread $value%';
  }

  @override
  String get investment_spreadPremium => 'Premium vs international price';

  @override
  String get investment_spreadDiscount => 'Discount vs international price';

  @override
  String get investment_chartTitle => 'Price Trend';

  @override
  String investment_chartDayChip(int days) {
    return '${days}d';
  }

  @override
  String get investment_chartYearChip => '1Y';

  @override
  String get investment_chartLoadError => 'Unable to load chart';

  @override
  String get investment_chartNoData => 'No data';

  @override
  String investment_marketClosed(String date) {
    return 'Market closed · Last trading day: $date';
  }

  @override
  String get investment_spreadChartTitle => 'Spread Trend';

  @override
  String get investment_spreadChartSubtitle => '(vs. international price)';

  @override
  String investment_spreadSummaryLabel(String label) {
    return 'Currently $label vs international price';
  }

  @override
  String get investment_spreadPremiumLabel => 'Premium';

  @override
  String get investment_spreadDiscountLabel => 'Discount';

  @override
  String get investment_coachIndicatorTitle => 'Investment Indicators';

  @override
  String get investment_coachIndicatorDesc =>
      'View major stock indices, exchange rates,\ncommodities, and crypto in real time.\nTap to see detailed charts and history.';

  @override
  String get investment_coachBookmarkTitle => 'Bookmarks';

  @override
  String get investment_coachBookmarkDesc =>
      'Tap the star to bookmark an indicator.\nBookmarked indicators are pinned to the top\nand visible on the home dashboard widget.';

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

  @override
  String get legal_termsOfService => 'Terms of Service';

  @override
  String get legal_privacyPolicy => 'Privacy Policy';

  @override
  String get legal_termsLastUpdated => 'Effective date: June 1, 2026';

  @override
  String get legal_termsContact => 'Contact: hmn.corp.dev@gmail.com';

  @override
  String get legal_agreeToTerms => 'Terms of Service';

  @override
  String get legal_agreeToPrivacy => 'Privacy Policy';

  @override
  String get legal_required => '(Required)';

  @override
  String get legal_agreeAll => 'Agree to all';

  @override
  String get legal_mustAgreeTerms => 'Please agree to the Terms of Service.';

  @override
  String get legal_mustAgreePrivacy => 'Please agree to the Privacy Policy.';

  @override
  String get legal_agreeAgeVerification =>
      'I am 14 years of age or older (Required)';

  @override
  String get legal_mustAgreeAgeVerification =>
      'Please confirm that you are 14 years of age or older.';

  @override
  String legal_socialLoginConsent(String termsLink, String privacyLink) {
    return 'By continuing, you agree to our $termsLink and $privacyLink.';
  }

  @override
  String get legal_terms_section1_title => 'Article 1 (Purpose)';

  @override
  String get legal_terms_section1_body =>
      'These Terms govern the rights, obligations, and responsibilities between HMN Corporation (the \"Company\") and its members in connection with the use of the Family Planner service (the \"Service\") provided by the Company.';

  @override
  String get legal_terms_section2_title => 'Article 2 (Service Content)';

  @override
  String get legal_terms_section2_body =>
      'The Company provides members with the following services:\n• Family group-based calendar and to-do sharing\n• Asset management and history sharing among members\n• Child reward (praise stickers, etc.) management system\n• Conversation, schedule management, and macroeconomic/market briefing services via AI agent\n• Other services additionally developed by the Company or provided through partnership agreements';

  @override
  String get legal_terms_section3_title => 'Article 3 (Member Obligations)';

  @override
  String get legal_terms_section3_body =>
      '• Members must not input illegal or harmful prompts to the AI agent within the Service.\n• Members are responsible for securely managing family group invitation codes and account information.\n• The asset management and market briefing features are provided for reference purposes only, and the Company bears no legal responsibility for investment outcomes based on such information.';

  @override
  String get legal_terms_section4_title =>
      'Article 4 (Copyright and Management of Posts)';

  @override
  String get legal_terms_section4_body =>
      '• Copyright of information posted by members within the Service (chats, schedules, asset information, etc.) belongs to the respective member.\n• The Company uses member posts only for service operation, improvement (including AI feature enhancement), and promotion, and only in a de-identified form that cannot identify individuals.';

  @override
  String get legal_terms_section5_title =>
      'Article 5 (Service Suspension and Changes)';

  @override
  String get legal_terms_section5_body =>
      'The Company may change or suspend all or part of the Service as needed for operational or technical reasons, and will provide advance notice in such cases.';

  @override
  String get legal_terms_section6_title =>
      'Article 6 (Limitation of Liability)';

  @override
  String get legal_terms_section6_body =>
      'The Company is exempt from liability for service provision in cases where the Service cannot be provided due to force majeure events such as natural disasters, server provider failures, or third-party AI API service failures.';

  @override
  String get legal_terms_section7_title => 'Article 7 (Effective Date)';

  @override
  String get legal_terms_section7_body =>
      'These Terms are effective from June 1, 2026.';

  @override
  String get legal_privacy_section1_title =>
      '1. Purpose of Processing Personal Information';

  @override
  String get legal_privacy_section1_body =>
      'HMN Corporation (the \'Company\') processes personal information for the following purposes. The personal information being processed will not be used for any purpose other than the following, and if the purpose of use changes, necessary measures such as obtaining separate consent will be taken.\n• Member registration and management, family group (invitation code, etc.) identification\n• Service provision (calendar, to-do, asset management, child reward system, etc.)\n• AI agent (chatbot, briefing, etc.) service provision and quality improvement\n• New service development and personalized service provision';

  @override
  String get legal_privacy_section2_title =>
      '2. Personal Information Items Processed';

  @override
  String get legal_privacy_section2_body =>
      'The Company processes the following personal information items to provide its services.\n• Required items: email address, password, name (or nickname), profile image\n• Information collected during service use: calendar events, to-do lists, asset data, family group information, AI chat history, service usage records, device information';

  @override
  String get legal_privacy_section3_title =>
      '3. Third-Party Provision and Entrustment of Personal Information';

  @override
  String get legal_privacy_section3_body =>
      'To provide smooth AI services (context analysis, briefing generation, etc.), the Company may transmit some of the entered data to external AI model APIs (e.g., OpenAI, Anthropic, Google, etc.).\nHowever, this data is used only for service provision purposes and measures are taken to ensure it is not used for model training.';

  @override
  String get legal_privacy_section4_title =>
      '4. Destruction of Personal Information';

  @override
  String get legal_privacy_section4_body =>
      'In principle, the Company destroys personal information without delay when the purpose of processing has been achieved.\n• Destruction procedure: When a user requests account withdrawal, the collected information is destroyed immediately or after the retention period required by law has elapsed.\n• Destruction method: Information in electronic file format is destroyed using technical methods that make it impossible to reproduce the records.';

  @override
  String get legal_privacy_section5_title =>
      '5. Rights of Data Subjects and How to Exercise Them';

  @override
  String get legal_privacy_section5_body =>
      'Users may access or modify their personal information at any time, and may withdraw consent to the collection and use of personal information by withdrawing from membership.';

  @override
  String get legal_privacy_section6_title => '6. Privacy Officer';

  @override
  String get legal_privacy_section6_body =>
      'Name: Yoo Youngjin\nEmail: hmn.corp.dev@gmail.com';

  @override
  String get legal_privacy_section7_title => '7. Effective Date';

  @override
  String get legal_privacy_section7_body =>
      'This Privacy Policy is effective from June 1, 2026.';

  @override
  String get legal_privacyLastUpdated => 'Effective date: June 1, 2026';

  @override
  String get shopping_history_delete_title => 'Delete Purchase History';

  @override
  String get shopping_history_delete_body =>
      'Are you sure you want to delete this shopping record?';

  @override
  String get shopping_history_delete_notice =>
      'Expense records and fridge items will not be deleted.';

  @override
  String get shopping_history_readd_all => 'Add all items to cart';

  @override
  String shopping_history_readd_all_snackbar(int count) {
    return 'Added $count items to cart.';
  }

  @override
  String shopping_history_readd_item_snackbar(String name) {
    return 'Added $name to cart.';
  }

  @override
  String get shopping_history_price_none => 'No price';

  @override
  String get shopping_history_add_to_cart => 'Add to cart';

  @override
  String get shopping_history_fridge_transferred => 'Moved to fridge';

  @override
  String get shopping_history_fridge_not_transferred => 'Not transferred';

  @override
  String get shopping_complete_snackbar => 'Shopping completed.';

  @override
  String get account_management_title => 'Account Management';

  @override
  String get account_delete_schedule_title => 'Schedule Account Deletion';

  @override
  String get account_delete_schedule_subtitle =>
      'All data deleted after 7-day grace period';

  @override
  String get account_delete_schedule_confirm_title =>
      'Schedule account deletion?';

  @override
  String get account_delete_schedule_confirm_body =>
      'Your account and all data will be permanently deleted after 7 days.\nYou can cancel during the grace period.';

  @override
  String account_delete_schedule_success(String date) {
    return 'Account deletion scheduled. Will be deleted on $date.';
  }

  @override
  String get account_cancel_delete_title => 'Cancel Account Deletion';

  @override
  String get account_cancel_delete_subtitle =>
      'Cancel the scheduled account deletion';

  @override
  String get account_cancel_delete_confirm_title => 'Cancel account deletion?';

  @override
  String get account_cancel_delete_success =>
      'Account deletion has been cancelled';

  @override
  String get account_export_data_title => 'Export My Data';

  @override
  String get account_export_data_subtitle =>
      'A copy of your data will be sent to your registered email';

  @override
  String get account_export_data_success =>
      'Request submitted. Please check your email.';

  @override
  String account_action_failed(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get subscription_free_label => 'Free Plan';

  @override
  String get subscription_free_sublabel => 'Ads are displayed';

  @override
  String get subscription_trial_label => '2-Week Free Trial';

  @override
  String subscription_trial_sublabel_days(int days) {
    return 'Switches to free plan in $days days';
  }

  @override
  String get subscription_trial_sublabel_today => 'Trial ends today';

  @override
  String get subscription_ad_free_label => 'Ad-Free';

  @override
  String subscription_ad_free_sublabel_expires(String date) {
    return 'Until $date';
  }

  @override
  String get subscription_ad_free_sublabel_active => 'Enjoying without ads';

  @override
  String get subscription_premium_label => 'Premium';

  @override
  String subscription_premium_sublabel_expires(String date) {
    return 'Until $date';
  }

  @override
  String get subscription_premium_sublabel_active => 'Enjoying all features';

  @override
  String get dashboard_trial_banner_title => 'Enjoying 2-Week Ad-Free Trial';

  @override
  String dashboard_trial_banner_sublabel_days(int days) {
    return 'Switches to regular plan in $days days';
  }

  @override
  String get dashboard_trial_banner_sublabel_today => 'Trial ends today';

  @override
  String get anniversary_widgetTitle => 'Upcoming Anniversaries';

  @override
  String get anniversary_widgetEmpty => 'No anniversaries registered';

  @override
  String get widgetSettings_anniversarySummary => 'Anniversaries';

  @override
  String get widgetSettings_anniversarySummaryDesc =>
      'Shows upcoming anniversaries and D-day countdown';

  @override
  String get subscription_manage_title => 'Manage Subscription';

  @override
  String get subscription_screen_title => 'Manage Subscription';

  @override
  String get subscription_current_plan_label => 'Current Plan';

  @override
  String get subscription_active_status_label => 'Status';

  @override
  String get subscription_active => 'Active';

  @override
  String get subscription_inactive => 'Inactive';

  @override
  String get subscription_expires_at_label => 'Expires';

  @override
  String get subscription_days_left_label => 'Time remaining';

  @override
  String subscription_days_left_value(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get subscription_days_left_today => 'Ends today';

  @override
  String get subscription_trial_ends_at_label => 'Trial ends';

  @override
  String get subscription_period_end_label => 'Current period ends';

  @override
  String get subscription_auto_renew_hint =>
      'Renews automatically on this date unless canceled';

  @override
  String get subscription_next_renewal_label => 'Next renewal';

  @override
  String get subscription_canceled_hint =>
      'Canceled — your subscription ends on this date';

  @override
  String get subscription_products_section_title => 'Subscription Plans';

  @override
  String get subscription_purchase_button => 'Subscribe';

  @override
  String get subscription_restore_button => 'Restore Purchases';

  @override
  String get subscription_purchase_success => 'Subscription completed.';

  @override
  String get subscription_verify_failed_title => 'Purchase Verification Failed';

  @override
  String get subscription_verify_failed_message =>
      'This purchase was already used or failed verification. Please contact support if the issue persists.';

  @override
  String get subscription_verify_network_error =>
      'A network error occurred. Please try again later.';

  @override
  String get subscription_restore_success => 'Subscription restored.';

  @override
  String get subscription_product_not_found =>
      'Subscription plans are being prepared. Please try again later.';

  @override
  String get subscription_ad_free_benefit => 'Removes all ads within the app.';

  @override
  String get subscription_period_monthly => 'Monthly subscription';

  @override
  String get subscription_auto_renew_notice =>
      'Your subscription renews automatically each month and will be charged the same amount unless canceled at least 24 hours before the end of the current period. Payment is charged to your store account upon purchase confirmation. You can manage or cancel your subscription at any time in your device\'s store account settings.';

  @override
  String get subscription_manage_subscription_button =>
      'Manage or cancel subscription';

  @override
  String get subscription_terms_button => 'Terms of Service';

  @override
  String get subscription_privacy_button => 'Privacy Policy';

  @override
  String get subscription_manage_launch_failed =>
      'Could not open the store subscription settings.';

  @override
  String get subscription_compare_title => 'Compare plans';

  @override
  String get subscription_plan_current => 'Current';

  @override
  String get subscription_benefit_all_features => 'All features included';

  @override
  String get subscription_benefit_ads_shown => 'Ads are shown';

  @override
  String get subscription_benefit_no_ads => 'No ads';

  @override
  String get subscription_benefit_no_reward_ads => 'No ads to unlock features';

  @override
  String get subscription_benefit_cancel_anytime => 'Cancel anytime';

  @override
  String get subscription_free_plan_price => 'Free';

  @override
  String get routine_title => 'Routines';

  @override
  String get routine_date_today => 'Today';

  @override
  String get routine_reorder => 'Reorder';

  @override
  String get routine_reorder_done => 'Done';

  @override
  String get routine_list_empty => 'No habits yet';

  @override
  String get routine_list_empty_subtitle =>
      'Add a habit you want to repeat every day\nand build a streak by checking it off consistently';

  @override
  String get routine_add => 'Add Habit';

  @override
  String get routine_edit => 'Edit Habit';

  @override
  String get routine_delete => 'Delete Habit';

  @override
  String get routine_delete_confirm => 'Delete this habit?';

  @override
  String get routine_field_title => 'Title';

  @override
  String get routine_field_title_hint => 'e.g. Morning stretch';

  @override
  String get routine_field_title_required => 'Please enter a title';

  @override
  String get routine_field_title_too_long =>
      'Title must be 100 characters or fewer';

  @override
  String get routine_field_emoji => 'Emoji';

  @override
  String get routine_field_emoji_custom => 'Custom';

  @override
  String get routine_field_emoji_helper => 'Enter a single emoji (e.g. 🏃)';

  @override
  String get routine_field_color => 'Color';

  @override
  String get routine_field_target_count => 'Weekly target count';

  @override
  String get routine_field_target_count_month => 'Monthly target count';

  @override
  String get routine_this_month_progress => 'This month\'s progress';

  @override
  String get routine_field_start_date => 'Start date';

  @override
  String get routine_field_end_date => 'End date (optional)';

  @override
  String get routine_field_end_date_none => 'No end date';

  @override
  String get routine_field_group => 'Routine';

  @override
  String get routine_field_group_none => 'None (standalone habit)';

  @override
  String get routine_save => 'Save';

  @override
  String get routine_check => 'Check';

  @override
  String get routine_uncheck => 'Uncheck';

  @override
  String get routine_check_already => 'Already checked';

  @override
  String get routine_check_future_date => 'Cannot check a future date';

  @override
  String get routine_check_error => 'Failed to check';

  @override
  String routine_streak_celebration(int days) {
    return '🔥 $days-day streak!';
  }

  @override
  String get routine_tab_heatmap => 'Calendar';

  @override
  String get routine_tab_stats => 'Stats';

  @override
  String get routine_streak_current_days => 'Current day streak';

  @override
  String get routine_streak_longest_days => 'Longest day streak';

  @override
  String get routine_streak_current_weeks => 'Current week streak';

  @override
  String get routine_streak_longest_weeks => 'Longest week streak';

  @override
  String get routine_streak_current_months => 'Current Months';

  @override
  String get routine_streak_longest_months => 'Best Months';

  @override
  String get routine_this_month_progress_label => 'This Month';

  @override
  String get routine_badges_goal_subtitle =>
      'Badges you earned by hitting your daily goal';

  @override
  String get routine_daily_goal_included_badge => 'Counts toward today\'s goal';

  @override
  String get routine_daily_goal_filter_on => 'Showing goal habits only';

  @override
  String get routine_daily_goal_filter_hint =>
      'Tap to see only your goal habits';

  @override
  String get routine_coach_add_title => 'Create a habit';

  @override
  String get routine_coach_add_desc =>
      'Add the things you want to repeat every day.\nYou can also bundle several habits into one routine.';

  @override
  String get routine_coach_goal_title => 'Today\'s goal';

  @override
  String get routine_coach_goal_desc =>
      'You don\'t have to finish every habit.\nHit the number you set and the day counts as a win.\nKeep a streak going and you\'ll earn badges.';

  @override
  String get routine_coach_flag_title => 'Habits in your goal';

  @override
  String get routine_coach_flag_desc =>
      'Habits with a flag count toward today\'s goal.\nTap the goal bar above to see just those habits.';

  @override
  String get routine_coach_check_title => 'Check it off';

  @override
  String get routine_coach_check_desc =>
      'Tap the circle to mark a habit done.\nHabits that track values let you log a time or amount too.';

  @override
  String get routine_coach_demo_habit_1 => 'Morning stretch';

  @override
  String get routine_coach_demo_habit_2 => 'Drink 2L of water';

  @override
  String get routine_coach_demo_habit_3 => 'Read for 30 minutes';

  @override
  String get routine_coach_skip => 'Skip';

  @override
  String get routine_coach_together_title => 'Do it together';

  @override
  String get routine_coach_together_desc =>
      'Share your habits with family or friends.\nSee how everyone is doing and take on challenges together.';

  @override
  String get routine_together_coach_status_title => 'Member status';

  @override
  String get routine_together_coach_status_desc =>
      'See what everyone in the group did today.\nTap a name for their full record.';

  @override
  String get routine_together_coach_tabs_title => 'Ranking and challenges';

  @override
  String get routine_together_coach_tabs_desc =>
      'Ranking compares goal achievement rates.\nChallenges let you set a deadline, chase a goal together,\nand even put stakes on it.';

  @override
  String get routine_together_coach_settings_title => 'Sharing settings';

  @override
  String get routine_together_coach_settings_desc =>
      'Choose which groups can see your habits.\nMark a habit private and it stays hidden from everyone.';

  @override
  String get routine_this_week_progress => 'This week\'s progress';

  @override
  String get routine_weekly_strip_title => 'Last 8 weeks';

  @override
  String get routine_rate_period_week => 'Week';

  @override
  String get routine_rate_period_month => 'Month';

  @override
  String get routine_rate_period_custom => 'Custom range';

  @override
  String get routine_rate_achievement => 'Achievement rate';

  @override
  String get routine_share_title => 'Manage Shared Groups';

  @override
  String get routine_share_screen_desc =>
      'Members of the groups you pick can see your habits and progress.';

  @override
  String get routine_share_private_note =>
      'Habits marked private are never shared.';

  @override
  String get routine_share_none => 'You\'re not sharing with any group yet';

  @override
  String get routine_share_no_groups =>
      'You\'re not in any group yet.\nCreate or join a group first.';

  @override
  String get routine_share_saved => 'Sharing settings saved';

  @override
  String get routine_field_private => 'Private';

  @override
  String get routine_field_private_desc =>
      'Hide this habit from others in your shared groups';

  @override
  String get routine_private_badge => 'Private habit';

  @override
  String get routine_share_select_group => 'Select a group to share with';

  @override
  String get routine_together_title => 'Together';

  @override
  String get routine_together_tab_status => 'Status';

  @override
  String get routine_together_tab_ranking => 'Ranking';

  @override
  String get routine_together_tab_challenge => 'Challenges';

  @override
  String get routine_challenge_create => 'New Challenge';

  @override
  String get routine_challenge_edit => 'Edit Challenge';

  @override
  String get routine_challenge_empty =>
      'No challenges yet.\nCreate a goal to take on with your group.';

  @override
  String get routine_challenge_field_title => 'Challenge name';

  @override
  String get routine_challenge_field_title_hint => 'e.g. Work out this week';

  @override
  String get routine_challenge_field_description => 'Description';

  @override
  String get routine_challenge_field_period => 'Period';

  @override
  String get routine_challenge_field_target => 'Target count';

  @override
  String routine_challenge_field_target_desc(int count) {
    return 'Check in $count times during the period to win';
  }

  @override
  String get routine_challenge_field_reward => 'Stakes';

  @override
  String get routine_challenge_field_reward_hint => 'e.g. Loser buys dinner';

  @override
  String get routine_challenge_status_upcoming => 'Upcoming';

  @override
  String get routine_challenge_status_ongoing => 'Ongoing';

  @override
  String get routine_challenge_status_ended => 'Ended';

  @override
  String routine_challenge_participants(int count) {
    return '$count joined';
  }

  @override
  String get routine_challenge_join => 'Join';

  @override
  String get routine_challenge_leave => 'Leave';

  @override
  String get routine_challenge_leave_confirm => 'Leave this challenge?';

  @override
  String get routine_challenge_delete_confirm =>
      'Delete this challenge?\nEveryone\'s records will be removed too.';

  @override
  String get routine_challenge_select_routine => 'Which habit will you use?';

  @override
  String get routine_challenge_select_routine_desc =>
      'Pick one of your habits to link.\nPrivate habits can\'t join.';

  @override
  String get routine_challenge_no_routine =>
      'No habits available to join with.\nCreate a habit first.';

  @override
  String get routine_challenge_change_routine => 'Change habit';

  @override
  String routine_challenge_progress(int checked, int target) {
    return '$checked / $target';
  }

  @override
  String routine_challenge_days_left(int days) {
    return '$days days left';
  }

  @override
  String get routine_challenge_saved => 'Challenge saved';

  @override
  String get routine_challenge_joined => 'You joined the challenge';

  @override
  String get routine_group_members_empty => 'No shared routines';

  @override
  String get routine_sort_order_updated => 'Order updated';

  @override
  String get routine_error_generic => 'Something went wrong';

  @override
  String get widgetSettings_routineSummary => 'Today\'s Routines';

  @override
  String get nav_routines => 'Routines';

  @override
  String get routine_badges_title => 'My Badges';

  @override
  String get routine_overview_title => 'Statistics';

  @override
  String get routine_overview_heatmap_title => 'Overall Completion Heatmap';

  @override
  String get routine_overview_previous_period => 'Previous period';

  @override
  String get routine_overview_next_period => 'Next period';

  @override
  String get routine_overview_this_week => 'This Week';

  @override
  String get routine_overview_this_month => 'This Month';

  @override
  String get routine_overview_weekly_title => 'This Week\'s Habit Performance';

  @override
  String get routine_overview_achieved => 'Achieved';

  @override
  String get routine_overview_not_achieved => 'Not Achieved';

  @override
  String get routine_overview_total_checked => 'Total Checked';

  @override
  String get routine_daily_goal_title => 'Today\'s Goal';

  @override
  String get routine_daily_goal_setting => 'Set Daily Goal';

  @override
  String routine_daily_goal_count_label(int total, int count) {
    return '$count of $total habits';
  }

  @override
  String routine_daily_goal_encourage(int count) {
    return '$count a day and you have succeeded';
  }

  @override
  String get routine_daily_goal_exceeds_total =>
      'Your goal is higher than the number of habits you have. Add more habits or lower the goal.';

  @override
  String routine_daily_goal_today_progress(int checked, int target) {
    return 'Today $checked / $target';
  }

  @override
  String get routine_daily_goal_achieved_today => 'Goal reached today!';

  @override
  String routine_daily_goal_bonus(int count) {
    return 'Bonus +$count';
  }

  @override
  String routine_daily_goal_streak(int days) {
    return '$days-day streak';
  }

  @override
  String routine_daily_goal_streak_longest(int days) {
    return 'Best $days days';
  }

  @override
  String get routine_daily_goal_rate => 'Goal Achievement';

  @override
  String routine_daily_goal_achieved_days(int achieved, int total) {
    return '$achieved of $total days';
  }

  @override
  String get routine_daily_goal_saved => 'Goal saved';

  @override
  String get routine_daily_goal_raise_title => 'Ready to aim higher?';

  @override
  String routine_daily_goal_raise_body(
    int average,
    int current,
    int suggested,
  ) {
    return 'You have been passing your goal often these past two weeks, averaging $average a day.\n\nShall we raise your daily goal from $current to $suggested?';
  }

  @override
  String get routine_daily_goal_raise_accept => 'Raise it';

  @override
  String get routine_daily_goal_keep => 'Keep it as is';

  @override
  String get routine_daily_goal_lower_title => 'Want to ease off for now?';

  @override
  String routine_daily_goal_lower_body(int current, int suggested) {
    return 'Busy stretch lately? There is no need to push.\n\nYou could drop your daily goal from $current to $suggested. You can always raise it again.';
  }

  @override
  String get routine_daily_goal_lower_accept => 'Lower it';

  @override
  String get routine_daily_goal_included_section =>
      'Habits Counted Toward Your Goal';

  @override
  String routine_daily_goal_included_summary(int included) {
    return '$included habits count toward your goal';
  }

  @override
  String get routine_daily_goal_group_daily => 'Everyday Habits';

  @override
  String get routine_daily_goal_group_periodic => 'Periodic Habits';

  @override
  String get routine_daily_goal_periodic_hint =>
      'Turning this on treats it as an everyday habit. A 3-times-a-week habit will still show as incomplete on the remaining days once you have done all 3.';

  @override
  String get routine_daily_goal_freq_daily => 'Daily';

  @override
  String routine_daily_goal_freq_weekly_count(int count) {
    return '${count}x per week';
  }

  @override
  String routine_daily_goal_freq_monthly_count(int count) {
    return '${count}x per month';
  }

  @override
  String get routine_daily_goal_no_included =>
      'No habits are counted toward your goal yet. Turn some on below.';

  @override
  String get routine_daily_goal_no_routines =>
      'You have not added any habits yet';

  @override
  String routine_overview_total_routines(int count) {
    return 'Based on $count habits';
  }

  @override
  String get routine_badges_empty => 'No badges earned yet';

  @override
  String get routine_badge_earned_title => 'Badge Earned!';

  @override
  String get routine_badge_earned_confirm => 'OK';

  @override
  String get routine_leaderboard_metric_goalRate => 'Goal Rate';

  @override
  String get routine_leaderboard_metric_goalStreak => 'Streak';

  @override
  String routine_leaderboard_goal_days(int achieved, int total) {
    return '$achieved / $total days';
  }

  @override
  String routine_leaderboard_streak_days(int days) {
    return '$days-day streak';
  }

  @override
  String get routine_leaderboard_empty =>
      'No group members with shared routines';

  @override
  String get routine_group_add => 'Add Routine';

  @override
  String get routine_group_edit => 'Edit Routine';

  @override
  String get routine_group_delete => 'Delete Routine';

  @override
  String get routine_group_delete_confirm =>
      'Delete this routine?\nHabits in it won\'t be deleted and will become standalone habits.';

  @override
  String get routine_group_field_title_hint => 'e.g. Morning Routine';

  @override
  String get routine_group_save => 'Save';

  @override
  String get routine_group_standalone_section_title => 'Standalone Habits';

  @override
  String get routine_table_header_number => 'No.';

  @override
  String get routine_table_header_habit => 'Habit';

  @override
  String get routine_table_header_check => 'Check';

  @override
  String get routine_group_error_generic => 'Something went wrong';

  @override
  String get routine_field_memo => 'Memo';

  @override
  String get routine_field_memo_hint => 'Add a note about this habit';

  @override
  String get routine_field_importance => 'Importance';

  @override
  String get routine_importance_low => 'Low';

  @override
  String get routine_importance_medium => 'Medium';

  @override
  String get routine_importance_high => 'High';

  @override
  String get routine_field_time_filter => 'Time of Day';

  @override
  String get routine_time_filter_morning => 'Morning';

  @override
  String get routine_time_filter_afternoon => 'Afternoon';

  @override
  String get routine_time_filter_evening => 'Evening';

  @override
  String get routine_time_filter_none => 'Not set';

  @override
  String get routine_field_category => 'Category';

  @override
  String get routine_field_category_none => 'Uncategorized';

  @override
  String get routine_category_title => 'Categories';

  @override
  String get routine_category_add => 'Add Category';

  @override
  String get routine_category_edit => 'Edit Category';

  @override
  String get routine_category_delete => 'Delete Category';

  @override
  String get routine_category_delete_confirm =>
      'Delete this category?\nHabits in it won\'t be deleted and will become uncategorized.';

  @override
  String get routine_category_save => 'Save';

  @override
  String get routine_category_field_title_hint => 'e.g. Healthy Living';

  @override
  String get routine_category_error_generic => 'Something went wrong';

  @override
  String get routine_category_empty => 'No categories yet';

  @override
  String get routine_category_filter_all => 'All';

  @override
  String get routine_category_picker_title => 'Select Categories';

  @override
  String get routine_category_edit_mode => 'Edit';

  @override
  String get routine_category_edit_mode_done => 'Done';

  @override
  String get routine_category_reorder_hint => 'Press the handle to reorder';

  @override
  String get routine_category_select_done => 'Done';

  @override
  String get routine_category_none_selected => 'Select category';

  @override
  String get routine_field_record_type => 'Record Type';

  @override
  String get routine_record_type_boolean => 'Simple check';

  @override
  String get routine_record_type_text => 'Text';

  @override
  String get routine_record_type_time => 'Time';

  @override
  String get routine_record_type_numeric => 'Number';

  @override
  String get routine_record_type_readonly_hint =>
      'Record type can\'t be changed after creation';

  @override
  String get routine_check_dialog_title => 'Log Entry';

  @override
  String get routine_check_dialog_text_label => 'Content';

  @override
  String get routine_check_dialog_numeric_label => 'Value';

  @override
  String get routine_check_dialog_time_label => 'Time';

  @override
  String get routine_check_dialog_confirm => 'Check';

  @override
  String get routine_check_dialog_cancel => 'Cancel';

  @override
  String get routine_status_active => 'Active';

  @override
  String get routine_status_paused => 'Paused';

  @override
  String get routine_status_ended => 'Ended';

  @override
  String get routine_pause => 'Pause';

  @override
  String get routine_pause_confirm =>
      'Pause this habit?\nYou won\'t be able to check it while paused.';

  @override
  String get routine_resume => 'Resume';

  @override
  String get routine_resume_success => 'Resumed';

  @override
  String get routine_pause_error => 'Failed to pause';

  @override
  String get routine_resume_error => 'Failed to resume';

  @override
  String get routine_end => 'End';

  @override
  String get routine_end_confirm =>
      'End this habit?\nCheck history will be preserved.';

  @override
  String get routine_frequency_type_daily => 'Daily';

  @override
  String get routine_frequency_type_weekly => 'Weekly';

  @override
  String get routine_frequency_type_monthly => 'Monthly';

  @override
  String get routine_weekly_mode_count_only => 'N times/week';

  @override
  String get routine_weekly_mode_fixed_days => 'Specific days';

  @override
  String get routine_field_target_days => 'Repeat Days';

  @override
  String get routine_day_sun => 'Sun';

  @override
  String get routine_day_mon => 'Mon';

  @override
  String get routine_day_tue => 'Tue';

  @override
  String get routine_day_wed => 'Wed';

  @override
  String get routine_day_thu => 'Thu';

  @override
  String get routine_day_fri => 'Fri';

  @override
  String get routine_day_sat => 'Sat';

  @override
  String get routine_error_weekly_mode_required =>
      'Please choose a weekly repeat mode';

  @override
  String get routine_error_weekly_target_required =>
      'Please set a weekly target count';

  @override
  String get routine_error_fixed_days_required =>
      'Please select at least one day';

  @override
  String get routine_error_monthly_target_required =>
      'Please set a monthly target count';

  @override
  String get emoji_picker_more => 'More emojis';

  @override
  String get emoji_picker_custom_selected => 'A custom emoji is selected';

  @override
  String get emoji_picker_search_hint => 'Search emoji';

  @override
  String get emoji_picker_no_result => 'No results found';

  @override
  String get emoji_picker_category_recent => 'Recent';

  @override
  String get emoji_picker_category_smileys => 'Smileys';

  @override
  String get emoji_picker_category_animals => 'Animals';

  @override
  String get emoji_picker_category_foods => 'Food';

  @override
  String get emoji_picker_category_travel => 'Travel';

  @override
  String get emoji_picker_category_activities => 'Activities';

  @override
  String get emoji_picker_category_objects => 'Objects';

  @override
  String get emoji_picker_category_symbols => 'Symbols';

  @override
  String get emoji_picker_category_flags => 'Flags';

  @override
  String get memo_tag_filter_clear => 'Clear tag filter';

  @override
  String get memo_section_pinned => 'Pinned';

  @override
  String memo_pinned_expand(int count) {
    return 'Show $count more';
  }

  @override
  String get memo_pinned_collapse => 'Collapse';

  @override
  String get memo_pin_add => 'Pin to dashboard';

  @override
  String get memo_pin_remove => 'Unpin';

  @override
  String get memo_pin_error => 'Couldn\'t change the pin';

  @override
  String get memo_pin_added => 'Pinned to the top and added to your dashboard.';

  @override
  String get memo_pin_removed => 'Unpinned.';

  @override
  String memo_duplicate_title(String title) {
    return '$title (copy)';
  }

  @override
  String get memo_tag_input_hint => 'Type a tag, then add';

  @override
  String get memo_editor_paste_failed => 'Couldn\'t paste from the clipboard.';

  @override
  String get memo_editor_link_card_add => 'Add link card';

  @override
  String get memo_editor_image => 'Image';

  @override
  String get memo_editor_paste_formatted => 'Paste with formatting';

  @override
  String get memo_editor_link_apply => 'Add link';

  @override
  String get memo_editor_link_select_first => 'Select text first';

  @override
  String get memo_editor_bold => 'Bold';

  @override
  String get memo_editor_italic => 'Italic';

  @override
  String get memo_editor_strikethrough => 'Strikethrough';

  @override
  String get memo_editor_heading1 => 'Heading 1';

  @override
  String get memo_editor_heading2 => 'Heading 2 (checklist section)';

  @override
  String get memo_editor_bullet_list => 'Bulleted list';

  @override
  String get memo_editor_numbered_list => 'Numbered list';

  @override
  String get memo_editor_undo => 'Undo';

  @override
  String get memo_editor_redo => 'Redo';

  @override
  String get savings_title => 'Group savings';

  @override
  String get savings_select_group => 'Choose a group';

  @override
  String get savings_intro_title => 'Set a goal and save together';

  @override
  String get savings_intro_body =>
      'Create a goal — a trip, an emergency fund, a new appliance — and add money automatically each month or whenever you like.';

  @override
  String get savings_intro_tip =>
      'It works for any group — friends or coworkers, not just family.';

  @override
  String get savings_list_empty => 'No savings goals yet\nTap + to add one';

  @override
  String savings_achievement_rate(String rate) {
    return '$rate% saved';
  }

  @override
  String get savings_deposit => 'Deposit';

  @override
  String get savings_withdraw => 'Withdraw';

  @override
  String get savings_amount_label => 'Amount (KRW)';

  @override
  String get savings_memo_label => 'Note (optional)';

  @override
  String get savings_withdraw_reason_label => 'Reason (required)';

  @override
  String get savings_delete_title => 'Delete goal';

  @override
  String savings_delete_message(String name) {
    return 'Delete \'$name\'?\nThis can\'t be undone.';
  }

  @override
  String get savings_detail_title => 'Savings goal';

  @override
  String get savings_goal_reached => 'Goal reached!';

  @override
  String savings_target_amount(String amount) {
    return 'Target: $amount';
  }

  @override
  String get savings_auto_deposit => 'Auto deposit';

  @override
  String savings_auto_deposit_monthly(String amount) {
    return '$amount/month';
  }

  @override
  String get savings_auto_deposit_pause => 'Pause auto deposit';

  @override
  String get savings_auto_deposit_resume => 'Resume auto deposit';

  @override
  String get savings_recent_transactions => 'Recent activity';

  @override
  String get savings_view_all => 'View all';

  @override
  String get savings_transactions_empty => 'No transactions yet.';

  @override
  String get savings_transactions_load_error => 'Couldn\'t load transactions';

  @override
  String get savings_filter_auto => 'Auto';

  @override
  String get savings_form_title_add => 'New savings goal';

  @override
  String get savings_form_title_edit => 'Edit savings goal';

  @override
  String get savings_form_submit_edit => 'Save changes';

  @override
  String get savings_form_save_error => 'Couldn\'t save';

  @override
  String get savings_field_name => 'Goal name *';

  @override
  String get savings_field_name_required => 'Enter a goal name';

  @override
  String get savings_field_description => 'Description (optional)';

  @override
  String get savings_field_target => 'Target amount (optional, KRW)';

  @override
  String get savings_field_target_hint => 'e.g. 1000000';

  @override
  String get savings_field_target_helper =>
      'Leave it blank to keep saving without a fixed target, like an emergency fund.';

  @override
  String get savings_field_amount_invalid => 'Enter a valid amount';

  @override
  String get savings_field_auto_deposit_desc =>
      'Add money automatically every month';

  @override
  String get savings_field_monthly_amount => 'Monthly amount (KRW)';

  @override
  String get savings_field_monthly_amount_hint => 'e.g. 100000';

  @override
  String get savings_field_monthly_amount_required => 'Enter a monthly amount';

  @override
  String get savings_field_deposit_day => 'Day of month (1–31)';

  @override
  String get savings_field_deposit_day_hint => 'e.g. 25';

  @override
  String get savings_field_deposit_day_helper =>
      'If a month is shorter, it runs on the last day.';

  @override
  String get savings_field_deposit_day_invalid =>
      'Enter a day between 1 and 31';

  @override
  String get savings_field_include_assets => 'Include in assets';

  @override
  String get savings_field_include_assets_desc =>
      'Your balance shows up in the assets overview.';

  @override
  String get vote_title => 'Votes';

  @override
  String get vote_filter_ongoing => 'Open';

  @override
  String get vote_filter_closed => 'Closed';

  @override
  String get vote_status_ongoing => 'Open';

  @override
  String get vote_status_closed => 'Closed';

  @override
  String get vote_select_group => 'Choose a group to see its votes';

  @override
  String get vote_list_empty => 'No votes yet\nTap + to create one';

  @override
  String get vote_list_load_error => 'Couldn\'t load votes';

  @override
  String get vote_detail_load_error => 'Couldn\'t load this vote';

  @override
  String vote_participants(int count) {
    return '$count voted';
  }

  @override
  String get vote_participated => 'Voted';

  @override
  String get vote_deadline_passed => 'Closed';

  @override
  String vote_deadline_days(int days) {
    return 'Closes in ${days}d';
  }

  @override
  String vote_deadline_hours(int hours) {
    return 'Closes in ${hours}h';
  }

  @override
  String vote_deadline_minutes(int minutes) {
    return 'Closes in ${minutes}m';
  }

  @override
  String get vote_delete => 'Delete vote';

  @override
  String get vote_delete_message => 'Delete this vote?\nIt can\'t be restored.';

  @override
  String get vote_delete_failed => 'Couldn\'t delete';

  @override
  String get vote_submit_success => 'Your vote is in';

  @override
  String get vote_submit_failed => 'Couldn\'t submit your vote';

  @override
  String get vote_multiple_choice_badge => 'Multiple choice';

  @override
  String get vote_anonymous_badge => 'Anonymous';

  @override
  String get vote_submit => 'Vote';

  @override
  String get vote_revote => 'Change my vote';

  @override
  String vote_option_result(int count, String percent) {
    return '$count votes ($percent%)';
  }

  @override
  String get vote_create_title => 'New vote';

  @override
  String get vote_field_title => 'Title *';

  @override
  String get vote_field_title_required => 'Enter a title';

  @override
  String get vote_field_description => 'Description (optional)';

  @override
  String get vote_options_section => 'Options';

  @override
  String vote_option_hint(int index) {
    return 'Option $index';
  }

  @override
  String get vote_options_min => 'Add at least two options';

  @override
  String get vote_create_failed => 'Couldn\'t create the vote';

  @override
  String get vote_allow_multiple => 'Allow multiple choices';

  @override
  String get vote_allow_multiple_desc =>
      'People can pick more than one option.';

  @override
  String get vote_anonymous => 'Anonymous vote';

  @override
  String get vote_anonymous_desc => 'Voter names stay hidden.';

  @override
  String get vote_deadline => 'Closing time';

  @override
  String get vote_deadline_none => 'Not set (close manually)';

  @override
  String get todo_label_dueDate => 'Due date';

  @override
  String get todo_label_category => 'Category';

  @override
  String get todo_label_createdAt => 'Created';

  @override
  String get todo_label_completedAt => 'Completed';

  @override
  String get todo_label_status => 'Status';

  @override
  String get todo_drag_to_move => 'Drag to move';

  @override
  String get common_more => 'Show more';

  @override
  String get cart_total => 'Total';

  @override
  String get cart_save_error => 'Couldn\'t save';

  @override
  String get cart_price_unit => 'Per item';

  @override
  String get cart_price_total => 'Total';

  @override
  String get cart_price_unit_label => 'Price per item';

  @override
  String get cart_price_total_label => 'Total price';

  @override
  String get cart_price_unit_hint => 'Enter price per item';

  @override
  String get cart_price_total_hint => 'Enter total price';

  @override
  String get cart_extra_show => 'Add unit and note';

  @override
  String get cart_extra_hide => 'Hide unit and note';

  @override
  String get cart_shopping_date => 'Shopping date';

  @override
  String get cart_select_date => 'Pick a date';

  @override
  String get cart_default_description => 'Grocery shopping';

  @override
  String get settings_myReportsTitle => 'My reports';

  @override
  String get settings_myReportsSubtitle => 'See the reports you\'ve submitted';

  @override
  String get settings_commonRolesTitle => 'Shared roles';

  @override
  String get settings_commonRolesSubtitle =>
      'Roles that apply across the whole service';

  @override
  String get settings_userAdminTitle => 'Users and accounts';

  @override
  String get settings_userAdminSubtitle =>
      'Edit subscriptions, schedule and process account deletion';

  @override
  String get settings_reportAdminTitle => 'Reports';

  @override
  String get settings_reportAdminSubtitle =>
      'Receive and handle member reports';

  @override
  String get settings_replayTutorial => 'Replay the tutorial';

  @override
  String get settings_replayTutorialBody =>
      'You can watch the intro slides and feature guides again from the start.';

  @override
  String get settings_replayTutorialConfirm => 'Replay';

  @override
  String get settings_replayTutorialDone =>
      'The tutorial will show the next time you open the app.';

  @override
  String get settings_personalColor => 'Your color';

  @override
  String get settings_personalColorPick => 'Pick your color';

  @override
  String get widgetSettings_addWidget => 'Add a widget';

  @override
  String get widgetSettings_addAnniversary => 'Add an anniversary';

  @override
  String get report_title => 'Report';

  @override
  String get report_reason => 'Reason';

  @override
  String get report_detail => 'Details (optional)';

  @override
  String get report_detail_hint => 'Add anything else we should know';

  @override
  String get report_submit => 'Submit report';

  @override
  String get report_submitted => 'Your report has been submitted.';

  @override
  String get report_submit_failed => 'Couldn\'t submit the report';

  @override
  String get report_empty => 'No reports';

  @override
  String get report_admin_title => 'Reports';

  @override
  String get report_handle_title => 'Handle report';

  @override
  String get report_handle_status => 'Status';

  @override
  String get report_handle_memo => 'Note (optional)';

  @override
  String get report_handle_memo_hint => 'What did you do about it?';

  @override
  String get report_handle_done => 'Done';

  @override
  String get report_handled => 'The report has been handled.';

  @override
  String get report_handle_failed => 'Couldn\'t handle the report';

  @override
  String get group_invite_cancel => 'Cancel invite';

  @override
  String group_invite_cancel_message(String email) {
    return 'Cancel the invite sent to $email?';
  }

  @override
  String get group_invite_canceled => 'Invite canceled';

  @override
  String group_invite_resent(String email) {
    return 'Invite resent to $email';
  }

  @override
  String get group_invite_resend => 'Resend';

  @override
  String get group_color_change_failed => 'Couldn\'t change the color';

  @override
  String get group_color_reset => 'Reset to the group\'s default color';

  @override
  String get group_color_reset_failed => 'Couldn\'t reset the color';

  @override
  String get group_order_saved => 'Group order saved';

  @override
  String get group_members_empty => 'No members';

  @override
  String get group_member_remove => 'Remove member';

  @override
  String get group_member_removed => 'Member removed';

  @override
  String get group_role_change => 'Change role';

  @override
  String get group_role_changed => 'Role changed';

  @override
  String get group_roles_load_error => 'Couldn\'t load roles';

  @override
  String get group_regenerate_code_message =>
      'Generate a new invite code?\nThe old one will stop working.';

  @override
  String get group_transfer_ownership => 'Transfer ownership';

  @override
  String get group_transfer_confirm => 'Transfer';

  @override
  String group_transfer_message(String name) {
    return 'Make $name the group owner?';
  }

  @override
  String get group_transfer_failed => 'Couldn\'t transfer ownership';

  @override
  String get invite_title => 'Group invite';

  @override
  String get invite_joining => 'Joining the group…';

  @override
  String get invite_joined => 'You\'re in!';

  @override
  String get invite_go_home => 'Go home';

  @override
  String get invite_login_required => 'Sign in to join this group.';

  @override
  String get invite_login => 'Sign in';

  @override
  String get invite_failed => 'Couldn\'t join';

  @override
  String group_transfer_done(String name) {
    return '$name is now the group owner';
  }

  @override
  String invite_code_label(String code) {
    return 'Invite code: $code';
  }

  @override
  String get invite_unknown_error => 'Something went wrong.';

  @override
  String get common_unknownError => 'Something went wrong';

  @override
  String get common_sortOrderSaved => 'Order saved';

  @override
  String get common_saveFailed => 'Couldn\'t save';

  @override
  String get common_deleteFailed => 'Couldn\'t delete';

  @override
  String get common_noSearchResults => 'No results';

  @override
  String get role_common_title => 'Shared roles';

  @override
  String get role_create => 'New role';

  @override
  String get role_list_load_error => 'Couldn\'t load roles';

  @override
  String get role_list_empty => 'No shared roles yet';

  @override
  String get role_list_empty_subtitle => 'Tap + to create one';

  @override
  String get role_info_load_error => 'Couldn\'t load the role';

  @override
  String get role_not_found => 'Role not found';

  @override
  String role_permissions_title(String name) {
    return '$name permissions';
  }

  @override
  String get role_permission_search => 'Search permissions';

  @override
  String get role_permissions_load_error => 'Couldn\'t load permissions';

  @override
  String get role_permissions_saved => 'Permissions saved';

  @override
  String get role_edit_title => 'Edit shared role';

  @override
  String get role_create_title => 'New shared role';

  @override
  String get role_created => 'Role created';

  @override
  String get role_updated => 'Role updated';

  @override
  String get role_create_failed => 'Couldn\'t create the role';

  @override
  String get role_update_failed => 'Couldn\'t update the role';

  @override
  String get role_field_name => 'Role name';

  @override
  String get role_field_name_hint => 'e.g. ADMIN, MEMBER';

  @override
  String get role_field_name_required => 'Enter a role name';

  @override
  String get role_default => 'Default role';

  @override
  String get role_default_desc => 'Given automatically to new members';

  @override
  String get role_default_badge => 'Default';

  @override
  String get role_color => 'Role color';

  @override
  String get role_delete => 'Delete role';

  @override
  String role_delete_message(String name) {
    return 'Delete the $name role?\nThis can\'t be undone.';
  }

  @override
  String get role_deleted => 'Role deleted';

  @override
  String get role_manage_permissions => 'Permissions';

  @override
  String get permission_name_hint => 'e.g. VIEW_REPORT';

  @override
  String get permission_desc_hint => 'Describe what this permission allows';

  @override
  String get permission_category_custom => '+ Custom';

  @override
  String get permission_category_new => 'New category name';

  @override
  String get permission_category_required => 'Enter a category name';

  @override
  String get childcare_savings_plan => 'Savings plan';

  @override
  String get childcare_savings_ongoing => 'In progress';

  @override
  String get childcare_savings_matured => 'Matured';

  @override
  String get childcare_interest_simple => 'Simple';

  @override
  String get childcare_interest_compound => 'Compound';

  @override
  String get childcare_interest_type => 'Interest type';

  @override
  String get childcare_monthly_deposit => 'Monthly deposit';

  @override
  String get childcare_interest_rate => 'Interest rate';

  @override
  String get childcare_period => 'Period';

  @override
  String get childcare_savings_start => 'Start a savings plan';

  @override
  String get childcare_savings_start_desc =>
      'Money is deposited automatically each month';

  @override
  String get childcare_savings_cancel => 'Cancel early';

  @override
  String get childcare_savings_cancel_title => 'Cancel the savings plan';

  @override
  String get childcare_savings_cancel_message =>
      'You\'ll get the principal back without interest.\nCancel anyway?';

  @override
  String get childcare_savings_cancel_confirm => 'Cancel plan';

  @override
  String get childcare_savings_canceled => 'Savings plan canceled';

  @override
  String get childcare_savings_cancel_failed => 'Couldn\'t cancel the plan';

  @override
  String get childcare_savings_started => 'Savings plan started';

  @override
  String get childcare_savings_create_title => 'New savings plan';

  @override
  String get childcare_savings_monthly_points => 'Points per month';

  @override
  String get childcare_savings_annual_rate => 'Annual rate';

  @override
  String childcare_savings_rate_helper(String rate) {
    return 'Default based on the 3-year treasury rate ($rate%)';
  }

  @override
  String get childcare_savings_rate_loading => 'Loading the treasury rate…';

  @override
  String get childcare_start_date => 'Start date';

  @override
  String get childcare_maturity_date => 'Maturity date';

  @override
  String get childcare_total_deposit => 'Total deposits';

  @override
  String get childcare_expected_interest => 'Interest';

  @override
  String get childcare_maturity_amount => 'At maturity';

  @override
  String childcare_months(int months) {
    return '$months months';
  }

  @override
  String get childcare_start => 'Start';

  @override
  String get childcare_allowance_missing => 'No allowance plan yet';

  @override
  String get childcare_allowance_missing_desc =>
      'Set the monthly points and payout day';

  @override
  String get childcare_negotiation_passed => 'The review date has passed';

  @override
  String get childcare_negotiation_upcoming => 'The review date is coming up';

  @override
  String childcare_negotiation_passed_desc(int days, String date) {
    return 'It was $days days ago ($date). Time to review the allowance.';
  }

  @override
  String childcare_negotiation_today(String date) {
    return 'Today is the review date! ($date)';
  }

  @override
  String get childcare_cashout => 'Cash out points';

  @override
  String get childcare_cashout_button => 'Cash out';

  @override
  String get childcare_cashout_points => 'Points to cash out';

  @override
  String get childcare_cashout_failed =>
      'Couldn\'t cash out. Please try again.';

  @override
  String childcare_cashout_description(String amount) {
    return 'Cashed out points ($amount KRW)';
  }

  @override
  String childcare_cashout_done(String points, String amount) {
    return 'Cashed out ${points}P for $amount KRW';
  }

  @override
  String childcare_cashout_rate(String ratio, String balance) {
    return '1P = $ratio KRW · ${balance}P available';
  }

  @override
  String childcare_cashout_approx(String amount) {
    return '≈ $amount KRW';
  }

  @override
  String get childcare_rule_apply => 'Apply rule';

  @override
  String get childcare_rule_apply_penalty => 'Apply penalty';

  @override
  String childcare_rule_apply_plus_message(String name, String points) {
    return '\"$name\"\nGive ${points}P.';
  }

  @override
  String childcare_rule_apply_minus_message(String name, String points) {
    return '\"$name\" broken.\nDeduct ${points}P.';
  }

  @override
  String get childcare_rule_give => 'Give';

  @override
  String get childcare_rule_deduct => 'Deduct';

  @override
  String childcare_points_given(String points) {
    return 'Gave ${points}P';
  }

  @override
  String childcare_points_deducted(String points) {
    return 'Deducted ${points}P';
  }

  @override
  String get childcare_rule_delete => 'Delete rule';

  @override
  String childcare_rule_delete_message(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get common_deleted => 'Deleted';

  @override
  String get common_saved => 'Saved';

  @override
  String get childcare_rule_type_plus => 'Reward rule';

  @override
  String get childcare_rule_type_minus => 'Penalty rule';

  @override
  String get childcare_rule_type_info => 'Plain rule';

  @override
  String get childcare_rule_help_title => 'What are rules?';

  @override
  String get childcare_rule_help_body =>
      'Rules tie points to your child\'s actions — points for good habits, deductions when a promise is broken.';

  @override
  String get childcare_rule_help_tip =>
      'The clearer the rule, the better. Vague rules invite arguments — and setting them together builds trust.';

  @override
  String get childcare_rule_examples_plus => 'Reward examples';

  @override
  String get childcare_rule_examples_minus => 'Penalty examples';

  @override
  String get childcare_rule_examples_info => 'Plain rule examples';

  @override
  String get childcare_rule_example_plus1 =>
      'Finished homework on their own  +10P';

  @override
  String get childcare_rule_example_plus2 =>
      'Went to bed before 9pm on their own  +5P';

  @override
  String get childcare_rule_example_plus3 =>
      'Cleared their dishes after a meal  +3P';

  @override
  String get childcare_rule_example_plus4 =>
      'A whole week without being late for school  +20P';

  @override
  String get childcare_rule_example_minus1 =>
      'Over an hour of phone time on a weekday  -10P';

  @override
  String get childcare_rule_example_minus2 => 'Still up after 10pm  -5P';

  @override
  String get childcare_rule_example_minus3 => 'Swore at a sibling  -15P';

  @override
  String get childcare_rule_example_minus4 =>
      'Came home later than the agreed 6pm  -10P';

  @override
  String get childcare_rule_example_info1 => 'Cash out up to 50P per month';

  @override
  String get childcare_rule_example_info2 => 'One shop item per day';

  @override
  String get childcare_rule_apply_note =>
      'Applying a rule updates the points right away.';

  @override
  String get childcare_rule_add => 'New rule';

  @override
  String get childcare_rule_edit => 'Edit rule';

  @override
  String get childcare_rule_type => 'Rule type';

  @override
  String get childcare_rule_type_plus_short => '+Points';

  @override
  String get childcare_rule_type_minus_short => '−Points';

  @override
  String get childcare_rule_type_info_short => 'Plain';

  @override
  String get childcare_rule_name_hint_plus => 'e.g. Did homework on their own';

  @override
  String get childcare_rule_name_hint_minus =>
      'e.g. Over 30 minutes of phone time';

  @override
  String get childcare_rule_name_hint_info => 'e.g. Monthly cash-out limit';

  @override
  String get childcare_rule_points_give => 'Points to give';

  @override
  String get childcare_rule_points_deduct => 'Points to deduct';

  @override
  String get childcare_rule_points_give_hint =>
      'Points given for the good habit';

  @override
  String get childcare_rule_points_deduct_hint => 'Points deducted when broken';

  @override
  String get childcare_save_failed => 'Couldn\'t save. Please try again.';

  @override
  String get childcare_child => 'Child';

  @override
  String childcare_allowance_plan_title(String name) {
    return '$name\'s allowance';
  }

  @override
  String get childcare_tab_settings => 'Settings';

  @override
  String get childcare_tab_change_history => 'Changes';

  @override
  String get childcare_allowance_setup => 'Set up the allowance';

  @override
  String get childcare_allowance_edit => 'Edit the allowance';

  @override
  String get childcare_monthly_points => 'Points per month';

  @override
  String get childcare_monthly_points_hint => 'e.g. 100';

  @override
  String get childcare_monthly_points_required => 'Enter the monthly points';

  @override
  String get childcare_number_required => 'Enter a number';

  @override
  String get childcare_pay_day => 'Payout day';

  @override
  String get childcare_day_unit => '';

  @override
  String get childcare_pay_day_helper =>
      'If a month is shorter, it pays on the last day';

  @override
  String childcare_day_value(String day) {
    return 'Day $day';
  }

  @override
  String get childcare_select_date => 'Pick a date';

  @override
  String get childcare_select_date_optional => 'Pick a date (optional)';

  @override
  String get childcare_point_ratio => '1 point = N KRW';

  @override
  String get childcare_point_ratio_hint => 'e.g. 10';

  @override
  String get childcare_point_ratio_helper =>
      'Just for reference, so the promise is clear';

  @override
  String get childcare_min_one => 'Enter a number of 1 or more';

  @override
  String get childcare_negotiation_date => 'Next review date (optional)';

  @override
  String get childcare_plan_save => 'Save plan';

  @override
  String get childcare_plan_update => 'Update plan';

  @override
  String get childcare_plan_saved => 'Allowance plan saved';

  @override
  String get childcare_current_plan => 'Current allowance';

  @override
  String get childcare_monthly_payout => 'Monthly';

  @override
  String get childcare_payout_day => 'Payout day';

  @override
  String childcare_payout_day_value(String day) {
    return 'Day $day of each month';
  }

  @override
  String get childcare_next_negotiation => 'Next review';

  @override
  String get childcare_history_empty => 'No changes yet';

  @override
  String get childcare_history_load_error => 'Couldn\'t load the history';

  @override
  String childcare_history_entry(String points, String day) {
    return '${points}P / day $day';
  }

  @override
  String childcare_ratio_value(String amount) {
    return '1P = $amount KRW';
  }

  @override
  String childcare_negotiation_suffix(String date) {
    return 'review $date';
  }

  @override
  String childcare_monthly_day(String day) {
    return 'Day $day each month';
  }

  @override
  String get childcare_item_use => 'Use item';

  @override
  String childcare_item_use_message(String name, String points) {
    return '\"$name\"\nSpend ${points}P.';
  }

  @override
  String get childcare_item_use_confirm => 'Use';

  @override
  String childcare_item_used(String name) {
    return 'Used \"$name\"';
  }

  @override
  String get childcare_item_use_failed => 'Couldn\'t use it. Please try again.';

  @override
  String get childcare_item_delete => 'Delete item';

  @override
  String childcare_item_delete_message(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get childcare_delete_failed => 'Couldn\'t delete. Please try again.';

  @override
  String get childcare_item_add => 'New shop item';

  @override
  String get childcare_item_edit => 'Edit shop item';

  @override
  String get childcare_item_name => 'Item name';

  @override
  String get childcare_item_name_hint => 'e.g. 30 more minutes of TV';

  @override
  String get childcare_item_points => 'Cost in points';

  @override
  String get childcare_shop_help_title => 'What is the shop?';

  @override
  String get childcare_shop_help_body =>
      'A list of rewards your child can buy with the points they\'ve earned — a reason to keep saving.';

  @override
  String get childcare_shop_examples => 'Example items';

  @override
  String get childcare_shop_example1 => '30 more minutes of TV';

  @override
  String get childcare_shop_example2 => 'An hour of gaming';

  @override
  String get childcare_shop_example3 => 'Pick a snack';

  @override
  String get childcare_shop_example4 => 'A late bedtime';

  @override
  String get childcare_shop_disable_note =>
      'Turn an item off to hide it from the list.';

  @override
  String get childcare_period_monthly => 'Monthly';

  @override
  String get childcare_period_yearly => 'Yearly';

  @override
  String get childcare_income => 'Earned';

  @override
  String get childcare_expense => 'Spent';

  @override
  String get childcare_net_change => 'Net';

  @override
  String get childcare_yearly_income => 'Earned this year';

  @override
  String get childcare_yearly_expense => 'Spent this year';

  @override
  String get childcare_balance_trend => 'Balance over time';

  @override
  String get childcare_monthly_status => 'By month';

  @override
  String get childcare_type_distribution => 'By type';

  @override
  String childcare_month_unit(String month) {
    return '$month';
  }

  @override
  String get childcare_no_income_this_month => 'Nothing earned this month';

  @override
  String get childcare_no_expense_this_month => 'Nothing spent this month';

  @override
  String get childcare_type_allowance => 'Allowance';

  @override
  String get childcare_type_reward => 'Reward';

  @override
  String get childcare_type_bonus => 'Bonus';

  @override
  String get childcare_type_interest => 'Interest';

  @override
  String get childcare_type_savings_withdraw => 'Savings out';

  @override
  String get childcare_type_penalty => 'Penalty';

  @override
  String get childcare_type_purchase => 'Shop';

  @override
  String get childcare_type_cashout => 'Cash out';

  @override
  String get childcare_type_savings_deposit => 'Savings';

  @override
  String get common_etc => 'Other';

  @override
  String get childcare_profile_add => 'Add a child';

  @override
  String get childcare_child_name => 'Child\'s name';

  @override
  String get childcare_child_name_hint => 'e.g. Minjun';

  @override
  String get childcare_child_name_required => 'Enter the child\'s name';

  @override
  String get childcare_birthdate => 'Date of birth';

  @override
  String get childcare_birthdate_required => 'Pick a date of birth';

  @override
  String get childcare_profile_added => 'Child added';

  @override
  String get childcare_profile_add_failed => 'Couldn\'t add. Please try again.';

  @override
  String childcare_date_full(String year, String month, String day) {
    return '$year-$month-$day';
  }

  @override
  String childcare_year_unit(String year) {
    return '$year';
  }

  @override
  String childcare_link_title(String name) {
    return 'Link $name\'s account';
  }

  @override
  String get childcare_link_linked => 'Account linked';

  @override
  String get childcare_link_unlinked => 'Not linked yet';

  @override
  String childcare_link_account_id(String id) {
    return 'Linked account: $id…';
  }

  @override
  String get childcare_link_guide => 'How linking works';

  @override
  String get childcare_link_guide1 =>
      'Your child needs their own account first.';

  @override
  String get childcare_link_guide2 =>
      'Once linked, they can check their own points.';

  @override
  String get childcare_link_guide3 => 'They can also deposit into savings.';

  @override
  String get childcare_link_button => 'Link an account';

  @override
  String get childcare_link_info => 'Linked account';

  @override
  String get childcare_link_info1 => 'They can check their points in the app.';

  @override
  String get childcare_link_info2 => 'They can deposit into savings.';

  @override
  String get childcare_link_done => 'Account linked';

  @override
  String get childcare_link_failed =>
      'Couldn\'t link. Check that your child has signed up.';

  @override
  String get childcare_bonus_give => 'Give a bonus';

  @override
  String get childcare_child_register => 'Add a child';

  @override
  String get childcare_allowance_setup_button => 'Set up allowance';

  @override
  String get childcare_link_account => 'Link account';

  @override
  String get childcare_bonus_desc =>
      'Give your child bonus points — for when you want to praise something outside the rules or shop.';

  @override
  String get childcare_bonus_points => 'Points';

  @override
  String get childcare_bonus_points_required => 'Enter the points';

  @override
  String get childcare_bonus_points_positive => 'Enter 1 or more';

  @override
  String get childcare_bonus_reason => 'Reason';

  @override
  String get childcare_bonus_reason_hint =>
      'e.g. Cleaned their room without being asked';

  @override
  String get childcare_bonus_reason_required => 'Enter a reason';

  @override
  String get childcare_bonus_given => 'Bonus given';

  @override
  String get common_deactivate => 'Turn off';

  @override
  String get common_activate => 'Turn on';

  @override
  String childcare_approx_money(String amount) {
    return '≈ $amount KRW';
  }

  @override
  String get childcare_points_per_month => 'P/mo';

  @override
  String childcare_plan_summary(String day, String amount) {
    return 'Day $day · 1P=$amount KRW';
  }

  @override
  String get task_recurring_guide => 'How repeats work';

  @override
  String get task_recurring_guide_body =>
      'Repeating events are created ahead of time like this.';

  @override
  String get task_recurring_daily_weekly => 'Daily / weekly';

  @override
  String get task_recurring_monthly_unit => 'Monthly';

  @override
  String get task_recurring_yearly_unit => 'Yearly';

  @override
  String get task_recurring_every_month => 'Every month';

  @override
  String get task_recurring_every_2months => 'Every 2 months';

  @override
  String get task_recurring_every_3months => 'Every 3 months';

  @override
  String get task_recurring_every_year => 'Every year';

  @override
  String get task_recurring_every_2years => 'Every 2 years';

  @override
  String task_recurring_ahead_months(String months) {
    return '$months months ahead';
  }

  @override
  String get task_recurring_ahead_3months => '3 months ahead';

  @override
  String get task_lunar => 'Lunar';

  @override
  String get task_lunar_leap_prefix => 'Leap ';

  @override
  String task_lunar_date(String prefix, String month, String day) {
    return 'Lunar $prefix$month/$day';
  }

  @override
  String get task_lunar_pick => 'Pick a lunar date';

  @override
  String get task_month => 'Month';

  @override
  String get task_day => 'Day';

  @override
  String task_month_value(String month) {
    return '$month';
  }

  @override
  String task_day_value(String day) {
    return '$day';
  }

  @override
  String get task_leap_month => 'Leap month';

  @override
  String get task_leap_month_desc =>
      'In years without a leap month, the same day of that month is used.';

  @override
  String get task_skip_settings => 'Skip settings';

  @override
  String get task_skip_weekend => 'Weekends';

  @override
  String get task_skip_holiday => 'Holidays';

  @override
  String get task_skip_when => 'When skipped';

  @override
  String get task_skip_do => 'Skip it';

  @override
  String get task_skip_next_weekday => 'Next weekday';

  @override
  String get anniversary_detail => 'Anniversary';

  @override
  String get anniversary_date => 'Date';

  @override
  String get anniversary_created_at => 'Added';

  @override
  String get anniversary_delete => 'Delete anniversary';

  @override
  String anniversary_delete_message(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get anniversary_delete_linked => 'Also delete the linked events';

  @override
  String get anniversary_delete_linked_desc => 'Uncheck to keep the events';

  @override
  String get anniversary_delete_failed => 'Couldn\'t delete';

  @override
  String get anniversary_days_elapsed => 'Days so far';

  @override
  String get anniversary_next => 'Next';

  @override
  String get anniversary_upcoming => 'Coming up';

  @override
  String get anniversary_collapse => 'Collapse';

  @override
  String anniversary_show_more(int count) {
    return '+$count more';
  }

  @override
  String get anniversary_every100 => 'Every 100 days (D+100, D+200…)';

  @override
  String get anniversary_everyYear => 'Every year (1st, 2nd…)';

  @override
  String get anniversary_auto_create => 'Create reminder events automatically';

  @override
  String get anniversary_manage => 'Anniversaries';

  @override
  String get anniversary_add => 'New anniversary';

  @override
  String get anniversary_edit => 'Edit anniversary';

  @override
  String get anniversary_load_failed => 'Couldn\'t load anniversaries';

  @override
  String get anniversary_empty => 'No anniversaries yet';

  @override
  String get anniversary_name => 'Name';

  @override
  String get anniversary_name_hint => 'e.g. Wedding anniversary';

  @override
  String get anniversary_name_required => 'Enter a name';

  @override
  String get anniversary_create_failed => 'Couldn\'t create it';

  @override
  String get anniversary_update_failed => 'Couldn\'t update it';

  @override
  String get common_date => 'Date';

  @override
  String get task_recurring_edit_title => 'Edit this repeating event?';

  @override
  String get task_recurring_edit_this => 'This event only';

  @override
  String get task_recurring_edit_following => 'This and following events';

  @override
  String get task_recurring_delete_title => 'Delete this repeating event?';

  @override
  String get task_recurring_delete_this => 'This event only';

  @override
  String get task_recurring_delete_following => 'This and following events';

  @override
  String get task_recurring_delete_all => 'All events in the series';

  @override
  String get task_label_type => 'Type';

  @override
  String get task_label_category => 'Category';

  @override
  String get task_label_createdAt => 'Created';

  @override
  String get task_completed => 'Done';

  @override
  String get task_inactive => '(inactive)';

  @override
  String task_start_at(String date, String time) {
    return 'Starts $date $time';
  }

  @override
  String task_end_at(String date, String time) {
    return 'Ends $date $time';
  }

  @override
  String task_end_time_only(String time) {
    return 'Ends $time';
  }

  @override
  String get task_type_calendarOnly => 'Calendar only';

  @override
  String get task_type_todoLinked => 'Calendar + to-do';

  @override
  String get task_type_todoOnly => 'To-do only';

  @override
  String get task_type_default => 'Event';

  @override
  String get task_coach_title_title => 'Event title';

  @override
  String get task_coach_title_desc =>
      'Name the event — short and clear works best.';

  @override
  String get task_coach_date_title => 'Date and time';

  @override
  String get task_coach_date_desc =>
      'Set the start and end dates, and the time.';

  @override
  String get task_coach_type_title => 'Event type';

  @override
  String get task_coach_type_desc => 'Choose an event, a to-do, or both.';

  @override
  String get task_coach_participants_title => 'Participants';

  @override
  String get task_coach_participants_desc =>
      'Invite group members — they\'ll get a notification.';

  @override
  String get common_skip => 'Skip';

  @override
  String get task_place_search_hint => 'Search a place or address';

  @override
  String get task_place_search_prompt => 'Search for a place';

  @override
  String get notif_settings => 'Notifications';

  @override
  String notif_hour_am(String hour) {
    return '$hour AM';
  }

  @override
  String get notif_hour_noon => 'Noon';

  @override
  String notif_hour_pm(String hour) {
    return '$hour PM';
  }

  @override
  String get notif_task => 'Events';

  @override
  String get notif_task_desc => 'Get a heads-up before an event starts';

  @override
  String get notif_todo => 'To-dos';

  @override
  String get notif_todo_desc => 'Get reminded before a to-do is due';

  @override
  String get notif_household => 'Household budget';

  @override
  String get notif_household_desc => 'Notifications about your budget';

  @override
  String get notif_assets => 'Assets';

  @override
  String get notif_assets_desc => 'Notifications when your assets change';

  @override
  String get notif_childcare => 'Child points';

  @override
  String get notif_childcare_desc => 'Notifications about child points';

  @override
  String get notif_group => 'Groups';

  @override
  String get notif_group_desc => 'Notifications about your groups';

  @override
  String get notif_savings => 'Savings';

  @override
  String get notif_savings_desc =>
      'Notifications about savings goals and deposits';

  @override
  String get notif_system => 'System';

  @override
  String get notif_system_desc => 'Important service notices';

  @override
  String get notif_weather => 'Weather';

  @override
  String get notif_weather_desc => 'Rain, snow, or a big temperature swing';

  @override
  String get notif_weather_time => 'Weather alert time';

  @override
  String get notif_weather_time_desc =>
      'Sent when you open the app after this time';

  @override
  String get notif_routine => 'Routines';

  @override
  String get notif_routine_desc => 'Reminders, badges, and a weekly summary';

  @override
  String get notif_routine_time => 'Routine reminder time';

  @override
  String get notif_routine_time_desc =>
      'We\'ll nudge you if anything is still unchecked by then';

  @override
  String get notif_unread => 'Unread';

  @override
  String get notif_mark_all_read => 'Mark all read';

  @override
  String get notif_view_all => 'See all';

  @override
  String get notif_mark_read => 'Mark as read';

  @override
  String get notif_action_failed => 'Couldn\'t update the notification';

  @override
  String notif_marked_read_count(int count) {
    return 'Marked $count as read';
  }

  @override
  String get notif_mark_all_failed => 'Couldn\'t mark all as read';

  @override
  String get notif_none_new => 'No new notifications';

  @override
  String get notif_load_failed => 'Couldn\'t load notifications';

  @override
  String get notif_permission => 'Notification permission';

  @override
  String get notif_permission_granted => 'Notifications allowed';

  @override
  String get notif_permission_denied => 'Notifications denied';

  @override
  String get notif_permission_on => 'On';

  @override
  String get notif_permission_off => 'Off';

  @override
  String get notif_permission_on_desc => 'You\'ll receive push notifications.';

  @override
  String get notif_permission_off_desc =>
      'Allow notifications to receive them.';

  @override
  String get notif_permission_request => 'Allow';

  @override
  String get notif_permission_settings => 'Open settings';

  @override
  String get location_permission => 'Location permission';

  @override
  String get location_permission_granted => 'Location allowed';

  @override
  String get location_permission_denied => 'Location denied';

  @override
  String get location_permission_on_desc =>
      'Your location is used for weather alerts.';

  @override
  String get location_permission_off_desc =>
      'Allow location to get weather alerts.\nIt\'s used only for weather alerts and is stored on our server.';

  @override
  String get notif_delete => 'Delete notification';

  @override
  String get notif_delete_message => 'Delete this notification?';

  @override
  String get notif_deleted => 'Notification deleted';

  @override
  String get notif_delete_failed => 'Couldn\'t delete the notification';

  @override
  String get notif_title => 'Notifications';

  @override
  String get notif_empty => 'No notifications';

  @override
  String get notif_history => 'Notification history';

  @override
  String get notif_history_desc => 'See the notifications you\'ve received';

  @override
  String get notif_settings_load_failed =>
      'Couldn\'t load notification settings';

  @override
  String get notif_test_send => 'Send a test notification';

  @override
  String get notif_test_send_desc => 'Sends a test to yourself (admin only)';

  @override
  String get notif_test_sent => 'Test notification sent';

  @override
  String get notif_test_failed => 'Couldn\'t send the test notification';

  @override
  String get common_anonymous => 'Anonymous';

  @override
  String get common_admin => 'Admin';

  @override
  String get common_updateDone => 'Save changes';

  @override
  String get qna_myQuestionsOnly => 'Mine only';

  @override
  String get qna_allCategories => 'All categories';

  @override
  String get qna_tab_pending => 'Pending';

  @override
  String get qna_tab_answered => 'Answered';

  @override
  String get qna_tab_resolved => 'Resolved';

  @override
  String qna_searchLabel(String query) {
    return 'Search: $query';
  }

  @override
  String get qna_writeQuestion => 'Ask a question';

  @override
  String get qna_editQuestion => 'Edit question';

  @override
  String get qna_searchByTitleOrContent => 'Search title or content';

  @override
  String qna_emptyByStatus(String status) {
    return 'No $status questions';
  }

  @override
  String qna_emptyByCategory(String category) {
    return 'No questions in $category';
  }

  @override
  String get qna_emptyMine =>
      'You haven\'t asked anything yet\nGo ahead and ask!';

  @override
  String get qna_listLoadError => 'Couldn\'t load questions';

  @override
  String get qna_contentLabel => 'Content';

  @override
  String get qna_titleLabel => 'Title';

  @override
  String get qna_contentHintDetailed =>
      'Describe it in detail — a screenshot helps us answer faster.';

  @override
  String get qna_contentMaxLength => 'Content can\'t exceed 5000 characters';

  @override
  String get qna_titleMin5 => 'Title must be at least 5 characters';

  @override
  String get qna_contentMin10 => 'Content must be at least 10 characters';

  @override
  String get qna_submitQuestion => 'Post question';

  @override
  String get qna_writeGuide => 'Before you ask';

  @override
  String get qna_writeGuideBody =>
      '• An admin will review and answer.\n• You\'ll get a notification when we reply.\n• You can edit or delete only while it\'s pending.';

  @override
  String get qna_visibility => 'Visibility';

  @override
  String get qna_createSuccessDetail =>
      'Your question is posted.\nWe\'ll notify you when it\'s answered.';

  @override
  String get qna_questionDetail => 'Question';

  @override
  String get qna_cannotEditResolved => 'Resolved questions can\'t be edited';

  @override
  String get qna_resolve => 'Resolve';

  @override
  String get qna_attachments => 'Attachments';

  @override
  String get qna_downloadNotReady => 'File download isn\'t available yet';

  @override
  String qna_answersCount(int count) {
    return 'Answers ($count)';
  }

  @override
  String get qna_resolveTitle => 'Mark as resolved';

  @override
  String get qna_resolveMessage =>
      'Mark this as resolved?\nYou won\'t be able to edit it afterwards.';

  @override
  String get qna_editAnswer => 'Edit answer';

  @override
  String get qna_deleteAnswer => 'Delete answer';

  @override
  String get qna_deleteAnswerMessage =>
      'Delete this answer?\nIt can\'t be restored.';

  @override
  String get qna_writeAnswer => 'Write an answer';

  @override
  String get qna_submitAnswer => 'Post answer';

  @override
  String get qna_submittingAnswer => 'Posting…';

  @override
  String get qna_resolvedPrompt => 'Did this solve it?';

  @override
  String get qna_resolvedPromptBody =>
      'If the answer helped, mark it resolved.\nWe\'ll do it automatically after a week.';

  @override
  String get common_collapse => 'Collapse';

  @override
  String get common_required_mark => '(required)';

  @override
  String get common_errorOccurred => 'Something went wrong';

  @override
  String get asset_account_order_saved => 'Account order saved';

  @override
  String get asset_management => 'Asset management';

  @override
  String get asset_management_placeholder => 'Asset management appears here';

  @override
  String get asset_record_reminder => 'Record reminder';

  @override
  String get asset_record_reminder_desc =>
      'We\'ll remind you to add a record on this day each month.';

  @override
  String get asset_reminder_day => 'Reminder day';

  @override
  String asset_monthly_day(String day) {
    return 'Day $day each month';
  }

  @override
  String get asset_reminder_day_note =>
      'For days 29–31, we send on the last day of shorter months.';

  @override
  String get asset_withdrawal_record => 'Withdrawal';

  @override
  String asset_withdrawal_date(String date) {
    return 'Date: $date';
  }

  @override
  String get asset_withdrawal_type => 'Withdrawal type';

  @override
  String get asset_withdrawal_type_desc =>
      'Did the money come out of your principal or your gains?';

  @override
  String get asset_withdrawal_type_required => 'Pick a withdrawal type';

  @override
  String get asset_withdrawal_amount => 'Amount';

  @override
  String get asset_amount_invalid => 'Enter a valid amount';

  @override
  String get asset_memo_optional => 'Note (optional)';

  @override
  String get asset_memo_hint => 'e.g. Living expenses, taking profit';

  @override
  String get asset_save_failed => 'Couldn\'t save';

  @override
  String get asset_withdrawal_from_principal =>
      'From principal (spending, transfers)';

  @override
  String get asset_holding_add => 'Add a holding';

  @override
  String get asset_holding_edit => 'Edit holding';

  @override
  String get asset_holding_name => 'Name';

  @override
  String get asset_holding_name_hint => 'e.g. Nasdaq ETF, Samsung';

  @override
  String get asset_holding_name_required => 'Enter a name';

  @override
  String get asset_holding_ticker => 'Ticker (optional)';

  @override
  String get asset_holding_ticker_hint => 'e.g. QQQ, 005930';

  @override
  String get asset_amount_label => 'Amount';

  @override
  String get asset_ratio_auto => 'The share is calculated from the balance';

  @override
  String asset_date_full(String year, String month, String day) {
    return '$year-$month-$day';
  }

  @override
  String get asset_coach_detail_title => 'Account details';

  @override
  String get asset_coach_detail_desc =>
      'See the latest balance and return — scroll down for the trend chart and the principal/gains breakdown.';

  @override
  String get asset_coach_record_title => 'Add a balance record';

  @override
  String get asset_coach_record_desc =>
      'Record the balance regularly to see the trend on a chart — withdrawals are tracked here too.';

  @override
  String get asset_coach_portfolio_title => 'Portfolio';

  @override
  String get asset_coach_portfolio_desc =>
      'Record holdings by date to see the mix as a pie chart — and compare two dates to see what changed.';

  @override
  String asset_view_all_records(int count) {
    return 'See all $count';
  }

  @override
  String get asset_balance_record => 'Balance record';

  @override
  String get asset_balance_record_desc =>
      'Record balance, principal, and gains';

  @override
  String get asset_withdrawal => 'Withdrawal';

  @override
  String get asset_withdrawal_desc =>
      'Record a principal withdrawal or realized gain';

  @override
  String get asset_portfolio => 'Portfolio';

  @override
  String get asset_change => 'Change';

  @override
  String get asset_total => 'Total';

  @override
  String get asset_retry => 'Retry';

  @override
  String get asset_reset_auto => 'Back to auto-calculated';

  @override
  String get asset_withdrawal_delete => 'Delete withdrawal';

  @override
  String get asset_withdrawal_delete_message =>
      'Deleting restores the principal and gains after that date. Continue?';

  @override
  String get asset_holding_add_button => 'Add holding';

  @override
  String get asset_compare => 'Compare';

  @override
  String get asset_record_first =>
      'Add a balance record first to track your portfolio.';

  @override
  String get asset_no_holdings => 'No holdings recorded for this date.';

  @override
  String get asset_cash => 'Cash';

  @override
  String get asset_holding_delete => 'Delete holding';

  @override
  String asset_holding_delete_message(String name) {
    return 'Delete the $name record?';
  }

  @override
  String get asset_delete_failed => 'Couldn\'t delete';

  @override
  String asset_others_count(int count) {
    return '$count others';
  }

  @override
  String asset_fill_with_cash(String amount) {
    return 'Fill with cash ($amount)';
  }

  @override
  String asset_balance_value(String amount) {
    return 'Balance: $amount';
  }

  @override
  String get asset_filter_min_one => 'Pick at least one';

  @override
  String get asset_withdrawal_type_desc_full =>
      'Did the money come out of your principal or your gains?\nWe use this to recalculate them when you add a balance record.';

  @override
  String get asset_withdrawal_from_profit => 'From gains (tax, taking profit)';

  @override
  String get asset_filter_min_one_account => 'Pick at least one account.';

  @override
  String asset_legend_more(int count) {
    return '+$count more';
  }

  @override
  String get asset_holdings_section => 'Portfolio';

  @override
  String asset_others_ratio(int count, String ratio) {
    return '$count others  $ratio%';
  }

  @override
  String get asset_cumulative_return => 'Cumulative return';

  @override
  String get asset_period_return => 'Period return';

  @override
  String get asset_tooltip_balance =>
      'Total balance at each point.\nBalance = principal + gains';

  @override
  String get asset_tooltip_principal =>
      'How much you\'ve actually put in, up to that point.\nGains and losses aren\'t counted.';

  @override
  String get asset_tooltip_profit =>
      'Cumulative gains at each point.\nGains = balance − principal';

  @override
  String get asset_tooltip_cumulative =>
      'Cumulative return at each point.\nReturn = gains ÷ principal × 100';

  @override
  String get asset_tooltip_period =>
      'Return for that period versus the previous point.\nDeposits and withdrawals are excluded, so only real gains show.\n\nPeriod return = (gains now − gains before) ÷ previous principal × 100';

  @override
  String asset_amount_won(String amount) {
    return '$amount KRW';
  }

  @override
  String asset_month_unit(String month) {
    return '$month';
  }

  @override
  String asset_gold_price_per_gram(String amount) {
    return '$amount KRW/g';
  }

  @override
  String get asset_compare_usd => 'In USD';

  @override
  String get minigame_title => 'Mini games';

  @override
  String get minigame_coach_desc =>
      'Ladder and roulette games — handy when you need a fair way to decide.';

  @override
  String get minigame_coach_group => 'Choose a group';

  @override
  String get minigame_coach_group_desc =>
      'Pick a group and results are saved automatically — anyone in the group can see the history.';

  @override
  String get minigame_history => 'Game history';

  @override
  String get minigame_coach_history_desc =>
      'See past results here — who got what is visible to everyone.';

  @override
  String get minigame_ladder => 'Ladder';

  @override
  String get minigame_roulette => 'Roulette';

  @override
  String get minigame_no_group => 'No group (don\'t save)';

  @override
  String get minigame_history_empty => 'No games yet';

  @override
  String get minigame_select_group_hint =>
      'Pick a group and your games are saved automatically';

  @override
  String get minigame_history_delete => 'Delete history';

  @override
  String get minigame_history_delete_message => 'Delete this game record?';

  @override
  String minigame_winner(String name) {
    return 'Winner: $name';
  }

  @override
  String get minigame_ladder_default_title => 'Ladder game';

  @override
  String get minigame_roulette_default_title => 'Roulette';

  @override
  String get minigame_game_title => 'Game title';

  @override
  String get minigame_create_ladder => 'Build the ladder';

  @override
  String get minigame_ladder_hint => 'Tap a name to follow the ladder!';

  @override
  String get minigame_skip_all => 'Skip all';

  @override
  String get minigame_reset => 'Start over';

  @override
  String get minigame_participants => 'Participants';

  @override
  String get minigame_final_result => 'Final result';

  @override
  String get minigame_saved => 'Result saved';

  @override
  String get minigame_save_failed => 'Couldn\'t save';

  @override
  String get minigame_result_items => 'Outcomes';

  @override
  String minigame_item_hint(int index) {
    return 'Item $index';
  }

  @override
  String get minigame_add_item => 'Add item';

  @override
  String minigame_count_mismatch(String total, String count) {
    return 'The totals ($total) must match the number of participants ($count)';
  }

  @override
  String get minigame_playing_with_group => 'Playing with a group';

  @override
  String get minigame_members_loading =>
      'Still loading group members. Try again in a moment.';

  @override
  String minigame_add_manually(String label) {
    return 'Add $label manually';
  }

  @override
  String get minigame_select_members => 'Pick members';

  @override
  String get minigame_select_group_members => 'Pick group members';

  @override
  String get minigame_unknown => 'Unknown';

  @override
  String get minigame_already_added => 'Already added';

  @override
  String minigame_add_count(int count) {
    return 'Add ($count)';
  }

  @override
  String get minigame_spin => 'Spin';

  @override
  String get minigame_need_two_items => 'Add at least two items';

  @override
  String get minigame_result => 'Result';

  @override
  String get minigame_item => 'Item';

  @override
  String get minigame_ratio => 'Share';

  @override
  String get common_filter => 'Filter';

  @override
  String get common_selectGroup => 'Choose a group';

  @override
  String get common_unknown => 'Unknown';

  @override
  String home_delete_scheduled(String date, String days) {
    return 'Your account is scheduled for deletion on $date (in $days days).';
  }

  @override
  String get home_delete_cancel => 'Cancel deletion';

  @override
  String get home_delete_canceled => 'Deletion canceled';

  @override
  String get home_coach_more => 'Start from the More tab';

  @override
  String get home_coach_group => 'Groups';

  @override
  String get home_coach_group_desc =>
      'Create a group — family, partner, friends — and invite people with a code.';

  @override
  String get home_coach_widget => 'Customize your dashboard';

  @override
  String get home_coach_widget_desc =>
      'Settings → Home widgets: pick just the widgets you want.';

  @override
  String get home_coach_tab => 'Customize the bottom tabs';

  @override
  String get home_coach_tab_desc =>
      'Settings → Bottom navigation: swap in the menus you use most.';

  @override
  String get home_coach_tap_more => 'Tap to open More';

  @override
  String get home_period => 'Period';

  @override
  String get home_personal_schedule => 'Personal events';

  @override
  String get home_personal_schedule_desc => 'Include my personal events';

  @override
  String get home_view_mode => 'View';

  @override
  String get home_pinned_memos => 'Pinned memos';

  @override
  String get home_pinned_memos_empty => 'No pinned memos';

  @override
  String home_checklist_progress(String checked, String total) {
    return '$checked/$total done';
  }

  @override
  String get home_no_expiry => 'No expiry';

  @override
  String home_expired_days(String days) {
    return '$days days past';
  }

  @override
  String get home_expires_today => 'Expires today';

  @override
  String get home_total_savings => 'Total saved';

  @override
  String home_active_goals(int count) {
    return '$count in progress';
  }

  @override
  String home_goal_amount(String amount) {
    return 'Goal $amount';
  }

  @override
  String home_more_goals(int count) {
    return '+$count more';
  }

  @override
  String get home_schedule_filter => 'Event filter';

  @override
  String get home_no_children => 'No children yet';

  @override
  String home_childcare_savings(String points) {
    return 'Savings ${points}P';
  }

  @override
  String home_anniversary_more(int count) {
    return '+$count more';
  }

  @override
  String get auth_email_copied => 'Email address copied';

  @override
  String get auth_login_processing => 'Signing you in…';

  @override
  String get auth_please_wait => 'One moment please.';

  @override
  String get auth_login_failed => 'Sign-in failed';

  @override
  String get auth_back_to_login => 'Back to sign-in';

  @override
  String get auth_code_required => 'Enter the verification code';

  @override
  String get auth_email_verified => 'Your email is verified. Please sign in.';

  @override
  String get auth_email_resent => 'We\'ve resent the verification email.';

  @override
  String get auth_email_verification => 'Verify your email';

  @override
  String get auth_check_email => 'Check your email';

  @override
  String auth_email_sent_to(String email) {
    return 'We sent a verification email to\n$email.';
  }

  @override
  String get auth_enter_code => 'Enter the code';

  @override
  String get auth_enter_code_desc => 'Type the 6-digit code from the email.';

  @override
  String get auth_code_label => 'Verification code';

  @override
  String get auth_code_hint => 'e.g. 123456';

  @override
  String get auth_no_email => 'Didn\'t get the email?';

  @override
  String get auth_resend_email => 'Resend email';

  @override
  String get auth_verify_later => 'Verify later ';

  @override
  String get auth_back_to_signin => 'Back to sign-in';

  @override
  String get auth_no_token => 'No auth token. Please sign in again.';

  @override
  String get auth_terms_title => 'Terms of service';

  @override
  String get auth_terms_desc =>
      'Please accept the terms to start using Family Planner.';

  @override
  String get auth_agree_and_start => 'Agree and continue';

  @override
  String get ai_assistant => 'AI assistant';

  @override
  String get ai_premium_desc =>
      'A premium subscription feature launching next year.\nSubscribe to use the AI assistant.';

  @override
  String get ai_premium_coming => 'Premium coming soon';

  @override
  String get ai_ask_anything => 'Ask me anything';

  @override
  String get ai_reset_chat => 'Clear chat';

  @override
  String get ai_greeting => 'Hi! I\'m the Family Planner AI.';

  @override
  String get ai_greeting_desc =>
      'Tap a suggestion below, or type your own question.';

  @override
  String get ai_new_chat => 'Started a new chat';

  @override
  String get ai_message_hint => 'Type a message…';

  @override
  String get ai_send => 'Send';

  @override
  String get ai_suggest1 => 'Analyze this month\'s spending';

  @override
  String get ai_suggest2 => 'Summarize the family schedule';

  @override
  String get ai_suggest3 => 'How are the savings goals going?';

  @override
  String get ai_suggest4 => 'Show my open to-dos';

  @override
  String get ai_suggest5 => 'How\'s my investment portfolio?';

  @override
  String get ai_suggest6 => 'What\'s important this week?';

  @override
  String get weather_title => 'Weather';

  @override
  String get weather_current_failed => 'Couldn\'t load the current weather';

  @override
  String get weather_forecast_failed => 'Couldn\'t load the forecast';

  @override
  String get weather_humidity => 'Humidity';

  @override
  String get weather_wind => 'Wind';

  @override
  String get weather_precipitation => 'Precipitation';

  @override
  String get weather_air_quality => 'Air quality';

  @override
  String get weather_pm10 => 'PM10';

  @override
  String get weather_pm25 => 'PM2.5';

  @override
  String weather_measured_at(String region) {
    return 'Measured at $region';
  }

  @override
  String get weather_hourly => 'Hourly';

  @override
  String get weather_hourly_empty => 'No hourly forecast';

  @override
  String get weather_daily => 'Daily';

  @override
  String weather_hour(String hour) {
    return '$hour:00';
  }

  @override
  String get weather_today => 'Today';

  @override
  String get calendar_view_day => 'Day';

  @override
  String get calendar_view_week => 'Week';

  @override
  String get calendar_view_month => 'Month';

  @override
  String get calendar_view_year => 'Year';

  @override
  String get calendar_manage_anniversary => 'Anniversaries';

  @override
  String get calendar_select_view => 'Choose a view';

  @override
  String get calendar_allday => 'All day';

  @override
  String calendar_lunar_label(String label) {
    return 'Lunar $label';
  }

  @override
  String calendar_hidden_count(int count) {
    return '+$count';
  }

  @override
  String calendar_group_more(String name, int count) {
    return '$name +$count';
  }

  @override
  String calendar_year_label(String year) {
    return '$year';
  }

  @override
  String get calendar_task_added => 'Event added.';

  @override
  String get calendar_task_title_hint => 'Event title';

  @override
  String get calendar_personal => 'Personal';

  @override
  String get calendar_type_event => 'Event';

  @override
  String get calendar_type_todo => 'To-do';

  @override
  String get calendar_type_both => 'Both';

  @override
  String get calendar_more => 'More';

  @override
  String get calendar_remind_5m => '5 min before';

  @override
  String get calendar_remind_15m => '15 min before';

  @override
  String get calendar_remind_30m => '30 min before';

  @override
  String get calendar_remind_1h => '1 hour before';

  @override
  String get calendar_remind_1d => '1 day before';

  @override
  String household_year_label(String year) {
    return '$year';
  }

  @override
  String get household_yearly_stats => 'Yearly';

  @override
  String get household_stats_exclude_note =>
      'Refunds and carried-over deposits are excluded';

  @override
  String get household_by_category => 'By category';

  @override
  String get household_by_merchant => 'By merchant';

  @override
  String get household_by_member => 'By member';

  @override
  String get household_custom_filter => 'Custom filter';

  @override
  String get household_category_spending => 'Spending by category';

  @override
  String get household_merchant_spending => 'Spending by merchant';

  @override
  String get household_member_spending => 'Spending by member';

  @override
  String get household_no_merchant => 'No merchant';

  @override
  String get household_unassigned => 'Unassigned';

  @override
  String get household_member => 'Member';

  @override
  String get household_monthly_spending => 'Monthly spending';

  @override
  String get household_compare_last_month => 'vs. last month';

  @override
  String get household_cumulative_trend => 'Cumulative spending';

  @override
  String get household_variable => 'Variable';

  @override
  String get household_expected_amount => 'Expected';

  @override
  String get household_due_day => 'Due day';

  @override
  String household_due_day_value(String day) {
    return 'Day $day each month';
  }

  @override
  String get household_payee => 'Payee';

  @override
  String get household_payer => 'Payer';

  @override
  String get household_no_applied => 'Nothing applied yet';

  @override
  String get household_confirmed_avg => 'Confirmed average';

  @override
  String get household_min => 'Min';

  @override
  String get household_max => 'Max';

  @override
  String household_unconfirmed_suffix(String date) {
    return '$date  unconfirmed';
  }

  @override
  String get asset_demo_nasdaq => 'Nasdaq ETF';

  @override
  String get asset_demo_samsung => 'Samsung';

  @override
  String get currency_won_unit => 'KRW';

  @override
  String get household_auto_registered => 'Added to your budget';

  @override
  String household_auto_registered_body(String amount) {
    return '$amount KRW was added to your budget.';
  }

  @override
  String get household_auto_service => 'Auto budget entry';

  @override
  String get household_auto_service_desc =>
      'Watches payment notifications and records them for you';

  @override
  String get coach_calendar_shared => 'Shared calendar';

  @override
  String get coach_calendar_shared_desc =>
      'See everyone\'s events in one place.\nTap a date to view that day.';

  @override
  String get coach_calendar_add => 'Add an event';

  @override
  String get coach_calendar_add_desc =>
      'Tap the button to create an event.\nGive it a try.';

  @override
  String get coach_group_create => 'Create a group';

  @override
  String get coach_group_create_desc =>
      'Family, partner, friends, a team — make the group you want.';

  @override
  String get coach_group_join => 'Join a group';

  @override
  String get coach_group_join_desc =>
      'Enter an invite code to join an existing group — a member can share one with you.';

  @override
  String get coach_group_requests => 'Your requests';

  @override
  String get coach_group_requests_desc =>
      'See the groups you\'ve asked to join and whether you\'ve been accepted.';

  @override
  String get coach_savings_status => 'Your savings';

  @override
  String get coach_savings_status_desc =>
      'See what you\'ve saved, the target, and how far along you are.\nAuto-deposit status shows here too.';

  @override
  String get coach_savings_deposit => 'Deposit / withdraw';

  @override
  String get coach_savings_deposit_desc =>
      'Add or take out money whenever you like — handy alongside auto-deposit.';

  @override
  String get coach_savings_goal => 'Savings goal';

  @override
  String get coach_savings_goal_desc =>
      'See the goal name, what\'s saved, and your progress at a glance.\nTurn on auto-deposit and it saves every month.';

  @override
  String get coach_savings_demo_desc => 'This summer\'s family trip';

  @override
  String get coach_savings_demo_jeju => 'Jeju trip';

  @override
  String get coach_savings_demo_emergency => 'Emergency fund';

  @override
  String get demo_milk => 'Milk';

  @override
  String get demo_eggs => 'Eggs';

  @override
  String get demo_tofu => 'Tofu';

  @override
  String get demo_unit_piece => 'pcs';

  @override
  String get demo_unit_pack => 'tray';

  @override
  String get demo_fridge => 'Fridge';

  @override
  String get demo_freezer => 'Freezer';

  @override
  String get demo_bank_savings => 'KB savings account';

  @override
  String get coach_ladder_participants => 'Add participants';

  @override
  String get coach_ladder_participants_desc =>
      'Type the names of everyone playing.\nOr pull in your group members all at once.';

  @override
  String get coach_ladder_results => 'Add outcomes';

  @override
  String get coach_ladder_results_desc =>
      'Enter the outcomes and how many of each.\nThe totals must match the number of participants.';

  @override
  String get coach_ladder_create => 'Build the ladder';

  @override
  String get coach_ladder_create_desc =>
      'Tap the button to build it.\nTap a name and the path animates to reveal the result.';

  @override
  String get coach_roulette_items => 'Add items';

  @override
  String get coach_roulette_items_desc =>
      'Enter the items for the wheel.\nAdjust the shares to change the odds.';

  @override
  String get coach_roulette_wheel => 'The wheel';

  @override
  String get coach_roulette_wheel_desc =>
      'Add two or more items and the wheel appears.\nThe center button spins it too.';

  @override
  String get coach_roulette_spin => 'Spin';

  @override
  String get coach_roulette_spin_desc =>
      'Tap to spin.\nThe result is saved to the group history for everyone to see.';

  @override
  String get coach_asset_card => 'Account card';

  @override
  String get coach_asset_card_desc =>
      'See the account name, institution, latest balance, and return at a glance.\nTap to manage balance records and the portfolio.';

  @override
  String get coach_asset_stats => 'Asset statistics';

  @override
  String get coach_asset_stats_desc =>
      'Totals, returns, and the mix by type — all in charts.\nYou can compare against KOSPI, S&P 500, and more.';

  @override
  String get demo_bank_kb => 'KB Bank';

  @override
  String get coach_group_invite => 'Invite some members';

  @override
  String get coach_group_invite_desc =>
      'In the Settings tab you can share an invite code or email an invitation.\n\nTap to go to Settings.';

  @override
  String get coach_group_invite_code => 'Invite with a code';

  @override
  String get coach_group_invite_code_desc =>
      'Copy the code to share it, or send an invitation by email.';

  @override
  String get coach_group_roles => 'Manage access with roles';

  @override
  String get coach_group_roles_desc =>
      'In the Roles tab you can create roles and fine-tune what each member can do.\n\nTap to go to Roles.';

  @override
  String get coach_group_role_new => 'Create a role';

  @override
  String get coach_group_role_new_desc =>
      'Tap to create a role and set its name, color, and permissions.';

  @override
  String get coach_group_color => 'Pick a color for this group';

  @override
  String get coach_group_color_desc =>
      'Set the group\'s color in the Settings tab.\nIt\'s used across the app — in the calendar and elsewhere — to tell this group\'s items apart.\n\nTap to go to Settings.';

  @override
  String get coach_cart_complete => 'What happens when you finish';

  @override
  String get coach_cart_complete_desc =>
      'Tapping Finish shopping does both of these at once.';

  @override
  String get coach_cart_to_fridge => 'Move to the fridge';

  @override
  String get coach_cart_to_fridge_desc =>
      'Send what you bought straight into fridge storage — with quantity, expiry, and reminder date.';

  @override
  String get coach_cart_to_expense => 'Record it in the budget';

  @override
  String get coach_cart_to_expense_desc =>
      'Enter the amount, payment method, and a note — it\'s recorded automatically.';

  @override
  String get coach_cart_no_transfer => 'Don\'t move';

  @override
  String get demo_todo_shopping => 'Make a shopping list';

  @override
  String get demo_todo_shopping_desc => 'Groceries we need this week';

  @override
  String get demo_todo_trip => 'Plan the family trip';

  @override
  String get demo_todo_trip_desc => 'Summer dates and booking a place';

  @override
  String get demo_todo_budget => 'Tidy up the monthly budget';

  @override
  String get demo_todo_budget_desc => 'Check last month\'s income and spending';

  @override
  String get coach_todo_byDate => 'To-dos by date';

  @override
  String get coach_todo_byDate_desc =>
      'Tap a date to see that day\'s to-dos and split them with your group.';

  @override
  String get coach_todo_status => 'Change status';

  @override
  String get coach_todo_status_desc =>
      'Tap the icon on the left to switch between pending, in progress, and done.';

  @override
  String get coach_todo_add => 'Add a to-do';

  @override
  String get coach_todo_add_desc =>
      'Add a to-do, then set who\'s on it and when it\'s due.';

  @override
  String get demo_apple => 'Apples';

  @override
  String get coach_history_records => 'Purchase history';

  @override
  String get coach_history_records_desc =>
      'Every finished shopping trip lands here.\nTap a card to see the items.';

  @override
  String get coach_history_expense => 'Linked to the budget';

  @override
  String get coach_history_expense_desc =>
      'Record the spending when you finish and this badge appears — it links to your budget automatically.';

  @override
  String get demo_expense_salary => 'June salary';

  @override
  String get demo_expense_dining => 'Dinner out';

  @override
  String get demo_expense_fuel => 'Fuel';

  @override
  String get demo_expense_utility => 'Electricity and gas';

  @override
  String get coach_household_summary => 'Monthly summary';

  @override
  String get coach_household_summary_desc =>
      'See this month\'s income, spending, and balance — plus how much of the budget you\'ve used.';

  @override
  String get coach_household_budget => 'Set a budget';

  @override
  String get coach_household_budget_desc =>
      'Open the More menu here to set monthly budgets per category.';

  @override
  String get coach_household_recurring => 'Recurring expenses';

  @override
  String get coach_household_recurring_desc =>
      'Register rent, subscriptions, and the like — we\'ll record them each month.';

  @override
  String get coach_household_stats => 'Statistics';

  @override
  String get coach_household_stats_desc =>
      'See spending by category and month-over-month trends in charts.';

  @override
  String get coach_household_add => 'Add spending or income';

  @override
  String get coach_household_add_desc =>
      'Record a new expense or income — you can keep them separate by group.';

  @override
  String get common_me => 'Me';

  @override
  String get demo_memo_trip => 'Getting ready for Jeju';

  @override
  String get demo_memo_trip_body =>
      'Flights booked\nStaying at a guesthouse in Hallim.\nStill need a rental car. Planning Udo and Seongsan Ilchulbong.';

  @override
  String get demo_tag_travel => 'Travel';

  @override
  String get demo_tag_jeju => 'Jeju';

  @override
  String get demo_memo_packing => 'Overnight packing';

  @override
  String get demo_check_passport => 'Passport / ID';

  @override
  String get demo_check_toiletries => 'Toiletries';

  @override
  String get demo_check_clothes => 'Change of clothes';

  @override
  String get demo_check_charger => 'Charger';

  @override
  String get demo_check_meds => 'Medicine';

  @override
  String get coach_memo_richtext => 'Rich text memos';

  @override
  String get coach_memo_richtext_desc =>
      'Bold, italic, headings — format freely.\nTag them, and paste a URL to get a link card automatically.';

  @override
  String get coach_memo_checklist => 'Checklists';

  @override
  String get coach_memo_checklist_desc =>
      'Drop a checklist anywhere in a memo.\nThe card shows how many are done, and you can tick them off in the detail view.';

  @override
  String get coach_memo_progress => 'Progress';

  @override
  String get coach_memo_progress_desc =>
      'See how many are done at a glance — with select-all and reset buttons.';

  @override
  String get coach_memo_check => 'Ticking items';

  @override
  String get coach_memo_check_desc =>
      'Tap a checkbox to mark it done — changes save on their own shortly after.';

  @override
  String get coach_memo_edit => 'Edit mode';

  @override
  String get coach_memo_edit_desc =>
      'Tap Edit to open the editor.\nUse the checklist button in the toolbar to add or change items.';

  @override
  String get demo_vote_outing => 'Where should we go this weekend?';

  @override
  String get demo_vote_outing_desc => 'Majority wins — cast your vote!';

  @override
  String get demo_vote_dinner => 'What\'s for dinner?';

  @override
  String get demo_member_mom => 'Mom';

  @override
  String get demo_member_dad => 'Dad';

  @override
  String get demo_member_child => 'Minjun';

  @override
  String get demo_place_hangang => 'Han River Park';

  @override
  String get demo_place_amusement => 'Amusement park';

  @override
  String get demo_place_zoo => 'Zoo';

  @override
  String get demo_food_chicken => 'Fried chicken';

  @override
  String get demo_food_pizza => 'Pizza';

  @override
  String get demo_food_pork => 'Pork belly';

  @override
  String get demo_group_family => 'Our family';

  @override
  String get coach_vote_group => 'Choose a group';

  @override
  String get coach_vote_group_desc =>
      'Votes belong to a group.\nPick one to see its votes.';

  @override
  String get coach_vote_filter => 'Status filter';

  @override
  String get coach_vote_filter_desc =>
      'Use the tabs to see all, open, or closed votes.';

  @override
  String get coach_vote_card => 'Vote card';

  @override
  String get coach_vote_card_desc =>
      'Tap a card to cast your vote.\nEveryone in the group can join, and results update live.';

  @override
  String get coach_vote_create => 'Create a vote';

  @override
  String get coach_vote_create_desc =>
      'Tap + to create one.\nSingle or multiple choice, anonymous voting, and a closing time are all supported.';

  @override
  String get demo_shop_tv_desc => '30 extra minutes of TV after dinner';

  @override
  String get demo_shop_game_desc => 'An hour of gaming on the weekend';

  @override
  String get demo_rule_homework => 'Finished homework on their own';

  @override
  String get demo_rule_phone => 'Over an hour of phone time';

  @override
  String get demo_rule_cashout => 'Cash out up to 50P this month';

  @override
  String get coach_child_register => 'Add a child';

  @override
  String get coach_child_register_desc =>
      'Start by adding a child.\nEnter a name and birthday and a points account is created automatically.';

  @override
  String get coach_child_points => 'Points overview';

  @override
  String get coach_child_points_desc =>
      'See the balance and the monthly allowance plan at a glance.\nPoints are given automatically on the day you set.';

  @override
  String get coach_child_savings => 'Savings plan';

  @override
  String get coach_child_savings_desc =>
      'Set up a points savings plan and it deposits every month — with interest.';

  @override
  String get coach_child_shop => 'Points shop';

  @override
  String get coach_child_shop_desc =>
      'Rewards your child can buy with the points they\'ve earned — a reason to keep saving.';

  @override
  String get coach_child_rule_plus_desc =>
      'Give points for good habits.\ne.g. Finished homework on their own +10P';

  @override
  String get coach_child_rule_minus_desc =>
      'Deduct points when a promise is broken.\ne.g. Over an hour of phone time −10P';

  @override
  String get coach_child_rule_info_desc =>
      'Record a promise without points.\ne.g. Cash out up to 50P this month';

  @override
  String get intro_slide1_title => 'A planner of your own';

  @override
  String get intro_slide1_subtitle => 'Family, partner, friends, teams';

  @override
  String get intro_slide1_desc =>
      'Manage several groups in one app.\nEach relationship gets its own space to plan in.';

  @override
  String get intro_slide2_title => 'Plan together';

  @override
  String get intro_slide2_subtitle => 'Shared calendar';

  @override
  String get intro_slide2_desc =>
      'See everyone\'s plans in one place.\nNever miss an important day.';

  @override
  String get intro_slide3_title => 'Get things done';

  @override
  String get intro_slide3_subtitle => 'Shared to-do list';

  @override
  String get intro_slide3_desc =>
      'Everyone knows who\'s doing what.\nSplit the work and finish it together.';

  @override
  String get intro_slide4_title => 'Money at a glance';

  @override
  String get intro_slide4_subtitle => 'Shared budget';

  @override
  String get intro_slide4_desc =>
      'Track income and spending together, and see where it goes.\nHit your money goals as a group.';

  @override
  String get intro_slide5_title => 'And plenty more';

  @override
  String get intro_slide5_subtitle => 'Assets, memos, savings, votes';

  @override
  String get intro_slide5_desc =>
      'Everything you need for daily life, in one place.\nGive it a try!';

  @override
  String get intro_start => 'Get started';

  @override
  String get intro_next => 'Next';

  @override
  String get intro_preview_couple => 'Partner';

  @override
  String get intro_preview_friends => 'Friends';

  @override
  String get intro_preview_team => 'Team project';

  @override
  String get intro_preview_mygroups => 'My groups';

  @override
  String intro_preview_members(String count) {
    return '$count';
  }

  @override
  String get intro_preview_dining => 'Family dinner';

  @override
  String get intro_preview_hospital => 'Doctor\'s appointment';

  @override
  String get intro_preview_birthday => 'Birthday party 🎂';

  @override
  String get intro_preview_todo1 => 'Grocery run';

  @override
  String get intro_preview_todo2 => 'Vacuum the floor';

  @override
  String get intro_preview_todo3 => 'Check insurance renewal';

  @override
  String get intro_preview_todo4 => 'Sort the photo album';

  @override
  String get intro_preview_todo5 => 'Check the kid\'s homework';

  @override
  String get intro_preview_today => 'Today';

  @override
  String get intro_preview_tomorrow => 'Tomorrow';

  @override
  String get intro_preview_thisweek => 'This week';

  @override
  String intro_preview_total(String count) {
    return '$count total';
  }

  @override
  String intro_preview_done(String count) {
    return '$count done';
  }

  @override
  String get intro_preview_mart => 'Groceries';

  @override
  String get intro_preview_eatout => 'Eating out';

  @override
  String get intro_preview_salary => 'Salary';

  @override
  String get intro_preview_transport => 'Transport';

  @override
  String get intro_preview_assets => 'Assets';

  @override
  String get intro_preview_savings => 'Savings';

  @override
  String get demo_memo_domestic => 'Local';

  @override
  String get coach_cart_add => 'Add items';

  @override
  String get coach_cart_add_desc =>
      'Add what you need to buy — it saves automatically.';

  @override
  String get coach_cart_manage => 'Manage items';

  @override
  String get coach_cart_manage_desc =>
      '• Tap to edit the name, quantity, or note\n• Use ± to change the quantity\n• Swipe left to delete\n• Changes save on their own shortly after';

  @override
  String get coach_cart_finish => 'Finish shopping';

  @override
  String get coach_cart_finish_desc =>
      'Tap here when you\'re done shopping.\nThe next screen shows what else it can do!';

  @override
  String get coach_cart_next => 'Tap to see what\'s next!';

  @override
  String get coach_cart_next_desc =>
      'We\'ll show you more in the Frequent items tab.';

  @override
  String get household_carryover_out => 'Balance carried over';

  @override
  String get household_carryover_in => 'Carried over from last month';

  @override
  String household_transfer_asset(String name) {
    return 'Moved to $name';
  }

  @override
  String household_transfer_savings(String name) {
    return 'Moved to $name';
  }

  @override
  String get household_transfer_from_ledger => 'Moved from the budget';
}
