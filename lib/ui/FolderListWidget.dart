import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'folderPageWidgets/FolderListItemRightPartWidget.dart';

class FolderListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  double folderListItemHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    int folderTotal = 5;

    List<GestureDetector> childrenWidgetList =
        List.generate(folderTotal, (index) {
      // Check if it is the first or last item
      bool isFirstItem = false;
      bool isLastItem = false;
      // bool canSwipeAction = false;

      if (index == 0) isFirstItem = true;
      if (index == folderTotal - 1) isLastItem = true;

      return GestureDetector(
        key: Key('FolderListWidget$index'),
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
                  // color: Colors.transparent,
                  // color: Colors.green,
                  decoration: BoxDecoration(
                    color: GlobalState.themeWhiteColorAtiOSTodo,
                    // color: Colors.red,
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(
                    //       (isFirstItem) ? GlobalState.borderRadius15 : 0),
                    //   topRight: Radius.circular(
                    //       (isFirstItem) ? GlobalState.borderRadius15 : 0),
                    //   bottomLeft: Radius.circular(
                    //       (isLastItem) ? GlobalState.borderRadius15 : 0),
                    //   bottomRight: Radius.circular(
                    //       (isLastItem) ? GlobalState.borderRadius15 : 0),
                    // ),
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
                                        (index == 0) ? '今日' : '英语知识$index',
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
                                numberToShow: (index == 0) ? 653 : index,
                                showBadgeBackgroundColor:
                                    (index == 0) ? true : false,
                                showZero: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(height: 1.0,color: Colors.red,)
                    ],
                  ),
                ),
                Container(
                  // folder list item line // folder list item bottom line
                  // color: Colors.red,
                  height: 1,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        // folder list item left bottom line // left bottom line
                        // color: Colors.green,
                        color: GlobalState.themeWhiteColorAtiOSTodo,
                        height: 1,
                        width: 40,
                      ),
                      Expanded(
                        // folder list item right bottom line // right bottom line
                        child: Container(
                          color: (!isLastItem)
                              ? GlobalState.themeGreyColorAtiOSTodoForBackground
                              : GlobalState
                                  .themeWhiteColorAtiOSTodo,
                          height: 1,
                          // width: 100,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            secondaryActions: <Widget>[
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
        onTap: () {
          // click on folder item // click folder item
          GlobalState.isHandlingFolderPage = true;
          GlobalState.isInFolderPage = false;

          GlobalState.masterDetailPageState.currentState
              .updatePageShowAndHide(shouldTriggerSetState: true);
        },
      );
    });

    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
                // color: Colors.red,
                height: GlobalState.screenHeight -
                    GlobalState.folderPageBottomContainerHeight -
                    GlobalState.appBarHeight,
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
            ],
          ),
        ),
      ],
    );

    // return Container(
    //   padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0, right: 15.0),
    //   // color: Colors.red,
    //   child: ReorderableListView(
    //     children: childrenWidgetList,
    //     onReorder: (oldIndex, newIndex) {
    //       setState(() {
    //         // These two lines are workarounds for ReorderableListView problems
    //         if (newIndex > childrenWidgetList.length)
    //           newIndex = childrenWidgetList.length;
    //         if (oldIndex < newIndex) newIndex--;
    //
    //         var oldWidget = childrenWidgetList.removeAt(oldIndex);
    //
    //         childrenWidgetList.insert(newIndex, oldWidget);
    //       });
    //     },
    //   ),
    // );
  }
}
