import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
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
                GlobalState.isHandlingFolderPage = true;
                GlobalState.isInFolderPage = true;
                GlobalState.masterDetailPageState.currentState
                    .updatePageShowAndHide(shouldTriggerSetState: true);

                GlobalState.masterDetailPageState.currentState
                    .refreshFolderListPageAppBarHeight();
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
                  return Container(
                    height: GlobalState.folderOptionItemHeight * 6 + 10,
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: FolderOptionListWidget(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
        title: Text(
          // note list caption // note list page title
          // note list title
          '${GlobalState.selectedFolderName}',
          style: TextStyle(
              color: GlobalState.themeBlackColor87ForFontForeColor,
              fontSize: 16.0),
          // style: TextStyle(color: Colors.red,),
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
        child: Icon(Icons.add),
        onPressed: () {
          // click new note button // click new button
          // new note event // click on new note button
          // click add note button

          // Update action status
          GlobalState.isQuillReadOnly = false;
          GlobalState.isCreatingNote = true;
          GlobalState.isHandlingNoteDetailPage = true;
          GlobalState.isInNoteDetailPage = true;

          // Set the Quill to the edit mode
          // GlobalState.flutterWebviewPlugin
          //     .evalJavascript("javascript:setQuillToReadOnly(false, true);");

          // Get note related variables
          var folderId = GlobalState.selectedFolderId;

          var responseJsonString =  '{"isCreatingNote": true, "folderId":$folderId, "noteId":0, "encodedHtml":""}';
          GlobalState.flutterWebviewPlugin.evalJavascript(
              "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString');");

          // Refresh tree
          GlobalState.masterDetailPageState.currentState
              .updatePageShowAndHide(shouldTriggerSetState: true);
        },
      ),
    );
  }
}
