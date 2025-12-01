# 소셜 로그인 설정 가이드

Google 및 Kakao 소셜 로그인 설정 및 트러블슈팅 가이드

## Google OAuth 2.0 설정

### 1. Google Cloud Console 설정

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. 프로젝트 생성 또는 선택
3. **필수 API 활성화** (매우 중요):
   - 좌측 메뉴: **API 및 서비스 > 라이브러리**
   - **Google+ API** 검색 → **사용 설정**
   - **People API** 검색 → **사용 설정**
   - (선택) **Google Identity Toolkit API** → **사용 설정**
   - API 활성화 후 1-2분 대기

4. **OAuth 클라이언트 ID 생성**:
   - **API 및 서비스 > 사용자 인증 정보** 이동
   - **사용자 인증 정보 만들기 > OAuth 클라이언트 ID** 선택
   - 동의 화면 구성 (처음 설정하는 경우)
   - **웹 애플리케이션** 선택

5. **승인된 JavaScript 원본** (정확히 입력):
   ```
   http://localhost:3001
   https://yourdomain.com
   ```

6. **승인된 리디렉션 URI** (정확히 입력, 매우 중요):
   ```
   http://localhost:3001
   http://localhost:3001/
   https://yourdomain.com
   https://yourdomain.com/
   ```

   ⚠️ **주의**:
   - URI는 대소문자를 구분하며 정확히 일치해야 함
   - 포트 번호, 슬래시(`/`) 유무도 정확히 일치해야 함
   - `http://localhost:3001`과 `http://localhost:3001/`는 **다른 URI**

7. 생성된 **클라이언트 ID** 복사

### 2. 프로젝트에 클라이언트 ID 설정

**lib/core/config/environment.dart:**
```dart
static String get googleWebClientId {
  return '123456789-abcdef.apps.googleusercontent.com';
}
```

**web/index.html:**
```html
<meta name="google-signin-client_id" content="123456789-abcdef.apps.googleusercontent.com">
```

### 3. Android 설정 (선택사항)

1. Google Cloud Console에서 **Android** 클라이언트 ID 추가
2. 패키지 이름: `com.example.family_planner`
3. SHA-1 인증서 지문 입력:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
4. 생성된 클라이언트 ID를 `environment.dart`에 설정

### 4. iOS 설정 (선택사항)

1. Google Cloud Console에서 **iOS** 클라이언트 ID 추가
2. 번들 ID: `com.example.familyPlanner`
3. 생성된 클라이언트 ID를 `environment.dart`에 설정
4. `ios/Runner/Info.plist`에 URL 스킴 추가:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
       </array>
     </dict>
   </array>
   ```

## Kakao Login 설정

### 1. Kakao Developers 설정

1. [Kakao Developers](https://developers.kakao.com/) 접속 및 로그인
2. **내 애플리케이션 > 애플리케이션 추가하기**
3. 앱 이름 입력 (예: "Family Planner")
4. **앱 키** 확인:
   - **네이티브 앱 키** (Android, iOS용)
   - **JavaScript 키** (웹용)

### 2. 플랫폼 설정

- **Web**: 사이트 도메인 등록
  - `http://localhost:3001`
  - `https://yourdomain.com`
- **Android**: 패키지명, 키 해시 등록
  - 패키지명: `com.example.family_planner`
- **iOS**: 번들 ID 등록
  - 번들 ID: `com.example.familyPlanner`

### 3. Kakao Login 활성화

1. **제품 설정 > 카카오 로그인** 이동
2. 카카오 로그인 **활성화** ON
3. **Redirect URI** 등록:
   ```
   http://localhost:3001/auth/kakao/callback
   https://yourdomain.com/auth/kakao/callback
   ```
4. **동의 항목** 설정:
   - 닉네임, 프로필 사진, 카카오계정(이메일) 필수 동의

### 4. 프로젝트에 앱 키 설정

