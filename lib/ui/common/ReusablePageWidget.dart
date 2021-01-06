import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class ReusablePageWidget extends StatefulWidget {
  ReusablePageWidget({Key key, this.title = '', @required this.child})
      : super(key: key);

  final String title;
  final Widget child;

  @override
  _ReusablePageWidgetState createState() => _ReusablePageWidgetState();
}

class _ReusablePageWidgetState extends State<ReusablePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalState.themeGreyColorAtiOSTodoForBackground,
      height: double.maxFinite,
      width: _getReusablePageWidth(),
      child: SafeArea(
        child: Column(
          children: [
            Stack(alignment: Alignment.center, children: [
              Container(
                alignment: Alignment.centerLeft,
                height: GlobalState.appBarHeight,
                width: GlobalState.currentReusablePageWidth,
                child: SafeArea(
                  child: GestureDetector(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 15.0),
                        width: GlobalState.currentReusablePageWidth / 4,
                        color: Colors.transparent,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: GlobalState.themeBlueColor,
                        ),
                      ),
                      onTap: () {
                        GlobalState.masterDetailPageState.currentState
                            .triggerToHideReusablePage();
                      }),
                ),
              ),
              Container(
                child: Text(
                  '${widget.title}',
                  style: TextStyle(
                      fontSize: GlobalState.appBarTitleDefaultFontSize),
                ),
              ),
            ]),
            Expanded(
              child: widget.child,
            )
          ],
        ),
      ),
    );
  }

  // Private methods
  double _getReusablePageWidth() {
    var reusablePageWidth;

    if (GlobalState.screenType == 1) {
      reusablePageWidth = GlobalState.screenWidth;
    } else if (GlobalState.screenType == 2) {
      reusablePageWidth = GlobalState.currentFolderPageWidth;
    } else {
      reusablePageWidth = GlobalState.currentFolderPageWidth +
          GlobalState.currentNoteListPageWidth;
    }

    GlobalState.currentReusablePageWidth = reusablePageWidth;

    return reusablePageWidth;
  }
}
