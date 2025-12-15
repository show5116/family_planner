import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'package:family_planner/l10n/app_localizations.dart';

/// 전역 ScaffoldMessenger Key
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

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

class _MyAppState extends ConsumerState<MyApp> {
  double _lastValidHeight = 0.0;
  double _lastValidWidth = 0.0;

  @override
  void initState() {
    super.initState();

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
      themeMode: themeMode, // Provider에서 관리되는 테마 모드 사용
      // 라우팅 설정
      routerConfig: router,

      // 로케일 설정
      locale: locale, // Provider에서 관리되는 언어 설정 (null이면 시스템 언어 사용)
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어
        Locale('en', 'US'), // 영어
        Locale('ja', 'JP'), // 일본어
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // 앱 다국어
        GlobalMaterialLocalizations.delegate, // Material 위젯 다국어
        GlobalWidgetsLocalizations.delegate, // 일반 위젯 다국어
        GlobalCupertinoLocalizations.delegate, // Cupertino 위젯 다국어
      ],

      // 웹에서 스크롤 동작 개선
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        if (kIsWeb) {
          final currentSize = mediaQuery.size;

          // 1. 높이 캐싱 로직
          // 가로(Width)가 변했다면(회전 등), 높이 기준도 초기화하고 새로 잡습니다.
          if (currentSize.width != _lastValidWidth) {
            _lastValidWidth = currentSize.width;
            _lastValidHeight = currentSize.height;
          } else {
            // 가로는 그대로인데, 높이가 더 커졌다면(키보드가 내려감) 최신 높이로 갱신
            if (currentSize.height > _lastValidHeight) {
              _lastValidHeight = currentSize.height;
            }
            // 높이가 작아졌다면(키보드가 올라옴)? -> _lastValidHeight를 그대로 유지 (갱신 X)
          }

          // 2. 강제 고정 MediaQuery 생성
          // 현재 화면 높이가 줄어들었더라도(_lastValidHeight보다 작더라도)
          // 우리는 무조건 '가장 컸던 높이(_lastValidHeight)'를 사용하라고 강제합니다.
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.noScaling,
              // 키보드 영역 0으로 강제
              viewInsets: mediaQuery.viewInsets.copyWith(bottom: 0),
              size: Size(
                currentSize.width,
                _lastValidHeight > 0 ? _lastValidHeight : currentSize.height,
              ),
            ),
            child: child ?? const SizedBox(),
          );
        }

        // 웹이 아니면 기본 로직
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
