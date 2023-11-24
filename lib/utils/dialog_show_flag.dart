import 'package:flutter/material.dart';

class DialogShownFlag with ChangeNotifier {
  bool _shown = false;

  bool get shown => _shown;

  void setFlag(bool value) {
    _shown = value;
    notifyListeners();
  }
}