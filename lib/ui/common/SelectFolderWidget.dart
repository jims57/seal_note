import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';

class SelectFolderWidget extends StatefulWidget {
  SelectFolderWidget({
    Key key,
    @required this.indexAtNoteList,
    @required this.folderIcon,
    @required this.folderIconColor,
    @required this.folderId,
    @required this.folderName,
    @required this.reviewPlanId,
  }) : super(key: key);

  final int indexAtNoteList;
  final IconData folderIcon;
  final Color folderIconColor;
  final int folderId;
  final String folderName;
  final int reviewPlanId;

  @override
  SelectFolderWidgetState createState() => SelectFolderWidgetState();
}

class SelectFolderWidgetState extends State<SelectFolderWidget> {
  // Configuration
  double fontSizeForFolderSelectionText = 20.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isCurrentFolder = false;
    if (!_isFolderSelectionItemClickable(theUserFolderId: widget.folderId)) {
      isCurrentFolder = true;
    }

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        height: GlobalState.folderListItemHeightForFolderSelection,
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  widget.folderIcon,
                  color: isCurrentFolder
                      ? GlobalState.themeGrey350Color
                      : widget.folderIconColor,
                  size: 28.0,
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      widget.folderName,
                      style: TextStyle(
                          fontSize: fontSizeForFolderSelectionText,
                          color: isCurrentFolder
                              ? GlobalState.themeGrey350Color
                              : GlobalState.themeBlackColor87ForFontForeColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              ],
            ),
            Flexible(
                child: Divider(
              indent: 35.0,
            ))
          ],
        ),
      ),
      onTap: () async {
        // click on folder selection item // click folder selection item
        // click to move folder // click on select folder event
        // move folder event

        if (_isFolderSelectionItemClickable(theUserFolderId: widget.folderId)) {
          GlobalState.targetFolderIdNoteIsMovingTo = widget.folderId;
          var targetReviewPlanId = widget.reviewPlanId;
          var shouldMoveNote = true; // By default, we should note the note
          var isDialogForFolderSelectionHidden = false;

          // Get current review plan id
          var theFolderListItemWidget = GlobalState
              .folderListPageState.currentState
              .getFolderListItemWidgetByFolderId(
                  folderId: GlobalState.selectedFolderIdCurrently);
          var currentReviewPlanId = theFolderListItemWidget.reviewPlanId;

          // Check whether we should show the alert dialog for the user to confirm before continuing this action
          var confirmTypeId = _getConfirmTypeIdForAlertDialog(
              currentReviewPlanId: currentReviewPlanId,
              targetReviewPlanId: targetReviewPlanId);

          if (confirmTypeId > 0) {
            // Greater than zero means it needs to show the alert dialog for the user to confirm

            // confirm dialog // confirm to move note
            // move note confirm dialog

            var remark =
                GlobalState.remarkForMovingNoteToFolderWithDifferentReviewPlan;
            if (confirmTypeId == 1) {
              remark = GlobalState.remarkForMovingNoteToFolderWithoutReviewPlan;
            }

            // Always enable the OK button every time
            GlobalState.appState.enableAlertDialogOKButton = true;

            var shouldContinueAction = await AlertDialogHandler()
                .showAlertDialog(
                    parentContext: context,
                    captionText: '移动笔记？',
                    remark: remark,
                    buttonTextForOK: '确定移动',
                    buttonColorForOK: Colors.red);

            if (shouldContinueAction) {
              // When the user clicks on OK button
              // Hide the dialog to the folder selection
              Navigator.of(GlobalState.currentShowingDialogContext).pop();
              isDialogForFolderSelectionHidden =
                  true; // If we have hide the dialog, marking it so that the subsequent code won't hide it again
            } else {
              // When the user clicks on Cancel button
              shouldMoveNote = false;
            }
          }

          if (shouldMoveNote) {
            // When the result is that the note should be moved anyway

            // Get typeId for moving a note
            var typeId = _getTypeIdForMovingNote(
                currentReviewPlanId: currentReviewPlanId,
                targetReviewPlanId: targetReviewPlanId);

            var effectedRowCount = await GlobalState.database
                .changeNoteFolderId(
                    noteId: GlobalState.selectedNoteModel.id,
                    newFolderId: GlobalState.targetFolderIdNoteIsMovingTo,
                    typeId: typeId);

            // When the dialog for folder selection isn't hidden, we should hide it by code
            if (!isDialogForFolderSelectionHidden) {
              Navigator.of(GlobalState.currentShowingDialogContext).pop();
            }

            if (effectedRowCount > 0) {
              // When sqlite is updated, refresh the note list

              // Remove the note item from the note list variable
              GlobalState.noteListWidgetForTodayState.currentState
                  .removeItemFromNoteListByIndex(
                      indexAtNoteList: widget.indexAtNoteList);

              GlobalState.noteListWidgetForTodayState.currentState
                  .triggerSetState(
                      forceToRefreshNoteListByDb: false,
                      forceToSetBackgroundColorToFirstItemIfBackgroundNeeded: true,
                      refreshFolderListPageFromDbByTheWay: true);
            }
          }
        }
      },
    );
  }

  // Private methods
  bool _isFolderSelectionItemClickable({@required int theUserFolderId}) {
    var isFolderSelectionItemClickable = false;

    if (theUserFolderId != GlobalState.selectedFolderIdCurrently) {
      isFolderSelectionItemClickable = true;
    }

    return isFolderSelectionItemClickable;
  }

  int _getConfirmTypeIdForAlertDialog(
      {@required int currentReviewPlanId, @required int targetReviewPlanId}) {
    // Only the two situations need to show the alert dialog for the user to confirm his action
    // confirmTypeId = [0, 1, 2], for more info at https://user-images.githubusercontent.com/1920873/101129130-fd906080-363b-11eb-882e-7809043de79e.png

    var confirmTypeId;

    if (currentReviewPlanId != null) {
      // When the current review plan id isn't null

      if (targetReviewPlanId == null) {
        confirmTypeId = 1;
      } else if (currentReviewPlanId != targetReviewPlanId) {
        confirmTypeId = 2;
      } else {
        confirmTypeId = 0;
      }
    } else {
      // When the current review plan id is null

      confirmTypeId = 0;
    }

    return confirmTypeId;
  }

  int _getTypeIdForMovingNote(
      {@required int currentReviewPlanId, @required int targetReviewPlanId}) {
    // Remark about type id at: https://user-images.githubusercontent.com/1920873/101114842-44bb2900-361d-11eb-9537-4492a6994286.png
    // 0 means: Set nextReviewTime, reviewProgressNo fields to NULL and set isReviewFinished back to 0
    // 1 means: Set value to nextReviewTime and reviewProgressNo fields and set isReviewFinished back to 0
    // 2 means: Don't need to change all review related fields, such as nextReviewTIme, reviewProgressNo and isReviewFinished

    var typeId = 0;

    if (targetReviewPlanId == null) {
      // If the target folder's review plan id is null
      typeId = 0;
    } else {
      // If the target folder's review plan id isn't null
      if (currentReviewPlanId == targetReviewPlanId) {
        typeId = 2;
      } else {
        typeId = 1;
      }
    }

    return typeId;
  }
}
