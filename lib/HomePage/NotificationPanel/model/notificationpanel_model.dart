// To parse this JSON data, do
//
//     final notificationPageModel = notificationPageModelFromMap(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/LoginPage/model/loginpage_model.dart';
import 'package:unnayan/my_vars.dart';

NotificationPageModel notificationPageModelFromMap(String str) =>
    NotificationPageModel.fromMap(json.decode(str));

String notificationPageModelToMap(NotificationPageModel data) =>
    json.encode(data.toMap());

class NotificationPageModel {
  NotificationPageModel({
    this.complainId,
    this.name,
    this.email,
    this.phone,
    this.detailsByUser,
    this.image,
    this.status,
    this.showNotiftoUser,
    this.showNotiftoOrg,
    this.iduser,
    this.organizationsId,
    this.detaiilsByOrg,
    this.repliedToUser,
    this.repliedToOrg,
  });

  String? complainId;
  String? name;
  String? email;
  String? phone;
  String? detailsByUser;
  String? image;
  String? status;
  String? showNotiftoUser;
  String? showNotiftoOrg;
  int? iduser;
  int? organizationsId;
  String? detaiilsByOrg;
  String? repliedToUser;
  String? repliedToOrg;

  factory NotificationPageModel.fromMap(QueryDocumentSnapshot json) {
    return NotificationPageModel(
      complainId: json.get('complainId'),
      name: json.get('name'),
      email: json.get('email'),
      phone: json.get('phone'),
      detailsByUser: json.get('detailsByUser'),
      image: json.get('image'),
      status: json.get('status'),
      showNotiftoUser: json.get('showNotiftoUser'),
      showNotiftoOrg: json.get('showNotiftoOrg'),
      iduser: json.get('iduser'),
      organizationsId: json.get('organizationsId'),
      detaiilsByOrg: json.get('detaiilsByOrg'),
      repliedToUser: json.get('repliedToUser'),
      repliedToOrg: json.get('repliedToOrg'),
    );
  }
  // factory NotificationPageModel.fromMap(Map<String, dynamic> json) {
  //   return NotificationPageModel(
  //     complainId: json["complainId"],
  //     name: json["name"].toString(),
  //     email: json["email"].toString(),
  //     phone: json["phone"].toString(),
  //     detailsByUser: json["detailsByUser"].toString(),
  //     image: json["image"],
  //     status: json["status"].toString(),
  //     showNotiftoUser: json["showNotiftoUser"].toString(),
  //     showNotiftoOrg: json["showNotiftoOrg"].toString(),
  //     iduser: json["iduser"],
  //     organizationsId: json["organizationsId"],
  //     detaiilsByOrg: json["detaiilsByOrg"].toString(),
  //     repliedToUser: json["repliedToUser"].toString(),
  //     repliedToOrg: json["repliedToOrg"].toString(),
  //   );
  // }

  Map<String, dynamic> toMap() => {
        "complainId": complainId,
        "name": name,
        "email": email,
        "phone": phone,
        "detailsByUser": detailsByUser,
        "image": image,
        "status": status,
        "showNotiftoUser": showNotiftoUser,
        "showNotiftoOrg": showNotiftoOrg,
        "iduser": iduser,
        "organizationsId": organizationsId,
        "detaiilsByOrg": detaiilsByOrg,
        "repliedToUser": repliedToUser,
        "repliedToOrg": repliedToOrg,
      };

