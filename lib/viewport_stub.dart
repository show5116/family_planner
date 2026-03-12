/// Stub for non-web platforms.
double getVisualViewportHeight() => 0.0;
void dispatchResizeEvent() {}
void Function() addVisualViewportResizeListener(void Function(double height) onResize) => () {};
void resetBrowserScroll() {}
