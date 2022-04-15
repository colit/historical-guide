import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/core/services/user_service.dart';
import 'package:historical_guide/ui/base/base_widget.dart';
import 'package:historical_guide/ui/commons/theme.dart';
import 'package:historical_guide/ui/ui_helpers.dart';
import 'package:provider/provider.dart';

import 'login_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFEFEFEF),
        body: BaseWidget<LoginModel>(
            model: LoginModel(
              userService: context.read<UserService>(),
              appState: context.read<AppState>(),
            ),
            builder: (context, model, child) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minWidth: 100, maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SvgPicture.asset(
                          'images/piligrim-logo.svg',
                          width: 250,
                          semanticsLabel: 'piligrim logo',
                          color: kColorPrimaryLight,
                        ),
                        UIHelper.verticalSpaceSmall(),
                        const Center(
                          child: Text('Historische Touren',
                              style: TextStyle(fontSize: 16)),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: model.controllerUsername,
                          enabled: !model.isLoggedIn,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Username'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: model.controllerPassword,
                          enabled: !model.isLoggedIn,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              labelText: 'Password'),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            child: const Text('Login'),
                            onPressed: model.isLoggedIn
                                ? null
                                : () => model.doUserLogin(),
                          ),
                        ),
                        if (model.loginErrorMessage != null) ...[
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            model.loginErrorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
