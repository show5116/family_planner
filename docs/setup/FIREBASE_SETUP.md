# Firebase 설정 가이드

> Firebase Cloud Messaging (FCM) 푸시 알림을 위한 플랫폼별 설정 가이드

---

## 📋 사전 준비

1. [Firebase Console](https://console.firebase.google.com/)에서 프로젝트 생성
2. 프로젝트에 앱 추가 (Android, iOS, Web)

---

## 🤖 Android 설정

> **현재 패키지 이름**: `com.example.family_planner`
>
> **프로덕션 배포 시 변경 권장**: `com.yourcompany.family_planner`로 변경하고 Firebase 앱도 재등록하세요.

### 1. Firebase 프로젝트에 Android 앱 추가

1. Firebase Console > 프로젝트 설정 > 앱 추가
2. Android 패키지 이름 입력: `com.example.family_planner`
   - **참고**: 현재 프로젝트의 패키지 이름입니다
   - **권장**: 프로덕션 배포 시 `com.yourcompany.family_planner`로 변경 권장
   - 패키지 이름 확인: `android/app/build.gradle.kts`의 `applicationId` 참고
3. 앱 닉네임 입력 (선택사항)
4. SHA-1 인증서 지문 추가 (선택사항, 나중에도 추가 가능)

### 2. google-services.json 다운로드

1. Firebase Console에서 `google-services.json` 파일 다운로드
2. 파일을 `android/app/` 디렉토리에 복사

```
android/
└── app/
    └── google-services.json  <- 여기에 배치
```

### 3. Android 프로젝트 설정

#### android/build.gradle
```gradle
buildscript {
    dependencies {
        // Firebase 플러그인 추가
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

#### android/app/build.gradle
```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    // Firebase 플러그인 적용
    id 'com.google.gms.google-services'
}

android {
    defaultConfig {
        minSdkVersion 21  // 최소 21 이상
        targetSdkVersion flutter.targetSdkVersion
        // ...
    }
}
```

#### android/app/src/main/AndroidManifest.xml
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 인터넷 권한 -->
    <uses-permission android:name="android.permission.INTERNET"/>

    <!-- 알림 권한 (Android 13+) -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application>
        <!-- 기본 알림 아이콘 설정 -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />

        <!-- 기본 알림 색상 -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />

        <!-- 기본 알림 채널 ID -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="default_channel" />
    </application>
</manifest>
```

#### 알림 아이콘 및 색상 리소스 추가

1. `android/app/src/main/res/drawable/ic_notification.xml` 생성:
```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24"
    android:tint="?attr/colorControlNormal">
    <path
        android:fillColor="@android:color/white"
        android:pathData="M12,22c1.1,0 2,-0.9 2,-2h-4c0,1.1 0.89,2 2,2zM18,16v-5c0,-3.07 -1.64,-5.64 -4.5,-6.32V4c0,-0.83 -0.67,-1.5 -1.5,-1.5s-1.5,0.67 -1.5,1.5v0.68C7.63,5.36 6,7.92 6,11v5l-2,2v1h16v-1l-2,-2z"/>
</vector>
```

