import 'package:flutter/material.dart';
import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/router/app_route_information_parser.dart';
import 'package:historical_guide/router/root_router_delegate.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

class AppRootWidget extends StatelessWidget {
  const AppRootWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Historical Guide',
      theme: context.read<GlobalTheme>().globalTheme,
      routerDelegate: RootRouterDelegate(appState: appState),
      routeInformationParser: AppRouteInformationParser(appState: appState),
    );
  }
}
