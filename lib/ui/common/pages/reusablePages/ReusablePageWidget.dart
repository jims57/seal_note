import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class ReusablePageWidget extends StatefulWidget {
  ReusablePageWidget({
    Key key,
    @required this.index,
    this.title,
    @required this.child,
    this.isSubPage = false,
    this.onBackButtonCallback,
  }) : super(key: key);

  final int index;
  final String title;
  final Widget child;
  final bool isSubPage;
  final Function(ReusablePageWidget) onBackButtonCallback;

  @override
  _ReusablePageWidgetState createState() => _ReusablePageWidgetState();
}

class _ReusablePageWidgetState extends State<ReusablePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Stack(alignment: Alignment.center, children: [
            Container(
              alignment: Alignment.centerLeft,
              height: GlobalState.defaultAppBarHeight,
              width: GlobalState.currentReusablePageWidth,
              color: GlobalState.themeGreyColorAtiOSTodoForBackground,
              child: GestureDetector(
                child: SafeArea(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15.0),
                    width: GlobalState.currentReusablePageWidth / 4,
                    color: Colors.transparent,
                    // color: Colors.red,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: GlobalState.themeBlueColor,
                    ),
                  ),
                ),
                onTap: () {
                  // reusable page back button // reusable page back event

                  if (widget.onBackButtonCallback != null) {
                    widget.onBackButtonCallback(widget);
                  }

                  _clickOnBackButton(reusablePageIndex: widget.index);
                },
              ),
            ),
            Container(
              child: Text(
                // reusable page title // reusable page caption

                widget.title,
                style: GlobalState.defaultPageCaptionTextStyle,
              ),
            ),
          ]),
        ),
        Expanded(
          child: widget.child,
        )
      ],
    );
  }

  // Private methods
  void _clickOnBackButton({@required int reusablePageIndex}) {
    // Only the back button on the reusable page will move the upcoming reusable page to right
    GlobalState.isUpcomingReusablePageMovingToLeft = false;

    var upcomingReusablePageIndex = reusablePageIndex - 1;
    GlobalState.reusablePageChangeNotifier.upcomingReusablePageIndex =
        upcomingReusablePageIndex;

    if (upcomingReusablePageIndex == -1) {
      GlobalState.masterDetailPageState.currentState
          .triggerToHideReusablePage();
    }
  }
}
