import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;
import 'package:http/http.dart' as http;
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/util/html/HtmlHandler.dart';
import 'package:seal_note/util/time/TimeHandler.dart';
import 'httper/NoteHttper.dart';

class NoteListWidgetForToday extends StatefulWidget {
  NoteListWidgetForToday({Key key}) : super(key: key);

  @override
  NoteListWidgetForTodayState createState() => NoteListWidgetForTodayState();
}

class NoteListWidgetForTodayState extends State<NoteListWidgetForToday> {
  List<NoteEntry> _noteEntryListForRefresh = List<NoteEntry>();
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
                    margin: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                    child: Container(
                      child: ClipRRect(
                        // note list item round corner // round corner note list item
                        // round note list item

                        borderRadius:
                            const BorderRadius.all(const Radius.circular(10)),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            // get note list item // note list item data
                            color: Colors.white,
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                  left: 10.0,
                                  right: 10.0),
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
                                    // note list content // note list item content
                                    '${HtmlHandler.decodeAndRemoveAllHtmlTags(theNote.content).trim()}',
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
                                                      _isReviewNoteOverdue(
                                                          theNote
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
                            // elevation: 1.1,
                            // shape: RoundedRectangleBorder(
                            //   side: BorderSide.none,
                            //   // borderRadius: BorderRadius.circular(
                            //   //     GlobalState.borderRadius15),
                            // ),
                          ),
                          actions: !_shouldShowDelaySwipeItem(
                                  nextTimeTime: theNote.nextReviewTime)
                              ? []
                              : <Widget>[
                                  // note list item swipe item // note list swipe item
                                  // note list swipe actions

                                  SlideAction(
                                    child: Container(
                                      constraints: BoxConstraints.expand(),
                                      color: GlobalState.themeBlueColor,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                            // note list swipe item right part // note list right swipe items

                            SlideAction(
                              child: Container(
                                constraints: BoxConstraints.expand(),
                                color: !_isInDeletedFolder()
                                    ? Colors.orangeAccent
                                    : GlobalState.themeLightBlueColorAtiOSTodo,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      !_isInDeletedFolder()
                                          ? Icons.playlist_play
                                          : Icons.undo,
                                      size: _slideIconSize,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      !_isInDeletedFolder() ? '移动' : '还原',
                                      style: TextStyle(
                                        fontSize: _slideFontSize,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () async {
                                // swipe to restore note // restore note

                                // Check which folder is
                                if (!_isInDeletedFolder()) {
                                  // Not in Deleted folder
                                  // move note event // note note
                                  // swipe to move note

                                } else {
                                  // In Deleted folder
                                  // restore deleted note // swipe to restore note

                                  var effectedRowCount = await GlobalState
                                      .database
                                      .setNoteDeletedStatus(
                                          noteId: theNote.id, isDeleted: false);

                                  if (effectedRowCount > 0) {
                                    GlobalState.noteListWidgetForTodayState
                                        .currentState
                                        .triggerSetState(
                                            resetNoteList: true,
                                            updateNoteListPageTitle: false);
                                  }
                                }
                              },
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
                                // delete note event // swipe to delete note event

                                _noteEntryDeleted = _noteList[index];
                                var noteTitleDeleted = _noteEntryDeleted.title;
                                var noteIdDeleted = _noteEntryDeleted.id;

                                // Check if it is in Deleted folder
                                if (GlobalState.isDefaultFolderSelected &&
                                    GlobalState.appState.noteListPageTitle ==
                                        GlobalState
                                            .defaultFolderNameForDeletion) {
                                  GlobalState.database
                                      .deleteNote(noteIdDeleted)
                                      .then((effectedRowsCount) {
                                    if (effectedRowsCount > 0) {
                                      setState(() {
                                        _noteList.removeAt(index);
                                      });
                                    }
                                  });
                                } else {
                                  GlobalState.database
                                      .setNoteDeletedStatus(
                                          noteId: noteIdDeleted,
                                          isDeleted: true)
                                      .then((effectedRowsCount) {
                                    if (effectedRowsCount > 0) {
                                      setState(() {
                                        _noteList.removeAt(index);

                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content:
                                              Text('已删除：$noteTitleDeleted'),
                                          backgroundColor:
                                              GlobalState.themeBlueColor,
                                          behavior: SnackBarBehavior.fixed,
                                          action: SnackBarAction(
                                            label: '撤消',
                                            textColor: Colors.white,
                                            onPressed: () {
                                              GlobalState.database
                                                  .setNoteDeletedStatus(
                                                      noteId: noteIdDeleted,
                                                      isDeleted: false)
                                                  .then((effectedRowsCount) {
                                                if (effectedRowsCount > 0) {
                                                  setState(() {
                                                    _noteList.insert(index,
                                                        _noteEntryDeleted);
                                                  });
                                                }
                                              });
                                            },
                                          ),
                                        ));
                                      });
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    // click note list item // click on note list item
                    // click note item

                    // Save the current note model as global variable
                    GlobalState.selectedNoteModel = theNote;

                    // Get note related variables
                    var folderId = theNote.folderId;
                    var noteId = theNote.id;
                    var noteContent = theNote.content;

                    // Record the encoded content saved in db for future comparison
                    GlobalState.noteContentEncodedInDb =
                        GlobalState.selectedNoteModel.content;

                    // Click note list item
                    GlobalState.isClickingNoteListItem = true;
                    GlobalState.noteModelForConsumer.noteId = noteId;
                    GlobalState.isQuillReadOnly = true;
                    GlobalState.isEditingOrCreatingNote = false;

                    // Force to clear the water mark in the quill editor, if coming from the note list(viewing an old note)
                    await GlobalState.flutterWebviewPlugin.evalJavascript(
                        "javascript:removeQuillEditorWatermark();");

                    // Update the quill's content
                    var responseJsonString =
                        '{"isCreatingNote": false, "folderId":$folderId, "noteId":$noteId, "encodedHtml":"$noteContent"}';

                    while (true) {
                      // while loop

                      await GlobalState.flutterWebviewPlugin.evalJavascript(
                          "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString');");

                      var noteContentEncodedFromWebView =
                          await GlobalState.flutterWebviewPlugin.evalJavascript(
                              "javascript:getNoteContentEncoded();");

                      // It won't exit the while-loop except the note content from the WebView equals to the one in global variable
                      if (_shouldBreakWhileLoop(
                          noteContentEncodedFromWebView:
                              noteContentEncodedFromWebView)) {
                        break;
                      }
                    }

                    GlobalState.isInNoteDetailPage = true;
                    if (GlobalState.screenType == 1) {
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

  // Public methods
  void triggerSetState(
      {bool resetNoteList = true,
      bool updateNoteListPageTitle = false,
      int millisecondToDelayExecution = 0}) {
    // If resetNoteList = true, it will fetch data from db again to get the latest note list

    Timer(Duration(milliseconds: millisecondToDelayExecution), () {
      setState(() {
        if (resetNoteList) initLoadingConfigs();
        if (updateNoteListPageTitle) {
          var noteListPageTitle = GlobalState.folderListPageState.currentState
              .getFolderListItemWidgetById(
                  folderId: GlobalState.selectedFolderIdCurrently)
              .folderName;
          GlobalState.appState.noteListPageTitle = noteListPageTitle;
        }
      });
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
                  .noteModelForConsumer.noteListWidgetForTodayState.currentState
                  .resetLoadingConfigsAfterUpdatingSqlite();

              Timer(Duration(seconds: 2), () {
                GlobalState.appState.isExecutingSync = false;
              });
            });
          }).catchError((e) {
            // String errorMessage = e;
          });
        }

        GlobalState
            .noteModelForConsumer.noteListWidgetForTodayState.currentState
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

  List<NoteWithProgressTotal> getNoteWithProgressTotalList() {
    // Expose the note list to public so that other widgets are able to access to it
    return _noteList;
  }

  NoteWithProgressTotal getModelFromNoteWithProgressTotalList(
      {@required int noteId}) {
    // Get the specific model from the note list by a note id
    return _noteList.firstWhere((n) => n.id == noteId);
  }

  // Private method
  Future<Null> _getRefresh() async {
    // get refresh data // refresh method
    // pull to get data method // note list refresh data
    // refresh data // refresh note data

    await Future.delayed(Duration(seconds: 2));

    _noteEntryListForRefresh.clear();

    for (var i = 0; i < _refreshCount; ++i) {
      var title = '[refresh] title${i + 1}';
      var content = '[refresh] content${i + 1}';
      var now = DateTime.now().toLocal();

      var noteEntry = NoteEntry(
          id: null,
          folderId: GlobalState.selectedFolderIdCurrently,
          title: title,
          content: content,
          created: now,
          updated: now,
          isReviewFinished: false,
          isDeleted: false,
          createdBy: GlobalState.currentUserId);

      _noteEntryListForRefresh.add(noteEntry);
      // _noteEntryList.add(noteEntry);
    }

    // Insert the refreshed data in batch
    // GlobalState.database.insertNotesInBatch(_notesCompanionList).then((value) {
    GlobalState.database
        .insertNotesInBatch(_noteEntryListForRefresh)
        .then((value) {
      GlobalState.noteModelForConsumer.noteListWidgetForTodayState.currentState
          .resetLoadingConfigsAfterUpdatingSqlite();
    });
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

  String _showProgressLabel(NoteWithProgressTotal noteWithProgressTotal) {
    var progressLabel = '';

    if (noteWithProgressTotal.nextReviewTime != null) {
      // Only it has the next review time, we need to show the label
      progressLabel =
          '进度：${noteWithProgressTotal.reviewProgressNo}/${noteWithProgressTotal.progressTotal}';
    }

    return progressLabel;
  }

  bool _shouldShowDelaySwipeItem({@required nextTimeTime}) {
    // Whether it should show the delay swipe item on the note list item
    var shouldShow = true;

    if (nextTimeTime == null) shouldShow = false;

    // If it is in Deleted folder, don't show Delay item as well
    if (_isInDeletedFolder()) {
      shouldShow = false;
    }

    return shouldShow;
  }

  bool _isInDeletedFolder() {
    var isInDeletedFolder = false;

    if (GlobalState.isDefaultFolderSelected &&
        GlobalState.appState.noteListPageTitle ==
            GlobalState.defaultFolderNameForDeletion) {
      isInDeletedFolder = true;
    }

    return isInDeletedFolder;
  }

  bool _shouldBreakWhileLoop({@required String noteContentEncodedFromWebView}) {
    var shouldBreak = false;

    if (!GlobalState.noteContentEncodedInDb.contains('&lt;')) {
      GlobalState.noteContentEncodedInDb =
          '&lt;p&gt;${GlobalState.noteContentEncodedInDb}&lt;/p&gt;';
    } else {
      // When it has '&lt;', but it is a empty note, that is: &lt;p&gt;&lt;em style=\"color: rgba(0, 0, 0, 0.6);\"&gt;添加笔记...&lt;/em&gt;&lt;/p&gt;
      if (GlobalState.noteContentEncodedInDb
          .contains('color: rgba(0, 0, 0, 0.6)')) {
        GlobalState.noteContentEncodedInDb = noteContentEncodedFromWebView;
      }
    }

    if (HtmlHandler.decodeHtmlString(noteContentEncodedFromWebView) ==
        HtmlHandler.decodeHtmlString(GlobalState.noteContentEncodedInDb)) {
      shouldBreak = true;
    }

    return shouldBreak;
  }
}