**lib/core/config/environment.dart:**
```dart
static String get kakaoNativeAppKey {
  return 'abcdef1234567890abcdef1234567890';
}

static String get kakaoJavaScriptAppKey {
  return '1234567890abcdef1234567890abcdef';
}
```

### 5. Android 추가 설정

**android/app/src/main/AndroidManifest.xml:**
```xml
<activity
    android:name="com.kakao.sdk.flutter.AuthCodeCustomTabsActivity"
    android:exported="true">
    <intent-filter android:label="flutter_web_auth">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="kakao{YOUR_NATIVE_APP_KEY}" android:host="oauth"/>
    </intent-filter>
</activity>
```

### 6. iOS 추가 설정

**ios/Runner/Info.plist:**
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>kakao{YOUR_NATIVE_APP_KEY}</string>
    </array>
  </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
  <string>kakaokompassauth</string>
  <string>kakaolink</string>
</array>
```

## 설정 확인

설정 완료 후:
```bash
flutter clean
flutter pub get
flutter run -d chrome --web-port=3001
```

## 트러블슈팅

### Google Login 에러

#### 1. "redirect_uri_mismatch" 에러

**증상:**
```
액세스 차단됨: 이 앱의 요청이 잘못되었습니다
400 오류: redirect_uri_mismatch
```

**원인:** URI 불일치

**해결:**
1. 브라우저 주소창에서 실행 중인 URL 확인
2. Google Cloud Console > 사용자 인증 정보 > OAuth 클라이언트 ID
3. **승인된 리디렉션 URI**에 다음 모두 추가:
   ```
   http://localhost:3001
   http://localhost:3001/
   ```
4. 저장 후 5-10분 대기
5. 브라우저 캐시 삭제
6. 앱 재시작

#### 2. "ClientID not set" 에러

**원인:** 클라이언트 ID 미설정

**해결:**
1. `web/index.html` 확인:
   ```html
   <meta name="google-signin-client_id" content="YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com">
   ```
2. `lib/core/config/environment.dart` 확인:
   ```dart
   static String get googleWebClientId {
     return 'YOUR_ACTUAL_CLIENT_ID.apps.googleusercontent.com';
   }
   ```

#### 3. "Method doesn't allow unregistered callers" 403 에러

**증상:**
```
403 에러: Method doesn't allow unregistered callers
```

**원인:** 필수 API 미활성화

**해결:**
1. Google Cloud Console 접속
2. **API 및 서비스 > 라이브러리**
3. **Google+ API** 검색 → **사용 설정**
4. **People API** 검색 → **사용 설정**
5. 1-2분 대기
6. 앱 재시작

⚠️ **참고:**
- Google+ API는 deprecated지만 Google Sign-In에서 여전히 필요
- API 활성화 후 즉시 적용되지 않을 수 있음

#### 4. "People API has not been used" 에러

**증상:**
```
People API has not been used in project...
```

**원인:** People API 미활성화

**해결:**
1. 에러 메시지의 링크 클릭 (가장 빠름)
2. **사용 설정** 클릭
3. 1-2분 대기
4. 앱 재시작

#### 5. CORS 에러

**원인:** JavaScript 원본 미설정

**해결:**
- Google Cloud Console > OAuth 클라이언트 ID
- **승인된 JavaScript 원본**에 `http://localhost:3001` 추가

### Kakao Login 에러

일반적인 Kakao 로그인 에러는 다음을 확인하세요:
1. 앱 키가 올바르게 설정되었는지 확인
2. Redirect URI가 정확히 등록되었는지 확인
3. 카카오 로그인이 활성화되었는지 확인
4. 동의 항목이 올바르게 설정되었는지 확인

## 참고 사항

- 웹: OAuth URL 리다이렉트 방식 사용
- 모바일: SDK 방식 사용
- 모바일용 토큰 검증 API는 백엔드에 추가 필요
  - `POST /auth/google/token`
  - `POST /auth/kakao/token`
