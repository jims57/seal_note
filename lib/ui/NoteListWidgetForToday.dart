import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;
import 'package:http/http.dart' as http;
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/ui/common/NoDataWidget.dart';
import 'package:seal_note/util/html/HtmlHandler.dart';
import 'package:seal_note/util/string/StringHandler.dart';
import 'package:seal_note/util/time/TimeHandler.dart';
import 'common/AlertDialogWidget.dart';
import 'common/SelectFolderWidget.dart';
import 'httper/NoteHttper.dart';

class NoteListWidgetForToday extends StatefulWidget {
  NoteListWidgetForToday({Key key}) : super(key: key);

  @override
  NoteListWidgetForTodayState createState() => NoteListWidgetForTodayState();
}

class NoteListWidgetForTodayState extends State<NoteListWidgetForToday> {
  // Configuration
  double fontSizeForFolderSelectionText = 20.0;

  List<NoteEntry> _noteEntryListForRefresh = List<NoteEntry>();
  List<NoteWithProgressTotal> _noteList = List<NoteWithProgressTotal>();

  int _pageNo;
  int _pageSize;

  int _refreshCount = 20;

  bool _isLoading;
  bool _hasMore;

  bool _isFirstLoad = true;

  // Slide options
  double _slideIconSize = 30.0;
  double _slideFontSize = 16.0;

  // Data manipulation
  NoteWithProgressTotal _noteEntryDeleted;

  // Global key
  SnackBar snackBar;

