import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/mixin/check_device.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';

class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage>
    with CheckDeviceMixin {
  @override
  void initState() {
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
    GlobalState.themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(
            children: [
              Container(
                child: (GlobalState.screenType == 3
                    ? Container(
                        width: 220,
                        height: GlobalState.screenHeight,
                        decoration: (GlobalState.screenType == 3
                            ? BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.grey[200])))
                            : BoxDecoration()),
                        child: FolderListPage(),
                      )
                    : Container()),
              ),
              Container(
                  width: (GlobalState.screenType == 1
                      ? GlobalState.screenWidth
                      : 280),
                  height: GlobalState.screenHeight,
                  decoration: (GlobalState.screenType == 1
                      ? BoxDecoration()
                      : BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey[200])))),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: NoteListPage(),
                  )),
              Expanded(
                child: (GlobalState.screenType == 1
                    ? Container()
                    : Container(
                        height: GlobalState.screenHeight,
                        child: NoteDetailPage(),
                      )),
              )
            ],
          );
        },
      ),
    );
  }
}
