import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

LoginpageModel loginpageModelFromMap(String str) =>
    LoginpageModel.fromMap(json.decode(str));

String loginpageModelToMap(LoginpageModel data) => json.encode(data.toMap());

class LoginpageModel extends ChangeNotifier {
  LoginpageModel({
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
  });

  int? iduser;
  String? username;
  String? email;
  String? password;
  String? phoneNumber;
  String? userType;
  String? universityName;
  String? name;
  String? location;
  // List<int>? image;
  String? image;
  Database? db;

  // factory LoginpageModel.fromMap(Map<String, dynamic> json) => LoginpageModel(
  //       iduser: json["iduser"],
  //       username: json["username"],
  //       email: json["email"],
  //       password: json["password"],
  //       phoneNumber: json["phoneNumber"],
  //       userType: json["userType"],
  //       universityName: json["universityName"],
  //       name: json["name"],
  //       location: json["location"],
  //       image: json["image"],
  //     );
  factory LoginpageModel.fromMap(Map<String, dynamic> json) => LoginpageModel(
        iduser: json["iduser"],
        userType: json["userType"],
        universityName: json["university"],
        name: json["name"],
        location: json["location"],
        image: json["image"],
      );
  Map<String, dynamic> toMap() => {
        "iduser": iduser,
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

  Future<LoginpageModel?> getUser(
      String? myUser, String? myPassword, BuildContext context) async {
    log("Clicked Login 2: $myUser and $myPassword");

    LoginpageModel? model = null;
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: myUser!, password: myPassword!);
      log(credential.user!.email.toString());
      final DocumentReference doc = FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('users')
          .doc(credential.user!.email.toString());
      dynamic data;
      await doc.get().then<dynamic>((DocumentSnapshot snapshot) async {
        data = snapshot.data();

        model = LoginpageModel.fromMap(data);
        log(model!.iduser.toString());
        log(model!.name.toString());
        log(model!.image.toString());
        log(model!.universityName.toString());
        await model!.getImage().then((value) {
          model!.image = value;
          notifyListeners();
        });
        log("ID" + model!.iduser.toString());
      });

      // model = LoginpageModel(email: email.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        const snackBar = SnackBar(content: Text('User Not Found'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        const snackBar = SnackBar(content: Text('Wrong Password'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return model;
  }

  // Future<LoginpageModel?> getUser(String? myUser, String? myPassword) async {
  //   db ??= await DBDetails.InitDatabase();
  //
  //   db!.isOpen ? log("Opended") : log("False");
  //
  //   log("Print: $myUser and $myPassword");
  //   String query =
  //       "SELECT * FROM ${DBDetails.DBTable_USER} WHERE (username = '$myUser' OR email = '$myUser' OR phoneNumber = '$myUser') AND (password = '$myPassword')";
  //   log(query);
  //   List<Map<String, dynamic>>? list = await db?.rawQuery(query);
  //   log("Print: ${list!.length}");
  //   if (list.isNotEmpty) {
  //     log(list.length.toString());
  //
  //     if (list.length == 1) {
  //       log(list.toString());
  //
  //       try {
  //         var v = LoginpageModel.fromMap(list.first);
  //         iduser = v.iduser;
  //         name = v.name;
  //         universityName = v.universityName;
  //         username = v.username;
  //         phoneNumber = v.phoneNumber;
  //         password = v.password;
  //         email = v.email;
  //         image = v.image;
  //         location = v.location;
  //         userType = v.userType;
  //         notifyListeners();
  //         return v;
  //       } catch (e) {
  //         return null;
  //       }
  //     }
  //   }

  //   return null;
  // }

  Future close() async => db?.close();

  void setUserData(LoginpageModel user) {
    this.iduser = user.iduser;
    this.name = user.name;
    this.image = user.image;
    this.universityName = user.universityName;
    this.userType = user.userType;
  }

  Future<String> getImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    log(storage.toString());
    log(image!);
    Reference ref = storage.refFromURL(image!);
    String imageUrl = await ref.getDownloadURL();
    log("Download URL: " + imageUrl);
    return imageUrl;
  }
}
