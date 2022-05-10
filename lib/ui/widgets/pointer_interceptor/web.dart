import 'package:flutter/widgets.dart';
import 'html_view_controller.dart';

/// The web implementation of the `PointerInterceptor` widget.
///
/// A `Widget` that prevents clicks from being swallowed by [HtmlElementView]s.
class PointerInterceptor extends StatelessWidget {
  /// Creates a PointerInterceptor for the web.
  PointerInterceptor({
    required this.child,
    this.intercepting = true,
    this.debug = false,
    Key? key,
  }) : super(key: key) {
    HtmlElementViewController().registerFactories();
  }

  /// The `Widget` that is being wrapped by this `PointerInterceptor`.
  final Widget child;

  /// Whether or not this `PointerInterceptor` should intercept pointer events.
  final bool intercepting;

  /// When true, the widget renders with a semi-transparent red background, for debug purposes.
  ///
  /// This is useful when rendering this as a "layout" widget, like the root child
  /// of a [Drawer].
  final bool debug;

  @override
  Widget build(BuildContext context) {
    // if (!intercepting) {
    //   print('clean');
    //   return child;
    // }
    final viewType = HtmlElementViewController().getViewType(debug: debug);
    final htmlElementView = HtmlElementView(
      viewType: viewType,
      onPlatformViewCreated: (id) {
        print('Platform View Created with $id');
      },
    );

    print('PointerInterceptor.build() with $intercepting');
    print(viewType);
    return Stack(
      children: [
        if (intercepting)
          Positioned.fill(
            child: htmlElementView,
          )
        else
          Positioned.fromRect(
            rect: const Rect.fromLTRB(0, 0, 1, 1),
            child: htmlElementView,
          ),
        child,
      ],
    );
  }
}
