import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/NoteListWidgetForToday.dart';

class SelectedNoteModel extends ChangeNotifier {
  int _folderId;
  // String _folderName = GlobalState.defaultUserFolderNameForMyNotes;
  int _id;
  String _title;
  String _content;
  BuildContext _noteListPageContext;

  GlobalKey<NoteListWidgetForTodayState> _noteListWidgetForTodayState;

  GlobalKey<NoteListWidgetForTodayState> get noteListWidgetForTodayState =>
      _noteListWidgetForTodayState;

  // ignore: unnecessary_getters_setters
  set noteListWidgetForTodayState(
      GlobalKey<NoteListWidgetForTodayState> value) {
    _noteListWidgetForTodayState = value;
  }

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

  // ignore: unnecessary_getters_setters
  // String get folderName => _folderName;

  // ignore: unnecessary_getters_setters
  // set folderName(String value) {
  //   _folderName = value;
  //   notifyListeners();
  // }

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

  // ignore: unnecessary_getters_setters
  BuildContext get noteListPageContext => _noteListPageContext;

  // ignore: unnecessary_getters_setters
  set noteListPageContext(BuildContext value) {
    _noteListPageContext = value;
  }
}
