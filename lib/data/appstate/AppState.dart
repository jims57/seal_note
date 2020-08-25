import 'package:flutter/cupertino.dart';

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
    notifyListeners();
  }

  // 1 = old note in read mode, 2 = old note in edit mode, 3 = creating a new note
  int _detailPageStatus = 1;

  int get detailPageStatus => _detailPageStatus;

  set detailPageStatus(int value) {
    _detailPageStatus = value;
    notifyListeners();
  }

  int _firstImageIndex = 0;

  int get firstImageIndex => _firstImageIndex;

  set firstImageIndex(int value) {
    _firstImageIndex = value;
    notifyListeners();
  }
}
