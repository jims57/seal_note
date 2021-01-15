import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/dividers/ItemDividerWidget.dart';

enum RoundBorderPart {
  TopLeftAndTopRight,
  BottomLeftAndBottomRight,
}

class RoundCornerPanelWidget extends StatefulWidget {
  RoundCornerPanelWidget({
    Key key,
    this.caption,
    @required this.child,
    @required this.height,
    this.isTopLeftAndTopRightCornerRound = true,
    this.isBottomLeftAndBottomRightCornerRound = true,
    this.backgroundColor = Colors.white,
    // this.bottomMargin = 0.0,
    this.addBottomMargin = false,
    this.showDivider = false,
    this.scrollable = false,
    this.topCenterChild = false,
    this.onTap,
  }) : super(key: key);

  final String caption;
  final Widget child;
  final double height;
  final bool isTopLeftAndTopRightCornerRound;
  final bool isBottomLeftAndBottomRightCornerRound;
  final Color backgroundColor;

  // final double bottomMargin;
  final bool addBottomMargin;
  final bool showDivider;
  final bool scrollable;
  final bool topCenterChild;
  final VoidCallback onTap;

  @override
  _RoundCornerPanelWidgetState createState() => _RoundCornerPanelWidgetState();
}

class _RoundCornerPanelWidgetState extends State<RoundCornerPanelWidget> {
  var panelContentHeight;

  @override
  Widget build(BuildContext context) {
    panelContentHeight = widget.height - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.caption != null)
          Container(
            alignment: Alignment.centerLeft,
            width: double.maxFinite,
            margin: EdgeInsets.only(
              top: 0.0,
              bottom: 5.0,
              left: GlobalState.defaultLeftAndRightPadding,
              right: GlobalState.defaultLeftAndRightPadding,
            ),
            padding: EdgeInsets.only(left: 15.0),
            height: GlobalState.defaultItemCaptionHeight,
            // color: Colors.transparent,
            // color: Colors.red,
            child: Text(
              widget.caption,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        GestureDetector(
          child: Container(
            // color:Colors.red,
            margin: EdgeInsets.only(
                left: GlobalState.defaultLeftAndRightPadding,
                right: GlobalState.defaultLeftAndRightPadding),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: _getBorderRadius(
                  roundBorderPart: RoundBorderPart.TopLeftAndTopRight,
                ),
                topRight: _getBorderRadius(
                  roundBorderPart: RoundBorderPart.TopLeftAndTopRight,
                ),
                bottomLeft: _getBorderRadius(
                  roundBorderPart: RoundBorderPart.BottomLeftAndBottomRight,
                ),
                bottomRight: _getBorderRadius(
                  roundBorderPart: RoundBorderPart.BottomLeftAndBottomRight,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    color: widget.backgroundColor,
                    height: panelContentHeight,
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                        left: GlobalState.defaultLeftAndRightPadding,
                        right: GlobalState.defaultLeftAndRightPadding),
                    child: (widget.scrollable)
                        ? SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Container(
                              alignment: _getChildAlignment(),
                              color: Colors.red,
                              height: panelContentHeight,
                              child: widget.child,
                            ),
                          )
                        : Container(
                            alignment: _getChildAlignment(),
                            child: widget.child,
                          ),
                  ),
                  if (widget.showDivider) ItemDividerWidget(),
                ],
              ),
            ),
          ),
          onTap: () {
            widget.onTap();
          },
        ),
        if (widget.addBottomMargin)
          SizedBox(
            height: GlobalState.defaultRoundCornerPanelBottomMargin,
          )
      ],
    );
  }

  // Private methods
  Radius _getBorderRadius({@required RoundBorderPart roundBorderPart}) {
    var borderRadius = 0.0;

    if (roundBorderPart == RoundBorderPart.TopLeftAndTopRight) {
      if (widget.isTopLeftAndTopRightCornerRound) {
        borderRadius = GlobalState.defaultBorderRadius;
      }
    } else {
      if (widget.isBottomLeftAndBottomRightCornerRound) {
        borderRadius = GlobalState.defaultBorderRadius;
      }
    }

    return Radius.circular(borderRadius);
  }

  Alignment _getChildAlignment() {
    var alignment = Alignment.center;

    if (widget.topCenterChild) {
      alignment = Alignment.topCenter;
    }

    return alignment;
  }
}
