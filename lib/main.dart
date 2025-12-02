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
import 'package:family_planner/features/auth/providers/auth_provider.dart';
import 'package:family_planner/core/services/oauth_callback_handler.dart';
import 'package:family_planner/l10n/app_localizations.dart';

void main() {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 웹에서 키보드 이벤트 경고 제거
  // Flutter 웹에서 키보드 입력 시 발생하는 채널 버퍼 경고를 방지
  if (kIsWeb) {
    // 키보드 이벤트 채널의 버퍼 용량 증가
    ServicesBinding.instance.channelBuffers.setListener(
      'flutter/keyevent',
      (data, callback) async {
        callback(data);
      },
    );
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
    const ProviderScope(
      child: MyApp(),
    ),
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
    // 앱 시작 시 인증 상태 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).checkAuthStatus();

      // Deep Link 리스너 초기화 (웹 전용)
      // 웹에서 OAuth URL 방식 로그인 시 콜백을 받기 위함
      // 모바일은 SDK 방식을 사용하므로 Deep Link 불필요
      if (kIsWeb) {
        OAuthCallbackHandler().initDeepLinkListener();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 테마 모드 상태 감지
    final themeMode = ref.watch(themeModeProvider);
    // 언어 설정 상태 감지
    final locale = ref.watch(localeProvider);
    // GoRouter 인스턴스 가져오기
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Family Planner',
      debugShowCheckedModeBanner: false,

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
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // 텍스트 스케일 고정 (웹에서 브라우저 설정에 영향받지 않도록)
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
