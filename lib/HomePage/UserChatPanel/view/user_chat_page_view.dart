import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/HomePage/UserChatPanel/ChatPanel/view/charpanel_view.dart';
import 'package:unnayan/HomePage/UserChatPanel/controller/userchatpanel_controller.dart';
import 'package:unnayan/HomePage/UserChatPanel/model/userchatpanel_model.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';
import 'package:unnayan/my_color.dart';

class UserChatPage extends StatefulWidget {
  const UserChatPage({Key? key}) : super(key: key);

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  final _searchController = TextEditingController();
  late List<UserChatPanelModel> _allUsers = [];
  late List<UserChatPanelModel> _foundUsers = [];
  bool fetchUserData = false;
  final userChatPanelController = UserChatpanelController();
  @override
  void initState() {
    // TODO: implement initState
    getOrgData(context.read<LoginpageModel>().iduser!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.whiteBG,
      child: CustomScrollView(slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Chats",
                style: CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 18),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              autofocus: false,
              controller: _searchController,
              onChanged: _runFilter,
              cursorColor: MyColor.newDarkTeal,
              decoration: InputDecoration(
                filled: true,
                fillColor: MyColor.white,
                labelStyle:
                    CustomTextStyle.RubiktextStyle(MyColor.newDarkTeal, 14),
                labelText: "Search",
                hintText: "Search",
                focusedBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: MyColor.newDarkTeal, width: 0.0),
                ),
                suffixIcon: const Material(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  color: MyColor.newDarkTeal,
                  child: Icon(
                    Icons.search,
                    color: MyColor.white,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        (fetchUserData)
            ? (_foundUsers.isEmpty)
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Text("No Organizations Found"),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return UserChatViewPanel(
                          userChatPanelModel: _foundUsers.elementAt(index),
                        );
                      },
                      childCount: _foundUsers.length,
                    ),
                  )
            : const SliverToBoxAdapter(
                child: Center(
                  child: Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
      ]),
    );
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<UserChatPanelModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allUsers;
    } else {
      for (var element in _allUsers) {
        if (element.name!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          log(element.name.toString());
          results.add(element);
        }
      }
    }
    setState(() {
      _foundUsers = results;
    });

    log("GO");
  }

  Future<void> getOrgData(int userId) async {
    await userChatPanelController
        .getOrgs(userId, context.read<LoginpageModel>().userType)
        .then((value) {
      setState(() {
        _allUsers = value!;
        _foundUsers = _allUsers;
        fetchUserData = true;
      });
    });
  }
}

class UserChatViewPanel extends StatefulWidget {
  final UserChatPanelModel? userChatPanelModel;
  const UserChatViewPanel({this.userChatPanelModel, Key? key})
      : super(key: key);

  @override
  State<UserChatViewPanel> createState() => _UserChatViewPanelState();
}

class _UserChatViewPanelState extends State<UserChatViewPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Card(
                color: MyColor.newLightTeal,
                child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipOval(
                      child: Container(
                        color: MyColor.white,
                        child: (widget.userChatPanelModel != null)
                            ? Image(
                                image: NetworkImage(
                                    widget.userChatPanelModel!.imgDir!),
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  title: Text(widget.userChatPanelModel!.name!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) {
                        return ChangeNotifierProvider<LoginpageModel>.value(
                          value: context.read<LoginpageModel>(),
                          child: ChatPage(
                            col: widget.userChatPanelModel!.msgTokenCollection,
                            name: widget.userChatPanelModel!.name,
                            receiverId:
                                widget.userChatPanelModel!.orgId.toString(),
                          ),
                        );
                      }),
                    );
                  },
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
        Divider(
          indent: 10,
          endIndent: 10,
          color: MyColor.blackFont.withOpacity(.5),
        ),
      ],
    );
    ;
  }
}
