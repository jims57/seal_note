import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class ShowDialogHandler {
  static double _contentListItemHeight;

  static Future<void> showMyDialog(
      {@required BuildContext parentContext,
      @required Widget content,
      int contentListItemCount = 1,
      double contentListItemHeight = 50.0}) async {
    _contentListItemHeight = contentListItemHeight;

    await showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          GlobalState.currentShowDialogContext = context;

          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            title: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(top: 10.0, bottom: 0.0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text('选择文件夹'),
                  Divider(),
                  // AlertDialogWidget(
                  //   // This alert dialog widget is used to append its widget to the UI tree, so that GlobalKey works
                  //   key: GlobalState
                  //       .alertDialogWidgetState,
                  //   captionText: captionText,
                  //   buttonTextForOK:
                  //   buttonTextForOK,
                  //   buttonColorForOK:
                  //   buttonColorForOK,
                  // )
                ],
              ),
            ),
            contentPadding: EdgeInsets.only(top: 0.0, bottom: 15.0),
            content: Container(
              // color: Colors.green,
              width: 350.0,
              height: _getFolderSelectionListMaxHeight(
                  contentListItemCount: contentListItemCount),
              child: content,
            ),
          );
        });
  }

  static double _getFolderSelectionListMaxHeight(
      {@required int contentListItemCount}) {
    double maxHeight = 0.0;

    if (contentListItemCount > 10) {
      maxHeight = _contentListItemHeight * 10;
    } else {
      maxHeight = _contentListItemHeight * contentListItemCount;
    }

    return maxHeight;
  }
}
