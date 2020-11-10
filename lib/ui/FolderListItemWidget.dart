import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'folderPageWidgets/UserFolderListListenerWidget.dart';

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
      this.folderListPanelMarginForTopOrBottom: 5.0})
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

  @override
  FolderListItemWidgetState createState() => FolderListItemWidgetState();
}

class FolderListItemWidgetState extends State<FolderListItemWidget> {
  @override
  Widget build(BuildContext context) {
    // Check if this is a default folder, if yes, we need to add the folder total
    if (widget.isDefaultFolder) {
      GlobalState.allFolderTotal += 1;

      // Record the default folder index to list
      GlobalState.defaultFolderIndexList.add(widget.index);
    }

    return GestureDetector(
      key: (widget.isDefaultFolder)
          ? Key('defaultFolderListItem${widget.index}')
          : Key('userFolderListItem${widget.index}'),
      child: UserFolderListListenerWidget(
        icon: widget.icon,
        iconColor: widget.iconColor,
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
      ),
      onTap: () {
        // click on folder item // click folder item
        // click folder list item event // click folder item event
        // click on folder list item

        // Update the note list
        GlobalState.isDefaultFolderSelected = widget.isDefaultFolder;
        GlobalState.selectedFolderIdCurrently = widget.folderId;
        GlobalState.selectedFolderReviewPlanId = widget.reviewPlanId;
        GlobalState.appState.noteListPageTitle = widget.folderName;
        GlobalState.isReviewFolderSelected = widget.isReviewFolder;
        GlobalState.noteListWidgetForTodayState.currentState.triggerSetState();

        // Switch the page
        GlobalState.isHandlingFolderPage = true;
        GlobalState.isInFolderPage = false;
        GlobalState.masterDetailPageState.currentState
            .updatePageShowAndHide(shouldTriggerSetState: true);
      },
    );
  }
}
