import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/RoundCornerButtonWidget.dart';
import 'package:seal_note/ui/common/TextFieldWithClearButtonWidget.dart';
import 'package:seal_note/ui/common/dividers/ItemDividerWidget.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanWidget.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';
import 'package:seal_note/ui/FolderListItemWidget.dart';

import 'FolderListItemRightPartWidget.dart';

class UserFolderListListenerWidget extends StatefulWidget {
  UserFolderListListenerWidget({
    Key key,
    this.icon = Icons.folder_open_outlined,
    this.iconColor = GlobalState.themeLightBlueColor07,
    @required this.folderId,
    @required this.folderName,
    @required this.numberToShow,
    this.isReviewFolder = false,
    this.isDefaultFolder = false,
    this.badgeBackgroundColor = GlobalState.themeBlueColor,
    this.showBadgeBackgroundColor = false,
    this.showZero = false,
    this.showDivider = true,
    this.canSwipe = true,
    this.folderListItemHeight = 60.0,
    this.folderListPanelMarginForTopOrBottom = 5.0,
    this.isRoundTopCorner = false,
    this.isRoundBottomCorner = false,
    this.isItemSelected = false,
  }) : super(key: key);

  final IconData icon;
  final Color iconColor;
  final int folderId;
  final String folderName;
  final int numberToShow;
  final bool isReviewFolder;
  final bool isDefaultFolder;
  final Color badgeBackgroundColor;
  final bool showBadgeBackgroundColor;
  final bool showZero;
  final bool showDivider;
  final bool canSwipe;

  final double folderListItemHeight;
  final double folderListPanelMarginForTopOrBottom;
  final bool isRoundTopCorner;
  final bool isRoundBottomCorner;
  final bool isItemSelected;

  @override
  _UserFolderListListenerWidgetState createState() =>
      _UserFolderListListenerWidgetState();
}