  @override
  void initState() {
    // _isFirstLoad = true;

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
                // note list page loading widget // note list loading widget
                // if (_isLoading) {

                return NoDataWidget();

                // return Container(height: 400,  child: Column(children: [NoDataWidget(),Text('b')],),);

                // if (GlobalState.isAppFirstTimeToLaunch) {
                //   return Center(
                //     child: SizedBox(
                //       child: CircularProgressIndicator(),
                //       height: 24,
                //       width: 24,
                //     ),
                //   );
                // } else {
                //   return NoDataWidget();
                // }
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
                var theNoteId = theNote.id;
                var theNoteTitle = _getNoteTitleFormatForNoteList(
                        encodedContent: theNote.content)
                    .trim();

                // Handle title if it is empty
                if (theNoteTitle.isEmpty) {
                  theNoteTitle = GlobalState.defaultTitleWhenNoteHasNoTitle;
                }

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
                              title: Text(
                                  // get note list item title
                                  '$theNoteTitle',
                                  // note list item title // note item title
                                  // get note item title // note list item title
                                  // get note list item title // note list title
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
                                    // note list item content // note item content
                                    // get note list item content // get note item content
                                    // get note list abstract // get note list item abstract
                                    // show note list abstract // format note list content
                                    // format abstract content // format note list abstract content
                                    '${_getNoteContentFormatForNoteList(encodedContent: theNote.content)}',
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

                            if (!_isInDefaultFolder() || _isInDeletedFolder())
                              SlideAction(
                                child: Container(
                                  constraints: BoxConstraints.expand(),
                                  color: !_isInDeletedFolder()
                                      ? Colors.orangeAccent
                                      : GlobalState
                                          .themeLightBlueColorAtiOSTodo,
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
                                    // swipe to move note // swipe note list item to move

                                    GlobalState.selectedNoteModel.id =
                                        theNoteId;

                                    // Get user folder list
                                    var userFolderListItemList = GlobalState
                                        .folderListPageState.currentState
                                        .getUserFolderListItemList();

                                    // We should hide the WebView first, since it isn't in the UI tree which will block the dialog widget
                                    GlobalState.flutterWebviewPlugin.hide();

                                    // Dialog info
                                    var captionText = '移动笔记？';
                                    // var remarkForMovingNote =
                                    //     '因为目标文件夹，有不同的复习计划。移动后，笔记的复习进度将会被重置！';
                                    var buttonTextForOK = '确定移动';
                                    var buttonColorForOK = Colors.red;

                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          GlobalState.currentShowDialogContext =
                                              context;

                                          return AlertDialog(
                                            titlePadding: EdgeInsets.all(0),
                                            title: Container(
                                              color: Colors.transparent,
                                              padding: EdgeInsets.only(
                                                  top: 10.0, bottom: 0.0),
                                              alignment: Alignment.center,
                                              child: Column(
                                                children: [
                                                  Text('选择文件夹'),
                                                  Divider(),
                                                  AlertDialogWidget(
                                                    // This alert dialog widget is used to append its widget to the UI tree, so that GlobalKey works
                                                    key: GlobalState
                                                        .alertDialogWidgetState,
                                                    captionText: captionText,
                                                    buttonTextForOK:
                                                        buttonTextForOK,
                                                    buttonColorForOK:
                                                        buttonColorForOK,
                                                  )
                                                ],
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                top: 0.0, bottom: 15.0),
                                            content: Container(
                                              // color: Colors.green,
                                              width: 350.0,
                                              height:
                                                  _getFolderSelectionListMaxHeight(
                                                      folderTotal:
                                                          userFolderListItemList
                                                              .length),
                                              child: ListView.builder(
                                                itemCount:
                                                    userFolderListItemList
                                                        .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var theUserFolderListItem =
                                                      userFolderListItemList[
                                                          index];

                                                  // select folder list // folder selection list
                                                  return SelectFolderWidget(
                                                    folderIcon:
                                                        theUserFolderListItem
                                                            .icon,
                                                    folderIconColor:
                                                        theUserFolderListItem
                                                            .iconColor,
                                                    folderId:
                                                        theUserFolderListItem
                                                            .folderId,
                                                    folderName:
                                                        theUserFolderListItem
                                                            .folderName,
                                                    reviewPlanId:
                                                        theUserFolderListItem
                                                            .reviewPlanId,
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        });

                                    GlobalState.flutterWebviewPlugin.show();
                                  } else {
                                    // In Deleted folder
                                    // restore deleted note // swipe to restore note

                                    var effectedRowCount = await GlobalState
                                        .database
                                        .setNoteDeletedStatus(
                                            noteId: theNote.id,
                                            isDeleted: false);

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
                                // swipe to delete note button // swipe to delete button

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

                                        // Refresh the note list page if no data at noteList variable
                                        refreshNoteListPageIfNoDataAtNoteListVariable(
                                            noteList: _noteList);
                                      });
                                    }
                                  });
                                } else {
                                  // mark note deleted status // note delete status
                                  GlobalState.database
                                      .setNoteDeletedStatus(
                                          noteId: noteIdDeleted,
                                          isDeleted: true)
                                      .then((effectedRowsCount) {
                                    if (effectedRowsCount > 0) {
                                      setState(() {
                                        _noteList.removeAt(index);

                                        // Refresh the note list page if no data at noteList variable
                                        refreshNoteListPageIfNoDataAtNoteListVariable(
                                            noteList: _noteList);

                                        if (snackBar != null) {
                                          Scaffold.of(context)
                                              .hideCurrentSnackBar();
                                        }

                                        // show delete message // show note delete message
                                        snackBar = SnackBar(
                                          content: Text(
                                              '已删除：${HtmlHandler.decodeAndRemoveAllHtmlTags(noteTitleDeleted)}'),
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
                                        );

                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
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

                    GlobalState.isInNoteDetailPage = true;
                    if (GlobalState.screenType == 1) {
                      GlobalState.isHandlingNoteDetailPage = true;
                      GlobalState.masterDetailPageState.currentState
                          .updatePageShowAndHide(shouldTriggerSetState: true);
                    } else {
                      // Screen Type = 2 or 3
                      // GlobalState.isInNoteDetailPage = true;
                    }

                    // Save the current note model as global variable
                    GlobalState.selectedNoteModel = theNote;

                    // Get note related variables
                    var folderId = theNote.folderId;
                    var noteId = theNote.id;
                    // Force to get note content from sqlite rather than from UI directly to beef up the robustness
                    var noteContent = await GlobalState.database
                        .getNoteContentById(noteId: noteId);

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
                          "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString', true);");

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
              .getFolderListItemWidgetByFolderId(
                  folderId: GlobalState.selectedFolderIdCurrently)
              .folderName;
          GlobalState.appState.noteListPageTitle = noteListPageTitle;
        }
      });
    });
  }

