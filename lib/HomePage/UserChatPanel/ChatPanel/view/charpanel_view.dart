import 'dart:developer';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/HomePage/UserChatPanel/ChatPanel/controller/charpanel_controller.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';
import 'package:unnayan/my_color.dart';

class ChatPage extends StatefulWidget {
  final String? name;
  final String? receiverId;
  final String? col;

  const ChatPage({this.col, this.name, this.receiverId, Key? key})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController chatTextContoroller = TextEditingController();
  final ScrollController _controller = ScrollController();
  String? msg;
  @override
  void initState() {
    // messages.add(chatPanels('bubble normal with tail', false));
    // messages.add(chatPanels('bubble normal with tail', true));
    log("ReceiverID:" + widget.receiverId.toString());
    super.initState();
    // _scrollDown();
  }

  // List<Widget> messages = [];
  List<QueryDocumentSnapshot> Qmessages = [];
  final chatPanelController = ChatPanelController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: MyColor.white,
        backgroundColor: MyColor.newDarkTeal,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(widget.name!),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: chatPanelController.getStreamChat(
                    context.read<LoginpageModel>().iduser.toString(),
                    widget.col!),
                builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
                  if (snap.hasData) {
                    Qmessages = snap.data!.docs;
                    if (Qmessages.isNotEmpty) {
                      // return SingleChildScrollView(
                      //   reverse: true,
                      //   controller: _controller,
                      //   child: Column(
                      //     children: messages,
                      //   ),
                      // );
                      log("Snap Data length:" +
                          snap.data!.docs.length.toString());
                      return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: snap.data?.docs.length,
                          reverse: true,
                          controller: _controller,
                          itemBuilder: (context, index) =>
                              chatPanels(index, snap.data!.docs[index]));
                    } else {
                      return const Center(
                        child: Text('No messages...'),
                      );
                    }
                  }
                  return Container();
                }),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.only(right: 8),
            color: MyColor.newDarkTeal,
            child: Row(
              children: [
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: chatTextContoroller,
                    cursorColor: MyColor.newDarkTeal,
                    decoration: const InputDecoration(
                      hoverColor: MyColor.newDarkTeal,
                      focusColor: MyColor.newDarkTeal,
                      fillColor: MyColor.white,
                      filled: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                )),
                ClipOval(
                  child: Container(
                      color: MyColor.white,
                      height: 40,
                      width: 40,
                      child: IconButton(
                        color: MyColor.newDarkTeal,
                        onPressed: onChatSend,
                        icon: const Icon(Icons.send),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onChatSend() {
    if (chatTextContoroller.value.text.isNotEmpty) {
      setState(() {
        chatPanelController.sendChatMessage(
            widget.col!,
            chatTextContoroller.text,
            widget.receiverId!,
            context.read<LoginpageModel>().iduser.toString());
        chatTextContoroller.text = "";
      });
    }
  }

  Widget chatPanels(int index, DocumentSnapshot doc) {
    if (doc.get('senderId') ==
        context.read<LoginpageModel>().iduser.toString()) {
      return BubbleSpecialOne(
        text: doc.get('message'),
        isSender: true,
        color: MyColor.newDarkTeal,
        tail: false,
        textStyle: CustomTextStyle.RubiktextStyle(MyColor.white, 16),
      );
    } else {
      return BubbleSpecialOne(
        text: doc.get('message'),
        isSender: false,
        color: MyColor.lightAsh,
        tail: false,
        textStyle: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 16),
      );
    }
  }

  // Widget chatPanels(String msg, bool isSender) {
  //   return
  // }
}
