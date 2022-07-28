import 'dart:developer';

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:unnayan/HomePage/HomePanel/model/homepanel_model.dart';

class HomePageController extends ControllerMVC {
  factory HomePageController() => _this ??= HomePageController._();

  HomePageController._()
      : model = HomeORGPageModel(),
        model2 = HomeINSPageModel(),
        super();

  static HomePageController? _this;
  final HomeORGPageModel model;
  final HomeINSPageModel model2;

  List<HomeORGPageGrid>? organizationGrid;
  List<HomeINSPageGrid>? instituesGrid;
  List<MyMainGrid>? grid;

  Future<void> getHomePageGrid() async {
    organizationGrid = await model.getOrganizationGrid();

    ///
    /// *Log
    ///
    log(organizationGrid.toString());

    grid = organizationGrid;
    setState(() {
      grid = organizationGrid;
    });
  }

  Future<void> getInstitutesGrid(int id) async {
    await model2.getInstitueGrid(id).then((value) {
      instituesGrid = value;
      grid = instituesGrid;
      // print("Grids:");
      // print(grid);
    });
  }
}