  void initLoadingConfigs() async {
    _pageNo = 1;
    _pageSize = 10;

    _isLoading = true;
    _hasMore = true;

    // If it is the first load, by the way to fetch data from the server
    if (_isFirstLoad) {
      _isFirstLoad = false;

      // Check if the Db has been initialized or not
      var isDbInitialized = await GlobalState.database.isDbInitialized();

      if (!isDbInitialized) {
        // Mark the app is the first time to launch
        GlobalState.isAppFirstTimeToLaunch = true;

        // If the notes table hasn't data, insert the dummy data
        fetchPhotos(client: http.Client()).then((fetchedPhotoList) {
          // initialize notes // init notes
          // note initialization // note init
          GlobalState.database
              .updateAllNotesContentByTitles(fetchedPhotoList)
              .whenComplete(() {
            GlobalState.isAppFirstTimeToLaunch = false;

            GlobalState
                .noteModelForConsumer.noteListWidgetForTodayState.currentState
                .resetLoadingConfigsAfterUpdatingSqlite();

            _refreshNoteListPageCaptionAndHideSyncStatus(
                shouldHideSyncStatus: false);
          });
        }).catchError((e) {});
      }

      GlobalState.noteModelForConsumer.noteListWidgetForTodayState.currentState
          .resetLoadingConfigsAfterUpdatingSqlite();
    }

    var noteList = await GlobalState.database
        .getNotesByPageSize(pageNo: _pageNo, pageSize: _pageSize);

    // load note list // note list first page data
    // first page note list data

    var shouldHideSyncStatus = true;

    _noteList.clear();
    _noteList.addAll(noteList);

    if (noteList.length == 0 && GlobalState.isAppFirstTimeToLaunch)
      shouldHideSyncStatus = false;
    _refreshNoteListPageCaptionAndHideSyncStatus(
        shouldHideSyncStatus: shouldHideSyncStatus);

    if (!_isLoading) _loadMore();

    setState(() {
      _isLoading = false;
    });
  }

  void resetLoadingConfigsAfterUpdatingSqlite() {
    initLoadingConfigs();
  }

