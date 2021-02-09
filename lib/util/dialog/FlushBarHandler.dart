import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class FlushBarHandler {
  void showFlushBar({
    IconData icon = Icons.info_outlined,
    @required String title,
    @required String message,
    @required BuildContext context,
    bool showUndoButton = true,
    VoidCallback callbackForUndo,
  }) {
    Flushbar(
      // review finish tip // review tip
      // note review tip // review note tip
      title: title,
      messageText: Text(
        message,
        style: TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      duration: Duration(milliseconds: GlobalState.defaultFlushBarDuration),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: GlobalState.themeBlueColor,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      mainButton: (showUndoButton)
          ? GestureDetector(
              child: Container(
                alignment: Alignment.center,
                width: 60,
                color: Colors.white,
                child: Text(
                  '撤消',
                  style: TextStyle(
                    color: GlobalState.themeBlueColor,
                  ),
                ),
              ),
              onTap: (callbackForUndo != null) ? callbackForUndo : () async {},
            )
          : Container(),
    )..show(context);
  }
}
