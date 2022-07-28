import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';
import 'package:unnayan/AlWids.dart';
import 'package:unnayan/HomePage/HomePanel/ComplainPanel/model/complainpanel_model.dart';

class ComplainPanelController extends ControllerMVC {
  factory ComplainPanelController() => _this ??= ComplainPanelController._();

  ComplainPanelController._()
      : model = ComplainPanelModel(),
        super();

  static ComplainPanelController? _this;
  final ComplainPanelModel model;

  Future<void> submitComplain(
      ComplainPanelModel model, String filename, BuildContext context) async {
    model.insertByUser(model, filename).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Complain Submitted"),
        ),
      );
    });

    await Future.delayed(const Duration(seconds: 1), () {
      Provider.of<WidContainer>(context, listen: false).resetHome();
    });
  }
}
