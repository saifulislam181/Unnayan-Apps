import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:unnayan/LoginPage/CreateAccount/model/create_account_model.dart';

class CreateAccountController extends ControllerMVC {
  factory CreateAccountController() => _this ??= CreateAccountController._();

  CreateAccountController._()
      : model = CreateAccountModel(),
        super();

  static CreateAccountController? _this;
  final CreateAccountModel model;

  Future<void> createAccountForUser(
      String? fullName,
      String? email,
      String? password,
      String? location,
      List<int>? image,
      String? fileName,
      String? cellNumber,
      String? userType,
      String? instituteName) async {
    await model.createAcccountForUser(
        filename: fileName,
        email: email,
        phoneNumber: cellNumber,
        password: password,
        userType: userType,
        image: image,
        universityName: instituteName,
        name: fullName,
        location: location);
  }

  Future<void> createAccountForOrg(
      String? fullName,
      String? email,
      String? password,
      String? location,
      List<int>? image,
      String? filename,
      String? cellNumber,
      String? userType,
      int? orgType) async {
    bool val = false;
    await model.createAccountForOrg(
        filename: filename,
        email: email,
        phoneNumber: cellNumber,
        password: password,
        userType: userType,
        image: image,
        name: fullName,
        location: location,
        orgType: orgType);
  }
}
