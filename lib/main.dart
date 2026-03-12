import 'dart:async';

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
  Timer? _viewportPollingTimer;
  // 폴링에서 이전 vvHeight를 추적 (키보드 올라옴 감지용)
  double _prevVvHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Android 뒤로 버튼으로 키보드 닫힐 때 DOM 이벤트가 발생하지 않는 문제 해결.
    // Dart에서 직접 visualViewport.height를 폴링하여 변화 감지 시 setState() 호출.
    if (kIsWeb) {
      _viewportPollingTimer = Timer.periodic(
        const Duration(milliseconds: 50),
        (_) {
          final vvHeight = getVisualViewportHeight();
          if (vvHeight <= 0) return;

          if (_prevVvHeight > 0 && vvHeight > _prevVvHeight) {
            // vvHeight가 증가 = 키보드가 닫혔음
            // 포커스 강제 해제 → Flutter 엔진이 히트 테스트 영역을 즉시 재계산하도록
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() {
              _lastValidHeight = vvHeight;
              _prevVvHeight = vvHeight;
            });
            return;
          }
          _prevVvHeight = vvHeight;
        },
      );
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
    _viewportPollingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 화면 회전 감지용
  @override
  void didChangeMetrics() {
    if (!kIsWeb) return;
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalWidth = view.physicalSize.width / view.devicePixelRatio;

    // 가로가 바뀌면(회전)만 처리 — 키보드 높이 변화는 폴링에서 처리
    if (logicalWidth != _lastValidWidth) {
      final vvHeight = getVisualViewportHeight();
      setState(() {
        _lastValidWidth = logicalWidth;
        _lastValidHeight = vvHeight > 0 ? vvHeight : view.physicalSize.height / view.devicePixelRatio;
        _prevVvHeight = _lastValidHeight;
      });
    }
    // 높이만 바뀐 경우(키보드) — setState 하지 않음, 폴링이 처리
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

          final fixedHeight = _lastValidHeight;
          final fixedWidth = mediaQuery.size.width;

          return OverflowBox(
            alignment: Alignment.topCenter,
            minWidth: fixedWidth,
            maxWidth: fixedWidth,
            minHeight: fixedHeight,
            maxHeight: fixedHeight,
            child: Stack(
              children: [
                MediaQuery(
                  data: mediaQuery.copyWith(
                    textScaler: TextScaler.noScaling,
                    viewInsets: mediaQuery.viewInsets.copyWith(bottom: 0),
                    size: Size(fixedWidth, fixedHeight),
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
                        'mq:${mediaQuery.size.height.toInt()} fix:${fixedHeight.toInt()} vv:${getVisualViewportHeight().toInt()}',
                        style: const TextStyle(color: Colors.yellow, fontSize: 11, fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
