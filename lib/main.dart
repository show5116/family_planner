import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:family_planner/core/theme/app_theme.dart';
import 'package:family_planner/core/theme/theme_provider.dart';
import 'package:family_planner/core/routes/app_router.dart';
import 'package:family_planner/core/config/environment.dart';
import 'package:family_planner/core/providers/locale_provider.dart';
import 'package:family_planner/core/services/api_client.dart';
import 'package:family_planner/features/auth/providers/auth_provider.dart';
// TODO: 결제 알림 자동 등록 기능 — 앱 심사 통과 후 주석 해제
// import 'package:family_planner/features/main/household/providers/household_auto_settings_provider.dart';
import 'package:family_planner/features/auth/services/oauth_callback_handler.dart';
import 'package:family_planner/features/auth/services/auth_service.dart';
import 'package:family_planner/features/notification/data/services/firebase_messaging_service.dart';
import 'package:family_planner/features/notification/data/services/local_notification_service.dart';
import 'package:family_planner/features/weather/providers/weather_provider.dart';
import 'package:family_planner/l10n/app_localizations.dart';
import 'package:family_planner/core/services/ad_service.dart';
import 'package:family_planner/core/services/analytics_service.dart';
import 'package:family_planner/core/providers/subscription_provider.dart';
import 'firebase_options.dart';

/// 전역 ScaffoldMessenger Key
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// 백그라운드 메시지 핸들러 (Top-level 함수)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await firebaseMessagingBackgroundHandler(message);
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
    // 웹은 measurementId 없이 Analytics 초기화 시 에러 발생하므로 비활성화
    // 모바일은 프로덕션에서만 수집 활성화
    const isProduction = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production') == 'production';
    await AnalyticsService.instance.analytics
        .setAnalyticsCollectionEnabled(!kIsWeb && isProduction);
  } catch (e) {
    debugPrint('❌ Firebase 초기화 실패: $e');
  }

  if (kIsWeb) {
    usePathUrlStrategy();
  }

  // ATT 동의 팝업 (iOS 전용, AdMob 초기화 전 반드시 선행)
  if (!kIsWeb && Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  // AdMob 초기화 (runApp 전, timeout 적용)
  await AdService.initialize();

  KakaoSdk.init(
    nativeAppKey: EnvironmentConfig.kakaoNativeAppKey,
    javaScriptAppKey: EnvironmentConfig.kakaoJavaScriptAppKey,
  );

  AuthRepository.initialize(appKey: EnvironmentConfig.kakaoJavaScriptAppKey);

  const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
  if (env == 'local') {
    EnvironmentConfig.setEnvironment(Environment.local);
  } else if (env == 'development') {
    EnvironmentConfig.setEnvironment(Environment.development);
  } else {
    EnvironmentConfig.setEnvironment(Environment.production);
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

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ApiClient.instance.onError = (String message) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    };

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 알림 서비스 초기화 (runApp 후 실행 - iOS APNs 이슈 방지)
      unawaited(FirebaseMessagingService.initialize().catchError((_) {}));
      unawaited(LocalNotificationService.initialize().catchError((_) {}));

      await ref.read(authProvider.notifier).checkAuthStatus();

      // checkAuthStatus 완료 후 user 정보가 확정된 시점에 광고 설정 초기화
      AdService.instance.useTestAds = ref.read(useTestAdsProvider);
      ref.listenManual(useTestAdsProvider, (_, useTest) {
        AdService.instance.useTestAds = useTest;
      });

      // TODO: 결제 알림 자동 등록 기능 — 앱 심사 통과 후 주석 해제
      // ref.read(householdAutoSettingsProvider.notifier).load();
      if (kIsWeb) {
        OAuthCallbackHandler().initDeepLinkListener();
      }
      _updateUserLocation();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AdService.instance.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      AdService.instance.onAppResumed();
    }
  }

  /// GPS 위치를 서버에 저장 (날씨 알림 크론잡에서 사용)
  /// 로그인된 상태에서만 전송합니다.
  Future<void> _updateUserLocation() async {
    final isAuthenticated = ref.read(authProvider).isAuthenticated;
    if (isAuthenticated != true) return;

    try {
      final latLon = await ref.read(locationProvider.future);
      await AuthService().updateLocation(lat: latLon.lat, lon: latLon.lon);
    } catch (_) {
      // 위치 권한 거부 등 실패 시 조용히 무시
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeSettings = ref.watch(themeSettingsProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Family Planner',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: AppTheme.lightTheme(variant: themeSettings.variant),
      darkTheme: AppTheme.darkTheme(variant: themeSettings.variant),
      themeMode: themeSettings.mode,
      routerConfig: router,
      locale: locale,
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
        Locale('ja', 'JP'),
        Locale('zh', 'CN'),
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
