import 'package:flutter/material.dart';

import '../core/app_state.dart';
import 'app_routes.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  AppRouteInformationParser({required AppState appState})
      : _appState = appState;

  final AppState _appState;

  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    print('--- AppRouteInformationParser.parseRouteInformation()');
    print('uri = $uri');
    print('state: ${routeInformation.state}');
    if (uri.pathSegments.isEmpty || uri.pathSegments.first == 'maps') {
      print('return map path');
      _appState.initState(0);
      return MapPath();
    } else {
      if (uri.pathSegments.first == 'guides') {
        print('found GUIDES whith ${uri.pathSegments.length}');
        if (uri.pathSegments.length == 1) {
          _appState.initState(1);
          return GuidesPath();
        } else {
          final pageId = uri.pathSegments[1];
          print('return GuideDetailPath whith $pageId');
          _appState.initState(1, pageId);
          return GuideDetailPath(pageId);
        }
      } else if (uri.pathSegments.first == 'about') {
        _appState.initState(2);
        return AboutPath();
      } else {
        return PageNotFoundPath();
      }
    }
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    print('--- AppRouteInformationParser.restoreRouteInformation()');
    print(configuration);
    if (configuration is MapPath) {
      print('restoreRouteInformation: MAP');
      return const RouteInformation(location: '/');
    }
    if (configuration is GuidesPath) {
      print('restoreRouteInformation: GUIDES');
      return const RouteInformation(location: '/guides');
    }
    if (configuration is GuideDetailPath) {
      print('restoreRouteInformation: GUIDES/${configuration.id}');
      return RouteInformation(location: '/guides/${configuration.id}');
    }
    if (configuration is AboutPath) {
      print('restoreRouteInformation: ABOUT');
      return const RouteInformation(location: '/about');
    }
    print('restoreRouteInformation: NOT FOUND');
    return null;
  }
}
