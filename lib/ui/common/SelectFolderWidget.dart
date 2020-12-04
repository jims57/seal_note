import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

import 'AlertDialogWidget.dart';

class SelectFolderWidget extends StatefulWidget {
  SelectFolderWidget({
    Key key,
    @required this.folderIcon,
    @required this.folderIconColor,
    @required this.folderId,
    @required this.folderName,
    @required this.reviewPlanId,
  }) : super(key: key);

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

        if (_isFolderSelectionItemClickable(theUserFolderId: widget.folderId)) {
          var folderIdClicked = widget.folderId;
          var folderNameClicked = widget.folderName;
          var reviewPlanIdClicked = widget.reviewPlanId;
          var shouldMoveNote = true; // By default, we should note the note
          var isDialogForFolderSelectionHidden = false;

          // Check whether we should show the alert dialog for the user to confirm before continuing this action
          if (_shouldShowAlertDialogToConfirm()) {
            var shouldContinueAction = await GlobalState
                .alertDialogWidgetState.currentState
                .showAlertDialog();

            if (shouldContinueAction) {
              // When the user clicks on OK button
              // Hide the dialog to the folder selection
              Navigator.of(GlobalState.currentShowDialogContext).pop();
              isDialogForFolderSelectionHidden =
                  true; // If we have hide the dialog, marking it so that the subsequent code won't hide it again
            } else {
              // When the user clicks on Cancel button
              shouldMoveNote = false;
            }
          }

          if (shouldMoveNote) {
            // When the result is that the note should be moved anyway

            // Get current review plan id

            var theFolderListItemWidget = GlobalState
                .folderListPageState.currentState
                .getFolderListItemWidgetByFolderId(
                    folderId: GlobalState.selectedFolderIdCurrently);
            var currentReviewPlanId = theFolderListItemWidget.reviewPlanId;

            // Get typeId for moving a note
            var typeId = _getTypeIdForMovingNote(
                currentReviewPlanId: currentReviewPlanId,
                targetReviewPlanId: reviewPlanIdClicked);

            var effectedRowCount = await GlobalState.database
                .changeNoteFolderId(
                    noteId: GlobalState.selectedNoteModel.id,
                    newFolderId: folderIdClicked,
                    typeId: typeId);

            // When the dialog for folder selection isn't hidden, we should hide it by code
            if (!isDialogForFolderSelectionHidden) {
              Navigator.of(GlobalState.currentShowDialogContext).pop();
            }

            if (effectedRowCount > 0) {
              // When sqlite is updated, refresh the note list
              GlobalState.noteListWidgetForTodayState.currentState
                  .triggerSetState(resetNoteList: true);
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

  bool _shouldShowAlertDialogToConfirm() {
    var shouldShowAlertDialog = false;

    return shouldShowAlertDialog;
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
