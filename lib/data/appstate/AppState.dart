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
}
