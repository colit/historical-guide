import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guide/router/app_route_information_parser.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import 'core/app_state.dart';
import 'providers.dart';
import 'router/root_router_delegate.dart';

void main() {
  dotenv.load(fileName: '.env').then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (context) {
        final appState = context.read<AppState>();
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Historical Guide',
          theme: context.read<GlobalTheme>().globalTheme,
          routerDelegate: RootRouterDelegate(appState: appState),
          routeInformationParser: AppRouteInformationParser(appState: appState),
        );
      }),
    );
  }
}


// Navigator(
//           key: navigatorKey,
//           pages: [
//             MaterialPage(
//               child: ModalViewManager(
//                 galleryService: context.read<ModalViewService>(),
//                 child: ,
//               ),
//             )
//           ],
//           onPopPage: (route, result) => route.didPop(result),
//         );
