import 'package:flutter/material.dart';
import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/core/services/user_service.dart';
import 'package:historical_guide/router/app_routes.dart';
import 'package:historical_guide/ui/views/login/login_view.dart';
import 'package:provider/provider.dart';

import '../ui/views/app_shell.dart';

class RootRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppState _appState;

  RootRouterDelegate({required AppState appState})
      : navigatorKey = GlobalKey<NavigatorState>(),
        _appState = appState {
    appState.addListener(notifyListeners);
  }

  @override
  AppRoutePath get currentConfiguration {
    print(
        'RootRouterDelegate get currentConfiguration = ${_appState.currentDestination}');
    switch (_appState.currentDestination) {
      case AppState.mapPath:
        return MapPath();
      case AppState.guidesPath:
        print('selected tour = ${_appState.selectedPageId}');
        if (_appState.selectedPageId == null) {
          return GuidesPath();
        } else {
          return GuideDetailPath(_appState.selectedPageId!);
        }
      case AppState.aboutPath:
        return AboutPath();
      default:
        return GuidesPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build root router delegate');
    return Navigator(
      key: navigatorKey,
      pages: _appState.getRootPage(),
      // [
      //   MaterialPage(
      //     child: context.read<UserService>().loggedIn
      //         ? const AppShell()
      //         : const LoginView(),
      //   )
      // ],
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    print('RootRouterDelegate.setNewRoutePath()');
    print('new path = $configuration');
    if (configuration is MapPath) {
      _appState.setHomePage(0);
    } else if (configuration is GuidesPath) {
      _appState.setHomePage(1);
    } else if (configuration is AboutPath) {
      _appState.setHomePage(2);
    } else if (configuration is GuideDetailPath) {
      print('selected tour = ${configuration.id}');
      _appState.selectedPageId = configuration.id;
      _appState.selectedIndex = 1;
    }
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    notifyListeners();
    return true;
  }
}
