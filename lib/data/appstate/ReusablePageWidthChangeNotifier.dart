import 'dart:async';
import 'GlobalState.dart';
import 'package:flutter/cupertino.dart';

class ReusablePageWidthChangeNotifier extends ChangeNotifier {
  void notifyReusablePageWidthChange() {
    // notify reusable page width change

    var theReusablePageWidth = GlobalState
        .reusablePageStackWidgetState.currentState
        .getReusablePageWidth(
            forceToUpdateCurrentReusablePageWidthVarAtGlobalState: false);

    GlobalState.currentReusablePageWidth = theReusablePageWidth;

    Timer(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
