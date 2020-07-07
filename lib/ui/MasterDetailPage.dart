import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/EditingNoteModel.dart';
import 'package:seal_note/function/checkScreenType.dart';
import 'package:seal_note/ui/FolderListWidget.dart';
import 'package:seal_note/ui/NoteListWidget.dart';
import 'package:provider/provider.dart';

class MasterDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MasterDetailPageState();
}

class _MasterDetailPageState extends State<MasterDetailPage> {
  int _screenType = 1; // 1 = Small, 2 = Medium, 3 = Large
  double _screenWidth = 0;
  double _screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
//    _screenWidth = size.width;
//    _screenHeight = size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
    _screenType = checkScreenType(_screenWidth);

    BuildContext noteListContext =
        Provider.of<EditingNoteModel>(context, listen: false).context;
    if (noteListContext != null) {
      bool canPop = Navigator.canPop(noteListContext);
      if (canPop && _screenType == 3) {
        Navigator.pop(noteListContext);
      }

      bool canPop2 = Navigator.canPop(context);
      String s = 's';
    }

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
                        color: Colors.red,
                        child: FolderListWidget(),
                      )
                    : Container()),
              ),
              Container(
                  width: (_screenType == 1 ? _screenWidth : 220),
                  height: _screenHeight,
                  color: Colors.green,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: NoteListWidget(
                      itemCount: 60,
                    ),
                  )),
              Expanded(
                child: (_screenType == 1
                    ? Container()
                    : Container(
                        height: _screenHeight,
                        child: Container(
                          color: Colors.blue,
                          child: Text('C3'),
                        ),
                      )),
              )
            ],
          );
        },
      ),
    );
  }
}
