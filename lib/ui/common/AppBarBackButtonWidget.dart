import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class AppBarBackButtonWidget extends StatefulWidget {
  AppBarBackButtonWidget({Key key, this.title, this.textWidth = 50.0, @required this.onTap})
      : super(key: key);

  final String title;
  final double textWidth;
  final GestureTapCallback onTap;

  @override
  _AppBarBackButtonWidgetState createState() => _AppBarBackButtonWidgetState();
}

class _AppBarBackButtonWidgetState extends State<AppBarBackButtonWidget> {
  @override
  Widget build(BuildContext context) {
    // app bar back button build method
    return GestureDetector(
      child: Container(
        // color: Colors.black,
        color: Colors.transparent,
        height: double.infinity,
        // width: double.infinity,
        padding: EdgeInsets.only(left: 10.0, right: 0.0),
        // width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            (GlobalState.screenType == 3
                ? Container()
                : Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            (GlobalState.screenType == 2 || widget.title == null
                ? Container()
                : SizedBox(
                    width: widget.textWidth,
                    child: Text(
                      '${widget.title}', // folder button // folder back button
                      style: TextStyle(fontSize: 14.0),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )),
          ],
        ),
      ),
      onTap: widget.onTap,
    );
  }
}
