import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';

ProfileModel loginpageModelFromMap(String str) =>
    ProfileModel.fromMap(json.decode(str));

String loginpageModelToMap(ProfileModel data) => json.encode(data.toMap());

class ProfileModel {
  ProfileModel({
    this.iduser,
    this.username,
    this.email,
    this.password,
    this.phoneNumber,
    this.userType,
    this.universityName,
    this.name,
    this.location,
    this.image,
  }) {}

  int? iduser;
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? userType;
  String? universityName;
  String? name;
  String? location;
  List<int>? image;
  Database? db;

  factory ProfileModel.fromMap(Map<String, dynamic> json) => ProfileModel(
        iduser: json["iduser"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        phoneNumber: json["phoneNumber"],
        userType: json["userType"],
        universityName: json["universityName"],
        name: json["name"],
        location: json["location"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "userType": userType,
        "universityName": universityName,
        "name": name,
        "location": location,
        "image": image,
      };

  Future<int> getTotalUserData(int id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .where('iduser', isEqualTo: id)
        .get();

    final data = querySnapshot.docs.map((e) => e).toList();

    if (data.isNotEmpty) {
      log("data not empty");
      return data.length;
    }
    return 0;
  }

  Future<int> getHistoryUserData(int id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .where('iduser', isEqualTo: id)
        .where('status', isEqualTo: 'solved')
        .get();
    final data = querySnapshot.docs.map((e) => e).toList();

    if (data.isNotEmpty) {
      return data.length;
    }
    return 0;
  }

  Future<int> getPendingUserData(int id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .where('iduser', isEqualTo: id)
        .where('status', isEqualTo: 'pending')
        .get();
    final data = querySnapshot.docs.map((e) => e).toList();

    if (data.isNotEmpty) {
      return data.length;
    }
    return 0;
  }

  ///
  ///
  /// Organizations Quries.
  ///
  ///
  Future<int> getOrgId(int id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('organizations')
        .where('iduser', isEqualTo: id.toString())
        .get();

    final data = querySnapshot.docs.map((e) => e).toList();
    if (data.isNotEmpty) {
      for (var element in data) {
        return int.parse(element.get('organizationsId'));
      }
    }

    return 0;
  }

  Future<int> getRecentOrgData(int id) async {
    id = await getOrgId(id);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .where('organizationsId', isEqualTo: id)
        .where('status', isEqualTo: 'solved')
        .get();

    final data = querySnapshot.docs.map((e) => e).toList();

    if (data.isNotEmpty) {
      log("data not empty");
      return data.length;
    }
    return 0;
  }

  Future<int> getPendingOrgData(int id) async {
    id = await getOrgId(id);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .where('organizationsId', isEqualTo: id)
        .where('status', isEqualTo: 'pending')
        .get();

    final data = querySnapshot.docs.map((e) => e).toList();

    if (data.isNotEmpty) {
      log("data not empty");
      return data.length;
    }

    return 0;
  }

  Future<int> getTotalOrgData(int id) async {
    id = await getOrgId(id);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .where('organizationsId', isEqualTo: id)
        .get();

    final data = querySnapshot.docs.map((e) => e).toList();

    if (data.isNotEmpty) {
      log("data not empty");
      return data.length;
    }
    return 0;
  }
}
