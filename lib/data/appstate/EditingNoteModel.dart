import 'package:flutter/material.dart';

class EditingNoteModel extends ChangeNotifier {
  int _id;
  String _title;
  String _content;
  BuildContext _context;

  BuildContext get context => _context;

  set context(BuildContext value) {
    _context = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
    notifyListeners();
  }

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
