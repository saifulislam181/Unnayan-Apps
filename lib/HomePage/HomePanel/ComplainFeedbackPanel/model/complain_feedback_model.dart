import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sqflite/sqflite.dart';

class ComplainFeedBackPanelModel {
  ComplainFeedBackPanelModel({
    this.iduser,
    this.username,
    this.location,
    this.image,
  });

  int? iduser;
  String? username;
  String? image;
  String? location;

  Database? db;

  factory ComplainFeedBackPanelModel.fromMap(QueryDocumentSnapshot json) {
    return ComplainFeedBackPanelModel(
      iduser: json.get('iduser'),
      username: json.get('name'),
      image: json.get('image'),
      location: json.get('location'),
    );
  }

  Future<ComplainFeedBackPanelModel?> getUserData(int ID) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('users')
        .where('iduser', isEqualTo: ID)
        .get();
    final data = querySnapshot.docs.map((e) => e);
    if (data.isNotEmpty) {
      for (var element in data) {
        ComplainFeedBackPanelModel user =
            ComplainFeedBackPanelModel.fromMap(element);
        String imgURl = user.image!;
        FirebaseStorage storage = FirebaseStorage.instance;
        log(storage.toString());
        Reference ref = storage.refFromURL(imgURl);
        await ref.getDownloadURL().then((value) => user.image = value);
        log("Download URL: " + imgURl);
        return user;
      }
    } else {
      return null;
    }
  }

  Future<void> insertFeedbackByOrg(
      String complainId, String detailsByOrg) async {
    await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('complain')
        .doc(complainId)
        .update({
          "status": "solved",
          "detaiilsByOrg": detailsByOrg,
          "showNotiftoUser": "true",
          "repliedToUser": "true",
        })
        .then((value) => log("User Updated"))
        .catchError((error) => log("Failed to update user: $error"));
  }
}
