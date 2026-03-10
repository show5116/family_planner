import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // 웹에서 키보드 이벤트 경고 제거
  // Flutter 웹에서 키보드 입력 시 발생하는 채널 버퍼 경고를 방지
  if (kIsWeb) {
    // 키보드 이벤트 채널의 버퍼 용량 증가
    ServicesBinding.instance.channelBuffers.setListener('flutter/keyevent', (
      data,
      callback,
    ) async {
      callback(data);
    });
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 키보드 올라오거나 내려갈 때 (metrics 변화) 호출됨
  @override
  void didChangeMetrics() {
    if (!kIsWeb) return;
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final physicalHeight = view.physicalSize.height;
    final dpr = view.devicePixelRatio;
    final logicalHeight = physicalHeight / dpr;
    final logicalWidth = view.physicalSize.width / dpr;

    // 가로가 바뀌면(회전) 기준 초기화
    if (logicalWidth != _lastValidWidth) {
      setState(() {
        _lastValidWidth = logicalWidth;
        _lastValidHeight = logicalHeight;
      });
      return;
    }

    // 높이가 커졌을 때만(키보드 내려감) setState로 rebuild
    if (logicalHeight > _lastValidHeight) {
      setState(() {
        _lastValidHeight = logicalHeight;
      });
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
          final currentSize = mediaQuery.size;

          // 초기값 설정 (첫 빌드 시)
          if (_lastValidHeight == 0.0) {
            _lastValidHeight = currentSize.height;
            _lastValidWidth = currentSize.width;
          }

          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.noScaling,
              viewInsets: mediaQuery.viewInsets.copyWith(bottom: 0),
              size: Size(
                currentSize.width,
                _lastValidHeight > 0 ? _lastValidHeight : currentSize.height,
              ),
            ),
            child: child ?? const SizedBox(),
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