2. `android/app/src/main/res/values/colors.xml` 생성:
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="notification_color">#4A90E2</color>
</resources>
```

---

## 🍎 iOS 설정

### 1. Firebase 프로젝트에 iOS 앱 추가

1. Firebase Console > 프로젝트 설정 > 앱 추가
2. iOS 번들 ID 입력: `com.example.familyPlanner`
3. 앱 닉네임 입력 (선택사항)
4. App Store ID (선택사항)

### 2. GoogleService-Info.plist 다운로드

1. Firebase Console에서 `GoogleService-Info.plist` 파일 다운로드
2. Xcode에서 `ios/Runner` 프로젝트에 파일 추가
   - Xcode에서 `Runner` 프로젝트 열기
   - `Runner` 폴더에 파일 드래그 앤 드롭
   - "Copy items if needed" 체크
   - Target에 "Runner" 선택

### 3. APNs 인증 키 설정

#### APNs 인증 키 생성 (Apple Developer)

1. [Apple Developer Console](https://developer.apple.com/account) 접속
2. Certificates, Identifiers & Profiles > Keys
3. "+" 버튼 클릭하여 새 키 생성
4. "Apple Push Notifications service (APNs)" 선택
5. 키 이름 입력 후 Continue
6. .p8 파일 다운로드 (한 번만 다운로드 가능하므로 안전하게 보관)
7. Key ID 기록

#### Firebase Console에 APNs 키 업로드

1. Firebase Console > 프로젝트 설정 > Cloud Messaging 탭
2. Apple 앱 구성 > APNs 인증 키 업로드
3. .p8 파일 선택
4. Key ID 입력
5. Team ID 입력 (Apple Developer Account의 Membership 페이지에서 확인)

### 4. Xcode 프로젝트 설정

#### Push Notifications Capability 활성화

1. Xcode에서 `ios/Runner.xcworkspace` 열기
2. Runner 프로젝트 선택 > Signing & Capabilities 탭
3. "+ Capability" 버튼 클릭
4. "Push Notifications" 추가
5. "Background Modes" 추가
   - "Remote notifications" 체크

#### ios/Runner/Info.plist
```xml
<dict>
    <!-- 기존 설정들... -->

    <!-- 알림 권한 설명 추가 -->
    <key>NSUserNotificationsUsageDescription</key>
    <string>일정, 할 일, 그룹 초대 등의 알림을 받기 위해 권한이 필요합니다.</string>
</dict>
```

---

## 🌐 Web 설정

### 1. Firebase 프로젝트에 Web 앱 추가

1. Firebase Console > 프로젝트 설정 > 앱 추가
2. 웹 앱 닉네임 입력
3. Firebase Hosting 설정 (선택사항)
4. Firebase SDK 설정 코드 복사

### 2. Firebase SDK 추가

#### web/index.html
```html
<!DOCTYPE html>
<html>
<head>
    <!-- 기존 헤드 내용... -->
</head>
<body>
    <!-- Firebase SDK -->
    <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js"></script>

    <script>
        // Firebase 설정
        const firebaseConfig = {
            apiKey: "YOUR_API_KEY",
            authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
            projectId: "YOUR_PROJECT_ID",
            storageBucket: "YOUR_PROJECT_ID.appspot.com",
            messagingSenderId: "YOUR_SENDER_ID",
            appId: "YOUR_APP_ID"
        };

        // Firebase 초기화
        firebase.initializeApp(firebaseConfig);
    </script>

    <!-- Flutter 앱 로드 -->
    <script src="flutter_bootstrap.js" async></script>
</body>
</html>
```

### 3. Service Worker 생성

#### web/firebase-messaging-sw.js
```javascript
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Firebase 설정 (index.html과 동일)
firebase.initializeApp({
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT_ID.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
});

const messaging = firebase.messaging();

