import 'package:flutter/material.dart';

class AppbarModel extends ChangeNotifier {
  int selectedTab = 0;
  void setSelection(int index) {
    selectedTab = index;
    notifyListeners();
  }
}
