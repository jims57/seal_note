import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class AlertDialogWidget extends StatefulWidget {
  AlertDialogWidget(
      {Key key,
      @required this.captionText,
      this.remark = '',
      this.buttonTextForOK = '确定',
      this.buttonColorForOK = GlobalState.themeBlueColor,
      this.buttonTextForCancel = '取消',
      this.buttonColorForCancel = GlobalState.themeBlueColor})
      : super(key: key);

  final String captionText;
  final String remark;
  final String buttonTextForOK;
  final Color buttonColorForOK;

  final String buttonTextForCancel;
  final Color buttonColorForCancel;

  @override
  AlertDialogWidgetState createState() => AlertDialogWidgetState();
}

class AlertDialogWidgetState extends State<AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(); // Return a empty Container so that there is a widget related to the UI tree
  }

  // Public methods
  Future<bool> showAlertDialog({String remark}) async {
    var shouldContinueAction = false;
    var theRemark = widget.remark;

    // If the remark parameter isn't null, we use it as the remark for the dialog
    if (remark != null) theRemark = remark;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(widget.captionText)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(theRemark),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(widget.buttonTextForCancel),
              onPressed: () {
                Navigator.of(context).pop();
                shouldContinueAction = false;
              },
            ),
            FlatButton(
              child: Text(
                widget.buttonTextForOK,
                style: TextStyle(color: widget.buttonColorForOK),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                shouldContinueAction = true;
              },
            ),
          ],
        );
      },
    );

    return shouldContinueAction;
  }
}
