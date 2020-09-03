import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'NoteDetailPage.dart';
import 'NoteDetailWidget.dart';
import 'httper/NoteHttper.dart';

class NoteListWidgetForToday extends StatefulWidget {
  NoteListWidgetForToday({Key key}) : super(key: key);

  @override
  NoteListWidgetForTodayState createState() => NoteListWidgetForTodayState();
}

class NoteListWidgetForTodayState extends State<NoteListWidgetForToday> {
  SelectedNoteModel _selectedNoteModel;
  AppState _appState;
  Database _database;

  List<NoteEntry> _noteList = List<NoteEntry>();

  int _pageNo;
  int _pageSize;

  int _refreshCount = 20;

  bool _isLoading;
  bool _hasMore;

  bool _isFirstLoad;

  // Slide options
  double _slideIconSize = 30.0;
  double _slideFontSize = 16.0;

  // Data manipulation
  NoteEntry _noteEntryDeleted;

  @override
  void initState() {
    _database = Provider.of<Database>(context, listen: false);
    GlobalState.database = _database;
    _selectedNoteModel = Provider.of<SelectedNoteModel>(context, listen: false);
    _appState = Provider.of<AppState>(context, listen: false);
    _isFirstLoad = true;

    initLoadingConfigs();
    super.initState();
  }

  void _loadMore() {
    _isLoading = true;

    _pageNo++;

    _database
        .getNotesByPageSize(pageNo: _pageNo, pageSize: _pageSize)
        .then((fetchedList) {
      if (fetchedList.isEmpty) {
        setState(() {
          _isLoading = false;
          _hasMore = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _noteList.addAll(fetchedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getRefresh,
      child: (_noteList.length == 0
          ? ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                if (_isLoading) {
                  return Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 24,
                      width: 24,
                    ),
                  );
                }

                return Text('No data2');
              })
          : ListView.builder(
              itemCount: _hasMore ? _noteList.length + 1 : _noteList.length,
              itemBuilder: (context, index) {
                if (index >= _noteList.length) {
                  if (!_isLoading) {
                    _loadMore();
                  }
                  return Center(
                    child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 24,
                      width: 24,
                    ),
                  );
                }

                return GestureDetector(
                  child: Container(
                    margin:
                        const EdgeInsets.only(top: 5.0, left: 8.0, right: 8.0),
                    child: Container(
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(
                                top: 15.0, bottom: 15, left: 10.0, right: 10.0),
                            title: Text(
                                'NoteID=>${_noteList[index].id.toString()}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '自2019年发生“修例风波”以来，香港各行各业深受其害，很多家庭收入锐减，都盼着尽快止暴制乱。杨志红痛心地说：“这一年的社会风波，暴露出香港在维护国家安全上存在巨大风险，使‘一国两制’香港实践遭遇前所未有的严峻挑战。',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '应30分钟前复习',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 10.0),
                                      ),
                                      Text(
                                        /**/
                                        '进度：4/7',
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 10.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          elevation: 1.1,
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        actions: <Widget>[
                          SlideAction(
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              color: GlobalState.themeColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    size: _slideIconSize,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '推迟',
                                    style: TextStyle(
                                      fontSize: _slideFontSize,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                        secondaryActions: <Widget>[
                          SlideAction(
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              color: Colors.orangeAccent,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.playlist_play,
                                    size: _slideIconSize,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '移动',
                                    style: TextStyle(
                                      fontSize: _slideFontSize,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SlideAction(
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              color: Colors.red,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    size: _slideIconSize,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    '删除',
                                    style: TextStyle(
                                      fontSize: _slideFontSize,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _noteEntryDeleted = _noteList[index];
                                _noteList.removeAt(index);

                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('SB'),
                                  backgroundColor: GlobalState.themeColor,
                                  behavior: SnackBarBehavior.fixed,
                                  action: SnackBarAction(
                                    label: '撤消',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _noteList.insert(
                                            index, _noteEntryDeleted);
                                      });
                                    },
                                  ),
                                ));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    GlobalState.selectedNoteModel.id = index;
                    GlobalState.appState.detailPageStatus = 1;
                    GlobalState.isQuillReadOnly = true;
                    GlobalState.isCreatingNote = false;

                    if (GlobalState.screenType == 1) {
                      Navigator.of(GlobalState.noteListPageContext)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return NoteDetailWidget();
                      }));
                    } else {}
                  },
                );
              },
            )),
    );
  }

  Future<Null> _getRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    for (var i = 0; i < _refreshCount; ++i) {
      final now = DateTime.now();
      NotesCompanion notesCompanion = NotesCompanion(
          title: Value('[refresh] title${i + 1}'),
          content: Value('[refresh] content${i + 1}'),
          created: Value(now));

      _database.insertNote(notesCompanion);
    }

    _selectedNoteModel.noteListWidgetForTodayState.currentState
        .resetLoadingConfigsAfterUpdatingSqlite();
  }

  void initLoadingConfigs() {
    _pageNo = 1;
    _pageSize = 10;

    _isLoading = true;
    _hasMore = true;

    _database
        .getNotesByPageSize(pageNo: _pageNo, pageSize: _pageSize)
        .then((value) {
      _noteList.addAll(value);

      if (!_isLoading) _loadMore();

      setState(() {
        _isLoading = false;
      });
    });

    // If it is the first load, by the way to fetch data from the server
    if (_isFirstLoad) {
      _isFirstLoad = false;

      fetchPhotos(client: http.Client()).then((fetchedPhotoList) {
        _database.upsertNotesInBatch(fetchedPhotoList).whenComplete(() {
          _selectedNoteModel.noteListWidgetForTodayState.currentState
              .resetLoadingConfigsAfterUpdatingSqlite();

          Timer(Duration(seconds: 2), () {
            _appState.isExecutingSync = false;
          });
        });
      }).catchError((e) {
        String errorMessage = e;
      });
    }
  }

  void resetLoadingConfigsAfterUpdatingSqlite() {
    _noteList.clear();

    initLoadingConfigs();
  }
}
