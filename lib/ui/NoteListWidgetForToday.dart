import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;
import 'package:http/http.dart' as http;
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/util/time/TimeHandler.dart';
import 'httper/NoteHttper.dart';

class NoteListWidgetForToday extends StatefulWidget {
  NoteListWidgetForToday({Key key}) : super(key: key);

  @override
  NoteListWidgetForTodayState createState() => NoteListWidgetForTodayState();
}

class NoteListWidgetForTodayState extends State<NoteListWidgetForToday> {
  List<NoteEntry> _noteEntryList = List<NoteEntry>();

  // List<NoteWithProgressTotal> _noteEntryList = List<NoteWithProgressTotal>();

  // List<NoteEntry> _noteList = List<NoteEntry>();
  List<NoteWithProgressTotal> _noteList = List<NoteWithProgressTotal>();

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
  // NoteEntry _noteEntryDeleted;
  NoteWithProgressTotal _noteEntryDeleted;

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

                // Get the current note item object
                var theNote = _noteList[index];

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
                          // get note list item // note list item data
                          child: ListTile(
                            contentPadding: EdgeInsets.only(
                                top: 15.0, bottom: 15, left: 10.0, right: 10.0),
                            title: Text('${theNote.title}',
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
                                  '${theNote.content}',
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
                                        // note review time format // note list date time format
                                        // get note review time // get review time
                                        // show note review time // review time
                                        // show review time
                                        '${TimeHandler.getDateTimeFormatForAllKindOfNote(updated: theNote.updated, nextReviewTime: theNote.nextReviewTime, isReviewFinished: theNote.isReviewFinished)}',
                                        style: TextStyle(
                                            color: (_isReviewNote(theNote
                                                        .nextReviewTime) &&
                                                    _isReviewNoteOverdue(theNote
                                                        .nextReviewTime) &&
                                                    !theNote.isReviewFinished)
                                                ? Colors.red
                                                : Colors.grey[400],
                                            fontSize: 10.0),
                                      ),
                                      Text(
                                        // progress label // show progress label
                                        // review progress label
                                        '${_showProgressLabel(theNote)}',
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

  void triggerSetState() {
    setState(() {
      initLoadingConfigs();
    });
  }

  Future<Null> _getRefresh() async {
    // get refresh data // refresh method
    // pull to get data method // note list refresh data
    // refresh data // refresh note data

    await Future.delayed(Duration(seconds: 2));

    // _notesCompanionList.clear();
    _noteEntryList.clear();

    for (var i = 0; i < _refreshCount; ++i) {
      var title = '[refresh] title${i + 1}';
      var content = '[refresh] content${i + 1}';
      var now = DateTime.now().toLocal();

      var noteEntry = NoteEntry(
          id: null,
          folderId: GlobalState.selectedFolderId,
          title: title,
          content: content,
          created: now,
          updated: now,
          isReviewFinished: false,
          isDeleted: false,
          createdBy: GlobalState.currentUserId);

      // var noteEntry = NoteWithProgressTotal(
      //     id: null,
      //     folderId: GlobalState.selectedFolderId,
      //     title: title,
      //     content: content,
      //     created: now,
      //     updated: now,
      //     nextReviewTime: TimeHandler.getNowForLocal(),
      //     reviewProgressNo: 1,
      //     isReviewFinished: false,
      //     isDeleted: false,
      //     createdBy: GlobalState.currentUserId,
      //     progressTotal: 2);

      _noteEntryList.add(noteEntry);
      // _noteEntryList.add(noteEntry);
    }

    // Insert the refreshed data in batch
    // GlobalState.database.insertNotesInBatch(_notesCompanionList).then((value) {
    GlobalState.database.insertNotesInBatch(_noteEntryList).then((value) {
      GlobalState.selectedNoteModel.noteListWidgetForTodayState.currentState
          .resetLoadingConfigsAfterUpdatingSqlite();
    });
  }

  void initLoadingConfigs() {
    _pageNo = 1;
    _pageSize = 10;

    _isLoading = true;
    _hasMore = true;

    GlobalState.database
        .getNotesByPageSize(pageNo: _pageNo, pageSize: _pageSize)
        .then((noteList) {
      // load note list // note list first page data
      // first page note list data

      _noteList.clear();
      _noteList.addAll(noteList);

      if (!_isLoading) _loadMore();

      setState(() {
        _isLoading = false;
      });
    });

    // If it is the first load, by the way to fetch data from the server
    if (_isFirstLoad) {
      _isFirstLoad = false;

      // Check if the notes table has data or not, if not, we insert dummy data
      GlobalState.database.hasNote().then((hasNote) {
        if (!hasNote) {
          // If the notes table hasn't data, insert the dummy data
          fetchPhotos(client: http.Client()).then((fetchedPhotoList) {
            // initialize notes // init notes
            // note initialization // note init
            GlobalState.database
                .updateAllNotesContentByTitles(fetchedPhotoList)
                .whenComplete(() {
              // TODO: To be deleted before releasing the app
              //  After insert, update notes' content

              GlobalState
                  .selectedNoteModel.noteListWidgetForTodayState.currentState
                  .resetLoadingConfigsAfterUpdatingSqlite();

              Timer(Duration(seconds: 2), () {
                GlobalState.appState.isExecutingSync = false;
              });
            });
          }).catchError((e) {
            // String errorMessage = e;
          });
        }

        GlobalState.selectedNoteModel.noteListWidgetForTodayState.currentState
            .resetLoadingConfigsAfterUpdatingSqlite();

        Timer(Duration(seconds: 2), () {
          GlobalState.appState.isExecutingSync = false;
        });
      });
    }
  }

  void resetLoadingConfigsAfterUpdatingSqlite() {
    initLoadingConfigs();
  }

  bool _isReviewNote(DateTime nextReviewTime) {
    // Check if this note is a review note or note
    var isReviewNote = false;

    if (nextReviewTime != null) {
      isReviewNote = true;
    }

    return isReviewNote;
  }

  bool _isReviewNoteOverdue(DateTime nextReviewTime) {
    // Check if this note is overdue or note
    var isReviewNoteOverdue = false;
    var smallHoursOfToday = TimeHandler.getSmallHoursOfToday();

    // If the next review time is earlier than the small hours of today, meaning it is overdue
    if (nextReviewTime.compareTo(smallHoursOfToday) < 0) {
      isReviewNoteOverdue = true;
    }

    return isReviewNoteOverdue;
  }

  // String _showProgressLabel(NoteEntry noteEntry) {
  String _showProgressLabel(NoteWithProgressTotal noteWithProgressTotal) {
    var progressLabel = '';

    if (noteWithProgressTotal.nextReviewTime != null) {
      // Only it has the next review time, we need to show the label
      progressLabel =
          '进度：${noteWithProgressTotal.reviewProgressNo}/${noteWithProgressTotal.progressTotal}';
    }

    return progressLabel;
  }
}
