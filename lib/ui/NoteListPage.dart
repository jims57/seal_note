import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/ui/common/AppBarBackButtonWidget.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';
import 'folderOption/FolderOptionListWidget.dart';
import 'NoteListWidget.dart';

typedef void ItemSelectedCallback();

class NoteListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  final GlobalKey<NoteListWidgetState> _noteListWidgetState =
      GlobalKey<NoteListWidgetState>();

  @override
  void initState() {
    GlobalState.noteListPageContext = context;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalState.themeGreyColorAtiOSTodoForBackground,
      appBar: AppBarWidget(
        // Note list app bar
        backgroundColor: GlobalState.themeGreyColorAtiOSTodoForBackground,
        leadingChildren: [
          // new app bar back button widget
          // note list back button
          AppBarBackButtonWidget(
              textWidth: 50.0,
              title: '文件夹', // Folder back button
              onTap: () {
                // click on note list back button // click note list back button
                // note list back button event

                GlobalState.isHandlingFolderPage = true;
                GlobalState.isInFolderPage = true;
                GlobalState.masterDetailPageState.currentState
                    .updatePageShowAndHide(shouldTriggerSetState: true);

                GlobalState.masterDetailPageState.currentState
                    .refreshFolderListPageAppBarHeight();

                // Refresh folder list every time the user clicks on the note list back button
                GlobalState.folderListWidgetState.currentState
                    .triggerSetState(forceToFetchFoldersFromDB: true);
              }),
        ],
        tailChildren: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: GlobalState.themeBlueColor,
            ),
            onPressed: () {
              GlobalState.appState.isInFolderOptionSubPanel = false;

              showModalBottomSheet<void>(
                barrierColor: Colors.black12,
                backgroundColor: Colors.transparent,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return SafeArea(
                    child: Container(
                      height: GlobalState.folderOptionItemHeight * 9,
                      child: MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: Scaffold(
                          backgroundColor: Colors.transparent,
                          body: FolderOptionListWidget(),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
        title: Consumer<AppState>(
          builder: (ctx, appState, child) {
            // Get folder name by the selected folder Id

            return Text(
              // note list caption // note list page title
              // note list title // note list page caption
              // note list item page caption

              '${GlobalState.appState.noteListPageTitle}',
              style: TextStyle(
                  color: GlobalState.themeBlackColor87ForFontForeColor,
                  fontSize: 16.0),
            );
          },
        ),
        showSyncStatus: true,
        leadingWidth: 90,
        tailWidth: 40,
      ),
      body: NoteListWidget(
        key: _noteListWidgetState,
      ),
      // Note list floating button
      floatingActionButton: FloatingActionButton(
        // floating button // add note floating button
        // add note button // new note floating button
        // add button
        child: Icon(Icons.add),
        onPressed: () {
          // click new note button // click new button
          // new note event // click on new note button
          // click add note button // new floating button
          // new note button // new note floating button
          // click on new button // create new note button
          // click on floating button // click floating button

          // Set web view related variables
          GlobalState.isNoteListSelectedAutomaticallyAfterNoteListPageLoaded = false;

          // Update action status
          GlobalState.isQuillReadOnly = false;
          GlobalState.isEditingOrCreatingNote = true;
          GlobalState.isHandlingNoteDetailPage = true;
          GlobalState.isInNoteDetailPage = true;

          // Get note related variables
          var folderId = GlobalState.selectedFolderIdCurrently;
          GlobalState.selectedNoteModel.id =
              0; // Every time when clicking on the Add button, making the note id equals zero
          GlobalState.selectedNoteModel.title =
              GlobalState.defaultTitleForNewNote;
          GlobalState.noteContentEncodedInDb = null;

          var responseJsonString =
              '{"isCreatingNote": true, "folderId":$folderId, "noteId":${GlobalState.selectedNoteModel.id}, "encodedHtml":""}';
          GlobalState.flutterWebviewPlugin.evalJavascript(
              "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString', true);");

          // Refresh tree
          GlobalState.masterDetailPageState.currentState
              .updatePageShowAndHide(shouldTriggerSetState: true);
        },
      ),
    );
  }
}
