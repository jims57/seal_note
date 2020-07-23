import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';
import 'package:seal_note/util/route/SlideRightRoute.dart';

import 'FolderListPage.dart';
import 'folderOption/FolderOptionListWidget.dart';
import 'NoteDetailPage.dart';
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
  final GlobalKey<NoteListWidgetState> _noteListWidgetState =
      GlobalKey<NoteListWidgetState>();

  Database _database;

  // Folder option items
  double _folderOptionCaptionSize = 16.0;

  @override
  void initState() {
    GlobalState.noteListPageContext = context;
    _database = Provider.of<Database>(context, listen: false);

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
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                barrierColor: Colors.black12,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
//                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5.0, bottom: 0.0),
                                width: 35.0,
                                height: 4.0,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(5),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
//                                      color: Colors.green,
                                      child: Center(
                                          child: Text(
                                        '文件夹选项',
                                        style: TextStyle(
                                            fontSize: _folderOptionCaptionSize,
                                            fontWeight: FontWeight.w400),
                                      )),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
//                                      color: Colors.blue,
                                      child: GestureDetector(
                                        child: Text(
                                          '完成',
                                          style: TextStyle(
                                              color: GlobalState.themeColor),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.black12,
                                height: 1,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                              )
                            ],
                          ),
                        ),
//                        Container(
//                            width: double.infinity,
//                            color: Colors.green,
//                            child: Column(
//                              children: [
//                                Container(child: Text('r12')),
//                                Text('r2'),
//                                Text('r3'),
//                                Text('r4-2')
//                              ],
//                            )),

//                        Container(
//                          width: double.infinity,
//                          child: MaterialApp(
//                              debugShowCheckedModeBanner: false,
//                              home: Text('mm')),
//                        )

//                      Container(child: MaterialApp(home:Scaffold(body: Text('s'),)),),

                        SizedBox(
                            height: GlobalState.folderOptionItemHeight * 2,
                            width: double.infinity,
                            child: MaterialApp(
                              debugShowCheckedModeBanner: false,
                              home: Scaffold(
                                body: FolderOptionListWidget(),
                              ),
                            )),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
        title: Text('英语知识'),
        leadingWidth: 90,
        tailWidth: 40,
      ),
      body: NoteListWidget(
        key: _noteListWidgetState,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _database.deleteAllNotes().then((value) {
            _noteListWidgetState
                .currentState.noteListWidgetForTodayState.currentState
                .resetLoadingConfigsAfterUpdatingSqlite();
          });
        },
      ),
    );
  }
}
