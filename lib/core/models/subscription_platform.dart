/// 인앱결제 검증 요청 시 사용하는 플랫폼 구분자
enum SubscriptionPlatform {
  android,
  ios;

  String get value => switch (this) {
        SubscriptionPlatform.android => 'ANDROID',
        SubscriptionPlatform.ios => 'IOS',
      };
}
