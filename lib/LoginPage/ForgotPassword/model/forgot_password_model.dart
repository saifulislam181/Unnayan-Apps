import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ForgotPasswordModel {
  String? Email;
  Database? db;

  ForgotPasswordModel({this.Email});

  Future<bool> onVerifiedEmail(String? email, BuildContext context) async {
    var reference = await FirebaseFirestore.instance
        .collection('db')
        .doc('unnayan')
        .collection('users')
        .doc(email)
        .get();
    if (reference.exists) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Reset Email Sent.'),
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      return true;
    } else {
      return false;
    }
  }
}
