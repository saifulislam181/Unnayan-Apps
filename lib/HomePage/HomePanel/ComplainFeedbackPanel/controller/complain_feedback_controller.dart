import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:unnayan/HomePage/HomePanel/ComplainFeedbackPanel/model/complain_feedback_model.dart';

class ComplainFeedbackPanelController extends ControllerMVC {
  factory ComplainFeedbackPanelController() =>
      _this ??= ComplainFeedbackPanelController._();

  ComplainFeedbackPanelController._()
      : user = ComplainFeedBackPanelModel(),
        super();

  static ComplainFeedbackPanelController? _this;
  final ComplainFeedBackPanelModel user;

  Future<ComplainFeedBackPanelModel?> getUserData(int ID) async {
    return await user.getUserData(ID);
  }

  Future<void> insertFeedbackByOrg(
      String complainId, String detailsByOrg) async {
    await user.insertFeedbackByOrg(complainId, detailsByOrg);
  }
}
