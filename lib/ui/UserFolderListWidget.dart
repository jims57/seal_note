import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'folderPageWidgets/FolderListItemRightPartWidget.dart';

class UserFolderListWidget extends StatefulWidget {
  UserFolderListWidget({Key key, @required this.folderTotal}) : super(key: key);

  final int folderTotal;

  @override
  State<StatefulWidget> createState() => _UserFolderListWidgetState();
}

class _UserFolderListWidgetState extends State<UserFolderListWidget> {
  int defaultFolderTotal = 1;
  double folderListItemHeight = 60.0;
  double folderListPanelMarginForTopOrBottom = 5.0;
  List<Widget> childrenWidgetList;

  @override
  void initState() {
    // int folderTotal = 5;

    childrenWidgetList = List.generate(widget.folderTotal, (index) {
      // Check if it is the first or last item
      bool isFirstItem = false;
      bool isLastItem = false;
      // bool canSwipeAction = false;

      if (index == 0) isFirstItem = true;
      if (index == widget.folderTotal - 1) isLastItem = true;

      return getFolderListItem(
          index: index,
          folderName: '英语知识$index',
          numberToShow: index,
          showDivider: true,
          showZero: true);
    });

    childrenWidgetList.insert(
        0,
        getFolderListItem(
            folderName: '今日',
            numberToShow: 546,
            showBadgeBackgroundColor: true,
            canSwipe: true,
            isRoundTopCorner: true,));

    childrenWidgetList.insert(
        1,
        getFolderListItem(
            folderName: '全部笔记', numberToShow: 2203, canSwipe: false));

    childrenWidgetList.add(getFolderListItem(
      folderName: '删除笔记',
      numberToShow: 43,
      canSwipe: false,
      showDivider: false,
      isRoundBottomCorner: true,
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: folderListPanelMarginForTopOrBottom,
          bottom: folderListPanelMarginForTopOrBottom,
          left: 15.0,
          right: 15.0),
      // color: Colors.red,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: GlobalState.screenHeight -
              GlobalState.appBarHeight -
              GlobalState.folderPageBottomContainerHeight -
              folderListPanelMarginForTopOrBottom * 2,
          // color: Colors.green,
          child: ReorderableListView(
            children: childrenWidgetList,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                // These two lines are workarounds for ReorderableListView problems
                if (newIndex > childrenWidgetList.length)
                  newIndex = childrenWidgetList.length;
                if (oldIndex < newIndex) newIndex--;

                var oldWidget = childrenWidgetList.removeAt(oldIndex);

                childrenWidgetList.insert(newIndex, oldWidget);
              });
            },
          ),
        ),
      ),
    );
  }

  // Private method
  Widget getFolderListItem(
      {int index = 0,
      @required String folderName,
      @required int numberToShow,
      bool canSwipe = true,
      bool isFirstItem = false,
      bool showDivider = true,
      bool showBadgeBackgroundColor = false,
      bool showZero = true,
      bool isRoundTopCorner = false,
      bool isRoundBottomCorner = false}) {
    return GestureDetector(
      key: (index == 0) ? Key('$folderName') : Key('getFolderListItem$index'),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft:
              (isRoundTopCorner) ? Radius.circular(10) : Radius.circular(0),
          topRight:
              (isRoundTopCorner) ? Radius.circular(10) : Radius.circular(0),
          bottomLeft:
              (isRoundBottomCorner) ? Radius.circular(10) : Radius.circular(0),
          bottomRight:
              (isRoundBottomCorner) ? Radius.circular(10) : Radius.circular(0),
        ),
        child: Container(
          // folder list item // folder item
          height: folderListItemHeight,
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Column(
              children: [
                Container(
                  // folder list item content
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    color: GlobalState.themeWhiteColorAtiOSTodo,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: folderListItemHeight - 1,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Icon(
                                    // folder list item icon // folder item icon // folder icon
                                    Icons.folder_open_outlined,
                                    size: 25.0,
                                    color: GlobalState.themeLightBlueColor07,
                                  ),
                                  Container(
                                      // folder name // folder list item name
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        // (index == 0) ? '今日' : '英语知识$index',
                                        '$folderName',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black87,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: FolderListItemRightPartWidget(
                                numberToShow: numberToShow,
                                showBadgeBackgroundColor:
                                    showBadgeBackgroundColor,
                                showZero: showZero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                          color: (showDivider)
                              ? GlobalState.themeGreyColorAtiOSTodoForBackground
                              : GlobalState.themeWhiteColorAtiOSTodo,
                          height: 1,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            secondaryActions: (!canSwipe)
                ? []
                : <Widget>[
                    IconSlideAction(
                      caption: '复习计划',
                      color: GlobalState.themeGreenColorAtiOSTodo,
                      foregroundColor: Colors.white,
                      icon: Icons.calendar_today_outlined,
                      //          onTap: () => _showSnackBar('More'),
                    ),
                    IconSlideAction(
                      caption: '更多',
                      color: GlobalState.themeGreyColorAtiOSTodo,
                      foregroundColor: Colors.white,
                      icon: Icons.more_horiz,
                      //          onTap: () => _showSnackBar('More'),
                    ),
                  ],
          ),
        ),
      ),
      onTap: () {
        // click on folder item // click folder item
        GlobalState.isHandlingFolderPage = true;
        GlobalState.isInFolderPage = false;

        GlobalState.masterDetailPageState.currentState
            .updatePageShowAndHide(shouldTriggerSetState: true);
      },
    );
  }
}
