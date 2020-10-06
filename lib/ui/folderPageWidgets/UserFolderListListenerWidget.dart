import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

import 'FolderListItemRightPartWidget.dart';

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
  BuildContext userFolderListListenerWidgetContext;
  Timer _timer;
  int _totalCount;

  @override
  void initState() {
    userFolderListListenerWidgetContext = context;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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
                              // folder list left part
                              flex: 3,
                              child: Consumer<AppState>(
                                  builder: (cxt, appState, child) {
                                // Only the pointer is down, it will trigger update available dy
                                if (GlobalState.isPointerDown &&
                                    !GlobalState.isPointerMoving) {
                                  updateUserFolderListItemAvailableDy();
                                }

                                var isDefaultFolder = widget.isDefaultFolder;
                                return Row(
                                  children: [
                                    Icon(
                                      // folder list item icon // folder item icon // folder icon
                                      Icons.folder_open_outlined,
                                      size: 25.0,
                                      // color: GlobalState.themeLightBlueColor07,
                                      color: (GlobalState
                                                  .shouldMakeDefaultFoldersGrey &&
                                              isDefaultFolder)
                                          ? GlobalState.themeGreyColorAtiOSTodo
                                          : GlobalState.themeLightBlueColor07,
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
                                            // color: Colors.black87,
                                            color: (GlobalState
                                                        .shouldMakeDefaultFoldersGrey &&
                                                    isDefaultFolder)
                                                ? GlobalState
                                                    .themeGreyColorAtiOSTodo
                                                : GlobalState
                                                    .themeBlackColor87ForFontForeColor,
                                          ),
                                        )),
                                  ],
                                );
                              }),
                            ),
                            Expanded(
                              // folder list item right part // folder list right part
                              flex: 1,
                              child: FolderListItemRightPartWidget(
                                numberToShow: widget.numberToShow,
                                showBadgeBackgroundColor:
                                    widget.showBadgeBackgroundColor,
                                showZero: widget.showZero,
                                isDefaultFolderRightPart:
                                    widget.isDefaultFolder,
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
        print('onPointerDown()');
        startCountdown(resetTotalCount: true);
        GlobalState.isPointerDown = true;

        // When the pointer is down, we should clear the available dy in GlobalState to get the right dy
        // Avoiding the old values effect the right outcomes
        resetUserFolderListItemAvailableDy();
      },
      onPointerUp: (opp) {
        GlobalState.isPointerDown = false;
        GlobalState.isPointerMoving = false;
        // GlobalState.isFolderListScrolling = true;
        GlobalState.appState.shouldMakeDefaultFoldersGrey = false;

        stopCountdown();

        // print('onPointerUp()');

        _showOverlay();
      },
      onPointerMove: (opm) {
        GlobalState.isPointerMoving = true;

        print('onPointerMove()');

        if (_totalCount < 0) {
          stopCountdown();
          GlobalState.appState.shouldMakeDefaultFoldersGrey = true;
          print('_totalCount<0');
        }

        // Only when the folder list isn't under the scrolling event, it will make default folders become grey
        // if (!GlobalState.isFolderListScrolling) {
        //   GlobalState.appState.shouldMakeDefaultFoldersGrey = true;
        // }

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

    // print('folderListItemDy=${offset.dy}');

    // var minAvailableDy = GlobalState.appBarHeight +
    //     widget.folderListPanelMarginForTopOrBottom +
    //     widget.folderListItemHeight * 2;
    // var maxAvailableDy = GlobalState.appBarHeight +
    //     widget.folderListPanelMarginForTopOrBottom +
    //     (GlobalState.allFolderTotal - 1) * widget.folderListItemHeight;
    var shouldShowBlockIcon = _shouldShowBlockIcon(
        folderListItemDy: folderListItemDy,
        minAvailableDy: GlobalState.userFolderListItemMinAvailableDy,
        maxAvailableDy: GlobalState.userFolderListItemMaxAvailableDy);

    return OverlayEntry(
        builder: (context) => Positioned(
              top: folderListItemDy -
                  GlobalState.appBarHeight -
                  widget.folderListPanelMarginForTopOrBottom -
                  12.0,
              right: widget.folderListPanelMarginForTopOrBottom,
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    color: _showBlockIconColor(
                        shouldShowBlockIcon: shouldShowBlockIcon,
                        isForBlockIcon: false),
                    shape: BoxShape.circle),
                child: Icon(
                  Icons.block_flipped,
                  color: _showBlockIconColor(
                      shouldShowBlockIcon: shouldShowBlockIcon,
                      isForBlockIcon: true),
                  size: 20.0,
                ),
              ),
            ));
  }

  bool _shouldShowBlockIcon(
      {@required folderListItemDy,
      @required minAvailableDy,
      @required maxAvailableDy}) {
    bool showBlockIcon = false;
    GlobalState.shouldReorderFolderListItem = true;

    if (folderListItemDy < minAvailableDy ||
        folderListItemDy > maxAvailableDy) {
      showBlockIcon = true;
      GlobalState.shouldReorderFolderListItem = false;
    }

    return showBlockIcon;
  }

  Color _showBlockIconColor(
      {@required bool shouldShowBlockIcon, isForBlockIcon = true}) {
    // isForBlockIcon = true, means it is for the block icon color, otherwise, for the background color the container of the block icon

    Color foreColor = GlobalState.themeWhiteColorAtiOSTodo;

    // Check it it is for the background color of the container
    if (!isForBlockIcon) {
      // For the background color of the container
      foreColor = GlobalState.themeGreyColorAtiOSTodoForBlockIconBackground;
    }

    Color color = Colors.transparent;

    if (GlobalState.isPointerMoving) {
      // When the pointer is down
      if (widget.isDefaultFolder) {
        // It is a default folder
        color = foreColor;
      } else {
        // It is a user folder
        if (shouldShowBlockIcon) {
          color = foreColor;
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

  // Private methods
  void updateUserFolderListItemAvailableDy() {
    Timer(const Duration(milliseconds: 500), () {
      var isDefaultFolder = widget.isDefaultFolder;

      // Only default folders will decide the available topBorderDy
      if (isDefaultFolder) {
        RenderBox renderBox =
            userFolderListListenerWidgetContext.findRenderObject();
        var size = renderBox.size;
        var folderListItemHeight = size.height;
        var offset = renderBox.localToGlobal(Offset.zero);
        var topBorderDy = offset.dy;

        if (widget.folderName == GlobalState.defaultFolderNameForDeletion) {
          // If it is the deletion folder
          GlobalState.userFolderListItemMaxAvailableDy = topBorderDy;
        } else {
          // Other default folders except the deletion folder
          var bottomBorderDy = topBorderDy + (folderListItemHeight / 4) * 3;

          if (bottomBorderDy > GlobalState.userFolderListItemMinAvailableDy) {
            GlobalState.userFolderListItemMinAvailableDy = bottomBorderDy;
          }
        }
      }
    });
  }

  void resetUserFolderListItemAvailableDy() {
    GlobalState.userFolderListItemMaxAvailableDy = double.infinity;
    GlobalState.userFolderListItemMinAvailableDy = double.negativeInfinity;
    // print('resetUserFolderListItemAvailableDy()');
  }

  void startCountdown({bool resetTotalCount = true}) {
    if (resetTotalCount) {
      _totalCount = 500;
    }

    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      _totalCount -= 50;
      print('$_totalCount');
    });
  }

  void stopCountdown() {
    _timer.cancel();
  }
}
