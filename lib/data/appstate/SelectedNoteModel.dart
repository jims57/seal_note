import 'package:flutter/material.dart';

class SelectedNoteModel extends ChangeNotifier {
  int _folderId;
  int _id;
  String _title;
  String _content;
  BuildContext _noteListPageContext;
  int _screenType = 1;

  int get screenType => _screenType;

  set screenType(int value) {
    _screenType = value;
    notifyListeners();
  }

  int get folderId => _folderId;

  set folderId(int value) {
    _folderId = value;
    notifyListeners();
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

  BuildContext get noteListPageContext => _noteListPageContext;

  set noteListPageContext(BuildContext value) {
    _noteListPageContext = value;
  }
}
