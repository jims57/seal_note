import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/EditingNoteModel.dart';
import 'package:seal_note/function/checkScreenType.dart';
import 'package:seal_note/ui/FolderListWidget.dart';
import 'package:seal_note/util/route/SlideRightRoute.dart';

import 'Common/AppBarWidget.dart';

typedef void ItemSelectedCallback();

class NoteListWidget extends StatefulWidget {
  NoteListWidget(
      {Key key, @required this.itemCount, @required this.onItemSelected})
      : super(key: key);

  final int itemCount;
  final ItemSelectedCallback onItemSelected;

  @override
  State<StatefulWidget> createState() => _NoteListWidgetState();
}

class _NoteListWidgetState extends State<NoteListWidget> {
  int _screenType = 1; // 1 = Small, 2 = Medium, 3 = Large
  double _screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    Provider.of<EditingNoteModel>(context, listen: false).context = context;

    _screenWidth = MediaQuery.of(context).size.width;
    _screenType = checkScreenType(_screenWidth);

    return Scaffold(
      appBar: AppBarWidget(
        leadingChildren: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, SlideRightRoute(page: FolderListWidget()));
            },
          ),
          (_screenType == 2
              ? Container()
              : Text(
                  '文件夹',
                  style: TextStyle(fontSize: 14.0),
                )),
        ],
        tailChildren: [
          IconButton(
              icon: Icon(
            Icons.more_horiz,
            color: Colors.white,
          )),
        ],
        title: '英语知识英语知识英语知识英语知识英语知识英语知识',
        leadingWidth: 90,
        tailWidth: 40,
      ),
      body: ListView.builder(
          itemCount: widget.itemCount,
          itemBuilder: (cxt, idx) {
            int currentIndex = idx;

            return Consumer<EditingNoteModel>(
              builder: (context, note, child) => GestureDetector(
                child: Text('I am text $currentIndex'),
                onTap: () {
//                  Navigator.pop(context);

//                  note.id = currentIndex;
//                  note.title = 'title $currentIndex';
//                  note.content = 'title $currentIndex content';
//                  widget.onItemSelected();
                },
              ),
            );
          }),
    );
  }
}