// 백그라운드 메시지 핸들러
messaging.onBackgroundMessage((payload) => {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/icons/Icon-192.png'
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
```

### 4. Firebase Console에서 Web Push 인증서 생성

1. Firebase Console > 프로젝트 설정 > Cloud Messaging 탭
2. 웹 구성 > 웹 푸시 인증서
3. "키 쌍 생성" 클릭
4. 생성된 키 복사

#### Flutter 앱에서 사용
```dart
// Web에서 FCM 토큰 가져올 때 사용
final token = await FirebaseMessaging.instance.getToken(
    vapidKey: 'YOUR_WEB_PUSH_CERTIFICATE_KEY',
);
```

### 5. HTTPS 환경 필수

- 로컬 개발: `localhost` 사용 가능
- 프로덕션: HTTPS 필수 (Service Worker 제한)

---

## 🔧 Flutter 앱에서 Firebase 초기화

### lib/main.dart
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase 초기화
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
}
```

### Firebase 옵션 파일 생성

Firebase CLI를 사용하여 플랫폼별 설정 파일 자동 생성:

```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login

# FlutterFire CLI 설치
dart pub global activate flutterfire_cli

# Firebase 프로젝트 설정 파일 생성
flutterfire configure
```

명령 실행 후:
1. Firebase 프로젝트 선택
2. 지원할 플랫폼 선택 (Android, iOS, Web)
3. `lib/firebase_options.dart` 파일 자동 생성됨

---

## ✅ 설정 확인

### Android
```bash
flutter run -d android
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d chrome --web-port=3001
```

### FCM 토큰 확인

앱 실행 후 로그에서 FCM 토큰 확인:
```
[firebase_messaging] FCM Token: eyJhbGc...
```

---

## 🧪 테스트

### Firebase Console에서 테스트 메시지 전송

1. Firebase Console > Cloud Messaging
2. "Send your first message" 클릭
3. 알림 제목 및 내용 입력
4. "Send test message" 클릭
5. FCM 토큰 입력 후 전송

---

## 🚨 트러블슈팅

### Android

**문제**: `google-services.json not found`
- **해결**: `android/app/` 디렉토리에 파일이 있는지 확인

**문제**: `Duplicate class com.google.android.gms...`
- **해결**: `android/app/build.gradle`의 dependencies 확인, 중복 제거

**문제**: 알림이 표시되지 않음
- **해결**:
  - Android 13+ 기기에서 알림 권한 확인
  - 앱 설정에서 알림 허용 확인
  - 알림 채널이 올바르게 설정되었는지 확인

### iOS

**문제**: `GoogleService-Info.plist not found`
- **해결**: Xcode에서 파일이 `Runner` 타겟에 포함되었는지 확인

**문제**: APNs 연결 실패
- **해결**:
  - APNs 인증 키가 Firebase Console에 올바르게 등록되었는지 확인
  - Bundle ID가 일치하는지 확인

**문제**: 실기기에서만 테스트 가능
- **참고**: iOS 시뮬레이터는 푸시 알림을 지원하지 않음

### Web

**문제**: `messaging/unsupported-browser`
- **해결**: HTTPS 환경에서 실행 (localhost 제외)

**문제**: Service Worker 등록 실패
- **해결**:
  - `firebase-messaging-sw.js` 파일이 `web/` 디렉토리에 있는지 확인
  - Firebase 설정이 올바른지 확인

**문제**: 토큰을 가져올 수 없음
- **해결**: VAPID 키가 올바르게 설정되었는지 확인

---

## 📚 참고 자료

- [FlutterFire 공식 문서](https://firebase.flutter.dev/)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)
- [APNs 설정 가이드](https://firebase.google.com/docs/cloud-messaging/ios/client)

---

## 💡 패키지 이름 변경 방법 (선택사항)

프로덕션 배포를 위해 `com.example.family_planner`를 변경하려면:

### Android
1. `android/app/build.gradle.kts` 수정:
```kotlin
android {
    namespace = "com.yourcompany.family_planner"

    defaultConfig {
        applicationId = "com.yourcompany.family_planner"
        // ...
    }
}
```

2. 패키지 구조 변경:
```
android/app/src/main/kotlin/
└── com/yourcompany/family_planner/  <- 폴더 구조 변경
    └── MainActivity.kt                <- 파일 내 package 선언도 수정
```

3. `android/app/src/main/AndroidManifest.xml`의 `package` 속성 확인

### iOS
1. Xcode에서 `ios/Runner.xcworkspace` 열기
2. Runner 프로젝트 선택 > General 탭
3. Bundle Identifier 변경: `com.yourcompany.familyPlanner`

### Firebase
- 새 패키지 이름으로 Firebase Console에서 앱을 다시 등록
- 새 설정 파일(`google-services.json`, `GoogleService-Info.plist`) 다운로드 및 교체

---

## 🔗 관련 문서

- [14-notification.md](features/14-notification.md) - 알림 기능 상세 문서
- [CLAUDE.md](../CLAUDE.md) - 프로젝트 개발 가이드
