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
}
