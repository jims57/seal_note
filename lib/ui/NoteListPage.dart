import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/NoteDetailWidget.dart';
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
      appBar: AppBarWidget(
        // Note list app bar
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
              color: Colors.white,
            ),
            onPressed: () {
              GlobalState.appState.isInFolderOptionSubPanel = false;

              showModalBottomSheet<void>(
                barrierColor: Colors.black12,
                backgroundColor: Colors.transparent,
                // backgroundColor: Colors.black,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  // return Container(height: 200,color: Colors.red,);
                  return Container(
                    height: GlobalState.folderOptionItemHeight * 6 + 10,
                    // color: Colors.yellow,
                    // color: Colors.transparent,
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      // color: Colors.green,
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
        title: Text('英语知识[考研必备知识点2020秋季]'),
        // title: Text('英语知识'),
        showSyncStatus: true,
        leadingWidth: 90,
        tailWidth: 40,
      ),
      body: NoteListWidget(
        key: _noteListWidgetState,
      ),
      // Note list floating button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Update action status
          GlobalState.isQuillReadOnly = false;
          GlobalState.isCreatingNote = true;
          GlobalState.isHandlingNoteDetailPage = true;
          GlobalState.isInNoteDetailPage = true;

          // Set the Quill to the edit mode
          GlobalState.flutterWebviewPlugin
              .evalJavascript("javascript:setQuillToReadOnly(false);");

          // Refresh tree
          GlobalState.masterDetailPageState.currentState
              .updatePageShowAndHide(shouldTriggerSetState: true);
        },
      ),
    );
  }
}
