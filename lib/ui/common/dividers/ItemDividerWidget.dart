import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class ItemDividerWidget extends StatefulWidget {
  ItemDividerWidget({
    Key key,
    this.showDivider = true,
  }) : super(key: key);

  final bool showDivider;

  @override
  _ItemDividerWidgetState createState() => _ItemDividerWidgetState();
}

class _ItemDividerWidgetState extends State<ItemDividerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // folder list item line // folder list item bottom line
      height: 1,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            // folder list item left bottom line // left bottom line
            color: GlobalState.themeWhiteColorAtiOSTodo,
            height: 1,
            width: 40,
          ),
          Expanded(
            // folder list item right bottom line // right bottom line
            child: Container(
              color: (widget.showDivider)
                  ? GlobalState.themeGreyColorAtiOSTodoForBackground
                  : GlobalState.themeWhiteColorAtiOSTodo,
              height: 1,
            ),
          )
        ],
      ),
    );
  }
}
