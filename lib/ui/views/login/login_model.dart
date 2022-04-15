import 'package:flutter/widgets.dart';
import 'package:historical_guide/core/exeptions/general_exeption.dart';
import 'package:historical_guide/core/services/user_service.dart';
import 'package:historical_guide/ui/base/base_model.dart';

import '../../../core/app_state.dart';

class LoginModel extends BaseModel {
  LoginModel({
    required UserService userService,
    required AppState appState,
  })  : _userService = userService,
        _appState = appState;

  final UserService _userService;
  final AppState _appState;

  String? _loginErrorMessage;

  final _controllerUsername = TextEditingController();
  final _controllerPassword = TextEditingController();

  TextEditingController get controllerUsername => _controllerUsername;
  TextEditingController get controllerPassword => _controllerPassword;

  String? get loginErrorMessage => _loginErrorMessage;

  bool get isLoggedIn => _userService.loggedIn;

  void doUserLogin() {
    final username = _controllerUsername.text.trim();
    final password = _controllerPassword.text.trim();
    setState(ViewState.busy);
    _userService.doUserLogin(username, password).then((_) {
      _appState.gotoRootPage('shell');
    }).onError((error, stackTrace) {
      _loginErrorMessage = (error as GeneralExeption).message;
      setState(ViewState.idle);
    });
  }

  void doUserLogout() {
    _userService.doUserLogout();
  }
}
