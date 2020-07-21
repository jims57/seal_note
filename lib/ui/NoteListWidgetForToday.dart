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

import 'NoteDetailPage.dart';
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
                      child: Card(
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 15.0, bottom: 15, left: 10.0, right: 10.0),
                          title: Text(
                              'NoteID=>${_noteList[index].id.toString()}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w400)),
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
                    ),
                  ),
                  onTap: () {
                    GlobalState.selectedNoteModel.id = index;

                    if (GlobalState.screenType == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoteDetailPage()),
                      );
                    }
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
