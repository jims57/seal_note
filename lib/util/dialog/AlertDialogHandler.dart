import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AlertDialogHeightChangeNotifier.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class AlertDialogHandler {
  Future<bool> showAlertDialog({
    @required BuildContext parentContext,
    @required String captionText,
    String remark,
    Widget child,
    bool showButtonForCancel = true,
    String buttonTextForCancel = '取消',
    bool showButtonForOK = true,
    String buttonTextForOK = '确定',
    bool alwaysEnableOKButton = true,
    Color buttonColorForOK = GlobalState.themeBlueColor,
    String topLeftButtonText = '取消',
    bool showTopLeftButton = false,
    String topRightButtonText = '确定',
    bool showTopRightButton = false,
    VoidCallback topRightButtonCallback,
    bool barrierDismissible = false,
    bool showDivider = false,
    bool restoreWebViewToShowIfNeeded = false,
    bool expandRemarkToMaxFinite = false,
    bool centerRemark = true,
  }) async {
    var shouldContinueAction = false;
    var theRemark = '';
    var topButtonWidth = 60.0;

    GlobalState.isAlertDialogBeingShown = true;

    // If the remark parameter isn't null, we use it as the remark for the dialog
    if (remark != null) {
      theRemark = remark.replaceAll('<br>', '\n');
    }

    var singleChildScrollView = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (theRemark.isNotEmpty)
            Container(
                alignment:
                    (centerRemark) ? Alignment.center : Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: (child != null) ? 0.0 : 10.0),
                child: Text(theRemark)),
          if (child != null)
            Container(
                margin: EdgeInsets.only(
                    top: 5.0,
                    bottom:
                        (showButtonForCancel || showButtonForOK) ? 0.0 : 20.0),
                child: child),
        ],
      ),
    );

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
                              onTap: () async {
                                Navigator.of(context).pop();
                                shouldContinueAction = false;
                              },
                            )
                          : Container(),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(
                          left: topButtonWidth, right: topButtonWidth),
                      child: Text(captionText),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: (showTopRightButton)
                          ? Consumer<AppState>(builder: (cxt, appState, child) {
                              var enableTopRightButton =
                                  appState.enableAlertDialogTopRightButton;

                              return GestureDetector(
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
                                        color: (enableTopRightButton)
                                            ? GlobalState.themeBlueColor
                                            : GlobalState.themeGrey350Color,
                                        fontSize: 16),
                                  ),
                                ),
                                onTap: () {
                                  if (enableTopRightButton) {
                                    shouldContinueAction = true;
                                    topRightButtonCallback();
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            })
                          : Container(),
                    )
                  ],
                ),
                if (showDivider) Divider()
              ],
            ),
          )),
          contentPadding: EdgeInsets.all(0.0),
          content: Expanded(
            child: Consumer<AlertDialogHeightChangeNotifier>(
                builder: (cxt, alertDialogHeightChangeNotifier, child) {
              var theColumn = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  (expandRemarkToMaxFinite)
                      ? Expanded(
                          child: singleChildScrollView,
                        )
                      : singleChildScrollView,
                  // singleChildScrollView,
                  if (showButtonForCancel || showButtonForOK)
                    Container(
                      child: Row(
                        mainAxisAlignment: (_hasOnlyOneBottomButton(
                                showButtonForOK: showButtonForOK,
                                showButtonForCancel: showButtonForCancel))
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (showButtonForCancel)
                              ? FlatButton(
                                  // alert dialog cancel button // cancel button
                                  // dialog cancel button

                                  child: Text(
                                    buttonTextForCancel,
                                    style: TextStyle(
                                        color: GlobalState.themeBlueColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    shouldContinueAction = false;

                                    if (restoreWebViewToShowIfNeeded) {
                                      GlobalState
                                          .noteDetailWidgetState.currentState
                                          .restoreWebViewToShowIfNeeded();
                                    }
                                  },
                                )
                              : Container(),
                          (showButtonForOK)
                              ? Consumer<AppState>(
                                  builder: (cxt, appState, child) {
                                  var enableOKButton =
                                      appState.enableAlertDialogOKButton;

                                  if (alwaysEnableOKButton)
                                    enableOKButton = true;

                                  return FlatButton(
                                    // alert dialog ok button // ok button
                                    // dialog ok button

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

                                        if (restoreWebViewToShowIfNeeded) {
                                          GlobalState.noteDetailWidgetState
                                              .currentState
                                              .restoreWebViewToShowIfNeeded();
                                        }
                                      }
                                    },
                                  );
                                })
                              : Container(),
                        ],
                      ),
                    ),
                ],
              );

              if (expandRemarkToMaxFinite) {
                return Container(
                  height: GlobalState.screenHeight / 3,
                  child: theColumn,
                );
              } else {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: theColumn,
                  ),
                );
              }
            }),
          ),
        );
      },
    );

    GlobalState.isAlertDialogBeingShown = false;

    return shouldContinueAction;
  }
}

bool _hasOnlyOneBottomButton(
    {@required bool showButtonForOK, @required bool showButtonForCancel}) {
  // Bottom button means OK button and Cancel button at the bottom of the alert dialog

  var hasOnlyOneBottomButton = true;

  if (showButtonForOK == showButtonForCancel) {
    hasOnlyOneBottomButton = false;
  }

  return hasOnlyOneBottomButton;
}
