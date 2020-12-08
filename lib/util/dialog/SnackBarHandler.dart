import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/html/HtmlHandler.dart';

class SnackBarHandler {
  static SnackBar snackBar;
  static BuildContext context;

  static SnackBar createSnackBar(
      {@required BuildContext parentContext,
      @required String tipAfterDone,
      String actionName = '删除',
      VoidCallback onPressForUndo}) {
    context = parentContext;

    snackBar = SnackBar(
      content: Text(_truncateTip(
          tip:
              '已$actionName：${HtmlHandler.decodeAndRemoveAllHtmlTags(tipAfterDone)}')),
      backgroundColor: GlobalState.themeBlueColor,
      behavior: SnackBarBehavior.fixed,
      action: SnackBarAction(
        label: '撤消',
        textColor: Colors.white,
        onPressed: onPressForUndo,
      ),
    );

    return snackBar;
  }

  static void showSnackBar() {
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static void hideSnackBar() {
    if (snackBar != null) {
      Scaffold.of(context).hideCurrentSnackBar();
    }
  }

  // Private methods
  static String _truncateTip({@required String tip}) {
    var maxLength = 100;

    if (tip.length >= maxLength) {
      tip = tip.substring(0, maxLength);
    }

    return tip;
  }
}
