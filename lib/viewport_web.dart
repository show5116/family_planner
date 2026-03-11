import 'dart:js_interop';

@JS('window.visualViewport.height')
external double? get _visualViewportHeight;

@JS('window.innerHeight')
external double get _innerHeight;

/// Returns the current visual viewport height (accounts for on-screen keyboard).
double getVisualViewportHeight() {
  return _visualViewportHeight ?? _innerHeight;
}
