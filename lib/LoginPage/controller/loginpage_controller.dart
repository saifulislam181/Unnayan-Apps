import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/AlWids.dart';
import 'package:unnayan/HomePage/homepage_view.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';

class LoginPageController extends ControllerMVC {
  factory LoginPageController() => _this ??= LoginPageController._();

  LoginPageController._()
      : model = LoginpageModel(),
        super();

  static LoginPageController? _this;
  final LoginpageModel model;

  Future<void> login(
      BuildContext context, String? _user, String? password) async {
    LoginpageModel? user =
        await model.getUser(_user!.trim(), password!.trim(), context);
    if (user != null) {
      model.setUserData(user);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          // context
          //     .read<WidContainer>()
          //     .enqueue(HomePagePanel(HomePageEnum.org, null));
          return ChangeNotifierProvider<LoginpageModel>.value(
            value: model,
            child: ChangeNotifierProvider<WidContainer>(
              create: (_) => WidContainer(),
              child: const HomePageSTL(),
            ),
          );
        }),
      );
    }
  }
}
