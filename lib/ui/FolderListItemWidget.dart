import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/time/TimeHandler.dart';
import 'folderPageWidgets/UserFolderListListenerWidget.dart';
import 'package:after_layout/after_layout.dart';

class FolderListItemWidget extends StatefulWidget {
  FolderListItemWidget(
      {Key key,
      this.index: 0,
      this.isDefaultFolder: false,
      this.icon: Icons.folder_open_outlined,
      this.iconColor: GlobalState.themeLightBlueColor07,
      @required this.folderId,
      @required this.folderName,
      @required this.numberToShow,
      @required this.reviewPlanId,
      this.isReviewFolder: false,
      this.canSwipe: true,
      this.showDivider: true,
      this.badgeBackgroundColor: GlobalState.themeBlueColor,
      this.showBadgeBackgroundColor: false,
      this.showZero: true,
      this.isRoundTopCorner: false,
      this.isRoundBottomCorner: false,
      this.folderListPanelMarginForTopOrBottom: 5.0,
      this.isItemSelected = false})
      : super(key: key);

  final int index;
  final bool isDefaultFolder;
  final IconData icon;
  final Color iconColor;
  final int folderId;
  final String folderName;
  final int numberToShow;
  final int reviewPlanId;
  final bool isReviewFolder;
  final bool canSwipe;
  final bool showDivider;
  final Color badgeBackgroundColor;
  final bool showBadgeBackgroundColor;
  final bool showZero;
  final bool isRoundTopCorner;
  final bool isRoundBottomCorner;
  final double folderListPanelMarginForTopOrBottom;
  final bool isItemSelected;

  @override
  FolderListItemWidgetState createState() => FolderListItemWidgetState();
}

class FolderListItemWidgetState extends State<FolderListItemWidget>
    with AfterLayoutMixin<FolderListItemWidget> {
  @override
  Widget build(BuildContext context) {
    // Check if this is a default folder, if yes, we need to add the folder total
    if (widget.isDefaultFolder) {
      // GlobalState.allFolderTotal += 1;

      var folderIndex = widget.index;

      // When there is no such index, adds it
      if (!GlobalState.defaultFolderIndexList.contains(folderIndex)) {
        // Record the default folder index to list
        GlobalState.defaultFolderIndexList.add(folderIndex);
      }
    }

    return GestureDetector(
      key: (widget.isDefaultFolder)
          ? Key('defaultFolderListItem${widget.index}')
          : Key('userFolderListItem${widget.index}'),
      child: UserFolderListListenerWidget(
        icon: widget.icon,
        iconColor: widget.iconColor,
        folderId: widget.folderId,
        folderName: widget.folderName,
        numberToShow: widget.numberToShow,
        isReviewFolder: widget.isReviewFolder,
        isDefaultFolder: widget.isDefaultFolder,
        badgeBackgroundColor: widget.badgeBackgroundColor,
        showBadgeBackgroundColor: widget.showBadgeBackgroundColor,
        showZero: widget.showZero,
        showDivider: widget.showDivider,
        canSwipe: widget.canSwipe,
        folderListItemHeight: GlobalState.folderListItemHeight,
        folderListPanelMarginForTopOrBottom:
            widget.folderListPanelMarginForTopOrBottom,
        isRoundTopCorner: widget.isRoundTopCorner,
        isRoundBottomCorner: widget.isRoundBottomCorner,
        isItemSelected: widget.isItemSelected,
      ),
      onTap: () async {
        // click on folder item // click folder item
        // click folder list item event // click folder item event
        // click on folder list item

        // Variables
        var forceToFetchFoldersFromDb = false;

        // Force to set the web view to read only mode
        await GlobalState.noteDetailWidgetState.currentState
            .setWebViewToReadOnlyMode(forceToSaveNoteToDbIfAnyUpdates: true);

        GlobalState.shouldSetBackgroundColorToFirstNoteAutomatically = true;

        // Update the note list
        GlobalState.isDefaultFolderSelected = widget.isDefaultFolder;
        GlobalState.selectedFolderIdCurrently = widget.folderId;
        GlobalState.selectedFolderNameCurrently = widget.folderName;
        GlobalState.appState.noteListPageTitle = widget.folderName;
        GlobalState.selectedFolderReviewPlanId = widget.reviewPlanId;
        GlobalState.isReviewFolderSelected = widget.isReviewFolder;

        // Check if it is Deleted folder being clicked
        if (_isDeletedFolderBeingClicked()) {
          await _clearDeletedNotesMoreThan30DaysAgo();
        }

        GlobalState.noteListWidgetForTodayState.currentState.triggerSetState(
            forceToRefreshNoteListByDb: true,
            forceToSetBackgroundColorToFirstItemIfBackgroundNeeded: true);

        if (GlobalState.screenType == 3) {
          forceToFetchFoldersFromDb = true;
        }
        GlobalState.folderListWidgetState.currentState.triggerSetState(
            forceToFetchFoldersFromDb: forceToFetchFoldersFromDb);

        // Switch the page
        GlobalState.isHandlingFolderPage = true;
        GlobalState.isInFolderPage = false;
        GlobalState.masterDetailPageState.currentState
            .updatePageShowAndHide(shouldTriggerSetState: true);
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    var s = 's';
  }

  // Private methods
  bool _isDeletedFolderBeingClicked() {
    var isDeletedFolder = false;

    if (GlobalState.isDefaultFolderSelected &&
        GlobalState.selectedFolderIdCurrently ==
            GlobalState.defaultFolderIdForDeletedFolder) {
      isDeletedFolder = true;
    }

    return isDeletedFolder;
  }

  Future<int> _clearDeletedNotesMoreThan30DaysAgo() async {
    var minAvailableDateTime = TimeHandler.getNowForLocal()
        .subtract(Duration(days: 30))
        .toIso8601String();

    var effectedRowCount = await GlobalState.database
        .clearDeletedNotesMoreThan30DaysAgo(minAvailableDateTime);

    return effectedRowCount;
  }
}
