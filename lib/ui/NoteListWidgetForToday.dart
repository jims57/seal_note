import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;
import 'package:http/http.dart' as http;
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'httper/NoteHttper.dart';

class NoteListWidgetForToday extends StatefulWidget {
  NoteListWidgetForToday({Key key}) : super(key: key);

  @override
  NoteListWidgetForTodayState createState() => NoteListWidgetForTodayState();
}

class NoteListWidgetForTodayState extends State<NoteListWidgetForToday> {
  List<NotesCompanion> _notesCompanionList = List<NotesCompanion>();
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
    _isFirstLoad = true;

    initLoadingConfigs();
    super.initState();
  }

  void _loadMore() {
    _isLoading = true;

    _pageNo++;

    GlobalState.database
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
    // note list widget build method
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

                return Text('No data');
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
                    // color: Colors.red,
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
                            title: Text('${_noteList[index].title}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                )),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_noteList[index].content}',
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
                            borderRadius: BorderRadius.circular(
                                GlobalState.borderRadius15),
                          ),
                        ),
                        actions: <Widget>[
                          SlideAction(
                            child: Container(
                              constraints: BoxConstraints.expand(),
                              color: GlobalState.themeBlueColor,
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
                                  backgroundColor: GlobalState.themeBlueColor,
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
                    // Click note list item
                    GlobalState.isClickingNoteListItem = true;

                    GlobalState.selectedNoteModel.id = index;
                    // GlobalState.appState.detailPageStatus = 1;
                    GlobalState.isQuillReadOnly = true;
                    GlobalState.isCreatingNote = false;

                    // GlobalState.rotationCounter += 1;
                    // GlobalState.htmlString2 =
                    //     GlobalState.rotationCounter.toString();

                    GlobalState.isInNoteDetailPage = true;
                    if (GlobalState.screenType == 1) {
                      // GlobalState.isInNoteDetailPage = true;
                      GlobalState.isHandlingNoteDetailPage = true;
                      GlobalState.masterDetailPageState.currentState
                          .updatePageShowAndHide(shouldTriggerSetState: true);
                    } else {
                      // Screen Type = 2 or 3
                      // GlobalState.isInNoteDetailPage = true;
                    }
                  },
                );
              },
            )),
    );
  }

  Future<Null> _getRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    _notesCompanionList.clear();

    for (var i = 0; i < _refreshCount; ++i) {
      var title = '[refresh] title${i + 1}';
      var content = '[refresh] content${i + 1}';

      final now = DateTime.now();
      NotesCompanion notesCompanion = NotesCompanion(
          title: Value(title), content: Value(content), created: Value(now));

      _notesCompanionList.add(notesCompanion);
      // TODO: Need to add _noteList data

      // GlobalState.database.insertNote(notesCompanion);
    }

    // Insert the refreshed data in batch
    GlobalState.database.insertNotesInBatch(_notesCompanionList).then((value) {
      // _noteList.insert(0, NoteEntry(id: null, folderId: 3, title: 'Refreshed1111', created: null));

      GlobalState.selectedNoteModel.noteListWidgetForTodayState.currentState
          .resetLoadingConfigsAfterUpdatingSqlite();
    });

    // GlobalState.selectedNoteModel.noteListWidgetForTodayState.currentState
    //     .resetLoadingConfigsAfterUpdatingSqlite();
  }

  void initLoadingConfigs() {
    _pageNo = 1;
    _pageSize = 10;

    _isLoading = true;
    _hasMore = true;

    GlobalState.database
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
        GlobalState.database
            .upsertNotesInBatch(fetchedPhotoList)
            .whenComplete(() {
          // TODO: To be deleted before releasing the app
          //  After insert, update notes' content
          GlobalState.database.upsertAllNotesContentByTitles(fetchedPhotoList);

          GlobalState.selectedNoteModel.noteListWidgetForTodayState.currentState
              .resetLoadingConfigsAfterUpdatingSqlite();

          Timer(Duration(seconds: 2), () {
            GlobalState.appState.isExecutingSync = false;
          });
        });
      }).catchError((e) {
        // String errorMessage = e;
      });
    }
  }

  void resetLoadingConfigsAfterUpdatingSqlite() {
    _noteList.clear();

    initLoadingConfigs();
  }
}
