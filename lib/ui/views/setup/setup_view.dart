import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:historical_guide/core/services/user_service.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../../core/app_state.dart';

class SetupView extends StatefulWidget {
  const SetupView({Key? key}) : super(key: key);

  @override
  State<SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  bool isReady = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('setup');
    var path = kIsWeb ? '' : Directory.current.path;
    print(path);
    Hive
      ..init(path)
      ..openBox('settings').then((box) {
        final token = box.get('sessionToken');
        print('token = $token');
        if (token != null) {
          context.read<UserService>().validateToken(token).then((valid) {
            print('is token valid: $valid');
            context.read<AppState>().gotoRootPage(valid ? 'shell' : 'login');
          });
        } else {
          context.read<AppState>().gotoRootPage('login');
        }
        setState(() {
          isReady = true;
        });
      }).onError((error, stackTrace) {
        print(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isReady ? const Center() : const CircularProgressIndicator(),
      ),
    );
  }
}