  void refreshNoteListPageIfNoDataAtNoteListVariable(
      {@required List<NoteWithProgressTotal> noteList,
      int minLengthToTriggerRefresh =
          GlobalState.minLengthToTriggerRefreshForNoteListPage}) {
    if (noteList.length <= minLengthToTriggerRefresh) {
      // When the note list variable has no items inside it, try to refresh the note list anyway

      GlobalState.noteListWidgetForTodayState.currentState
          .triggerSetState(resetNoteList: true);
    }
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
          // title: title,
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

  bool _isInDefaultFolder() {
    var isDefaultFolder = false;

    if (GlobalState.isDefaultFolderSelected) isDefaultFolder = true;

    return isDefaultFolder;
  }

  bool _shouldBreakWhileLoop({@required String noteContentEncodedFromWebView}) {
    var shouldBreak = false;

    if (GlobalState.noteContentEncodedInDb.isEmpty) {
      // When the content of a note is empty
      GlobalState.noteContentEncodedInDb = noteContentEncodedFromWebView;
    } else if (!GlobalState.noteContentEncodedInDb.contains('&lt;')) {
      GlobalState.noteContentEncodedInDb =
          '&lt;p&gt;${GlobalState.noteContentEncodedInDb}&lt;/p&gt;';
    } else if (GlobalState.noteContentEncodedInDb
        .contains('color: rgba(0, 0, 0, 0.6)')) {
      // When it has '&lt;', but it is a empty note, that is: &lt;p&gt;&lt;em style=\"color: rgba(0, 0, 0, 0.6);\"&gt;添加笔记...&lt;/em&gt;&lt;/p&gt;
      GlobalState.noteContentEncodedInDb = noteContentEncodedFromWebView;
    } else if (noteContentEncodedFromWebView != '') {
      GlobalState.noteContentEncodedInDb = noteContentEncodedFromWebView;
    }

    if (noteContentEncodedFromWebView == GlobalState.noteContentEncodedInDb) {
      shouldBreak = true;
    }

    return shouldBreak;
  }

  void _refreshNoteListPageCaptionAndHideSyncStatus(
      {bool shouldHideSyncStatus = true}) async {
    // Get the note list page title
    GlobalState.appState.noteListPageTitle = await GlobalState.database
        .getFolderNameById(GlobalState.selectedFolderIdCurrently);

    // Hide the sync status on the app bar
    if (shouldHideSyncStatus) {
      Timer(const Duration(seconds: 1), () {
        GlobalState.appState.isExecutingSync = false;
      });
    }
  }

  String _getNoteTitleFormatForNoteList(
      {@required String encodedContent, int pageIndex = 0}) {
    // var noteTitle = GlobalState.defaultTitleWhenNoteHasNoTitle;
    var noteTitle = '';
    var oldEncodedContent = encodedContent;
    var pageSize = GlobalState.incrementalStepToUseRegex;
    var endLengthToTruncate = (pageIndex + 1) * pageSize;

    if (encodedContent.length >= endLengthToTruncate) {
      encodedContent = encodedContent.substring(0, endLengthToTruncate);
    } else {
      encodedContent = encodedContent.substring(0, encodedContent.length);
    }

    var htmlTagList = HtmlHandler.getHtmlTagList(
        encodedHtmlString: encodedContent,
        tagNameToMatch: 'p',
        forceToAddTagWhenNotExistent: true);

    for (var i = 0; i < htmlTagList.length; i++) {
      var theHtmlTag = htmlTagList[i];
      noteTitle += HtmlHandler.decodeAndRemoveAllHtmlTags(theHtmlTag).trim();

      // Make sure title isn't empty
      if (noteTitle.isNotEmpty) break;
    }

    // Check if it has at least a p tag as a title
    if (noteTitle.isEmpty) {
      if (oldEncodedContent.length > endLengthToTruncate) {
        noteTitle = _getNoteTitleFormatForNoteList(
            encodedContent: oldEncodedContent, pageIndex: pageIndex + 1);
      }
    }

    // Decode the html again, for sometimes some encoded characters, such as &amp; don't decode properly
    noteTitle = HtmlHandler.decodeHtmlString(noteTitle);

    return noteTitle;
  }

  String _getNoteContentFormatForNoteList(
      {@required String encodedContent, int pageIndex = 0}) {
    var noteContent = '';
    var oldEncodedContent = encodedContent;
    var pageSize = GlobalState.incrementalStepToUseRegex;
    var endLengthToTruncate = (pageIndex + 1) * pageSize;
    var title = '';
    var titleIndexAtHtmlTagList = -1;

    if (encodedContent.length >= endLengthToTruncate) {
      encodedContent = encodedContent.substring(0, endLengthToTruncate);
    } else {
      encodedContent = encodedContent.substring(0, encodedContent.length);
    }

    var htmlTagList = HtmlHandler.getHtmlTagList(
        encodedHtmlString: encodedContent,
        tagNameToMatch: 'p',
        forceToAddTagWhenNotExistent: true);

    // When there is no result, and it still has content which is not handled yet
    if (htmlTagList.length == 0 &&
        oldEncodedContent.length > endLengthToTruncate) {
      noteContent = _getNoteContentFormatForNoteList(
          encodedContent: oldEncodedContent, pageIndex: pageIndex + 1);
    }

    // We don't use index = 0, since zero index is for the title of a note
    for (var i = 0; i < htmlTagList.length; i++) {
      // So index = 1 isn't a mistake here
      var theHtmlTag = htmlTagList[i];

      // If invalid tag, just try the next one
      if ((theHtmlTag == GlobalState.emptyNoteEncodedContentWithBr ||
          theHtmlTag == GlobalState.emptyNoteEncodedContentWithoutChild)) {
        if (encodedContent.length == oldEncodedContent.length) {
          continue;
        } else {
          noteContent += _getNoteContentFormatForNoteList(
                  encodedContent: oldEncodedContent, pageIndex: pageIndex + 1)
              .replaceAll(noteContent, '');
          break;
        }
      }

      // Get title index at the list
      if (titleIndexAtHtmlTagList == -1) {
        // For title part
        title += HtmlHandler.decodeAndRemoveAllHtmlTags(theHtmlTag).trim();
        if (title.isNotEmpty) {
          titleIndexAtHtmlTagList = i;
        }

        // When is still for title but reaching the last index, we need to recurse this method
        if (oldEncodedContent.length > endLengthToTruncate &&
            i == htmlTagList.length - 1) {
          noteContent = _getNoteContentFormatForNoteList(
              encodedContent: oldEncodedContent, pageIndex: pageIndex + 1);
        }
      } else {
        // For content part
        noteContent +=
            HtmlHandler.decodeAndRemoveAllHtmlTags(theHtmlTag).trim();

        // Check if the appended note content is long enough as an abstract shown on the note list
        if (noteContent.length > GlobalState.noteListAbstractMaxLength) {
          break;
        }

        //
        if (i == htmlTagList.length - 1 &&
            noteContent.length < GlobalState.noteListAbstractMaxLength &&
            oldEncodedContent.length > endLengthToTruncate) {
          noteContent += _getNoteContentFormatForNoteList(
                  encodedContent: oldEncodedContent, pageIndex: pageIndex + 1)
              .replaceAll(noteContent, '');
        }
      }
    }

    // Decode the html again, for sometimes some encoded characters, such as &amp; don't decode properly
    noteContent = HtmlHandler.decodeHtmlString(noteContent);

    return noteContent;
  }

  double _getFolderSelectionListMaxHeight({@required int folderTotal}) {
    double maxHeight = 0.0;

    if (folderTotal > 10) {
      maxHeight = GlobalState.folderListItemHeightForFolderSelection * 10;
    } else {
      maxHeight =
          GlobalState.folderListItemHeightForFolderSelection * folderTotal;
    }

    return maxHeight;
  }
}
