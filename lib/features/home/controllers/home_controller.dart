import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  int xp = 120;

  void gainXP(int value) {
    xp += value;
    notifyListeners();
  }
}
