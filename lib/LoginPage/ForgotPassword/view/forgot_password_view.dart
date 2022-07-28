import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/LoginPage/ForgotPassword/controller/forgot_password_controller.dart';
import 'package:unnayan/LoginPage/view/loginpage_view.dart';
import 'package:unnayan/my_color.dart';

class ForgotPasswordSTF extends StatefulWidget {
  const ForgotPasswordSTF({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordSTF> createState() => _ForgotPasswordSTFState();
}

class _ForgotPasswordSTFState extends State<ForgotPasswordSTF> {
  final emailConfirmed = GlobalKey<FormState>();
  final forgotConfirmed = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  String? _email, _errorText, _pass, _repass;
  late bool emailVerified;

  final forgotPasswordController = ForgotPasswordController();
  @override
  void initState() {
    // TODO: implement initState
    emailVerified = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColor.newLightTeal,
        body: SingleChildScrollView(
          child: getEmailPasswordView(),
        ),
      ),
    );
  }

  Widget getEmailPasswordView() {
    return Form(
      key: emailConfirmed,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
            child: TextFormField(
              cursorColor: MyColor.newDarkTeal,
              controller: emailTextController,
              decoration: InputDecoration(
                filled: true,
                fillColor: MyColor.white,
                labelStyle:
                    CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14),
                hintText: 'Email',
                labelText: 'Email',
                errorText: _errorText,
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
              ),
              onChanged: (val) {
                _email = val;
              },
              keyboardType: TextInputType.emailAddress,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Your Email';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return "Please enter a valid email address";
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Enter your valid email address.",
                style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 10),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
            child: Ink(
              decoration: BoxDecoration(
                  color: MyColor.white,
                  borderRadius: BorderRadius.circular(50)),
              child: Container(
                width: 300,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Verify',
                  style: CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            onPressed: () {
              if (emailConfirmed.currentState!.validate()) {
                // Process data.

                onVerify();
              }
            },
          ),
        ],
      ),
    );
  }

  Future onVerify() async {
    setState(() {
      _errorText = null;
    });
    bool val = await forgotPasswordController.onVerifiedEmail(_email, context);
    log(_email.toString());
    log(val.toString());
    if (val) {
      Future.delayed(const Duration(seconds: 1));
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => LoginPageSTL()));
    } else {
      setState(() {
        _errorText = "User does not exits.";
      });
    }
  }
}
