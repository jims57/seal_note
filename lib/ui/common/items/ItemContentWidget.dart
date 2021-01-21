import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/arrows/RightArrowWidget.dart';
import 'package:seal_note/ui/common/icons/IconWidget.dart';
import 'package:seal_note/ui/common/switches/CupertinoSwitchWidget.dart';

class ItemContentWidget extends StatefulWidget {
  // Elements relation: https://user-images.githubusercontent.com/1920873/103877106-928cea80-510f-11eb-98b5-4324d7489a65.png

  ItemContentWidget({
    Key key,
    this.icon,
    this.iconColor = GlobalState.themeLightBlueColorAtiOSTodo,
    this.itemTitle,
    this.itemTitleForeColor = Colors.black,
    this.itemContent,
    this.itemContentForeColor = GlobalState.themeBlackColor87ForFontForeColor,
    this.showSwitch = false,
    this.showInfoIcon = false,
    this.showRightGreyArrow = false,
    this.onSwitchChanged,
    this.onInfoIconClicked,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final String itemTitle;
  final Color itemTitleForeColor;
  final String itemContent;
  final Color itemContentForeColor;
  final bool showSwitch;
  final bool showInfoIcon;

  // final bool showCheck;
  final bool showRightGreyArrow;
  final Function(bool) onSwitchChanged;
  final VoidCallback onInfoIconClicked;

  @override
  _ItemContentWidgetState createState() => _ItemContentWidgetState();
}

class _ItemContentWidgetState extends State<ItemContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (widget.icon != null)
                  Container(
                    margin: EdgeInsets.only(
                      right: GlobalState.defaultHorizontalMarginBetweenItems,
                    ),
                    child: IconWidget(
                      icon: widget.icon,
                      iconColor: widget.iconColor,
                    ),
                  ),
                if (widget.itemTitle != null)
                  Container(
                    // color: Colors.green,
                    margin: EdgeInsets.only(
                      right: GlobalState.defaultHorizontalMarginBetweenItems,
                    ),
                    child: Text(
                      widget.itemTitle,
                      style: TextStyle(
                        fontWeight: GlobalState.defaultBoldFontWeightForItem,
                        fontSize: GlobalState.defaultTitleFontSizeForItem,
                        color: widget.itemTitleForeColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        right: GlobalState.defaultHorizontalMarginBetweenItems),
                    child: Text(
                      (widget.itemContent != null) ? widget.itemContent : '',
                      style: TextStyle(
                        fontSize: GlobalState.defaultNormalFontSizeForItem,
                        color: widget.itemContentForeColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.showSwitch)
            Container(
              color: Colors.greenAccent,
              child: CupertinoSwitchWidget(
                onSwitchChanged: widget.onSwitchChanged,
              ),
            ),
          if (widget.showInfoIcon)
            GestureDetector(
              child: Container(
                // info icon // item content info button
                color: Colors.transparent,
                margin: EdgeInsets.only(
                  right: GlobalState.defaultHorizontalMarginBetweenItems,
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: GlobalState.themeBlueColor,
                ),
              ),
              onTap: () async {
                if (widget.onInfoIconClicked != null) {
                  widget.onInfoIconClicked();
                }
              },
            ),
          if (widget.showRightGreyArrow) RightGreyArrowWidget(),
        ],
      ),
    );
  }
}
