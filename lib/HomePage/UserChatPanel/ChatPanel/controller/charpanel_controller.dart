import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:unnayan/HomePage/UserChatPanel/ChatPanel/model/chatpanel_model.dart';

class ChatPanelController extends ControllerMVC {
  factory ChatPanelController() => _this ??= ChatPanelController._();

  ChatPanelController._()
      : model = ChatPanelModel(),
        super();

  static ChatPanelController? _this;
  final ChatPanelModel model;

  Stream<QuerySnapshot> getStreamChat(String senderId, String col) {
    return model.getChatMessage(senderId, col);
  }

  void sendChatMessage(
      String col, String msg, String receiverId, String senderId) {
    model.sendChatMessage(col, msg, receiverId, senderId);
  }
}
