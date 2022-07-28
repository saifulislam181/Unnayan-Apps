// To parse this JSON data, do
//
//     final homePageModel = homePageModelFromMap(jsonString);

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sqflite.dart';

class HomeORGPageModel {
  Database? db;

  Future<List<HomeORGPageGrid>?> getOrganizationGrid() async {
    List<HomeORGPageGrid> grid = [];
    List<Map<dynamic, dynamic>> list = [];

    final credential = await FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('organizationType')
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc).toList();

    //for a specific field
    log(allData.length.toString());
    for (var element in allData) {
      HomeORGPageGrid p = HomeORGPageGrid.fromMap(element);
      await p.getImage().then((value) {
        p.imageDir = value;
        grid.add(p);
      });
    }
    log(allData.toString());
    return grid;
  }

  // Future<List<HomeORGPageGrid>?> getOrganizationGrid() async {
  //   if (db == null) {
  //     db = await DBDetails.InitDatabase();
  //   }
  //   // Get the records
  //   List<Map<String, dynamic>>? maps = await db
  //       ?.rawQuery("SELECT * FROM ${DBDetails.DBTable_ORGANIZATIONSTYPE}");
  //   List<HomeORGPageGrid> grid = [];
  //   if (maps!.length > 0) {
  //     maps.forEach((card) {
  //       grid.add(HomeORGPageGrid.fromMap(card));
  //     });
  //     return grid;
  //   }
  //   return null;
  // }

  Future close() async => db!.close();
}

class HomeINSPageModel {
  Database? db;

  Future<List<HomeINSPageGrid>?> getInstitueGrid(int ID) async {
    List<HomeINSPageGrid> grid = [];
    log("getInstitueGrid( " + ID.toString() + " ");
    final credential = await FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('organizations')
        .where('organizationTypeId', isEqualTo: ID.toString())
        .get();
    log(querySnapshot.toString());
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc).toList();

    //for a specific field
    log(allData.length.toString());
    for (var element in allData) {
      HomeINSPageGrid p = HomeINSPageGrid.fromMap(element);
      await p.getImage().then((value) {
        p.imageDir = value;
        grid.add(p);
      });
    }
    log(allData.toString());
    return grid;
  }

  // Future<List<HomeINSPageGrid>?> getInstitueGrid(int ID) async {
  //   // Get the records
  //   if (db == null) {
  //     db = await DBDetails.InitDatabase();
  //   }
  //
  //   List<Map<String, dynamic>>? maps = await db?.rawQuery(
  //       "SELECT * FROM ${DBDetails.DBTable_ORGANIZATIONS} WHERE ( ${DBDetails.DBTable_Where_ORGANIZATIONSTYPEID} = '${ID}' )");
  //   List<HomeINSPageGrid> grid = [];
  //   if (maps!.length > 0) {
  //     maps.forEach((card) {
  //       grid.add(HomeINSPageGrid.fromMap(card));
  //     });
  //
  //     return grid;
  //   }
  //   return null;
  // }

  Future close() async => db!.close();
}

class MyMainGrid {
  String? organizationTypeId;
  String? name;
  List<int>? image;
  String? imageDir;
}

class HomeORGPageGrid extends MyMainGrid {
  HomeORGPageGrid(
      {this.organizationTypeId, this.name, this.image, this.imageDir});

  @override
  String? organizationTypeId;
  @override
  String? name;
  @override
  List<int>? image;
  String? imageDir;

  // factory HomeORGPageGrid.fromMap(Map<String, dynamic> json) => HomeORGPageGrid(
  //       organizationTypeId: json["organizationTypeId"].toString(),
  //       name: json["name"],
  //       image: json["image"],
  //     );
  //
  // Map<String, dynamic> toMap() => {
  //       "organizationTypeId": organizationTypeId,
  //       "name": name,
  //       "image": image,
  //     };
  //

  factory HomeORGPageGrid.fromMap(QueryDocumentSnapshot json) {
    return HomeORGPageGrid(
      organizationTypeId: json.get('organizationTypeId'),
      name: json.get('name'),
      imageDir: json.get('image'),
    );
  }

  // factory HomeORGPageGrid.fromMap(Map<String, dynamic> json) => HomeORGPageGrid(
  //       organizationTypeId: json["organizationTypeId"].toString(),
  //       name: json["name"],
  //       imageDir: json["image"],
  //     );

  Map<String, dynamic> toMap() => {
        "organizationTypeId": organizationTypeId,
        "name": name,
        "image": imageDir,
      };

  Future<String> getImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    log(storage.toString());
    Reference ref = storage.refFromURL(imageDir!);
    String imageUrl = await ref.getDownloadURL();
    log("Download URL: " + imageUrl);
    return imageUrl;
  }
}

class HomeINSPageGrid extends MyMainGrid {
  HomeINSPageGrid({
    this.organizationId,
    this.organizationTypeId,
    this.name,
    this.imageDir,
  });

  @override
  String? organizationTypeId;
  @override
  String? name;
  @override
  String? imageDir;
  String? organizationId;

  factory HomeINSPageGrid.fromMap(QueryDocumentSnapshot json) {
    return HomeINSPageGrid(
      organizationTypeId: json.get('organizationTypeId'),
      organizationId: json.get('organizationsId'),
      name: json.get('name'),
      imageDir: json.get('image'),
    );
  }

  Map<String, dynamic> toMap() => {
        "organizationTypeId": organizationTypeId,
        "name": name,
        "image": image,
        "organizationId": organizationId,
      };

  Future<String> getImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    log(storage.toString());
    Reference ref = storage.refFromURL(imageDir!);
    String imageUrl = await ref.getDownloadURL();
    log("Download URL: " + imageUrl);
    return imageUrl;
  }
}
