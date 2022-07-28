import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/AlWids.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/HomePage/ProfilePanel/controller/profilepanel_contorller.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';
import 'package:unnayan/LoginPage/view/loginpage_view.dart';
import 'package:unnayan/my_color.dart';
import 'package:unnayan/my_vars.dart';

///
/// Profile Page Stateless Class for Profile Screen
///

class ProfileSTL extends StatelessWidget {
  const ProfileSTL({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: MyColor.whiteBG,
          // image: DecorationImage(
          //   image: AssetImage('assets/images/profile_bg.png'),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: const SingleChildScrollView(child: ProfilePage()),
      ),
    );
  }
}

///
/// Profile Page Statefull Class for Profile Screen
///
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late LoginpageModel user;
  late String username, university;
  int totalNum = 0, historyNum = 0, pendingNum = 0;
  ProfileController con = ProfileController();
  @override
  void initState() {
    // TODO: implement initState

    user = context.read<LoginpageModel>();

    getComplainData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            child: Container(
              color: MyColor.newLightTeal,
            ),
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 100,
                color: MyColor.newLightTeal,
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: ClipOval(
                  child: Container(
                    color: MyColor.white,
                    padding: const EdgeInsets.all(6),
                    child: ClipOval(
                      child: (user.image!.isNotEmpty)
                          ? Image(
                              image: NetworkImage(user.image!),
                              fit: BoxFit.cover,
                            )
                          // Image(
                          //         image:

                          // MemoryImage(Uint8List.fromList(user.image!)),
                          //   fit: BoxFit.cover,
                          // )
                          : const Image(
                              image: const AssetImage(
                                  'assets/images/unnayan_logo.png'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            Provider.of<LoginpageModel>(context, listen: false).name.toString(),
            style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 24),
          ),
          const SizedBox(
            height: 10,
          ),
          (context.read<LoginpageModel>().userType == 'user')
              ? Text(
                  Provider.of<LoginpageModel>(context, listen: false)
                      .universityName
                      .toString(),
                  style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 18),
                )
              : const SizedBox(
                  height: 30,
                ),
          const SizedBox(
            height: 30,
          ),
          Divider(
            indent: 90,
            endIndent: 90,
            height: 1,
            color: MyColor.blackFont.withOpacity(.3),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              ProfileInfoRowNew(
                  (context.read<LoginpageModel>().userType == 'user')
                      ? 'History'
                      : 'Recent',
                  historyNum,
                  "History Of Complains",
                  (context.read<LoginpageModel>().userType == 'user')
                      ? NotificationEnum.userHistory
                      : NotificationEnum.orgRecent),
              ProfileInfoRowNew(
                  'Pending Complains',
                  pendingNum,
                  "Pending Complains",
                  (context.read<LoginpageModel>().userType == 'user')
                      ? NotificationEnum.userPending
                      : NotificationEnum.orgPending),
              ProfileInfoRowNew(
                  'Total Complains',
                  totalNum,
                  "Total Complains",
                  (context.read<LoginpageModel>().userType == 'user')
                      ? NotificationEnum.userTotal
                      : NotificationEnum.orgTotal),
              Expanded(
                child: Container(),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: onSignOut,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
            child: Ink(
              decoration: BoxDecoration(
                  color: MyColor.newDarkTeal,
                  borderRadius: BorderRadius.circular(50)),
              child: Container(
                width: 300,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Sign Out',
                  style: CustomTextStyle.RubiktextStyle(MyColor.white, 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future getComplainData() async {
    log("User: " + user.iduser!.toString());
    int i = 0;
    int j = 0;
    int k = 0;
    if (context.read<LoginpageModel>().userType == 'user') {
      i = await con.getTotalUserData(user.iduser!);
      j = await con.getPendingUserData(user.iduser!);
      k = await con.getHistoryUserData(user.iduser!);
      setState(() {
        totalNum = i;
        pendingNum = j;
        historyNum = k;
      });
    } else {
      i = await con.getTotalOrgData(user.iduser!);
      j = await con.getPendingOrgData(user.iduser!);
      k = await con.getHistoryOrgData(user.iduser!);
      setState(() {
        totalNum = i;
        pendingNum = j;
        historyNum = k;
      });
    }
  }

  Future onSignOut() async {
    await FirebaseAuth.instance.signOut().whenComplete(
          () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (builder) => LoginPageSTL(),
              ),
              (Route<dynamic> route) => false),
        );
  }
}

class ProfileInfoRowNew extends StatefulWidget {
  final String title;
  final int number;
  final String notificationTitle;
  final NotificationEnum nEnum;
  const ProfileInfoRowNew(
      this.title, this.number, this.notificationTitle, this.nEnum,
      {Key? key})
      : super(key: key);

  @override
  State<ProfileInfoRowNew> createState() => _ProfileInfoRowNewState();
}

class _ProfileInfoRowNewState extends State<ProfileInfoRowNew> {
  late WidContainer widContainer;
  @override
  void initState() {
    // TODO: implement initState
    widContainer = context.read<WidContainer>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Center(
          child: InkWell(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: MyColor.white,
                  border: Border.all(color: MyColor.newLightBrown, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: CustomTextStyle.RubiktextStyle(
                            MyColor.newDarkTeal, 12),
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 3,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget.number.toString(),
                        style: CustomTextStyle.RubiktextStyle(
                            MyColor.newDarkTeal, 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              widContainer.setToProgileTONotificationPanel(
                  widget.notificationTitle, widget.nEnum);
            },
          ),
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatefulWidget {
  final String title;
  final int number;
  final String notificationTitle;
  final NotificationEnum nEnum;

  const ProfileInfoRow(
      this.title, this.number, this.notificationTitle, this.nEnum,
      {Key? key})
      : super(key: key);

  @override
  State<ProfileInfoRow> createState() => _ProfileInfoRowState();
}

class _ProfileInfoRowState extends State<ProfileInfoRow> {
  late WidContainer widContainer;
  @override
  void initState() {
    // TODO: implement initState
    widContainer = context.read<WidContainer>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const SizedBox(width: 50),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Text(
                widget.title,
                style: CustomTextStyle.RubiktextStyle(MyColor.blackFont, 14),
              ),
            ),
          ),
        ),
        Flexible(
          child: InkWell(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: ClipOval(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  decoration: const BoxDecoration(
                    // shape: BoxShape.circle,
                    color: MyColor.blueButton,
                  ),
                  child: Text(
                    widget.number.toString(),
                    style: CustomTextStyle.RubiktextStyle(MyColor.white, 10),
                  ),
                ),
              ),
            ),
            onTap: () {
              widContainer.setToProgileTONotificationPanel(
                  widget.notificationTitle, widget.nEnum);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
