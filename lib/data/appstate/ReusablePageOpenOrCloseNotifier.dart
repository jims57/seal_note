import 'package:flutter/cupertino.dart';

class ReusablePageOpenOrCloseNotifier with ChangeNotifier {
  bool _isGoingToOpenReusablePage = false;

  // ignore: unnecessary_getters_setters
  bool get isGoingToOpenReusablePage => _isGoingToOpenReusablePage;

  // ignore: unnecessary_getters_setters
  set isGoingToOpenReusablePage(bool value) {
    _isGoingToOpenReusablePage = value;

    notifyListeners();
  }
}
