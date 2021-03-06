import 'package:flutter/material.dart';
import 'package:historical_guide/core/services/user_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../core/app_state.dart';
import '../../router/shell_router_delegate.dart';
import 'navigation_bar/navigation_bar_web.dart';

class AppShell extends StatefulWidget {
  const AppShell({Key? key}) : super(key: key);

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late AppState appState;

  late ShellRouterDelegate _shellRouterDelegate;
  ChildBackButtonDispatcher? _backButtonDispatcher;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = context.read<AppState>();
    _shellRouterDelegate = ShellRouterDelegate(
      appState: appState,
      userService: context.read<UserService>(),
    );
    _backButtonDispatcher = Router.of(context)
        .backButtonDispatcher
        ?.createChildBackButtonDispatcher();
  }

  @override
  Widget build(BuildContext context) {
    _backButtonDispatcher?.takePriority();
    return ModalViewManager(
      modalViewService: context.read<ModalViewService>(),
      child: Consumer<AppState>(
        builder: ((context, value, child) {
          return Scaffold(
            body: Column(
              children: [
                Container(
                  color: kColorBackgroundLight,
                  child: NavigationBarWeb(
                      selectedIndex: appState.selectedIndex,
                      onTap: (index) {
                        appState.setHomePage(index);
                      }),
                ),
                Expanded(
                  child: Router(
                    routerDelegate: _shellRouterDelegate,
                    backButtonDispatcher: _backButtonDispatcher,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
