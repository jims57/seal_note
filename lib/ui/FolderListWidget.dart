import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class FolderListWidget extends StatefulWidget {
  // FolderListWidget({Key key, @required this.folderPageWidth})
  //     : super(key: key);

  // final double folderPageWidth;

  @override
  State<StatefulWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(child: Text('I am folder list[Folder Page]')),
      onTap: () {
        GlobalState.isHandlingFolderPage = true;
        GlobalState.isInFolderPage = false;
        GlobalState.masterDetailPageState.currentState
            .updatePageShowAndHide(shouldTriggerSetState: true);

        // if (GlobalState.screenType != 3)
        //   Navigator.pop(GlobalState.noteListPageContext);
      },
    );
  }
}
