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
// Web-only: visualViewport height polling
// ignore: avoid_web_libraries_in_flutter
import 'viewport_stub.dart' if (dart.library.js_interop) 'viewport_web.dart';
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
  debugPrint('백그라운드 메시지 수신: ${message.messageId}');
}

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 변수 로드
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('✅ 환경 변수 로드 완료');
  } catch (e) {
    debugPrint('⚠️ 환경 변수 로드 실패: $e');
    debugPrint('⚠️ .env 파일이 없거나 읽을 수 없습니다. 기본값을 사용합니다.');
  }

  // Firebase 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase 초기화 완료');

    // 백그라운드 메시지 핸들러 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Firebase Messaging 초기화
    await FirebaseMessagingService.initialize();

    // 로컬 알림 초기화
    await LocalNotificationService.initialize();
  } catch (e) {
    debugPrint('❌ Firebase 초기화 실패: $e');
  }

  // 웹에서 URL 해시(#) 제거 - 경로 기반 라우팅 사용
  // 이렇게 하면 URL이 /#/path가 아닌 /path 형태가 됨
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  // Kakao SDK 초기화
  // Kakao Developers 콘솔에서 발급: https://developers.kakao.com
  // environment.dart에서 키 설정
  KakaoSdk.init(
    nativeAppKey: EnvironmentConfig.kakaoNativeAppKey,
    javaScriptAppKey: EnvironmentConfig.kakaoJavaScriptAppKey,
  );

  // 환경 설정 초기화
  // Release 모드면 프로덕션, 아니면 개발 환경
  if (kReleaseMode) {
    EnvironmentConfig.setEnvironment(Environment.production);
  } else {
    EnvironmentConfig.setEnvironment(Environment.development);
  }

  // 환경 정보 출력 (디버그 모드)
  if (kDebugMode) {
    print('🚀 Environment: ${EnvironmentConfig.currentEnvironment}');
    print('🌐 API Base URL: ${EnvironmentConfig.apiBaseUrl}');
  }

  runApp(
    // Riverpod의 ProviderScope로 앱을 감싸기
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  double _lastValidHeight = 0.0;
  double _lastValidWidth = 0.0;
  double _prevVvHeight = 0.0;
  void Function()? _removeViewportListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (kIsWeb) {
      // visualViewport resize 이벤트 리스너 (폴링보다 즉각적)
      _removeViewportListener = addVisualViewportResizeListener((vvHeight) {
        if (vvHeight <= 0) return;
        if (_prevVvHeight > 0 && vvHeight > _prevVvHeight) {
          // vvHeight 증가 = 키보드 닫힘
          FocusManager.instance.primaryFocus?.unfocus();
          resetBrowserScroll();
          dispatchResizeEvent();
          if (mounted) setState(() { _lastValidHeight = vvHeight; });
        }
        _prevVvHeight = vvHeight;
      });
    }

    // API 에러 콜백 설정 (401, 500 제외한 에러만 표시)
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
  void dispose() {
    _removeViewportListener?.call();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (!kIsWeb) return;
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalWidth = view.physicalSize.width / view.devicePixelRatio;
    final logicalHeight = view.physicalSize.height / view.devicePixelRatio;

    if (logicalWidth != _lastValidWidth) {
      // 화면 회전
      final vvHeight = getVisualViewportHeight();
      setState(() {
        _lastValidWidth = logicalWidth;
        _lastValidHeight = vvHeight > 0 ? vvHeight : logicalHeight;
        _prevVvHeight = _lastValidHeight;
      });
      return;
    }

    // 키보드 상태 변화 감지
    // viewInsets.bottom == 0 → 키보드가 완전히 내려간 상태
    final bottomInset = view.viewInsets.bottom;
    if (bottomInset == 0.0) {
      // 키보드가 내려갔는데 포커스가 남아있으면 강제 해제
      // → Flutter 엔진이 키보드 상태를 재평가하고 physicalSize 복원
      if (FocusManager.instance.primaryFocus != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      // logicalHeight가 줄어든 역전 상태면 복원 트리거
      if (logicalHeight < _lastValidHeight * 0.95) {
        Future.delayed(const Duration(milliseconds: 50), () {
          dispatchResizeEvent();
          if (mounted) setState(() {});
        });
      }
    }
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

      // 테마 설정
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      // 라우팅 설정
      routerConfig: router,

      // 로케일 설정
      locale: locale,
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
        Locale('en', 'US'), // 영어
        Locale('ja', 'JP'), // 일본어
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],

      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        if (kIsWeb) {
          // vv 기준으로 초기화 (첫 빌드 시)
          if (_lastValidHeight == 0.0) {
            final vvH = getVisualViewportHeight();
            _lastValidHeight = vvH > 0 ? vvH : mediaQuery.size.height;
            _lastValidWidth = mediaQuery.size.width;
            _prevVvHeight = _lastValidHeight;
          }

          final vvNow = getVisualViewportHeight();

          return Stack(
            children: [
              MediaQuery(
                data: mediaQuery.copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: child ?? const SizedBox(),
              ),
              // DEBUG 오버레이
              Positioned(
                top: 20,
                left: 0,
                child: IgnorePointer(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      'mq:${mediaQuery.size.height.toInt()} vv:${vvNow.toInt()}',
                      style: const TextStyle(color: Colors.yellow, fontSize: 11, fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
