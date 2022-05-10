import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/core/repositories/parse_server_repository.dart';
import 'package:historical_guide/core/repositories/parse_users_repository.dart';
import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guide/core/services/user_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/services/map_service.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider(create: (_) => AppState()),
  Provider(create: (_) => GlobalTheme()),
  Provider(create: (_) => ParseServerRepository()),
  Provider(create: (_) => ParseUsersRepository()),
];

List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<ParseServerRepository, MapService>(
    create: (_) => MapService(),
    update: (_, databaseRepository, notyfier) =>
        notyfier!..update(databaseRepository),
  ),
  ProxyProvider<ParseServerRepository, TourService>(
    update: (_, databaseRepository, __) => TourService(
      databaseRepository: databaseRepository,
    ),
  ),
  ProxyProvider<ParseUsersRepository, UserService>(
    update: (_, usersRepository, __) =>
        UserService(usersRepository: usersRepository),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [];
