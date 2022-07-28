import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:unnayan/HomePage/ProfilePanel/model/profilepanel_model.dart';

class ProfileController extends ControllerMVC {
  factory ProfileController() => _this ??= ProfileController._();

  ProfileController._()
      : model = ProfileModel(),
        super();

  static ProfileController? _this;
  final ProfileModel model;

  Future<int> getTotalUserData(int id) async {
    return await model.getTotalUserData(id);
  }

  Future<int> getPendingUserData(int id) async {
    return await model.getPendingUserData(id);
  }

  Future<int> getHistoryUserData(int id) async {
    return await model.getHistoryUserData(id);
  }

  Future<int> getHistoryOrgData(int id) async {
    return model.getRecentOrgData(id);
  }

  Future<int> getTotalOrgData(int id) async {
    return await model.getTotalOrgData(id);
  }

  Future<int> getPendingOrgData(int id) async {
    return await model.getPendingOrgData(id);
  }
}
