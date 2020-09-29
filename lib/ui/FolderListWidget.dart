import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'folderPageWidgets/FolderListItemRightPartWidget.dart';

class FolderListWidget extends StatefulWidget {
  FolderListWidget({Key key, @required this.userFolderTotal}) : super(key: key);

  final int userFolderTotal;

  @override
  State<StatefulWidget> createState() => FolderListWidgetState();
}

class FolderListWidgetState extends State<FolderListWidget> {
  String todayTitle = '今日';
  bool isPointerDown = false;

  int defaultFolderTotal = 1;

  double folderListPanelMarginForTopOrBottom = 5.0;
  List<Widget> childrenWidgetList;

  // Positions
  double draggedWidgetDx;
  double draggedWidgetDy;
  double pointerDx;
  double pointerDy;

  @override
  void initState() {
    // int folderTotal = 5;
    // markerDy = -(60.0 * 3 + 76);

    GlobalState.userFolderTotal = widget.userFolderTotal;
    GlobalState.allFolderTotal = GlobalState.userFolderTotal;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Always clear the existing record
    GlobalState.defaultFolderIndexList.clear();

    childrenWidgetList = List.generate(widget.userFolderTotal, (index) {
      // Check if it is the first or last item
      bool isFirstItem = false;
      bool isLastItem = false;
      // bool canSwipeAction = false;

      if (index == 0) isFirstItem = true;
      if (index == widget.userFolderTotal - 1) isLastItem = true;

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
          index: 0,
          isDefaultFolder: true,
          folderName: '$todayTitle',
          numberToShow: 546,
          showBadgeBackgroundColor: true,
          canSwipe: false,
          isRoundTopCorner: true,
        ));

    childrenWidgetList.insert(
        1,
        getFolderListItem(
            index: 1,
            isDefaultFolder: true,
            folderName: '全部笔记',
            numberToShow: 2203,
            canSwipe: false));

    childrenWidgetList.add(getFolderListItem(
      index: GlobalState.allFolderTotal,
      isDefaultFolder: true,
      folderName: '删除笔记',
      numberToShow: 43,
      canSwipe: false,
      showDivider: false,
      isRoundBottomCorner: true,
    ));

    super.didChangeDependencies();
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
          // color: (todayTitle == '今日3333') ? Colors.red : Colors.green,
          height: GlobalState.screenHeight -
              GlobalState.appBarHeight -
              GlobalState.folderPageBottomContainerHeight -
              folderListPanelMarginForTopOrBottom * 2,
          // color: Colors.green,
          child: ReorderableListView(
            // header: Container(,child: Text('Folder')),
            children: childrenWidgetList,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                // These two lines are workarounds for ReorderableListView problems
                if (newIndex > childrenWidgetList.length)
                  newIndex = childrenWidgetList.length;
                if (oldIndex < newIndex) newIndex--;

                var isDefaultFolder = checkIfDefaultFolder(index: oldIndex);

                if (newIndex != oldIndex &&
                    !isDefaultFolder &&
                    GlobalState.shouldReorderFolderListItem) {
                  var oldWidget = childrenWidgetList.removeAt(oldIndex);

                  childrenWidgetList.insert(newIndex, oldWidget);
                }
              });
            },
          ),
        ),
      ),
    );
  }

  // Public methods
  void triggerSetState() {
    setState(() {});
  }

  // Private method
  bool checkIfDefaultFolder({@required index}) {
    bool isDefaultFolder = false;

    if (GlobalState.defaultFolderIndexList.contains(index)) {
      isDefaultFolder = true;
    }

    return isDefaultFolder;
  }

  Widget getFolderListItem(
      {int index = 0,
      bool isDefaultFolder = false,
      @required String folderName,
      @required int numberToShow,
      bool canSwipe = true,
      bool isFirstItem = false,
      bool showDivider = true,
      bool showBadgeBackgroundColor = false,
      bool showZero = true,
      bool isRoundTopCorner = false,
      bool isRoundBottomCorner = false}) {
    // Check if this is a default folder, if yes, we need to add the folder total
    if (isDefaultFolder) {
      GlobalState.allFolderTotal += 1;

      // Record the default folder index to list
      GlobalState.defaultFolderIndexList.add(index);
    }

    return GestureDetector(
      key: (isDefaultFolder)
          ? Key('defaultFolderListItem$index')
          : Key('userFolderListItem$index'),
      child: UserFolderListListenerWidget(
        folderName: folderName,
        numberToShow: numberToShow,
        isDefaultFolder: isDefaultFolder,
        showBadgeBackgroundColor: showBadgeBackgroundColor,
        showZero: showZero,
        showDivider: showDivider,
        canSwipe: canSwipe,
        folderListItemHeight: GlobalState.folderListItemHeight,
        folderListPanelMarginForTopOrBottom:
            folderListPanelMarginForTopOrBottom,
        isRoundTopCorner: isRoundTopCorner,
        isRoundBottomCorner: isRoundBottomCorner,
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

class UserFolderListListenerWidget extends StatefulWidget {
  UserFolderListListenerWidget(
      {Key key,
      @required this.folderName,
      @required this.numberToShow,
      this.isDefaultFolder = false,
      this.showBadgeBackgroundColor = false,
      this.showZero = false,
      this.showDivider = true,
      this.canSwipe = true,
      this.folderListItemHeight = 60.0,
      this.folderListPanelMarginForTopOrBottom = 5.0,
      this.isRoundTopCorner = false,
      this.isRoundBottomCorner = false})
      : super(key: key);

  final String folderName;
  final int numberToShow;
  final bool isDefaultFolder;
  final bool showBadgeBackgroundColor;
  final bool showZero;
  final bool showDivider;
  final bool canSwipe;

  final double folderListItemHeight;
  final double folderListPanelMarginForTopOrBottom;
  final bool isRoundTopCorner;
  final bool isRoundBottomCorner;

  @override
  _UserFolderListListenerWidgetState createState() =>
      _UserFolderListListenerWidgetState();
}

class _UserFolderListListenerWidgetState
    extends State<UserFolderListListenerWidget> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: (widget.isRoundTopCorner)
              ? Radius.circular(10)
              : Radius.circular(0),
          topRight: (widget.isRoundTopCorner)
              ? Radius.circular(10)
              : Radius.circular(0),
          bottomLeft: (widget.isRoundBottomCorner)
              ? Radius.circular(10)
              : Radius.circular(0),
          bottomRight: (widget.isRoundBottomCorner)
              ? Radius.circular(10)
              : Radius.circular(0),
        ),
        child: Container(
          // folder list item // folder item
          height: widget.folderListItemHeight,
          // color: Colors.green,
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
                        height: widget.folderListItemHeight - 1,
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
                                        '${widget.folderName}',
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
                                numberToShow: widget.numberToShow,
                                showBadgeBackgroundColor:
                                    widget.showBadgeBackgroundColor,
                                showZero: widget.showZero,
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
                          color: (widget.showDivider)
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
            secondaryActions: (!widget.canSwipe)
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
      onPointerDown: (opd) {
        GlobalState.isPointerDown = true;
      },
      onPointerUp: (opp) {
        GlobalState.isPointerDown = false;
        _showOverlay();
      },
      onPointerMove: (opm) {
        _showOverlay();
      },
    );
  }

  void _showOverlay() {
    if (GlobalState.overlayEntry != null) {
      GlobalState.overlayEntry.remove();
    }

    GlobalState.overlayEntry = this._createOverlayEntry();
    Overlay.of(context).insert(GlobalState.overlayEntry);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    var folderListItemDy = offset.dy;
    var minAvailableDy = GlobalState.appBarHeight +
        widget.folderListPanelMarginForTopOrBottom +
        widget.folderListItemHeight * 2;
    var maxAvailableDy = GlobalState.appBarHeight +
        widget.folderListPanelMarginForTopOrBottom +
        (GlobalState.allFolderTotal - 1) * widget.folderListItemHeight;
    var shouldShowBlockIcon = _shouldShowBlockIcon(
        folderListItemDy: folderListItemDy,
        minAvailableDy: minAvailableDy,
        maxAvailableDy: maxAvailableDy);

    return OverlayEntry(
        builder: (context) => Positioned(
              top: folderListItemDy -
                  GlobalState.appBarHeight -
                  widget.folderListPanelMarginForTopOrBottom -
                  12.0,
              right: widget.folderListPanelMarginForTopOrBottom,
              child: Icon(
                Icons.block,
                color: _showBlockIconColor(
                    shouldShowBlockIcon: shouldShowBlockIcon),
                // color: (!widget.isDefaultFolder &&
                //         !shouldShowBlockIcon &&
                //         GlobalState.isPointerDown)
                //     ? Colors.transparent
                //     : Colors.grey,
                size: 24.0,
              ),
            ));
  }

  bool _shouldShowBlockIcon(
      {@required folderListItemDy,
      @required minAvailableDy,
      @required maxAvailableDy}) {
    bool showBlockIcon = false;
    GlobalState.shouldReorderFolderListItem = true;

    if (folderListItemDy <
            (minAvailableDy - GlobalState.folderListItemHeight / 4) ||
        folderListItemDy > maxAvailableDy) {
      showBlockIcon = true;
      GlobalState.shouldReorderFolderListItem = false;
    }

    // If the pointer isn't down, we don't show the block icon
    // if (!GlobalState.isPointerDown) {
    //   showBlockIcon = false;
    // }

    return showBlockIcon;
  }

  Color _showBlockIconColor({@required bool shouldShowBlockIcon}) {
    Color color = Colors.transparent;
    if (GlobalState.isPointerDown) {
      // When the pointer is down
      if (widget.isDefaultFolder) {
        // It is a default folder
        color = Colors.grey;
      } else {
        // It is a user folder
        if (shouldShowBlockIcon) {
          color = Colors.grey;
        } else {
          color = Colors.transparent;
        }
      }
    } else {
      // When the pointer is up
      color = Colors.transparent;
    }

    return color;
  }
}
