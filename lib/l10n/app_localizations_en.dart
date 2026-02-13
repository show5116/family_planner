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
  String get common_error => 'Error';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_close => 'Close';

  @override
  String get common_done => 'Done';

  @override
  String get common_next => 'Next';

  @override
  String get common_previous => 'Previous';

  @override
  String get common_all => 'All';

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
  String get auth_signupPasswordHelperText => 'At least 6 characters';

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
  String get group_leaveSuccess => 'Left group successfully';

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
  String get schedule_shareFamily => 'Family';

  @override
  String get schedule_shareSpecific => 'Specific Members';

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
  String get todo_searchHint => 'Search by title, description';

  @override
  String get todo_searchNoResults => 'No search results';

  @override
  String todo_searchResultCount(int count) {
    return '$count results found';
  }
}
