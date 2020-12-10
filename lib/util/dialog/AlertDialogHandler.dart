import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class AlertDialogHandler {
  static Future<bool> showAlertDialog({
    @required BuildContext parentContext,
    @required String captionText,
    String remark = '',
    Widget child,
    String buttonTextForCancel = '取消',
    String buttonTextForOK = '确定',
    bool alwaysEnableOKButton = true,
    Color buttonColorForOK = GlobalState.themeBlueColor,
    topLeftButtonText = '取消',
    showTopLeftButton = false,
    VoidCallback topLeftButtonCallback,
    topRightButtonText = '确定',
    showTopRightButton = false,
    VoidCallback topRightButtonCallback,
    barrierDismissible = false,
    showDivider = false,
  }) async {
    var shouldContinueAction = false;
    var theRemark = remark;
    var topButtonWidth = 60.0;

    // If the remark parameter isn't null, we use it as the remark for the dialog
    if (remark != null) theRemark = remark;

    await showDialog<void>(
      context: parentContext,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding:
              EdgeInsets.only(top: 10.0, bottom: 5.0, left: 0.0, right: 0.0),
          title: Center(
              child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: (showTopLeftButton)
                          ? GestureDetector(
                              // top left button // alert dialog top left button
                              // alert dialog left button // alert dialog button
                              child: Container(
                                margin: EdgeInsets.only(left: 0.0),
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 0.0),
                                color: Colors.transparent,
                                width: topButtonWidth,
                                child: Text(
                                  topLeftButtonText,
                                  style: TextStyle(
                                      color: GlobalState.themeBlueColor,
                                      fontSize: 16),
                                ),
                              ),
                              onTap: topLeftButtonCallback,
                            )
                          : Container(),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(
                            left: topButtonWidth, right: topButtonWidth),
                        child: Text(captionText),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: (showTopRightButton)
                          ? GestureDetector(
                              // alert dialog right button // alert dialog top right button
                              // top right button
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(right: 0.0),
                                color: Colors.transparent,
                                width: topButtonWidth,
                                child: Text(
                                  topRightButtonText,
                                  style: TextStyle(
                                      color: GlobalState.themeBlueColor,
                                      fontSize: 16),
                                ),
                              ),
                              onTap: topRightButtonCallback,
                            )
                          : Container(),
                    )
                  ],
                ),
                if (showDivider) Divider()
              ],
            ),
          )),
          contentPadding: EdgeInsets.all(0.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(theRemark)),
              if (child != null)
                Container(margin: EdgeInsets.only(top: 5.0), child: child),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    child: Text(
                      buttonTextForCancel,
                      style: TextStyle(color: GlobalState.themeBlueColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      shouldContinueAction = false;
                    },
                  ),
                  Consumer<AppState>(builder: (cxt, appState, child) {
                    var enableOKButton = appState.enableOKButton;

                    if (alwaysEnableOKButton) enableOKButton = true;

                    return FlatButton(
                      child: Text(
                        buttonTextForOK,
                        style: TextStyle(
                            color: (enableOKButton)
                                ? buttonColorForOK
                                : GlobalState.themeGrey350Color),
                      ),
                      onPressed: () {
                        if (enableOKButton) {
                          Navigator.of(context).pop();
                          shouldContinueAction = true;
                        }
                      },
                    );
                  }),
                ],
              )
            ],
          ),
        );
      },
    );

    return shouldContinueAction;
  }
}
