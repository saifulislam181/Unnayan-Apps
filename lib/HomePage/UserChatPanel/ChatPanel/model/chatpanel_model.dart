import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPanelModel {
  Stream<QuerySnapshot> getChatMessage(String senderId, String col) {
    return FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('messages')
        .doc('messages')
        .collection(col)
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();
  }

  void sendChatMessage(
      String col, String message, String receiverId, String senderId) {
    print("Collection:" + col);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('messages')
        .doc('messages')
        .collection(col)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    Map<String, dynamic> chat = {
      "notifiedReceiver": "false",
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
    };

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chat);
    });
  }
}
