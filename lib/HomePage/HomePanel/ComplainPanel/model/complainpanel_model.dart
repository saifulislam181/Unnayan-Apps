// To parse this JSON data, do
//
//     final complainPanelModel = complainPanelModelFromMap(jsonString);

import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ComplainPanelModel {
  ComplainPanelModel({
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
  List<int>? image;
  // String? image;
  String? status;
  String? showNotiftoUser;
  String? showNotiftoOrg;
  int? iduser;
  int? organizationsId;
  String? detaiilsByOrg;
  String? repliedToUser;
  String? repliedToOrg;

  factory ComplainPanelModel.fromMap(Map<String, dynamic> json) =>
      ComplainPanelModel(
        complainId: json["complainId"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        detailsByUser: json["detailsByUser"],
        image: json["image"],
        status: json["status"],
        showNotiftoUser: json["showNotiftoUser"],
        showNotiftoOrg: json["showNotiftoOrg"],
        iduser: json["iduser"],
        organizationsId: json["organizationsId"],
      );

  Map<String, dynamic> toMap(String filename) => {
        "complainId": complainId,
        "name": name,
        "email": email,
        "phone": phone,
        "detailsByUser": detailsByUser,
        "image": "gs://unnayan-e10b9.appspot.com/" + filename,
        "status": status,
        "showNotiftoUser": showNotiftoUser,
        "showNotiftoOrg": showNotiftoOrg,
        "iduser": iduser,
        "organizationsId": organizationsId,
        "detaiilsByOrg": "",
        "repliedToUser": repliedToUser,
        "repliedToOrg": repliedToOrg,
      };

  Future insertByUser(ComplainPanelModel model, String filename) async {
    final storageRef = FirebaseStorage.instance.ref();

    final imgRef = storageRef.child(filename);
    try {
      CollectionReference users = FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('complain');
      log("THE IMAGE" + imgRef.toString());
      log("THE IMAGE NAME:" + imgRef.name);

      users.add(model.toMap(filename)).then((value) {
        users.doc(value.id).update({'complainId': value.id});
      });

      await imgRef.putData(Uint8List.fromList(model.image!));
      await addMsgTokens(
          model.iduser.toString(), model.organizationsId.toString());
    } catch (e) {}
  }

  Future<void> addMsgTokens(String? iduser, String? organizationsId) async {
    String token;
    String token2;
    String tokenGenerated = "";
    //Check On Loged In user Side.
    QuerySnapshot getusers = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('users')
        .where('iduser', isEqualTo: int.parse(iduser!))
        .get();

    final userdata = getusers.docs.map((e) => e).toList();
    if (userdata.isNotEmpty) {
      log(userdata.first.reference.id);
      QuerySnapshot getUserToken = await FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('users')
          .doc(userdata.first.reference.id)
          .collection('msgTokens')
          .where('to', isEqualTo: organizationsId)
          .get();
      final tokendata = getUserToken.docs.map((e) => e).toList();
      if (tokendata.isNotEmpty) {
        token = tokendata.first.get('msgToken');
        return;
      } else {
        var uuid = Uuid();

        tokenGenerated = uuid.generateV4();
        String newOrgId = await getOtherUserId(organizationsId!);
        log("Org ID:" + organizationsId);
        log("New Org ID:" + newOrgId);
        await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('users')
            .doc(userdata.first.reference.id)
            .collection('msgTokens')
            .add({"from": iduser, "to": newOrgId, "msgToken": tokenGenerated});
        QuerySnapshot getusers2 = await FirebaseFirestore.instance
            .collection('db')
            .doc('unnayan')
            .collection('users')
            .where('iduser', isEqualTo: int.parse(newOrgId))
            .get();
        final userdata2 = getusers2.docs.map((e) => e).toList();
        if (userdata2.isNotEmpty) {
          QuerySnapshot getUserToken2 = await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('users')
              .doc(userdata2.first.reference.id)
              .collection('msgTokens')
              .where('to', isEqualTo: iduser)
              .get();
          final tokendata2 = getUserToken2.docs.map((e) => e).toList();

          if (tokendata2.isNotEmpty) {
            token2 = tokendata2.first.get('msgToken');
          } else {
            await FirebaseFirestore.instance
                .collection('db')
                .doc('unnayan')
                .collection('users')
                .doc(userdata2.first.reference.id)
                .collection('msgTokens')
                .add({
              "from": newOrgId,
              "to": iduser,
              "msgToken": tokenGenerated
            });
          }
        }
      }
    }
  }

  Future<String> getOtherUserId(String orgId) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('organizations')
        .where('organizationsId', isEqualTo: orgId)
        .get();

    final data = snap.docs.map((e) => e).toList();
    if (data.isNotEmpty) {
      return data.first.get('iduser');
    }
    return "0";
  }
}
