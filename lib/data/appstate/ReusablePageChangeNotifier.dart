import 'package:flutter/cupertino.dart';

class ReusablePageChangeNotifier extends ChangeNotifier {
  int _upcomingReusablePageIndex = 0;

  // ignore: unnecessary_getters_setters
  int get upcomingReusablePageIndex => _upcomingReusablePageIndex;

  // ignore: unnecessary_getters_setters
  set upcomingReusablePageIndex(int value) {
    _upcomingReusablePageIndex = value;
    notifyListeners();
  }
}
