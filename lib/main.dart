import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app_root_widget.dart';
import 'providers.dart';

void main() {
  // dotenv.load(fileName: '.env').then((value) {
  //   Parse()
  //       .initialize(
  //         dotenv.env['APP_ID']!,
  //         dotenv.env['PARSE_SERVER']!,
  //         masterKey: dotenv.env['MASTER_KEY']!,
  //         clientKey: dotenv.env['CLIENT_KEY']!,
  //       )
  //       .then((_) => runApp(const MyApp()));
  // });
  dotenv.load(fileName: '.env').then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(builder: (context) {
        return const AppRootWidget();
      }),
    );
  }
}
