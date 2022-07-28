import 'package:flutter/cupertino.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:unnayan/LoginPage/ForgotPassword/model/forgot_password_model.dart';

class ForgotPasswordController extends ControllerMVC {
  factory ForgotPasswordController() => _this ??= ForgotPasswordController._();

  ForgotPasswordController._()
      : model = ForgotPasswordModel(),
        super();
  static ForgotPasswordController? _this;
  final ForgotPasswordModel model;

  Future<bool> onVerifiedEmail(String? email, BuildContext context) async {
    bool val = false;
    await model.onVerifiedEmail(email, context).then((value) {
      val = value;
    });
    return val;
  }
}
