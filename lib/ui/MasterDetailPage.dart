import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/function/checkScreenType.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/ui/NoteListPage.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';



class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  // Common variables
  int _screenType; // 1 = Small, 2 = Medium, 3 = Large
  double _screenWidth;
  double _screenHeight;

  // Page variables
  FolderListPage _folderListPage;
  NoteListPage _noteListPage;
  NoteDetailPage _noteDetailPage;

  @override
  void initState() {

    _noteListPage = Provider.of<NoteListPage>(context, listen: false);
    GlobalState.noteListPage = _noteListPage;

    _folderListPage = Provider.of<FolderListPage>(context, listen: false);
    GlobalState.folderListPage = _folderListPage;

    _noteDetailPage = Provider.of<NoteDetailPage>(context, listen: false);
    GlobalState.noteDetailPage = _noteDetailPage;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _screenType = checkScreenType(_screenWidth);
    GlobalState.screenType = _screenType;


    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Row(
            children: [
              Container(
                child: (_screenType == 3
                    ? Container(
                        width: 195,
                        height: _screenHeight,
                        decoration: (_screenType == 3
                            ? BoxDecoration(
                                border: Border(
                                    right: BorderSide(color: Colors.grey[200])))
                            : BoxDecoration()),
                        child: _folderListPage,
                      )
                    : Container()),
              ),
              Container(
                  width: (_screenType == 1 ? _screenWidth : 220),
                  height: _screenHeight,
                  decoration: (_screenType == 1
                      ? BoxDecoration()
                      : BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey[200])))),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: _noteListPage,
                  )),
              Expanded(
                child: (_screenType == 1
                    ? Container()
                    : Container(
                        height: _screenHeight,
                        child: _noteDetailPage,
                      )),
              )
            ],
          );
        },
      ),
    );
  }
}
