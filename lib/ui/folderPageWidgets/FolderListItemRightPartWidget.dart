import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class FolderListItemRightPartWidget extends StatefulWidget {
  FolderListItemRightPartWidget(
      {Key key,
      @required this.numberToShow,
      this.showBadgeBackgroundColor = false,
      this.showZero = false,
      this.isDefaultFolderRightPart = false})
      : super(key: key);

  final int numberToShow;
  final bool showBadgeBackgroundColor;
  final bool showZero;
  final bool isDefaultFolderRightPart;

  @override
  _FolderListItemRightPartWidgetState createState() =>
      _FolderListItemRightPartWidgetState();
}

class _FolderListItemRightPartWidgetState
    extends State<FolderListItemRightPartWidget> {
  BuildContext folderListItemRightPartWidgetContext;

  @override
  void initState() {
    folderListItemRightPartWidgetContext = context;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: (!widget.showZero && widget.numberToShow == 0)
                  ? Container()
                  : Consumer<AppState>(builder: (cxt, appState, child) {
                      return Container(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 1.0, bottom: 1.0),
                          decoration: BoxDecoration(
                              color: (widget.showBadgeBackgroundColor)
                                  ? ((GlobalState
                                              .shouldMakeDefaultFoldersGrey &&
                                          widget.isDefaultFolderRightPart)
                                      ? GlobalState.themeGreyColorAtiOSTodo
                                      : GlobalState.themeBlueColor)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(GlobalState.borderRadius40))),
                          child: Text(
                            '${widget.numberToShow}',
                            style: TextStyle(
                                color: (widget.showBadgeBackgroundColor)
                                    ? Colors.white
                                    : GlobalState.themeGrey350Color,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right,
            size: 20,
            color: GlobalState.themeGrey350Color,
          ),
        ],
      ),
    );
  }
}
