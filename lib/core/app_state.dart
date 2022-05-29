import 'package:flutter/material.dart';
import 'package:historical_guide/ui/views/app_shell.dart';
import 'package:historical_guide/ui/views/login/login_view.dart';
import 'package:historical_guide/ui/views/page_404/page_404.dart';
import 'package:historical_guide/ui/views/setup/setup_view.dart';
import 'package:historical_guide/ui/views/tour_detail/tour_detail_view.dart';

import '../router/fade_animation_page.dart';
import '../ui/views/about/about_view.dart';
import '../ui/views/homepage/maps_view.dart';
import '../ui/views/tours/tours_view.dart';

// enum pageType {
//   maps,
//   tours,
//   tourDetail,
//   about,
// }

class AppState extends ChangeNotifier {
  static const mapPath = '/';
  static const guidesPath = '/guides';
  static const aboutPath = '/about';
  static const pageNotFoundPath = '/404';

  // AppState({required UserService userService}) : _userService = userService;

  // final UserService _userService;

  int _selectedIndex = 0;
  int _rootIndex = 0;

  String? selectedPageId;

  String _currentRootPageName = 'setup';

  List<RouteSettings> _pages = [];

  final _rootPages = ['setup', 'shell'];
  final _shellPages = ['maps', 'tours', 'about'];

  final _destinations = [mapPath, guidesPath, aboutPath];

  int get selectedIndex => _selectedIndex;

  void initWithIndex(int idx) {
    print('initWithIndex($idx)');
    _selectedIndex = idx;
  }

  set selectedIndex(int idx) {
    _selectedIndex = idx;
    print('set selectedIndex($idx)');
    _pages = [
      if (idx >= 0 && idx < _shellPages.length)
        RouteSettings(name: _shellPages[idx])
      // else
      //   const RouteSettings(name: 'pageNotFound')
    ];
    if (selectedPageId != null) {
      print('add page $selectedPageId');
      _pages.add(
        RouteSettings(
          name: 'tour_details',
          arguments: TourDetailArguments(selectedPageId!),
        ),
      );
    }
    notifyListeners();
  }

  String get currentDestination => _destinations[_selectedIndex];

  List<Page> getPages() {
    print('--- getPages()');
    for (final pageSettings in _pages) {
      print(pageSettings.name);
    }
    return [for (final pageSettings in _pages) _createPage(pageSettings)];
  }

  Page _createPage(RouteSettings settings) {
    // print('createPage(${settings.name})');
    switch (settings.name) {
      case 'maps':
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: MapsView(
            key: ValueKey(settings.name),
          ),
        );
      case 'tours':
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const ToursView(),
        );
      case 'about':
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const AboutView(),
        );
      case 'tour_details':
        print('tour_details created');
        return MaterialPage(
          key: ValueKey(settings.name),
          child: TourDetailView(
            id: (settings.arguments as TourDetailArguments).id.toString(),
          ),
        );
      case 'login':
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const LoginView(),
        );
      case 'setup':
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const SetupView(),
        );
      case 'shell':
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const AppShell(),
        );
      default:
        print('404 page created');
        return FadeAnimationPage(
          key: ValueKey(settings.name),
          child: const Page404View(),
        );
    }
  }

  void setHomePage(int idx) {
    selectedPageId = null;
    selectedIndex = idx;
  }

  void setDeepLink(int rootPageIndex, String pageName, {String? detailsId}) {
    selectedPageId = detailsId;
    selectedIndex = rootPageIndex;
  }

  void pushPage({required String name, Object? arguments}) {
    _pages.add(RouteSettings(
      name: name,
      arguments: arguments,
    ));
    notifyListeners();
  }

  void popPage() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
    }
  }

  void initState(int index, [String? pageId]) {
    _selectedIndex = index;
    selectedPageId = pageId;

    _pages = [RouteSettings(name: _shellPages[index])];

    if (index == 1 && pageId != null) {
      _pages.add(
        RouteSettings(
          name: _shellPages[index],
          arguments: TourDetailArguments(pageId),
        ),
      );
    }
  }

  void gotoRootPage(String pageName) {
    _currentRootPageName = pageName;
    notifyListeners();
  }

  List<Page> getRootPage() {
    return [
      _createPage(
        RouteSettings(name: _currentRootPageName),
      ),
    ];
  }
}

class TourDetailArguments extends Object {
  TourDetailArguments(
    this.id,
  );
  final String id;
}
