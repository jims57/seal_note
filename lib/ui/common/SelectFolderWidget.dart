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
  }) : super(key: key);

  final IconData folderIcon;
  final Color folderIconColor;
  final int folderId;
  final String folderName;

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
                  color: _isFolderSelectionItemClickable(
                          theUserFolderId: widget.folderId)
                      ? widget.folderIconColor
                      : GlobalState.themeGrey350Color,
                  size: 28.0,
                ),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(
                      widget.folderName,
                      style: TextStyle(
                          fontSize: fontSizeForFolderSelectionText,
                          color: _isFolderSelectionItemClickable(
                                  theUserFolderId: widget.folderId)
                              ? GlobalState.themeBlackColor87ForFontForeColor
                              : GlobalState.themeGrey350Color),
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
        if (_isFolderSelectionItemClickable(theUserFolderId: widget.folderId)) {
          var folderIdClicked = widget.folderId;
          var folderNameClicked = widget.folderName;
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
            var effectedRowCount = await GlobalState.database
                .changeNoteFolderId(
                    noteId: GlobalState.selectedNoteModel.id,
                    newFolderId: folderIdClicked);

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
}
