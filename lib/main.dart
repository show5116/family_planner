import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:family_planner/core/theme/app_theme.dart';

import 'package:family_planner/core/theme/theme_provider.dart';
import 'package:family_planner/core/routes/app_router.dart';
import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/core/providers/locale_provider.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/features/auth/services/oauth_callback_handler.dart';
import 'package:family_planner/features/notification/data/services/firebase_messaging_service.dart';
import 'package:family_planner/features/notification/data/services/local_notification_service.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'firebase_options.dart';

/// 전역 ScaffoldMessenger Key
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// 백그라운드 메시지 핸들러 (Top-level 함수)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env 파일이 없거나 읽을 수 없는 경우 기본값 사용
  }

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await FirebaseMessagingService.initialize();
    await LocalNotificationService.initialize();
  } catch (e) {
    debugPrint('❌ Firebase 초기화 실패: $e');
  }

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  KakaoSdk.init(
    nativeAppKey: EnvironmentConfig.kakaoNativeAppKey,
    javaScriptAppKey: EnvironmentConfig.kakaoJavaScriptAppKey,
  );

  if (kReleaseMode) {
    EnvironmentConfig.setEnvironment(Environment.production);
  } else {
    EnvironmentConfig.setEnvironment(Environment.development);
  }


  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    ApiClient.instance.onError = (String message) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();
      if (kIsWeb) {
        OAuthCallbackHandler().initDeepLinkListener();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Family Planner',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
        Locale('ja', 'JP'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
