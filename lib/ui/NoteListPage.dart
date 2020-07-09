import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/ui/FolderListPage.dart';
import 'package:seal_note/util/route/SlideRightRoute.dart';

import 'Common/AppBarWidget.dart';

typedef void ItemSelectedCallback();

class NoteListPage extends StatefulWidget {
  NoteListPage(
      {Key key, @required this.itemCount, @required this.onItemSelected})
      : super(key: key);

  final int itemCount;
  final ItemSelectedCallback onItemSelected;

  @override
  State<StatefulWidget> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  @override
  void initState() {
    GlobalState.noteListPageContext = context;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        leadingChildren: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, SlideRightRoute(page: FolderListPage()));
            },
          ),
          (GlobalState.screenType == 2
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
      body: GlobalState.noteListWidget,
    );
  }
}
