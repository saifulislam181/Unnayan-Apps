import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sqflite.dart';

CreateAccountModel createAccountModelFromMap(String str) =>
    CreateAccountModel.fromMap(json.decode(str));

String createAccountModelToMap(CreateAccountModel data) =>
    json.encode(data.toMap());

class CreateAccountModel {
  CreateAccountModel({
    this.iduser,
    this.filename,
    this.email,
    this.password,
    this.phoneNumber,
    this.userType,
    this.universityName,
    this.name,
    this.location,
    this.image,
  });

  String? iduser;
  String? filename;
  String? email;
  String? password;
  String? phoneNumber;
  String? userType;
  String? universityName;
  String? name;
  String? location;
  String? image;

  factory CreateAccountModel.fromMap(Map<String, dynamic> json) =>
      CreateAccountModel(
        iduser: json["iduser"],
        filename: json["username"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        userType: json["userType"],
        universityName: json["universityName"],
        name: json["name"],
        location: json["location"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "iduser": iduser,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "userType": userType,
        "universityName": universityName,
        "name": name,
        "location": location,
        "image": image,
      };

  Database? db;

  Future<void> createAcccountForUser(
      {String? filename,
      String? email,
      String? phoneNumber,
      String? password,
      String? userType,
      List<int>? image,
      String? universityName,
      String? name,
      String? location}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      )
          .whenComplete(() async {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('users')
            .get();
        final userData = querySnapshot.docs.map((e) => e).toList();
        int newId = userData.length + 1;
        log("USers Length: " + newId.toString());

        // Create a storage reference from our app
        final storageRef = FirebaseStorage.instance.ref();

        // Create a reference to "mountains.jpg"
        final imgRef = storageRef.child(filename!);
        try {
          // Upload raw data.
          await imgRef.putData(Uint8List.fromList(image!));
          Map<String, dynamic> user = {
            "iduser": newId,
            "location": location,
            "name": name,
            "image": "gs://unnayan-e10b9.appspot.com/" + filename,
            "university": universityName,
            "userType": userType
          };
          await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('users')
              .doc(email)
              .set(user);
        } catch (e) {
          // ...
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> createAccountForOrg(
      {String? filename,
      String? email,
      String? phoneNumber,
      String? password,
      String? userType,
      List<int>? image,
      String? name,
      String? location,
      int? orgType}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      )
          .whenComplete(() async {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('users')
            .get();
        final userData = querySnapshot.docs.map((e) => e).toList();
        int newId = userData.length + 1;
        log("USers Length: " + newId.toString());
        // Create a storage reference from our app
        final storageRef = FirebaseStorage.instance.ref();

        // Create a reference to "mountains.jpg"
        final imgRef = storageRef.child(filename!);
        try {
          // Upload raw data.
          await imgRef.putData(Uint8List.fromList(image!));
          Map<String, dynamic> user = {
            "iduser": newId,
            "location": location,
            "name": name,
            "image": "gs://unnayan-e10b9.appspot.com/" + filename,
            "university": null,
            "userType": userType
          };
          await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('users')
              .doc(email)
              .set(user);
          QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('organizations')
              .get();
          final userData2 = querySnapshot2.docs.map((e) => e).toList();
          int userlen = userData2.length + 1;
          Map<String, dynamic> orguser = {
            "iduser": newId,
            "name": name,
            "image": "gs://unnayan-e10b9.appspot.com/" + filename,
            "organizationTypeId": orgType.toString(),
            "organizationsId": userlen.toString()
          };
          await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('organizations')
              .doc(name)
              .set(orguser);
        } catch (e) {
          // ...
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
