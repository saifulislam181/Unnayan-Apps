import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserChatPanelModel {
  String? name;
  String? imgDir;
  String? complainID;
  String? orgId;
  String? msgTokenCollection;
  UserChatPanelModel({
    this.name,
    this.imgDir,
    this.complainID,
  });
  Future<List<UserChatPanelModel>?> getOrgs(
      int userId, String? userType) async {
    int neworgId;
    QuerySnapshot querySnapshot;
    if (userType == 'user') {
      querySnapshot = await FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('complain')
          .where('iduser', isEqualTo: userId)
          .get();
    } else {
      neworgId = await getOrgId(userId);
      log("New ORGID:" + neworgId.toString());
      querySnapshot = await FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('complain')
          .where('organizationsId', isEqualTo: neworgId)
          .get();
    }

    List<UserChatPanelModel>? model;

    final data = querySnapshot.docs.map((e) => e).toList();
    log("Chat Data Check!");
    log(data.toString());
    if (data.isNotEmpty) {
      log("Chat Data Not empty");
      model = [];
      List<String> ids = [];
      for (QueryDocumentSnapshot element in data) {
        bool ignoreModel = false;
        QuerySnapshot querySnapshot2;
        if (userType == 'user') {
          querySnapshot2 = await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('organizations')
              .where('organizationsId',
                  isEqualTo: element.get('organizationsId').toString())
              .get();
        } else {
          querySnapshot2 = await FirebaseFirestore.instance
              .collection('db')
              .doc('unnayan')
              .collection('users')
              .where('iduser', isEqualTo: element.get('iduser'))
              .get();
        }

        final data2 = querySnapshot2.docs.map((e) => e).toList();
        if (userType == 'user') {
          if (ids.length > 0) {
            for (var id in ids) {
              if (id == element.get('organizationsId').toString()) {
                log("Found Copy");
                ignoreModel = true;
                break;
              } else {
                log("Unique ID: " + element.get('organizationsId').toString());

                ids.add(element.get('organizationsId').toString());
                break;
              }
            }
          } else {
            ids.add(element.get('organizationsId').toString());
          }
          if (!ignoreModel) {
            String token = await getOrgToken(data2[0].get('iduser'), userId);
            UserChatPanelModel nModel = UserChatPanelModel();
            nModel.name = data2.first.get('name');
            nModel.complainID = element.get('complainId');
            nModel.orgId = data2.first.get('iduser').toString();
            nModel.msgTokenCollection = token;
            await getImageDir(data2[0].get('image')).then((value) {
              nModel.imgDir = value;
            });
            model.add(nModel);
          }
        } else {
          if (ids.length > 0) {
            for (var id in ids) {
              if (id == element.get('iduser').toString()) {
                log("Found Copy");
                ignoreModel = true;
                break;
              } else {
                log("Unique ID: " + element.get('iduser').toString());

                ids.add(element.get('iduser').toString());
              }
            }
          } else {
            ids.add(element.get('iduser').toString());
          }

          if (!ignoreModel) {
            log("Chat Data Check 2!");
            log(data2.toString());
            log(data2.length.toString());
            int assId = data2.first.get('iduser');
            String token = await getOrgToken(assId.toString(), userId);
            UserChatPanelModel nModel = UserChatPanelModel();
            nModel.name = data2.first.get('name');
            nModel.complainID = element.get('complainId');
            nModel.orgId = data2.first.get('iduser').toString();
            nModel.msgTokenCollection = token;
            await getImageDir(data2[0].get('image')).then((value) {
              nModel.imgDir = value;
            });
            model.add(nModel);
          }
        }
      }
      log(model.toString());
      return model;
    }

    return null;
  }

  Future<String> getImageDir(String dir) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    log(storage.toString());
    Reference ref = storage.refFromURL(dir);
    String imageUrl = await ref.getDownloadURL();
    log("Download URL: " + imageUrl);
    return imageUrl;
  }

  Future<String> getOrgToken(String orgId, int userId) async {
    log("OrgId :" + orgId);
    log("UserId :" + userId.toString());

    String email;
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('users')
        .where('iduser', isEqualTo: int.parse(orgId))
        .get();
    final user = snap.docs.map((e) => e).toList();
    if (user.isNotEmpty) {
      email = user.first.reference.id;
      log("Got Email:" + email);
    } else {
      return "";
    }

    QuerySnapshot snap2 = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('users')
        .doc(email)
        .collection('msgTokens')
        .where('from', isEqualTo: userId.toString())
        .get();

    final data = snap2.docs.map((e) => e).toList();
    log('gonna go for token');
    if (data.isNotEmpty) {
      log(data.first.get('msgToken').toString());
      return data.first.get('msgToken');
    } else {
      QuerySnapshot snap3 = await FirebaseFirestore.instance
          .collection('db')
          .doc('unnayan')
          .collection('users')
          .doc(email)
          .collection('msgTokens')
          .where('to', isEqualTo: userId.toString())
          .get();
      final data2 = snap3.docs.map((e) => e).toList();
      log('gonna go for token Again');

      if (data2.isNotEmpty) {
        log(data2.first.get('msgToken').toString());
        return data2.first.get('msgToken');
      }
    }
    return "";
  }

  Future<int> getOrgId(int userId) async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('organizations')
        .where('iduser', isEqualTo: userId.toString())
        .get();
    final data = snap.docs.map((e) => e).toList();
    if (data.isNotEmpty) {
      return int.parse(data.first.get('organizationsId').toString());
    }
    return 0;
  }
}
