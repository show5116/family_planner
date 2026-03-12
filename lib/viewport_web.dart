import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('window.visualViewport')
external _VisualViewport? get _visualViewport;

@JS('window.innerHeight')
external double get _innerHeight;

extension type _VisualViewport._(JSObject _) implements JSObject {
  external double get height;
}

/// Returns the current visual viewport height (accounts for on-screen keyboard).
double getVisualViewportHeight() {
  final vp = _visualViewport;
  if (vp == null) return _innerHeight;
  return vp.height;
}

/// Dispatches a resize event to trigger Flutter engine physicalSize recalculation.
void dispatchResizeEvent() {
  web.window.dispatchEvent(web.Event('resize'));
}
