import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/Components/badge_model.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/LoginPage/CreateAccount/view/create_acocunt_view.dart';
import 'package:unnayan/LoginPage/ForgotPassword/view/forgot_password_view.dart';
import 'package:unnayan/LoginPage/controller/loginpage_controller.dart';
import 'package:unnayan/my_color.dart';

///
/// Login Page Stateless Class for Login Screen
///
class LoginPageSTL extends StatelessWidget {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  LoginPageSTL({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

///
/// Login Page Statefull Class for Login Screen
///
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: popOut,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: [
                  MyColor.newLightTeal,
                  MyColor.whiteBG,
                ],
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          child: Image.asset('assets/images/unnayan_logo.png'),
                          height: 300,
                          width: 300,
                        ),
                        const LoginPageForm(),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 15),
                              side: const BorderSide(
                                  color: MyColor.newMediumTeal),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: Text(
                            'Create Account',
                            style: CustomTextStyle.RubiktextStyle(
                                MyColor.newDarkTeal, 14),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => const CreateAcountSTF(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> popOut() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

///
/// Login Page Form Statefull Class for Login Screen
///
class LoginPageForm extends StatefulWidget {
  const LoginPageForm({Key? key}) : super(key: key);

  @override
  State<LoginPageForm> createState() => _LoginPageFormState();
}

class _LoginPageFormState extends State<LoginPageForm> {
  final LoginPageController con = LoginPageController();
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _loginFormKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _user, _password;
  bool _userTaped = false;
  late BadgeCounter badgeCounter;
  @override
  void dispose() {
    // TODO: implement dispose
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    badgeCounter = context.read<BadgeCounter>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _userController,
              onChanged: (val) {
                _user = val;
              },
              cursorColor: MyColor.newDarkTeal,
              decoration: InputDecoration(
                filled: true,
                fillColor: MyColor.white,
                labelStyle:
                    CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14),
                hintText: 'User name or Email or Phone',
                labelText: 'User name or Email or Phone',
                errorText: _userTaped ? errorUserText : null,
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              onChanged: (val) {
                _password = val;
              },
              obscureText: true,
              cursorColor: MyColor.newDarkTeal,
              decoration: InputDecoration(
                filled: true,
                fillColor: MyColor.white,
                labelStyle:
                    CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14),
                hintText: 'Password',
                labelText: 'Password',
                errorText: _userTaped ? errorUserText : null,
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  "Forgot Password?",
                  style:
                      CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => const ForgotPasswordSTF(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        colors: [MyColor.tealBackground, MyColor.newLightTeal]),
                    borderRadius: BorderRadius.circular(50)),
                child: Container(
                  width: 300,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Login',
                    style: CustomTextStyle.RubiktextStyle(MyColor.white, 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              onPressed: onLogin,
            ),
          ],
        ),
      ),
    );
  }

  void onLogin() {
    setState(() {
      _userTaped = true;
    });

    if (errorUserText == null && errorPasswordText == null) {
      con.login(this.context, _user!.trim(), _password!.trim());
      badgeCounter.resetCounter();
    }
  }

  String? get errorUserText {
    final text = _userController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    return null;
  }

  String? get errorPasswordText {
    final text = _passwordController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }
}
