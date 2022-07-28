import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/Components/badge_model.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';
import 'package:unnayan/HomePage/HomePanel/controller/homepanel_controller.dart';
import 'package:unnayan/HomePage/HomePanel/model/homepanel_model.dart';
import 'package:unnayan/HomePage/NotificationPanel/controller/notificationpanel_controller.dart';
import 'package:unnayan/HomePage/NotificationPanel/model/notificationpanel_model.dart';
import 'package:unnayan/HomePage/UserChatPanel/view/user_chat_page_view.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';
import 'package:unnayan/Services/notification_service.dart';
import 'package:unnayan/my_color.dart';

import '../../../AlWids.dart';
import '../../../my_vars.dart';

///
/// Home Page Statefull Class for Home Screen
///

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  late WidContainer widContainer;
  Widget home = HomePagePanel(HomePageEnum.org, null);
  late BadgeCounter badgeCounter;
  void _onItemTapped(int index) {
    if (index == 2) {
      badgeCounter.resetCounter();
    }
    // if (index == 1) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (builder) => ChatPage()));
    // }
    setState(() {
      widContainer.resetHome();
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    badgeCounter = context.read<BadgeCounter>();
    widContainer = context.read<WidContainer>();

    if (context.read<LoginpageModel>().userType == 'user') {
      getNotificationsFromOrg(context.read<LoginpageModel>().userType);
    } else {
      getNotificationsFromUser(context.read<LoginpageModel>().userType);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      const HomeSTF(),
      // ComplainPage(),

      UserChatPage(),

      // Text(
      //   'Index 1: Messaging',
      //   style: optionStyle,
      // ),
      // ChatPanel(),
      Provider.of<WidContainer>(context).notificaitonPanel,
      Provider.of<WidContainer>(context).profilePanel,
      // Text(
      //   'Index 3: Profile',
      //   style: optionStyle,
      // ),
    ];
    final badgeText = context.watch<BadgeCounter>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: MyColor.newDarkTeal,
          ),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: (badgeCounter.counter > 0)
                    ? Badge(
                        badgeContent: Text(badgeText.counter.toString()),
                        child: const Icon(Icons.notifications))
                    : const Icon(Icons.notifications),
                label: 'Notification',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: MyColor.white,
            unselectedItemColor: MyColor.newLightTeal,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  NotificationPageController controller = NotificationPageController();

  Future<void> getNotificationsFromOrg(String? userType) async {
    int notifId = 1;
    List<NotificationPageModel> ls = [];
    await controller
        .showList(context.read<LoginpageModel>().iduser!, NotificationEnum.def,
            "true", userType!)
        .then((value) {
      ls = value!;
      for (var element in ls) {
        log("userType: " + context.read<LoginpageModel>().userType.toString());
        log("organizationsId: " + element.organizationsId.toString());
        log("detailsByUser: " + element.detailsByUser.toString());
        log("showNotiftoOrg: " + element.showNotiftoOrg.toString());
        log("showNotiftoUser: " + element.showNotiftoUser.toString());
        log("repliedToUser: " + element.repliedToUser.toString());
        log("repliedToOrg: " + element.repliedToOrg.toString());

        if (element.showNotiftoUser == 'true' &&
            context.read<LoginpageModel>().userType == 'user') {
          setState(() {
            badgeCounter.increment();
          });

          NotificationService().showNotificaiton(notifId, element.name!,
              "Gave a feedback, Please check", 1, false);
        } else if (element.showNotiftoOrg == 'true' &&
            context.read<LoginpageModel>().userType != 'user') {
          setState(() {
            badgeCounter.increment();
          });

          NotificationService().showNotificaiton(notifId, element.name!,
              element.detailsByUser.toString(), 1, false);

          log("Notfications form ORG");
        }
        notifId++;
      }

      for (var element in ls) {
        if (element.showNotiftoUser == 'true' &&
            context.read<LoginpageModel>().userType! == 'user') {
          controller.updateComplainNotificationToUserToFalse(
              element.complainId!, "false");
        } else if (element.showNotiftoOrg == 'true' &&
            context.read<LoginpageModel>().userType! != 'user') {
          controller.updateComplainNotificationToOrgToFalse(
              element.complainId!, "false");
        }
      }
    });
  }

  Future<void> getNotificationsFromUser(String? userType) async {
    int notifId = 1;
    List<NotificationPageModel> ls = [];
    await controller
        .showList(context.read<LoginpageModel>().iduser!, NotificationEnum.def,
            "true", userType!)
        .then((value) {
      ls = value!;
      for (var element in ls) {
        log("userType: " + context.read<LoginpageModel>().userType.toString());
        log("organizationsId: " + element.organizationsId.toString());
        log("detailsByUser: " + element.detailsByUser.toString());
        log("showNotiftoOrg: " + element.showNotiftoOrg.toString());
        log("showNotiftoUser: " + element.showNotiftoUser.toString());
        log("repliedToUser: " + element.repliedToUser.toString());
        log("repliedToOrg: " + element.repliedToOrg.toString());

        if (element.showNotiftoUser == 'true' &&
            context.read<LoginpageModel>().userType == 'user') {
          setState(() {
            badgeCounter.increment();
          });

          NotificationService().showNotificaiton(
              notifId,
              element.name!,
              (element.detailsByUser!.length > 30)
                  ? element.detailsByUser!.substring(0, 30)
                  : element.detailsByUser.toString(),
              1,
              false);
        } else if (element.showNotiftoOrg == 'true' &&
            context.read<LoginpageModel>().userType != 'user') {
          setState(() {
            badgeCounter.increment();
          });

          NotificationService().showNotificaiton(notifId, element.name!,
              element.detailsByUser.toString(), 1, false);

          log("Notfications form user");
        }
        notifId++;
      }

      // for (var element in ls) {
      //   if (element.showNotiftoUser == 'true' &&
      //       context.read<LoginpageModel>().userType! == 'user') {
      //     controller.updateComplainNotificationToUserToFalse(
      //         element.complainId!, "false");
      //   } else if (element.showNotiftoOrg == 'true' &&
      //       context.read<LoginpageModel>().userType! != 'user') {
      //     controller.updateComplainNotificationToOrgToFalse(
      //         element.complainId!, "false");
      //   }
      // }
    });
  }
}

///
/// HomePage Panel
///

class HomePagePanel extends StatefulWidget {
  HomePageEnum enu;
  int? id;

  HomePagePanel(this.enu, this.id, {Key? key}) : super(key: key);

  @override
  State<HomePagePanel> createState() => _HomePagePanelState();
}

class _HomePagePanelState extends State<HomePagePanel> {
  final _searchController = TextEditingController();
  final HomePageController homePageController = HomePageController();
  late WidContainer widContainer;
  late List<MyMainGrid>? _allUsers;
  late List<MyMainGrid>? _foundUsers;

  late bool fetchGridData;
  @override
  void initState() {
    // TODO: implement initState
    fetchGridData = false;
    widContainer = context.read<WidContainer>();
    log(widget.enu.toString());
    if (context.read<LoginpageModel>().userType == 'user') {
      homePageGetData(widget.enu, widget.id);
    }

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    homePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.whiteBG,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 80),
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(20),
                  child: TextField(
                    autofocus: false,
                    controller: _searchController,
                    onChanged: _runFilter,
                    cursorColor: MyColor.newDarkTeal,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: MyColor.white,
                      labelStyle: CustomTextStyle.RubiktextStyle(
                          MyColor.newDarkTeal, 14),
                      labelText: "Search",
                      hintText: "Search",
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: MyColor.newDarkTeal, width: 0.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: MyColor.newDarkTeal, width: 0.0),
                      ),
                      suffixIcon: Material(
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
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          (context.read<LoginpageModel>().userType == 'user')
              ? getGridView()
              : const SliverToBoxAdapter(
                  child: null,
                ),
          const SliverPadding(
            padding: EdgeInsets.only(bottom: 40),
          ),
        ],
      ),
    );
  }

  Widget getGridView() {
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: (!fetchGridData)
          ? SliverPadding(
              padding: const EdgeInsets.all(10.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              color: MyColor.white,
                              border: Border.all(
                                  color: MyColor.newLightTeal, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: const SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )),
                      onTap: () {},
                    );
                  },
                  childCount: 20,
                ),
              ),
            )
          : (_foundUsers == null || _foundUsers?.length == 0)
              ? const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No Organizations Found"),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: MyColor.white,
                              border: Border.all(
                                  color: MyColor.newLightTeal, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image:
                                    // MemoryImage(Uint8List.fromList(
                                    //     _foundUsers![index].image!)),
                                    NetworkImage(_foundUsers![index].imageDir!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              if (widget.enu == HomePageEnum.org) {
                                widContainer.setToInst(int.parse(
                                    _foundUsers![index].organizationTypeId!));
                              } else if (widget.enu == HomePageEnum.ins) {
                                widContainer.setToComplainPage(int.parse(
                                    _foundUsers![index].organizationTypeId!));
                              }
                            });
                          },
                        );
                      },
                      childCount: _foundUsers!.length,
                    ),
                  ),
                ),
    );
  }

  Future<void> homePageGetData(HomePageEnum enu, [int? id]) async {
    log("Called homePageGetData");
    log("Called HomePageEnum: ");
    log(enu.toString());
    log("Called ID: ");
    log(id.toString());

    if (enu == HomePageEnum.org) {
      await homePageController.getHomePageGrid().then((value) {
        setState(() {
          fetchGridData = true;
          _allUsers = homePageController.grid;
          _foundUsers = _allUsers;
        });
      });
    } else {
      await homePageController.getInstitutesGrid(id!).then((value) {
        setState(() {
          fetchGridData = true;
          _allUsers = homePageController.grid;
          _foundUsers = _allUsers;
        });
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<MyMainGrid>? results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      for (var element in _allUsers!) {
        if (element.name!
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          log(element.name.toString());
          results.add(element);
        }
      }
    }
    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });

    log("Founder Length: " + _foundUsers!.length.toString());
  }
}

class HomeSTF extends StatefulWidget {
  const HomeSTF({Key? key}) : super(key: key);

  @override
  State<HomeSTF> createState() => _HomeSTFState();
}

class _HomeSTFState extends State<HomeSTF> {
  @override
  void initState() {
    log("Container");
    log(context.read<WidContainer>().homePanel.toString());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log("Provider WidContainer:");
    log(context.watch<WidContainer>().homePanel.toString());
    return WillPopScope(
      child: (Provider.of<WidContainer>(context).homePanel),
      onWillPop: () async {
        return false;
      },
    );
  }

  Future<bool> popOut() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
