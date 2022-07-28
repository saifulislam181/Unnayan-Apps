import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/AlWids.dart';
import 'package:unnayan/Components/cusomt_text_style.dart';

import '../../../../my_color.dart';
import '../../controller/homepanel_controller.dart';
import '../../model/homepanel_model.dart';

class InstituteGridPanel extends StatefulWidget {
  int? ID;
  InstituteGridPanel(this.ID, {Key? key}) : super(key: key);

  @override
  State<InstituteGridPanel> createState() => _InstituteGridPanelState();
}

class _InstituteGridPanelState extends State<InstituteGridPanel> {
  final _searchController = TextEditingController();
  final HomePageController homepagecontroller = HomePageController();
  late WidContainer widContainer;
  late List<HomeINSPageGrid>? _allUsers;
  late List<HomeINSPageGrid>? _foundUsers;
  late bool fetchGridData;
  bool InstituesVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    fetchGridData = false;
    widContainer = context.read<WidContainer>();
    InstituteGetData();
    super.initState();
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
              ],
            ),
          ),
          getGridView(),
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
                                    const BorderRadius.all(Radius.circular(8))),
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
                                  image: NetworkImage(
                                      _foundUsers![index].imageDir!),
                                  // MemoryImage(Uint8List.fromList(
                                  //     _foundUsers![index].image!)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                widContainer.enqueue(widget);
                                widContainer.setToComplainPage(int.parse(
                                    _foundUsers![index].organizationId!));
                              });
                            },
                          );
                        },
                        childCount: _foundUsers!.length,
                      ),
                    ),
                  ));
  }

  Future<void> InstituteGetData() async {
    await homepagecontroller.getInstitutesGrid(widget.ID!).whenComplete(() {
      setState(() {
        fetchGridData = true;
        _allUsers = homepagecontroller.instituesGrid;
        _foundUsers = _allUsers;
      });
    });
  }

  void _runFilter(String enteredKeyword) {
    List<HomeINSPageGrid>? results = [];
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

    log("Founder LEngth: " + _foundUsers!.length.toString());
  }
}
