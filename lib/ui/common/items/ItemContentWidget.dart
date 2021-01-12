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
    this.itemTitle,
    this.itemContent,
    this.itemContentForeColor = GlobalState.themeBlackColor87ForFontForeColor,
    this.showSwitch = false,
    this.showRightGreyArrow = false,
    this.onSwitchChanged,
  }) : super(key: key);

  final IconData icon;
  final String itemTitle;
  final String itemContent;
  final Color itemContentForeColor;
  final bool showSwitch;
  final bool showRightGreyArrow;
  final Function(bool) onSwitchChanged;

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
                    // color: Colors.red,
                    margin: EdgeInsets.only(
                      right: GlobalState.defaultHorizontalMarginBetweenItems,
                    ),
                    child: IconWidget(
                      icon: widget.icon,
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
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        right: GlobalState.defaultHorizontalMarginBetweenItems),
                    // color: Colors.blue,
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
            CupertinoSwitchWidget(
              onSwitchChanged: widget.onSwitchChanged,
            ),
          if (widget.showRightGreyArrow) RightGreyArrowWidget(),
        ],
      ),
    );
  }
}
