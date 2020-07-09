import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/mixin/check_device.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';

import 'NoteDetailWidget.dart';
import 'NoteListWidget.dart';

class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage>
    with CheckDeviceMixin {
  @override
  void initState() {
    // Folder
    GlobalState.folderListPage =
        Provider.of<FolderListPage>(context, listen: false);

    // Note list
    GlobalState.noteListPage =
        Provider.of<NoteListPage>(context, listen: false);
    GlobalState.noteListWidget =
        Provider.of<NoteListWidget>(context, listen: false);

    // Note detail
    GlobalState.noteDetailPage =
        Provider.of<NoteDetailPage>(context, listen: false);
    GlobalState.noteDetailWidget =
        Provider.of<NoteDetailWidget>(context, listen: false);

    // Model
    GlobalState.selectedNoteModel =
        Provider.of<SelectedNoteModel>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalState.screenHeight = getScreenHeight(context);
    GlobalState.screenWidth = getScreenWidth(context);
    GlobalState.screenType = checkScreenType(GlobalState.screenWidth);

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(
            children: [
              Container(
                child: (GlobalState.screenType == 3
                    ? Container(
                        width: 195,
                        height: GlobalState.screenHeight,
                        decoration: (GlobalState.screenType == 3
                            ? BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.grey[200])))
                            : BoxDecoration()),
                        child: GlobalState.folderListPage,
                      )
                    : Container()),
              ),
              Container(
                  width: (GlobalState.screenType == 1
                      ? GlobalState.screenWidth
                      : 220),
                  height: GlobalState.screenHeight,
                  decoration: (GlobalState.screenType == 1
                      ? BoxDecoration()
                      : BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey[200])))),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: GlobalState.noteListPage,
                  )),
              Expanded(
                child: (GlobalState.screenType == 1
                    ? Container()
                    : Container(
                        height: GlobalState.screenHeight,
                        child: GlobalState.noteDetailPage,
                      )),
              )
            ],
          );
        },
      ),
    );
  }
}
