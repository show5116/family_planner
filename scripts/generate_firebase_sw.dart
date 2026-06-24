#!/usr/bin/env dart

import 'dart:io';

/// .env 파일에서 Firebase 설정을 읽어 firebase-messaging-sw.js 파일을 생성합니다.
void main() {
  try {
    // .env 파일 읽기
    final envFile = File('.env');
    if (!envFile.existsSync()) {
      print('❌ .env 파일을 찾을 수 없습니다.'); // ignore: avoid_print
      exit(1);
    }

    final envContent = envFile.readAsStringSync();
    final envMap = <String, String>{};

    // .env 파일 파싱
    for (var line in envContent.split('\n')) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final parts = line.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        envMap[key] = value;
      }
    }

    // Firebase Web 설정 추출
    final apiKey = envMap['FIREBASE_WEB_API_KEY'];
    final authDomain = envMap['FIREBASE_WEB_AUTH_DOMAIN'];
    final projectId = envMap['FIREBASE_WEB_PROJECT_ID'];
    final storageBucket = envMap['FIREBASE_WEB_STORAGE_BUCKET'];
    final messagingSenderId = envMap['FIREBASE_WEB_MESSAGING_SENDER_ID'];
    final appId = envMap['FIREBASE_WEB_APP_ID'];

    // 필수 값 확인
    if (apiKey == null ||
        authDomain == null ||
        projectId == null ||
        storageBucket == null ||
        messagingSenderId == null ||
        appId == null) {
      print('❌ .env 파일에 필수 Firebase Web 설정이 없습니다.'); // ignore: avoid_print
      exit(1);
    }

    // firebase-messaging-sw.js 생성
    final swContent = '''
// Firebase Cloud Messaging Service Worker
// 🤖 이 파일은 자동 생성됩니다. 수동으로 수정하지 마세요.
// 생성 스크립트: scripts/generate_firebase_sw.dart

importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Firebase 설정 (.env 파일에서 자동 주입)
const firebaseConfig = {
  apiKey: "$apiKey",
  authDomain: "$authDomain",
  projectId: "$projectId",
  storageBucket: "$storageBucket",
  messagingSenderId: "$messagingSenderId",
  appId: "$appId"
};

try {
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  // 백그라운드 메시지 처리
  messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message:', payload);

    const notificationTitle = payload.notification?.title || 'New Notification';
    const notificationOptions = {
      body: payload.notification?.body || '',
      icon: '/icons/Icon-192.png',
      data: payload.data
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
  });

  console.log('✅ [firebase-messaging-sw.js] Firebase initialized successfully');
} catch (error) {
  console.error('[firebase-messaging-sw.js] Failed to initialize Firebase:', error);
}
''';

    // 파일 저장
    final outputFile = File('web/firebase-messaging-sw.js');
    outputFile.writeAsStringSync(swContent);

    print('✅ firebase-messaging-sw.js 파일이 성공적으로 생성되었습니다.'); // ignore: avoid_print
    print('   경로: ${outputFile.absolute.path}'); // ignore: avoid_print
  } catch (e) {
    print('❌ 오류 발생: $e'); // ignore: avoid_print
    exit(1);
  }
}
