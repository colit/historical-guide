// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'shim/dart_ui.dart' as ui;

class HtmlElementViewController {
  static final HtmlElementViewController _singleton =
      HtmlElementViewController._internal();

  factory HtmlElementViewController() {
    return _singleton;
  }

  HtmlElementViewController._internal();

  static const String viewType = '__webPointerInterceptorViewType__';
  static const String debugKey = 'debug__';

  bool registered = false;

  void registerFactories() {
    print('registerFactories()');
    if (!registered) {
      _registerFactory();
      _registerFactory(debug: true);
      registered = true;
    }
  }

  void reset() {
    registered = false;
  }

  String getViewType({bool debug = false}) {
    return debug ? viewType + debugKey : viewType;
  }

  void _registerFactory({bool debug = false}) {
    print('_registerFactory($debug)');
    final String viewType = getViewType(debug: debug);
    ui.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        print('--------- factory view $viewType');
        final divElement = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%';
        if (debug) {
          divElement.style.backgroundColor = 'rgba(255, 0, 0, .5)';
        }
        return divElement;
      },
      isVisible: false,
    );
  }
}
