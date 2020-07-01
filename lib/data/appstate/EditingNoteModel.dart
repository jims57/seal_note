import 'package:flutter/material.dart';

class EditingNoteModel extends ChangeNotifier {
  int _id;

  int get id => _id;

  set id(int value) {
    _id = value;
    notifyListeners();
  }

  String _title;
  String _content;

  String get title => _title;

  set title(String value) {
    _title = value;

    notifyListeners();
  }

  String get content => _content;

  set content(String value) {
    _content = value;

    notifyListeners();
  }
}
