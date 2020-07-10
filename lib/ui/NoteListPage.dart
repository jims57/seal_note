import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/route/SlideRightRoute.dart';

import 'Common/AppBarWidget.dart';
import 'FolderListPage.dart';
import 'NoteListWidget.dart';

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
          (GlobalState.screenType == 3
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context, SlideRightRoute(page: FolderListPage()));
                  },
                )),
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
        title: '今天',
        leadingWidth: 90,
        tailWidth: 40,
      ),
      body: NoteListWidget(),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),),
    );
  }
}
