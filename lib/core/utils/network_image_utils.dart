import 'package:cached_network_image/cached_network_image.dart';

/// Cloudflare R2 pub-xxxx.r2.dev 도메인은 비브라우저 User-Agent를 차단하는 경우가 있어
/// 안드로이드에서 이미지가 표시되지 않는 문제가 발생한다.
/// 모든 네트워크 이미지 요청에 브라우저 호환 헤더를 포함시킨다.
const Map<String, String> _imageRequestHeaders = {
  'User-Agent':
      'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
};

CachedNetworkImageProvider networkImageProvider(String url) {
  return CachedNetworkImageProvider(url, headers: _imageRequestHeaders);
}
