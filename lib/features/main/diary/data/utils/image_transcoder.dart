/// 이미지 재인코딩 — 플랫폼별 구현으로 갈린다
///
/// 모바일은 `flutter_image_compress`(플랫폼 코덱), 웹은 캔버스를 쓴다.
/// 웹에서 순수 Dart 디코더(`package:image`)를 쓰면 12MP 사진 한 장에
/// UI가 멈추므로, 브라우저 네이티브 경로를 쓰는 것이 중요하다.
library;

export 'image_transcoder_io.dart'
    if (dart.library.js_interop) 'image_transcoder_web.dart';
