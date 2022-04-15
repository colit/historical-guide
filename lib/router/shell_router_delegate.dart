import 'package:flutter/material.dart';
import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/core/services/user_service.dart';
import 'package:historical_guide/router/app_routes.dart';

class ShellRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ShellRouterDelegate(
      {required AppState appState, required UserService userService})
      : _appState = appState,
        _userService = userService;

  final AppState _appState;
  final UserService _userService;

  @override
  Widget build(BuildContext context) {
    print('build shell router delegate');
    return Navigator(
      key: navigatorKey,
      pages: _appState.getPages(),
      onPopPage: (route, result) {
        notifyListeners();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    assert(false);
  }
}
