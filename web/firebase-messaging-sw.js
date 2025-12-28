// Firebase Cloud Messaging Service Worker
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Firebase 설정은 런타임에 index.html에서 주입됩니다
// 하지만 Service Worker는 별도의 컨텍스트에서 실행되므로
// 환경 변수를 직접 사용할 수 없습니다.
//
// 개발 환경에서는 이 파일이 존재하기만 하면 됩니다.
// 프로덕션에서는 Firebase 설정을 하드코딩하거나
// 빌드 시 환경 변수를 주입해야 합니다.

// 임시 설정 (개발용)
// 실제 Firebase 설정은 .env 파일을 참조하세요
const firebaseConfig = {
  apiKey: "your-api-key",
  authDomain: "your-auth-domain",
  projectId: "your-project-id",
  storageBucket: "your-storage-bucket",
  messagingSenderId: "your-messaging-sender-id",
  appId: "your-app-id"
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
} catch (error) {
  console.error('[firebase-messaging-sw.js] Failed to initialize Firebase:', error);
}
