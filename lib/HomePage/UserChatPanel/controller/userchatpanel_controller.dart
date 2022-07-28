import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:unnayan/HomePage/UserChatPanel/model/userchatpanel_model.dart';

class UserChatpanelController extends ControllerMVC {
  factory UserChatpanelController() => _this ??= UserChatpanelController._();

  UserChatpanelController._()
      : model = UserChatPanelModel(),
        super();
  static UserChatpanelController? _this;
  final UserChatPanelModel model;

  Future<List<UserChatPanelModel>?> getOrgs(
      int userId, String? userType) async {
    return await model.getOrgs(userId, userType);
  }
}