class _UserFolderListListenerWidgetState
    extends State<UserFolderListListenerWidget> {
  BuildContext userFolderListListenerWidgetContext;
  Timer _timer;
  int _totalCountdownMilliseconds;

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
          child: Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Column(
              children: [
                Container(
                  // folder list item content
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                    color: (widget.isItemSelected)
                        ? GlobalState.themeBlueColorForSelectedItemBackground
                        : GlobalState.themeWhiteColorAtiOSTodo,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: widget.folderListItemHeight - 1,
                        child: Row(
                          children: [
                            Expanded(
                              // folder list left part // folder item left part
                              flex: 3,
                              child: Consumer<AppState>(
                                  builder: (cxt, appState, child) {
                                // Only the pointer is down, it will trigger update available dy
                                if (GlobalState.isPointerDown) {
                                  _updateUserFolderListItemAvailableDy();
                                }

                                var isDefaultFolder = widget.isDefaultFolder;
                                return Row(
                                  children: [
                                    Icon(
                                      // folder list item icon // folder item icon // folder icon
                                      widget.icon,
                                      size: 25.0,
                                      color: (GlobalState
                                                  .shouldMakeDefaultFoldersGrey &&
                                              isDefaultFolder)
                                          ? GlobalState.themeGreyColorAtiOSTodo
                                          : widget.iconColor,
                                    ),
                                    Expanded(
                                      child: Container(
                                          // folder name // folder list item name
                                          padding: EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            // folder list name // folder list item name
                                            '${widget.folderName}',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w400,
                                              color: (GlobalState.shouldMakeDefaultFoldersGrey &&
                                                      isDefaultFolder)
                                                  ? GlobalState
                                                      .themeGreyColorAtiOSTodo
                                                  : GlobalState
                                                      .themeBlackColor87ForFontForeColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    ),
                                  ],
                                );
                              }),
                            ),
                            Expanded(
                              // folder list item right part // folder list right part
                              // folder item right part
                              flex: 1,
                              child: FolderListItemRightPartWidget(
                                numberToShow: widget.numberToShow,
                                badgeBackgroundColor:
                                    widget.badgeBackgroundColor,
                                showBadgeBackgroundColor:
                                    widget.showBadgeBackgroundColor,
                                showZero: widget.showZero,
                                isDefaultFolderRightPart:
                                    widget.isDefaultFolder,
                                isItemSelected: widget.isItemSelected,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ItemDividerWidget(),
              ],
            ),
            secondaryActions: (!widget.canSwipe)
                ? []
                : <Widget>[
                    // swipe folder list item // folder page swipe action
                    IconSlideAction(
                      // swipe to review plan // swipe review plan

                      caption: '复习计划',
                      color: GlobalState.themeGreenColorAtiOSTodo,
                      foregroundColor: Colors.white,
                      icon: Icons.calendar_today_outlined,
                      onTap: () async {
                        // swipe to review plan event // click on review plan button
                        var s = 's';
                        GlobalState.reusablePageChangeNotifier
                            .upcomingReusablePageIndex = 0;

                        GlobalState.masterDetailPageState.currentState
                            .triggerToShowReusablePage(
                          title: '复习计划',
                          child: ReviewPlanWidget(),
                        );
                      },
                    ),
                    IconSlideAction(
                      // swipe to get more // swipe to more
                      // swipe more button // swipe more

                      caption: '更多',
                      color: GlobalState.themeGreyColorAtiOSTodo,
                      foregroundColor: Colors.white,
                      icon: Icons.more_horiz,
                      onTap: () async {
                        // click on more button // click on swipe more button
                        // swipe to more event

                        // Hide the webView first
                        GlobalState.noteDetailWidgetState.currentState
                            .hideWebView(
                                forceToSyncWithShouldHideWebViewVar: true);

                        var folderId = widget.folderId;
                        var oldFolderName = widget.folderName;
                        var newFolderName = oldFolderName;

                        // GlobalState.isAlertDialogBeingShown = true;

                        await AlertDialogHandler().showAlertDialog(
                          parentContext: context,
                          captionText: '文件夹选项',
                          showDivider: true,
                          showTopLeftButton: true,
                          topLeftButtonText: '取消',
                          showTopRightButton: true,
                          topRightButtonText: '保存',
                          topRightButtonCallback: () async {
                            // change folder name event // click on change folder name
                            // click to change folder name // click change folder name

                            // Execute the change name operation by checking folder name
                            GlobalState.folderListPageState.currentState
                                .executeCallbackWithoutDuplicateFolderName(
                              parentContext: context,
                              newFolderName: newFolderName,
                              callback: () async {
                                // When the new folder name doesn't exist, in this case, we allow it to change the folder name

                                var effectedRowCount =
                                    await GlobalState.database.changeFolderName(
                                        folderId: folderId,
                                        newFolderName: newFolderName);

                                if (effectedRowCount > 0) {
                                  // When update the folder name successfully

                                  GlobalState.folderListWidgetState.currentState
                                      .triggerSetState(
                                          forceToFetchFoldersFromDb: true);
                                }
                              },
                            );

                            // GlobalState.isAlertDialogBeingShown = false;

                            // Set the top right button, that is Save, back to the disabled status anyway
                            GlobalState.appState
                                .enableAlertDialogTopRightButton = false;
                          },
                          child: Column(
                            children: [
                              TextFieldWithClearButtonWidget(
                                currentText: oldFolderName,
                                showClearButton: true,
                                onTextChanged: (input) {
                                  input = input.trim();

                                  if (input.length > 0 &&
                                      oldFolderName != input) {
                                    // Only the user has changed the name, button is available to click

                                    newFolderName =
                                        input; // Record the current input

                                    GlobalState.appState
                                        .enableAlertDialogTopRightButton = true;
                                  } else {
                                    GlobalState.appState
                                            .enableAlertDialogTopRightButton =
                                        false;
                                  }
                                },
                              ),
                              if (folderId != 3)
                                RoundCornerButtonWidget(
                                    // delete folder button

                                    buttonText: '删除文件夹',
                                    buttonThemeColor: Colors.red,
                                    topMargin: 25.0,
                                    buttonCallback: () async {
                                      // delete folder event

                                      var continueAction = true;
                                      var hasAvailableNotesInsideFolder =
                                          await GlobalState.database
                                              .hasNotesInFolder(
                                                  folderId: folderId,
                                                  includeDeletedNotes: false);

                                      if (hasAvailableNotesInsideFolder) {
                                        continueAction = await AlertDialogHandler()
                                            .showAlertDialog(
                                                parentContext: context,
                                                captionText: '删除文件夹？',
                                                remark:
                                                    '此文件夹已有笔记。删除后，相关的所有笔记也会被删除！',
                                                buttonTextForOK: '确定',
                                                buttonColorForOK: Colors.red);
                                      }

                                      if (continueAction) {
                                        // Decide to delete the folder anyway

                                        // Check if the folder has deleted notes
                                        var hasDeletedNotesInsideFolder =
                                            await GlobalState.database
                                                .hasNotesInFolder(
                                                    folderId: folderId,
                                                    includeDeletedNotes: true);

                                        if (hasDeletedNotesInsideFolder) {
                                          // When there is any note inside the folder, just mark the folder as deleted status

                                          await GlobalState.database
                                              .setFolderAndItsNotesToDeletedStatus(
                                                  folderId: folderId);
                                        } else {
                                          // When there is no notes inside the folder, delete the folder directly
                                          await GlobalState.database
                                              .deleteFolder(folderId: folderId);
                                        }

                                        GlobalState
                                            .folderListWidgetState.currentState
                                            .triggerSetState(
                                                forceToFetchFoldersFromDb:
                                                    true);

                                        if (Navigator.canPop(context)) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    })
                            ],
                          ),
                          showButtonForCancel: false,
                          showButtonForOK: false,
                        );

                        GlobalState.noteDetailWidgetState.currentState
                            .showWebView();
                      },
                    ),
                  ],
          ),
        ),
      ),
      onPointerDown: (opd) {
        print('onPointerDown()');
        _startCountdown(resetTotalCount: true);
        GlobalState.isPointerDown = true;

        // When the pointer is down, we should clear the available dy in GlobalState to get the right dy
        // Avoiding the old values effect the right outcomes
        _resetUserFolderListItemAvailableDy();
      },
      onPointerUp: (opp) {
        GlobalState.isPointerDown = false;
        GlobalState.isPointerMoving = false;
        GlobalState.isAfterLongPress = false;
        GlobalState.appState.shouldMakeDefaultFoldersGrey = false;

        _stopCountdown();
      },
      onPointerMove: (opm) {
        GlobalState.isPointerMoving = true;

        print('onPointerMove()');

        if (_totalCountdownMilliseconds <= 0) {
          _stopCountdown();

          GlobalState.isAfterLongPress = true;
          GlobalState.appState.shouldMakeDefaultFoldersGrey = true;
          _showOverlay();

          print('_totalCount<=0');
        }
      },
    );
  }

  // Private methods
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
      // When beyond the available dy
      if (GlobalState.isAfterLongPress) showBlockIcon = true;
      GlobalState.shouldReorderFolderListItem = false;
    } else {
      // When inside the available dy
      if (GlobalState.isAfterLongPress) showBlockIcon = false;
      GlobalState.shouldReorderFolderListItem = true;
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

  void _updateUserFolderListItemAvailableDy() {
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
        } else if (widget.folderName ==
            GlobalState.defaultFolderNameForAllNotes) {
          // When it is All Notes folder

          // Other default folders except the deletion folder
          var bottomBorderDy = topBorderDy + (folderListItemHeight / 4) * 3;
          GlobalState.userFolderListItemMinAvailableDy = bottomBorderDy;
        }
      }
    });
  }

  void _resetUserFolderListItemAvailableDy() {
    GlobalState.userFolderListItemMaxAvailableDy = double.infinity;
    GlobalState.userFolderListItemMinAvailableDy = double.negativeInfinity;
    // print('resetUserFolderListItemAvailableDy()');
  }

  void _startCountdown({bool resetTotalCount = true}) {
    if (resetTotalCount) {
      _totalCountdownMilliseconds = 500;
    }

    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      _totalCountdownMilliseconds -= 50;
      print('$_totalCountdownMilliseconds');
    });
  }

  void _stopCountdown() {
    _timer.cancel();
  }

// bool _hasNotesInsideFolder() {
//   var hasNotes = true;
//
//   if (widget.numberToShow == 0) {
//     hasNotes = false;
//   }
//
//   return hasNotes;
// }
}
