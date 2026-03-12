import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('window.visualViewport')
external _VisualViewport? get _visualViewport;

@JS('window.innerHeight')
external double get _innerHeight;

extension type _VisualViewport._(JSObject _) implements JSObject {
  external double get height;
  external void addEventListener(String type, JSFunction listener);
  external void removeEventListener(String type, JSFunction listener);
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

/// Registers a listener on visualViewport resize event.
/// Returns a function to remove the listener.
void Function() addVisualViewportResizeListener(void Function(double height) onResize) {
  final vp = _visualViewport;
  if (vp == null) return () {};

  final listener = ((JSObject _) {
    onResize(vp.height);
  }).toJS;

  vp.addEventListener('resize', listener);
  return () => vp.removeEventListener('resize', listener);
}
