import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:moor/moor.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/DetailPageState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/ui/common/AppBarBackButtonWidget.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';
import 'package:seal_note/util/converter/ImageConverter.dart';
import 'package:seal_note/util/crypto/CryptoHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';
import 'package:seal_note/util/robustness/RetryHandler.dart';
import 'package:seal_note/util/route/ScaleRoute.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

import 'common/PhotoViewWidget.dart';
import 'package:seal_note/model/ImageSyncItem.dart';
import 'package:after_layout/after_layout.dart';

class NoteDetailWidget extends StatefulWidget {
  NoteDetailWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailWidgetState();
  }
}

class NoteDetailWidgetState extends State<NoteDetailWidget>
    with AfterLayoutMixin<NoteDetailWidget> {
  KeyboardUtils _keyboardUtils = KeyboardUtils();

  int _idKeyboardListener;

  // App bar width related
  double appBarTailWidth = 100.0;

  @override
  void initState() {
    GlobalState.appBarWidgetState = GlobalKey<AppBarWidgetState>();

    super.initState();

    if (GlobalState.flutterWebviewPlugin == null) {
      GlobalState.flutterWebviewPlugin = FlutterWebviewPlugin();
    }
    GlobalState.noteDetailWidgetContext = context;

    _idKeyboardListener = _keyboardUtils.add(
        listener: KeyboardListener(willHideKeyboard: () {
      GlobalState.isKeyboardEventHandling = true;
      GlobalState.keyboardHeight = 0.0;

      var showToolbar = false;

      // Check if it is in edit mode and decide we should show the toolbar or note
      if (!GlobalState.isQuillReadOnly) showToolbar = true;

      // Hide keyboard event
      GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:hideKeyboard($showToolbar);");
    }, willShowKeyboard: (double keyboardHeight) {
      GlobalState.isKeyboardEventHandling = true;
      GlobalState.keyboardHeight = keyboardHeight;

      // Show keyboard event
      GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:showKeyboard($keyboardHeight);");
    }));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    GlobalState.flutterWebviewPlugin.dispose();

    if (GlobalState.isInNoteDetailPageInsideScreenType1) {
      GlobalState.isInNoteDetailPageInsideScreenType1 = false;
    }

    _keyboardUtils.unsubscribeListener(subscribingId: _idKeyboardListener);
    if (_keyboardUtils.canCallDispose()) {
      _keyboardUtils.dispose();
    }

    super.dispose();
  }

  final Set<JavascriptChannel> jsChannels = [
    JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }), // Print
    JavascriptChannel(
        name: 'NotifyDartWebViewHasLoaded',
        onMessageReceived: (JavascriptMessage message) {
          GlobalState.isClickingNoteListItem = false;

          // If the WebView isn't loaded yet, we try to set the height in one second
          if (GlobalState.rotatedTimes > 0) {
            GlobalState.flutterWebviewPlugin.evalJavascript(
                "javascript:updateScreenHeight(${GlobalState.webViewHeight},${GlobalState.keyboardHeight},true);");
          }

          // Record the status of whether the WebView is loaded or note in dart
          GlobalState.hasWebViewLoaded = true;
        }), // NotifyDartWebViewHasLoaded
    JavascriptChannel(
        name: 'CheckIfOldNote',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }), // CheckIfOldNote
    JavascriptChannel(
        name: 'UpdateQuillStatus',
        onMessageReceived: (JavascriptMessage message) {
          // print(message.message);
          if (GlobalState.isQuillReadOnly) {
            GlobalState.flutterWebviewPlugin
                .evalJavascript("javascript:setQuillToReadOnly(true);");
          } else {
            GlobalState.flutterWebviewPlugin
                .evalJavascript("javascript:setQuillToReadOnly(false);");
          }
        }), // UpdateQuillStatus
    JavascriptChannel(
        // Trigger multi image picker from js
        name: 'TriggerMultiImagePickerFromJs',
        onMessageReceived: (JavascriptMessage message) async {
          try {
            await MultiImagePicker.pickImages(maxImages: 9, enableCamera: true)
                .then((assets) async {
              var batchId = UniqueKey().toString().substring(
                  2, 7); // Indicating the batch number, format: [#b0e7a]

              int insertOrder = 1;
              int assetsCount = assets.length;

              assets.forEach((asset) async {
                var imageIdentifier = asset.identifier;
                var imageMd5 =
                    CryptoHandler.convertStringToMd5(imageIdentifier);

                // Get imageId, format = timestamp+insertOrder[3 bits]
                String paddedInsertOrder =
                    insertOrder.toString().padLeft(3, '0');

                int expectedImageIndex =
                    insertOrder - 1; // Index is always less than its order

                insertOrder++;

                ByteData imageBytes = await asset.getByteData(quality: 90);

                Uint8List imageUint8List = imageBytes.buffer.asUint8List();

                // imageId format: {imageMd5}-{batchId}-{3 bit insertOrder}
                String imageId = '$imageMd5-$batchId-$paddedInsertOrder';
                GlobalState.imageId = imageId;

                // Save the image's Uint8List into a file at Document Directory
                String fileName =
                    '$imageMd5.jpg'; // Directly use imageId as the file name with .jpg extension

                // Check if the image already exists or not
                bool isFileExisting =
                    await FileHandler.checkIfFileExistsOrNot(fileName);
                if (!isFileExisting) {
                  // When the image isn't existing in Document Directory
                  FileHandler.writeUint8ListToFile(imageUint8List, fileName);
                }

                // Save the image to imageSyncList
                var imageSyncItem = ImageSyncItem(
                  imageId: imageId,
                  imageIndex: expectedImageIndex,
                  syncId: 1,
                );
                GlobalState.imageSyncItemList.add(imageSyncItem);

                // Compressing the image before passing to the WebView for the sake of performance
                FileHandler.compressUint8List(
                  imageUint8List,
                ).then((compressedImageUint8List) {
                  GlobalState.flutterWebviewPlugin.evalJavascript(
                      "javascript:insertImagesByMultiImagePicker($compressedImageUint8List, '$imageId', $assetsCount);");
                });

                insertOrder++;
              });
            });
          } on NoImagesSelectedException catch (e) {
            print('No image selected');
          } on Exception catch (e) {
            print('Other exception');
          }
        }), // TriggerMultiImagePickerFromJs
    JavascriptChannel(
        name: 'TriggerPhotoView',
        onMessageReceived: (JavascriptMessage message) {
          // view photo // click on photo event
          // click on photo event // click photo view event
          // click on photo view event // click photo event
          // show image event // show big image event

          // Mark the photo view is showing
          GlobalState.shouldHideWebView = true;

          print(message.message);

          // Convert image index to int
          GlobalState.appState.firstImageIndex = int.parse(message.message);

          GlobalState.appState.widgetNo = 2;

          Navigator.push(GlobalState.noteDetailWidgetContext,
              ScaleRoute(page: PhotoViewWidget()));

          GlobalState.noteDetailWidgetState.currentState
              .hideWebView(forceToSyncWithShouldHideWebViewVar: false);
        }), // TriggerPhotoView
    JavascriptChannel(
        name: 'SyncImageSyncArrayToDart',
        onMessageReceived: (JavascriptMessage message) {
          var jsonString = message.message;
          var jsonResponse = jsonDecode(jsonString);
          var imageSyncArray = jsonResponse['imageSyncArray'] as List;
          var shouldClearArrayInDart =
              jsonResponse['shouldClearArrayInDart'] as bool;
          var imageIdList = <String>[];

          var latestImageSyncItemList = imageSyncArray.map((imageSync) {
            var _imageSyncItem = ImageSyncItem.fromJson(imageSync);
            return _imageSyncItem;
          }).toList();

          // If the page is being initialized, we should clear all old data from imageSyncItemList to avoid duplicate data
          if (shouldClearArrayInDart) {
            GlobalState.imageSyncItemList.clear();
          }

          for (var i = 0; i < latestImageSyncItemList.length; i++) {
            var _imageId = latestImageSyncItemList[i].imageId;
            var _imageIndex = latestImageSyncItemList[i].imageIndex;
            var _syncId = latestImageSyncItemList[i].syncId;

            // Record each image id for notifying js they are synced
            imageIdList.add(_imageId);

            if (_syncId == 1) {
              // For add operation
              GlobalState.imageSyncItemList.add(ImageSyncItem(
                  imageId: _imageId, imageIndex: _imageIndex, syncId: 0));
            } else if (_syncId == 2) {
              // For deletion operation
              GlobalState.imageSyncItemList.removeWhere(
                  (imageSyncItem) => imageSyncItem.imageId == _imageId);
            } else if (_syncId == 3) {
              // Add back the image sync item that belongs to this request
              // GlobalState.imageSyncItemList.add(latestImageSyncItemList[i]);

              // For update operation
              var theImageSyncItem = GlobalState.imageSyncItemList.firstWhere(
                  (imageSyncItem) => imageSyncItem.imageId == _imageId);

              theImageSyncItem.imageIndex = _imageIndex;
              theImageSyncItem.syncId = 0;
            }
          }

          // Notify javascript that all of these image sync item have been synced successfully
          if (imageIdList.length > 0) {
            GlobalState.flutterWebviewPlugin.evalJavascript(
                "javascript:setSomeImageSyncsToSyncedStatus($imageIdList);");
          }
        }), // SyncImageSyncArrayToDart
    JavascriptChannel(
        name: 'GetBase64ByImageIdFromWebView',
        onMessageReceived: (JavascriptMessage message) {
          var imageSyncItemString = message.message;

          var imageSyncItem =
              ImageSyncItem.fromJson(json.decode(imageSyncItemString));
          var imageIndex = imageSyncItem.imageIndex;
          GlobalState.imageSyncItemList[imageIndex] = imageSyncItem;

          if (imageSyncItem.base64.isNotEmpty) {
            imageSyncItem.byteData =
                ImageConverter.convertBase64ToUint8List(imageSyncItem.base64);
            imageSyncItem.base64 = null;
          }

          new Timer(const Duration(milliseconds: 500), () {
            GlobalState.appState.firstImageIndex = imageIndex;
          });
        }), // GetBase64ByImageIdFromWebView
    JavascriptChannel(
        name: 'GetAllImagesBase64FromImageFiles',
        onMessageReceived: (JavascriptMessage message) async {
          var jsonString = message.message;
          var jsonResponse = jsonDecode(jsonString);
          var imageIdMapList = jsonResponse as List;

          // Get the file name of the image
          imageIdMapList.forEach((imageIdMap) async {
            var imageId = imageIdMap['imageId'].toString();
            var imageMd5 = imageId.substring(0, 32);
            var fileName = '$imageMd5.jpg';
            var imageUint8List =
                await FileHandler.readFileAsUint8List(fileName);

            // Anyway to compress the image before passing to the WebView
            var compressedImageUint8List = await FileHandler.compressUint8List(
                imageUint8List,
                minWidth: 250,
                minHeight: 250);

            await GlobalState.flutterWebviewPlugin.evalJavascript(
                "javascript:updateImageBase64($compressedImageUint8List,'$imageId');");
          });
        }), // GetAllImagesBase64FromImageFiles
    JavascriptChannel(
        // auto save // auto save to db
        name: 'SaveNoteToDb',
        onMessageReceived: (JavascriptMessage message) async {
          // Only in edit mode, we will update the note content
          if (!GlobalState.isQuillReadOnly) {
            // Update the note list by updating the related note model
            GlobalState.selectedNoteModel.content = message.message;
          }

          // It won't execute the save operation to db until something is changed in the note content
          if (_shouldSaveNoteToDb()) {
            // Check if this is a new note
            if (GlobalState.selectedNoteModel.id > 0) {
              // Old note

              _setToReadingOldNoteStatus(resetCounter: false);

              // Save the changes into sqlite every time
              var notesCompanion = NotesCompanion(
                  id: Value(GlobalState.selectedNoteModel.id),
                  // title: Value(GlobalState.selectedNoteModel.title),
                  content: Value(GlobalState.selectedNoteModel.content),
                  created: Value(GlobalState.selectedNoteModel.created),
                  updated: Value(TimeHandler.getNowForLocal()));

              // Retry to enhance the robustness
              for (var i = 0; i <= GlobalState.retryTimesToSaveDb; i++) {
                var effectedRowsCount =
                    await GlobalState.database.updateNote(notesCompanion);

                if (effectedRowsCount > 0) {
                  // Make sure the note is updated successfully

                  // Update the variable related to db, avoid the duplicate operation when clicking on the back button to save note again
                  GlobalState.noteContentEncodedInDb =
                      GlobalState.selectedNoteModel.content;

                  _setToReadingOldNoteStatus(resetCounter: true);

                  GlobalState.noteListWidgetForTodayState.currentState
                      .triggerSetState(forceToRefreshNoteListByDb: true);

                  break;
                }
              }
            } else {
              // Add new note

              // add new note to db // insert new note to db
              // create new note to db

              if (!GlobalState.isNewNoteBeingSaved) {
                _setToCreatingNewNoteStatus(resetCounter: false);

                // It won't save the new note unless its content isn't empty
                // if (contentText.isNotEmpty) {
                if (GlobalState.selectedNoteModel.content !=
                    GlobalState.emptyNoteEncodedContentWithBr) {
                  // Get now for local
                  var nowForLocal = TimeHandler.getNowForLocal();
                  var folderIdNoteShouldSaveTo = _getFolderIdNoteShouldSaveTo();

                  // New note
                  var noteEntry = NoteEntry(
                      id: null,
                      folderId: folderIdNoteShouldSaveTo,
                      // title: GlobalState.defaultTitleForNewNote,
                      content: GlobalState.selectedNoteModel.content,
                      created: nowForLocal,
                      updated: nowForLocal,
                      nextReviewTime: _getNextReviewTimeForNewNote(
                          nowForLocal: nowForLocal),
                      reviewProgressNo: null,
                      isReviewFinished: false,
                      isDeleted: false,
                      createdBy: GlobalState.currentUserId);

                  // Retry to enhance the robustness
                  for (var i = 0; i <= GlobalState.retryTimesToSaveDb; i++) {
                    var newNoteId =
                        await GlobalState.database.insertNote(noteEntry);

                    // Make sure the new note is inserted successfully
                    if (newNoteId > 0) {
                      GlobalState.noteContentEncodedInDb =
                          GlobalState.selectedNoteModel.content;
                      _goToUserFolderListIfCreatingNoteFromDefaultFolder(
                          folderIdNoteShouldSaveTo: folderIdNoteShouldSaveTo);
                      GlobalState.selectedNoteModel.id = newNoteId;
                      GlobalState.selectedNoteModel.created = nowForLocal;
                      _setToReadingOldNoteStatus(resetCounter: true);

                      GlobalState.noteListWidgetForTodayState.currentState
                          .triggerSetState(
                              forceToRefreshNoteListByDb: true,
                              updateNoteListPageTitle: true,
                              setBackgroundColorToFirstItemIfBackgroundNeeded:
                                  true,
                              refreshFolderListPageFromDbByTheWay: true);

                      break;
                    }
                  }
                } else {
                  _setToReadingOldNoteStatus(resetCounter: true);
                }
              }
            }
          }
        }), // SaveNoteEncodedHtmlToSqlite
  ].toSet();

  @override
  Widget build(BuildContext context) {
    // note detail build method
    return Consumer<DetailPageChangeNotifier>(
      builder: (ctx, detailPageChangeNotifier, child) {
        switch (GlobalState.appState.widgetNo) {
          case 2:
            {
              // New webView scaffold
              return WebviewScaffold(
                // return web view object
                url: new Uri.dataFromString(GlobalState.htmlString,
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'))
                    .toString(),
                appBar: AppBarWidget(
                    // detail page app bar // detail app bar
                    backgroundColor:
                        GlobalState.themeGreyColorAtiOSTodoForBackground,
                    key: GlobalState.appBarWidgetState,
                    showSyncStatus: false,
                    leadingWidth: _getAppBarLeadingWidth(),
                    tailWidth: appBarTailWidth,
                    // tailWidth: 50,
                    leadingChildren: [
                      (GlobalState.screenType == 1)
                          ? AppBarBackButtonWidget(
                              // note detail back button // detail back button
                              // detail page back button // webView back button
                              textWidth: 180.0,
                              title: '  ',
                              onTap: () async {
                                // detail page back button event // click on detail page back button
                                // click detail page back button // click on detail back button
                                // click detail back button // click detail back button event

                                GlobalState.isHandlingNoteDetailPage = true;
                                GlobalState.isInNoteDetailPage = false;

                                // If the Quill is in edit mode, we set it back to read only after clicking the back button
                                if (!GlobalState.isQuillReadOnly) {
                                  // When the note is in edit mode

                                  // Force to fetch the note content encoded from the WebView anyway
                                  var noteContentEncodedFromWebView =
                                      await GlobalState.flutterWebviewPlugin
                                          .evalJavascript(
                                              "javascript:getNoteContentEncoded();");

                                  // Update the note content encoded stored at global variable
                                  GlobalState.selectedNoteModel.content =
                                      noteContentEncodedFromWebView;

                                  // Save the changes again if the user edited the note content
                                  if (_shouldSaveNoteToDb()) {
                                    await GlobalState.flutterWebviewPlugin
                                        .evalJavascript(
                                            "javascript:saveNoteToDb(true);");
                                  }

                                  await toggleQuillModeBetweenReadOnlyAndEdit(
                                      keepNoteDetailPageOpen: false);
                                }

                                GlobalState.masterDetailPageState.currentState
                                    .updatePageShowAndHide(
                                        shouldTriggerSetState: true);

                                // Timer(const Duration(milliseconds: 1000), () {
                                //   // Force the WebView to clear its old content to speed up the next loading
                                //   GlobalState.flutterWebviewPlugin
                                //       .evalJavascript(
                                //           "javascript:clearQuillContent();");
                                // });

                                //Refresh the note list if a new note is noted
                                if (GlobalState.isEditingOrCreatingNote) {
                                  // If it is creating a new note, we need to refresh the note list to reflect its changes
                                  GlobalState
                                      .noteListWidgetForTodayState.currentState
                                      .triggerSetState(
                                          forceToRefreshNoteListByDb: true,
                                          updateNoteListPageTitle: false,
                                          millisecondToDelayExecution: 1500);
                                }
                              })
                          : Container()
                    ],
                    tailChildren: [
                      Consumer<AppState>(builder: (cxt, appState, child) {
                        if (appState.hasDataInNoteListPage) {
                          return Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                // edit web view button // edit note button
                                // web view action button // note detail edit button
                                // edit detail button // detail edit button
                                // note edit button // edit note
                                // save note button

                                icon: (GlobalState.isQuillReadOnly
                                    ? Icon(
                                        Icons.edit,
                                        color: GlobalState.themeBlueColor,
                                      )
                                    : Icon(
                                        Icons.done,
                                        color: GlobalState.themeBlueColor,
                                      )),
                                onPressed: () async {
                                  // click on save button // click save button
                                  // save button // edit button
                                  // click on edit button // click edit note button
                                  // click on edit note button // click edit button

                                  if (GlobalState.isQuillReadOnly) {
                                    await GlobalState
                                        .noteDetailWidgetState.currentState
                                        .setWebViewToEditMode(
                                            keepNoteDetailPageOpen: true);
                                  } else {
                                    // Always to set the web view to read only mode and save the note to db
                                    await GlobalState
                                        .noteDetailWidgetState.currentState
                                        .setWebViewToReadOnlyMode(
                                            keepNoteDetailPageOpen: true,
                                            forceToSaveNoteToDbIfAnyUpdates:
                                                true);
                                  }
                                }),
                          );
                        } else {
                          return Container();
                        }
                      })
                    ]),
                javascriptChannels: jsChannels,
                initialChild: Container(
                  color: GlobalState.themeGreyColorAtiOSTodoForBackground,
                  height: double.maxFinite,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: GlobalState.appBarHeight),
                  child: Text(
                    '没有选择笔记',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  ),
                ),
                hidden: true,
                scrollBar: false,
                withJavascript: true,
                withLocalStorage: true,
                withZoom: false,
                allowFileURLs: true,
              );
            }

            break;
          default:
            {
              return Container();
            }
            break;
        }
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (GlobalState.screenType != 1) {
      Timer(
          const Duration(
              milliseconds: GlobalState.millisecondToSyncWithWebView * 4), () {
        GlobalState.noteListWidgetForTodayState.currentState
            .triggerToClickOnNoteListItem(
                theNote: GlobalState.firstNoteToBeSelected);
      });
    }
  }

  // Private methods
  double _getAppBarLeadingWidth() {
    double leadingWidth = 0.0;
    double appBarWidth = 0.0;

    if (GlobalState.screenType == 1) {
      appBarWidth = GlobalState.screenWidth;
      leadingWidth = (appBarWidth - appBarTailWidth);
    } else if (GlobalState.screenType == 2) {
      appBarWidth =
          GlobalState.screenWidth - GlobalState.noteListPageDefaultWidth;
    } else {
      appBarWidth = GlobalState.screenWidth -
          GlobalState.folderPageDefaultWidth -
          GlobalState.noteListPageDefaultWidth;
    }

    return leadingWidth;
  }

  static int _getFolderIdNoteShouldSaveTo() {
    var folderId;
    var defaultFolderIds =
        GlobalState.folderListPageState.currentState.getDefaultFolderIds();

    // Check if the selected folder id is a default one
    if (defaultFolderIds.contains(GlobalState.selectedFolderIdCurrently)) {
      // When the selected folder is a default one

      // If it is a default folder, we need to save to the default folder id
      folderId = GlobalState.selectedFolderIdByDefault;
    } else {
      // When the selected folder isn't a default one
      folderId = GlobalState.selectedFolderIdCurrently;
    }

    return folderId;
  }

  static DateTime _getNextReviewTimeForNewNote({DateTime nowForLocal}) {
    var folderIdNewNoteBelongsTo = _getFolderIdNoteShouldSaveTo();
    DateTime nextReviewTime;

    if (nowForLocal == null) {
      nextReviewTime = TimeHandler.getNowForLocal();
    } else {
      nextReviewTime = nowForLocal;
    }

    var folderListItemWidget = GlobalState.folderListPageState.currentState
        .getFolderListItemWidgetByFolderId(folderId: folderIdNewNoteBelongsTo);

    if (folderListItemWidget.reviewPlanId == null) {
      nextReviewTime = null;
    }

    return nextReviewTime;
  }

  static void _setToCreatingNewNoteStatus({bool resetCounter = true}) {
    GlobalState.isNewNoteBeingSaved = true;
    if (resetCounter) _resetCounter();
  }

  static void _setToReadingOldNoteStatus({bool resetCounter = true}) {
    GlobalState.isNewNoteBeingSaved = false;
    if (resetCounter) _resetCounter();
  }

  static void _resetCounter() {
    GlobalState.flutterWebviewPlugin.evalJavascript(
        "javascript:beginToCountElapsingMillisecond(8000, true);");
  }

  static void _goToUserFolderListIfCreatingNoteFromDefaultFolder(
      {@required folderIdNoteShouldSaveTo}) {
    // If the selected folder id doesn't equal to the one the new note should be saved to
    if (GlobalState.selectedFolderIdCurrently != folderIdNoteShouldSaveTo) {
      GlobalState.isDefaultFolderSelected = false;
      GlobalState.selectedFolderIdCurrently = folderIdNoteShouldSaveTo;

      GlobalState.noteListWidgetForTodayState.currentState.triggerSetState(
          forceToRefreshNoteListByDb: true, updateNoteListPageTitle: true);
    }
  }

  static bool _shouldSaveNoteToDb() {
    var shouldSave = false;

    if (GlobalState.selectedNoteModel.content !=
            GlobalState.noteContentEncodedInDb &&
        !GlobalState.isQuillReadOnly) {
      shouldSave = true;
    }

    return shouldSave;
  }

  // Public methods
  void showWebView({bool forceToSyncWithShouldHideWebViewVar = true}) {
    if (forceToSyncWithShouldHideWebViewVar) {
      GlobalState.shouldHideWebView = false;
    }

    GlobalState.flutterWebviewPlugin.show();
  }

  void hideWebView({bool forceToSyncWithShouldHideWebViewVar = true}) {
    if (forceToSyncWithShouldHideWebViewVar) {
      GlobalState.shouldHideWebView = true;
    }

    GlobalState.flutterWebviewPlugin.hide();
  }

  Future<void> setWebViewToReadOnlyMode(
      {bool keepNoteDetailPageOpen = true,
      bool forceToSaveNoteToDbIfAnyUpdates = false,
      Future<VoidCallback> callback}) async {
    if (forceToSaveNoteToDbIfAnyUpdates) {
      await saveNoteToDb(forceToSave: forceToSaveNoteToDbIfAnyUpdates);
    }

    if (!GlobalState.isQuillReadOnly) {
      await toggleQuillModeBetweenReadOnlyAndEdit(
          keepNoteDetailPageOpen: keepNoteDetailPageOpen,
          executeAutoSaveNoteWhenSettingToReadOnlyMode: false);

      await callback;
    }
  }

  Future<void> setWebViewToEditMode(
      {bool keepNoteDetailPageOpen = true}) async {
    if (GlobalState.isQuillReadOnly) {
      await toggleQuillModeBetweenReadOnlyAndEdit(
          keepNoteDetailPageOpen: keepNoteDetailPageOpen);
    }
  }

  Future<void> toggleQuillModeBetweenReadOnlyAndEdit(
      {bool keepNoteDetailPageOpen = true,
      bool executeAutoSaveNoteWhenSettingToReadOnlyMode = true}) async {
    // toggle edit mode // toggle read only mode

    // Both edit and read only mode will view it as handling the detail page
    GlobalState.isHandlingNoteDetailPage = true;

    // Check if it keeps stay at the detail page or note after executing this
    if (keepNoteDetailPageOpen) {
      GlobalState.isInNoteDetailPage = true;
    } else {
      GlobalState.isInNoteDetailPage = false;
    }

    if (GlobalState.isQuillReadOnly) {
      // edit note // set note to edit mode

      // If it is currently in readonly mode

      GlobalState.isEditingOrCreatingNote = true;

      // Set it to the edit mode
      await GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:setQuillToReadOnly(false);");
    } else {
      // save note // set note to read only mode
      // save note event // save button execute save note

      // Set it to the read only mode

      // execute save note
      // Trigger the auto-save function to save the note
      if (executeAutoSaveNoteWhenSettingToReadOnlyMode) {
        await GlobalState.flutterWebviewPlugin
            .evalJavascript("javascript:saveNoteToDb(false, true);");
      }

      await GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:setQuillToReadOnly(true);");
    }

    // Switch the readonly status
    GlobalState.isQuillReadOnly = !GlobalState.isQuillReadOnly;

    setState(() {});
  }

  Future<void> saveNoteToDb(
      {bool forceToSave = true, bool canSaveInReadOnly = false}) async {
    // save note to db function // save note to db method

    var evalString =
        "javascript:saveNoteToDb($forceToSave, $canSaveInReadOnly);";

    await GlobalState.flutterWebviewPlugin.evalJavascript(evalString);
  }
}