  Future<List<NotificationPageModel>?> showNotifications(int userId,
      NotificationEnum nEnum, String repliedToUser, String userType) async {
    final credential = FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot querySnapshot;

    // final allData = querySnapshot.docs.map((doc) => doc).toList();
    log("showNotifications ");
    List<Map<String, dynamic>>? maps;
    switch (nEnum) {
      case NotificationEnum.def:
        if (userType == 'user') {
          log("Type user");
          querySnapshot = await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('complain')
              .where('iduser', isEqualTo: userId)
              .where('repliedToUser', isEqualTo: repliedToUser.toString())
              .get();

          // maps = await db?.rawQuery(
          //     "SELECT * from ${DBDetails.DBTable_COMPLAIN} where (iduser = ${userId} AND repliedToUser = '${repliedToUser}')");
        } else {
          int newId = await getOrgId(userId);
          log("Old Org ID: " + userId.toString());
          log("New Org ID: " + newId.toString());

          querySnapshot = await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('complain')
              .where('organizationsId', isEqualTo: newId)
              .where('repliedToOrg', isEqualTo: repliedToUser.toString())
              .get();
        }

        break;
      case NotificationEnum.userTotal:
        querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('complain')
            .where('iduser', isEqualTo: userId)
            .get();

        break;

      case NotificationEnum.userHistory:
        querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('complain')
            .where('iduser', isEqualTo: userId)
            .where('status', isEqualTo: 'solved')
            .get();

        break;
      case NotificationEnum.userPending:
        querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('complain')
            .where('iduser', isEqualTo: userId)
            .where('status', isEqualTo: 'pending')
            .get();

        break;

      ///
      ///
      /// ORG
      ///
      case NotificationEnum.orgTotal:
        int newId = await getOrgId(userId);
        querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('complain')
            .where('organizationsId', isEqualTo: newId)
            .get();
        log("Org ID: " + newId.toString());

        break;

      case NotificationEnum.orgRecent:
        int newId = await getOrgId(userId);
        log("Org ID: " + newId.toString());
        querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('complain')
            .where('organizationsId', isEqualTo: newId)
            .where('status', isEqualTo: 'solved')
            .get();

        break;
      case NotificationEnum.orgPending:
        int newId = await getOrgId(userId);
        log("Org ID: " + newId.toString());
        querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('complain')
            .where('organizationsId', isEqualTo: newId)
            .where('status', isEqualTo: 'pending')
            .get();

        break;
    }
    List<NotificationPageModel>? model;
    log(querySnapshot.toString());
    final data = querySnapshot.docs.map((e) => e).toList();
    log("Notif Data Check!");
    log(data.toString());
    if (data.isNotEmpty) {
      log("Data Not empty");
      model = [];
      for (QueryDocumentSnapshot element in data) {
        NotificationPageModel nModel = NotificationPageModel.fromMap(element);
        log(nModel.toString());
        await nModel.getImage().then((value) {
          nModel.image = value;
          model!.add(nModel);
        });
      }
      log(model.toString());
      return model;
    }

    return null;
  }

  Future<String> getImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    log(storage.toString());
    String imageUrl;
    try {
      Reference ref = storage.refFromURL(image!);
      imageUrl = await ref.getDownloadURL();
      log("Download URL: " + imageUrl);
    } catch (e) {
      return "";
    }

    return imageUrl;
  }

  Future<String?> getTileLogo(int id, BuildContext context) async {
    QuerySnapshot querySnapshot;
    log("User Id:" + id.toString());
    if (context.read<LoginpageModel>().userType != 'user') {
      log("Looking for Org :" + id.toString());

      querySnapshot = await FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('users')
          .where('iduser', isEqualTo: id)
          .get();
    } else {
      log("Looking for User :" + id.toString());

      querySnapshot = await FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('organizations')
          .where('organizationsId', isEqualTo: id.toString())
          .get();
    }
    log(querySnapshot.toString());
    final data = querySnapshot.docs.map((e) => e).toList();
    String? imgURl;
    log("Tile Data Size:" + data.length.toString());
    if (data.isNotEmpty) {
      log("Tile got data");
      for (var element in data) {
        imgURl = element.get('image');
      }
      FirebaseStorage storage = FirebaseStorage.instance;
      log(storage.toString());
      Reference ref = storage.refFromURL(imgURl!);
      await ref.getDownloadURL().then((value) => imgURl = value);
      log("Download URL: " + imgURl!);
      return imgURl;
    } else {
      log("Tile does not got  data");

      return imgURl;
    }
  }

  Future<void> updateComplainNotificationToUserToFalse(
      String complainId, String showNotifToUserStr) async {
    return await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .doc(complainId)
        .update({'showNotiftoUser': showNotifToUserStr})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<int> getOrgId(int userId) async {
    QuerySnapshot reference = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('organizations')
        .where('iduser', isEqualTo: userId.toString())
        .get();
    final data = reference.docs.map((e) => e).toList();

    if (data.length == 1) {
      for (var element in data) {
        return int.parse(element.get('organizationsId'));
      }
    }

    return 0;
  }
  // Future<int> getOrgId(int userId) async {
  //   db ??= await DBDetails.InitDatabase();
  //   log("getTotalData for user :");
  //   List<Map<String, dynamic?>>? map = await db?.rawQuery(
  //       "SELECT organizationsId FROM ${DBDetails.DBTable_ORGANIZATIONS} WHERE (iduser = ${userId})");
  //   log(map!.length.toString());
  //   if (map != null) {
  //     return map.first['organizationsId'];
  //   }
  //   return 0;
  // }

  Future<void> updateComplainNotificationToOrgToFalse(
      String complainId, String showNotifToUserStr) async {
    return await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .doc(complainId)
        .update({'showNotiftoOrg': showNotifToUserStr})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // Future<void> updateComplainNotificationToOrgToFalse(
  //     int complainId, String showNotifToUserStr) async {
  //   db ??= await DBDetails.InitDatabase();
  //
  //   String query =
  //       "UPDATE complain SET showNotiftoOrg = ? WHERE complainId = ?";
  //
  //   int num = await db!.rawUpdate(query, [showNotifToUserStr, complainId]);
  //   log("Updated Row: " + num.toString());
  // }
}
