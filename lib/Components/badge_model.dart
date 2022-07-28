import 'package:flutter/material.dart';

class BadgeCounter extends ChangeNotifier{


  int counter = 0;


  void increment() {
    counter++;
    notifyListeners();
  }

  void resetCounter() {
    counter = 0;
    notifyListeners();
  }
}
