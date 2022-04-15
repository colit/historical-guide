import 'package:flutter/material.dart';

class Page404View extends StatelessWidget {
  const Page404View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Text('Page not fond'),
        ));
  }
}
