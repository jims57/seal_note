import 'package:flutter/cupertino.dart';
import 'GlobalState.dart';

class AppState extends ChangeNotifier {
  bool _isExecutingSync = true;

  bool get isExecutingSync => _isExecutingSync;

  set isExecutingSync(bool value) {
    _isExecutingSync = value;

    notifyListeners();
  }

  bool get isInFolderOptionSubPanel => _isInFolderOptionSubPanel;

  set isInFolderOptionSubPanel(bool value) {
    _isInFolderOptionSubPanel = value;

    notifyListeners();
  }

  bool _isInFolderOptionSubPanel = false;

  int _widgetNo = 1; // 1 = init page, 2 = webview, 3 = image gallery

  int get widgetNo => _widgetNo;

  set widgetNo(int value) {
    _widgetNo = value;
    // notifyListeners();
  }

  int _firstImageIndex = 0;

  int get firstImageIndex => _firstImageIndex;

  set firstImageIndex(int value) {
    _firstImageIndex = value;
    notifyListeners();
  }

  bool _shouldMakeDefaultFoldersGrey = false;

  // ignore: unnecessary_getters_setters
  bool get shouldMakeDefaultFoldersGrey => _shouldMakeDefaultFoldersGrey;

  // ignore: unnecessary_getters_setters
  set shouldMakeDefaultFoldersGrey(bool value) {
    _shouldMakeDefaultFoldersGrey = value;

    GlobalState.shouldMakeDefaultFoldersGrey = value;

    notifyListeners();
  }

  String _noteListPageTitle = '海豹笔记';

  // ignore: unnecessary_getters_setters
  String get noteListPageTitle => _noteListPageTitle;

  // ignore: unnecessary_getters_setters
  set noteListPageTitle(String value) {
    GlobalState.selectedFolderNameCurrently = value;
    _noteListPageTitle = value;
    notifyListeners();
  }

  bool _enableAlertDialogOKButton = false;

  // ignore: unnecessary_getters_setters
  bool get enableAlertDialogOKButton => _enableAlertDialogOKButton;

  // ignore: unnecessary_getters_setters
  set enableAlertDialogOKButton(bool value) {
    _enableAlertDialogOKButton = value;
    notifyListeners();
  }

  bool _enableAlertDialogTopRightButton = false;

  // ignore: unnecessary_getters_setters
  bool get enableAlertDialogTopRightButton => _enableAlertDialogTopRightButton;

  // ignore: unnecessary_getters_setters
  set enableAlertDialogTopRightButton(bool value) {
    _enableAlertDialogTopRightButton = value;
    notifyListeners();
  }

  bool _hasDataInNoteListPage = false;

  // ignore: unnecessary_getters_setters
  bool get hasDataInNoteListPage => _hasDataInNoteListPage;

  set hasDataInNoteListPage(bool value) {
    _hasDataInNoteListPage = value;
    notifyListeners();
  }

  bool _isEditorReadOnly = true;

  // ignore: unnecessary_getters_setters
  bool get isEditorReadOnly => _isEditorReadOnly;

  set isEditorReadOnly(bool value) {
    _isEditorReadOnly = value;
    notifyListeners();
  }

  bool _isGoingToOpenReusablePage = false;

  // ignore: unnecessary_getters_setters
  bool get isGoingToOpenReusablePage => _isGoingToOpenReusablePage;

  // ignore: unnecessary_getters_setters
  set isGoingToOpenReusablePage(bool value) {
    _isGoingToOpenReusablePage = value;

    notifyListeners();
  }


}
