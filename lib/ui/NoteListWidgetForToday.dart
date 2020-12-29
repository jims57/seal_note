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
import 'package:seal_note/util/dialog/SnackBarHandler.dart';
import 'package:seal_note/util/html/HtmlHandler.dart';
import 'package:seal_note/util/time/TimeHandler.dart';
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

  List<NoteEntry> _noteEntryListForRefresh = <NoteEntry>[];
  List<NoteWithProgressTotal> _noteList = <NoteWithProgressTotal>[];

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
  NoteWithProgressTotal _noteEntryBeingHandled;

  // Global key
  SnackBar snackBar;

  // Delay
  DateTime
      oldNextReviewTime; // Used to record the next review time for the note which has been delayed, so that we can undo the operation

  @override
  void initState() {
    // _isFirstLoad = true;

    initLoadingConfigs();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
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

                // Hide the web view if there is no data
                if (GlobalState.isEditingOrCreatingNote) {
                  GlobalState.noteDetailWidgetState.currentState.showWebView();
                } else {
                  GlobalState.noteDetailWidgetState.currentState.hideWebView();
                }

                Timer(
                    const Duration(
                        milliseconds: GlobalState.millisecondToSyncWithWebView),
                    () {
                  GlobalState.appState.hasDataInNoteListPage = false;
                });

                return NoDataWidget();
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
                var theIndexAtNoteList = index;
                var theNote = _noteList[theIndexAtNoteList];

                // Save the first note
                if (index == 0) {
                  GlobalState.firstNoteToBeSelected = theNote;

                  // Show the web view if there is data
                  if (!GlobalState.shouldHideWebView) {
                    GlobalState.noteDetailWidgetState.currentState.showWebView(
                        forceToSyncWithShouldHideWebViewVar: false);
                  }

                  Timer(
                      const Duration(
                          milliseconds:
                              GlobalState.millisecondToSyncWithWebView), () {
                    GlobalState.appState.hasDataInNoteListPage = true;
                  });

                  // Trigger the web view to show the first note by the way
                  if (!GlobalState
                          .isNoteListSelectedAutomaticallyAfterNoteListPageLoaded &&
                      GlobalState.screenType != 1 &&
                      GlobalState.isQuillReadOnly) {
                    GlobalState
                            .isNoteListSelectedAutomaticallyAfterNoteListPageLoaded =
                        true;

                    Timer(
                        const Duration(
                            milliseconds:
                                GlobalState.millisecondToSyncWithWebView), () {
                      triggerToClickOnNoteListItem(
                          theNote: GlobalState.firstNoteToBeSelected);
                    });
                  }
                }

                // Check if the note list is the selected note currently
                var isSelectedItem = false;
                if (GlobalState.screenType != 1 &&
                    GlobalState.selectedNoteModel.id == theNote.id &&
                    theNote.id != 0) {
                  isSelectedItem = true;
                }

                var theNoteId = theNote.id;
                var theNoteTitle = _getNoteTitleFormatForNoteList(
                        encodedContent: theNote.content,
                        replaceOlTagToPTag: true)
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
                            color: (isSelectedItem)
                                ? GlobalState
                                    .themeBlueColorForSelectedItemBackground
                                : Colors.white,
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
                                          // show review time // next review time format
                                          '${TimeHandler.getDateTimeFormatForAllKindOfNote(updated: theNote.updated, nextReviewTime: theNote.nextReviewTime, isReviewFinished: theNote.isReviewFinished)}',
                                          style: TextStyle(
                                              color: (_isReviewNote(theNote
                                                          .nextReviewTime) &&
                                                      _isReviewNoteOverdue(
                                                          theNote
                                                              .nextReviewTime) &&
                                                      !theNote.isReviewFinished)
                                                  ? Colors.red
                                                  : (isSelectedItem)
                                                      ? GlobalState
                                                          .themeBlackColor87ForFontForeColor
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
                                  nextReviewTime: theNote.nextReviewTime)
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
                                    onTap: () async {
                                      // click on delay item // click delay item
                                      // delay note to review // delay note review time
                                      // swipe to delay note // swipe delay note

                                      _noteEntryBeingHandled =
                                          _noteList[theIndexAtNoteList];

                                      oldNextReviewTime =
                                          _noteEntryBeingHandled.nextReviewTime;

                                      // Get tomorrow date time
                                      var newNextReviewTime =
                                          TimeHandler.getSameTimeForTomorrow(
                                              nextReviewTime: oldNextReviewTime,
                                              forceToUseTomorrowBasedOnNow:
                                                  true);

                                      // Set the next review time to tomorrow on the same time
                                      var effectedRowCount = await GlobalState
                                          .database
                                          .updateNoteNextReviewTime(
                                              noteId: theNoteId,
                                              nextReviewTime:
                                                  newNextReviewTime);

                                      if (effectedRowCount > 0) {
                                        // When updated successfully

                                        setState(() {
                                          if (isInTodayFolder()) {
                                            _noteList
                                                .removeAt(theIndexAtNoteList);
                                          } else {
                                            _noteList[theIndexAtNoteList]
                                                    .nextReviewTime =
                                                newNextReviewTime;
                                          }
                                        });

                                        // Show the snack bar to tell the user it is successful
                                        SnackBarHandler
                                            .hideSnackBar(); // Hide the snack bar anyway to avoid the duplicate ones

                                        SnackBarHandler.createSnackBar(
                                            parentContext: context,
                                            tipAfterDone: '$theNoteTitle',
                                            actionName: '推迟到明天再复习',
                                            onPressForUndo: () async {
                                              // Undo the operation from the db
                                              var effectedRowCount =
                                                  await GlobalState.database
                                                      .updateNoteNextReviewTime(
                                                          noteId: theNoteId,
                                                          nextReviewTime:
                                                              oldNextReviewTime);

                                              if (effectedRowCount > 0) {
                                                setState(() {
                                                  if (isInTodayFolder()) {
                                                    _noteList.insert(
                                                        theIndexAtNoteList,
                                                        _noteEntryBeingHandled);
                                                  } else {
                                                    theNote.nextReviewTime =
                                                        oldNextReviewTime;
                                                  }
                                                });
                                              }
                                            });

                                        SnackBarHandler.showSnackBar();
                                      }
                                    },
                                  ),
                                ],
                          secondaryActions: <Widget>[
                            // note list swipe item right part // note list right swipe items

                            if (!isInDefaultFolder() || isInDeletedFolder())
                              SlideAction(
                                child: Container(
                                  constraints: BoxConstraints.expand(),
                                  color: !isInDeletedFolder()
                                      ? Colors.orangeAccent
                                      : GlobalState
                                          .themeLightBlueColorAtiOSTodo,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        !isInDeletedFolder()
                                            ? Icons.playlist_play
                                            : Icons.undo,
                                        size: _slideIconSize,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        !isInDeletedFolder() ? '移动' : '还原',
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
                                  // restore note event // click on restore note button
                                  // click to restore note button

                                  // Check which folder is
                                  if (!isInDeletedFolder()) {
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
                                    GlobalState
                                        .noteDetailWidgetState.currentState
                                        .hideWebView(
                                            forceToSyncWithShouldHideWebViewVar:
                                                false);

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

                                    GlobalState
                                        .noteDetailWidgetState.currentState
                                        .showWebView(
                                            forceToSyncWithShouldHideWebViewVar:
                                                false);
                                  } else {
                                    // In Deleted folder

                                    // restore deleted note // swipe to restore note

                                    var effectedRowCount = await GlobalState
                                        .database
                                        .restoreNoteFromDeletedFolder(
                                            noteId: theNoteId);

                                    if (effectedRowCount > 0) {
                                      GlobalState.noteListWidgetForTodayState
                                          .currentState
                                          .triggerSetState(
                                              forceToRefreshNoteListByDb: true,
                                              updateNoteListPageTitle: false,
                                              setBackgroundColorToFirstItemIfBackgroundNeeded:
                                                  true,
                                              refreshFolderListPageFromDbByTheWay:
                                                  true);
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
                              onTap: () async {
                                // delete note event // swipe to delete note event
                                // swipe to delete note button // swipe to delete button

                                _noteEntryBeingHandled =
                                    _noteList[theIndexAtNoteList];
                                var noteTitleDeleted =
                                    _noteEntryBeingHandled.title;
                                var noteIdDeleted = _noteEntryBeingHandled.id;
                                var effectedRowCount = 0;

                                // Check if it is in Deleted folder
                                if (GlobalState.isDefaultFolderSelected &&
                                    GlobalState.appState.noteListPageTitle ==
                                        GlobalState
                                            .defaultFolderNameForDeletion) {
                                  // delete note in deleted folder // deleted folder delete note
                                  // delete note from deleted folder

                                  effectedRowCount = await GlobalState.database
                                      .deleteNote(noteIdDeleted,
                                          forceToDeleteFolderWhenNoNote: false,
                                          autoDeleteFolderWithDeletedStatus:
                                              true);

                                  if (effectedRowCount > 0) {
                                    setState(() {
                                      _noteList.removeAt(index);

                                      // Refresh the note list page if no data at noteList variable
                                      refreshNoteListPageIfNoDataAtNoteListVariable(
                                          noteList: _noteList);
                                    });
                                  }
                                } else {
                                  // mark note deleted status // note delete status
                                  effectedRowCount = await GlobalState.database
                                      .setNoteDeletedStatus(
                                          noteId: noteIdDeleted,
                                          isDeleted: true);

                                  if (effectedRowCount > 0) {
                                    setState(() {
                                      _noteList.removeAt(index);

                                      // Refresh the note list page if no data at noteList variable
                                      refreshNoteListPageIfNoDataAtNoteListVariable(
                                          noteList: _noteList);

                                      SnackBarHandler.hideSnackBar();

                                      // show delete message // show note delete message
                                      SnackBarHandler.createSnackBar(
                                          parentContext: context,
                                          tipAfterDone: noteTitleDeleted,
                                          onPressForUndo: () async {
                                            var effectedRowCount =
                                                await GlobalState
                                                    .database
                                                    .setNoteDeletedStatus(
                                                        noteId: noteIdDeleted,
                                                        isDeleted: false);

                                            if (effectedRowCount > 0) {
                                              setState(() {
                                                _noteList.insert(index,
                                                    _noteEntryBeingHandled);
                                              });
                                            }
                                          });

                                      SnackBarHandler.showSnackBar();
                                    });
                                  }
                                }

                                // Refresh the note list page, it will set background color for the first item when needed
                                triggerSetState(
                                    forceToRefreshNoteListByDb: true,
                                    setBackgroundColorToFirstItemIfBackgroundNeeded:
                                        true,
                                    refreshFolderListPageFromDbByTheWay: true);
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

                    triggerToClickOnNoteListItem(
                        theNote: theNote,
                        forceToSaveNoteToDbIfAnyUpdates: true);

                    // always set the check button back to edit button on the web view
                    GlobalState.appState.hasDataInNoteListPage = true;
                  },
                );
              },
            )),
    );
  }

  // Public methods
  void triggerSetState(
      {bool forceToRefreshNoteListByDb = true,
      bool updateNoteListPageTitle = false,
      bool setBackgroundColorToFirstItemIfBackgroundNeeded = false,
      bool refreshFolderListPageFromDbByTheWay = false,
      int millisecondToDelayExecution = 0}) {
    // If resetNoteList = true, it will fetch data from db again to get the latest note list

    // Refresh the note list anyway, so that it will set the selected item background color
    if (setBackgroundColorToFirstItemIfBackgroundNeeded) {
      GlobalState.isNoteListSelectedAutomaticallyAfterNoteListPageLoaded =
          false;
    }

    if (refreshFolderListPageFromDbByTheWay) {
      GlobalState.folderListWidgetState.currentState
          .triggerSetState(forceToFetchFoldersFromDb: true);
    }

    Timer(Duration(milliseconds: millisecondToDelayExecution), () {
      setState(() {
        if (forceToRefreshNoteListByDb) initLoadingConfigs();
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

  bool isInDeletedFolder() {
    var isInDeletedFolder = false;

    if (GlobalState.isDefaultFolderSelected &&
        GlobalState.appState.noteListPageTitle ==
            GlobalState.defaultFolderNameForDeletion) {
      isInDeletedFolder = true;
    }

    return isInDeletedFolder;
  }

  bool isInDefaultFolder() {
    var isDefaultFolder = false;

    if (GlobalState.isDefaultFolderSelected) isDefaultFolder = true;

    return isDefaultFolder;
  }

  bool isInTodayFolder() {
    var isInTodayFolder = false;

    if (GlobalState.isDefaultFolderSelected &&
        GlobalState.appState.noteListPageTitle ==
            GlobalState.defaultFolderNameForToday) {
      isInTodayFolder = true;
    }

    return isInTodayFolder;
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
          .triggerSetState(forceToRefreshNoteListByDb: true);
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

  void removeItemFromNoteListByIndex({@required int indexAtNoteList}) {
    _noteList.removeAt(indexAtNoteList);
  }

  void triggerToClickOnNoteListItem(
      {@required NoteWithProgressTotal theNote,
      bool forceToSetWebViewReadOnlyMode = true,
      bool forceToSaveNoteToDbIfAnyUpdates = true,
      bool keepNoteDetailPageOpen = true}) async {
    GlobalState.isInNoteDetailPage = true;
    if (GlobalState.screenType == 1) {
      GlobalState.isHandlingNoteDetailPage = true;
      GlobalState.masterDetailPageState.currentState
          .updatePageShowAndHide(shouldTriggerSetState: true);
    } else {
      // For screenType = 2 or 3, we don't need to change the page show and hide
      // Screen Type = 2 or 3
    }

    if (forceToSetWebViewReadOnlyMode) {
      await GlobalState.noteDetailWidgetState.currentState
          .setWebViewToReadOnlyMode(
              keepNoteDetailPageOpen: keepNoteDetailPageOpen,
              forceToSaveNoteToDbIfAnyUpdates: forceToSaveNoteToDbIfAnyUpdates);
    }

    // Force to show the web view
    GlobalState.noteDetailWidgetState.currentState.showWebView();

    // Save the current note model as global variable
    setState(() {
      GlobalState.selectedNoteModel = theNote;
    });

    // Get note related variables
    var folderId = theNote.folderId;
    var noteId = theNote.id;
    // Force to get note content from sqlite rather than from UI directly to beef up the robustness
    var noteContent =
        await GlobalState.database.getNoteContentById(noteId: noteId);

    // Record the encoded content saved in db for future comparison
    GlobalState.noteContentEncodedInDb = GlobalState.selectedNoteModel.content;

    // Click note list item
    GlobalState.isClickingNoteListItem = true;
    GlobalState.noteModelForConsumer.noteId = noteId;
    GlobalState.isQuillReadOnly = true;
    GlobalState.isEditingOrCreatingNote = false;

    // Force to clear the water mark in the quill editor, if coming from the note list(viewing an old note)
    await GlobalState.flutterWebviewPlugin
        .evalJavascript("javascript:removeQuillEditorWatermark();");

    // Update the quill's content
    var responseJsonString =
        '{"isCreatingNote": false, "folderId":$folderId, "noteId":$noteId, "encodedHtml":"$noteContent"}';

    while (true) {
      // while loop

      await GlobalState.flutterWebviewPlugin.evalJavascript(
          "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString', true);");

      var noteContentEncodedFromWebView = await GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:getNoteContentEncoded();");

      // It won't exit the while-loop except the note content from the WebView equals to the one in global variable
      if (_shouldBreakWhileLoop(
          noteContentEncodedFromWebView: noteContentEncodedFromWebView)) {
        break;
      }
    }
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

  bool _shouldShowDelaySwipeItem({@required DateTime nextReviewTime}) {
    // Whether it should show the delay swipe item on the note list item
    var shouldShow = true;

    if (nextReviewTime == null) {
      shouldShow = false;
    } else {
      // When the nextReviewTime isn't null
      var smallHoursOfTomorrow = TimeHandler.getSmallHoursOfTomorrow();

      if (nextReviewTime.isAfter(smallHoursOfTomorrow)) {
        shouldShow = false;
      }
    }

    // If it is in Deleted folder, don't show Delay item as well
    if (isInDeletedFolder()) {
      shouldShow = false;
    }

    return shouldShow;
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
      {@required String encodedContent,
      int pageIndex = 0,
      replaceOlTagToPTag = false}) {
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

    // Force to replace <ol> to <p>
    if (replaceOlTagToPTag) {
      encodedContent = encodedContent
          .replaceAll('&lt;ol&gt;', '&lt;p&gt;')
          .replaceAll('&lt;/ol&gt;', '&lt;/p&gt;');
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
