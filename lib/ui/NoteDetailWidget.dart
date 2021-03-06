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
import 'package:seal_note/model/NoteWithProgressTotal.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/ui/common/appBars/AppBarBackButtonWidget.dart';
import 'package:seal_note/ui/common/appBars/AppBarWidget.dart';
import 'package:seal_note/util/crypto/CryptoHandler.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';
import 'package:seal_note/util/dialog/FlushBarHandler.dart';
import 'package:seal_note/util/enums/EnumHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';
import 'package:seal_note/util/html/HtmlHandler.dart';
import 'package:seal_note/util/robustness/RetryHandler.dart';
import 'package:seal_note/util/route/ScaleRoute.dart';
import 'package:seal_note/util/tcb/TCBStorageHandler.dart';
import 'package:seal_note/util/time/TimeHandler.dart';
import 'package:seal_note/util/images/ImageHandler.dart';
import 'common/PhotoViewWidget.dart';
import 'package:seal_note/model/images/ImageSyncItem.dart';
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

      var showToolbar = false;

      // Check if it is in edit mode and decide we should show the toolbar or note
      if (!GlobalState.isQuillReadOnly) {
        // It is in edit mode
        showToolbar = true;
      }
      // else { // It is in read only mode
      //   GlobalState.keyboardHeight = 0.0;
      //   GlobalState.bottomPanelHeight = GlobalState.keyboardHeight;
      // }

      GlobalState.keyboardHeight = 0.0;

      // Hide keyboard event
      GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:hideKeyboard($showToolbar);");
    }, willShowKeyboard: (double keyboardHeight) {
      GlobalState.isKeyboardEventHandling = true;
      GlobalState.keyboardHeight = keyboardHeight;
      GlobalState.bottomPanelHeight = keyboardHeight;

      // Show keyboard event
      GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:showKeyboard($keyboardHeight);");
    }));
  }

  @override
  void didChangeDependencies() {
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
          // print html // trigger print // print js log method

          print(message.message);
        }), // Print
    JavascriptChannel(
        name: 'SyncVariables',
        onMessageReceived: (JavascriptMessage message) {
          // sync variables // sync js variables

          var echo = message.message;

          if (echo == 'pickerIsBeingShown = true') {
            GlobalState.pickerIsBeingShown = true;
          } else if (echo == 'pickerIsBeingShown = false') {
            GlobalState.pickerIsBeingShown = false;
          }

          print(message.message);
        }), // Sync variables between dart and js
    JavascriptChannel(
        name: 'NotifyDartWebViewHasLoaded',
        onMessageReceived: (JavascriptMessage message) {
          // notify web view load // when web view load successfully
          // webview loaded event

          GlobalState.isClickingNoteListItem = false;

          // When the web view is ready, show the first note on the note list
          if (GlobalState.screenType != 1) {
            GlobalState.noteListWidgetForTodayState.currentState
                .triggerToClickOnNoteListItem(
                    theNote: GlobalState.firstNoteToBeSelected);
          }

          // Record the status of whether the WebView is loaded or note in dart
          GlobalState.hasWebViewLoaded = true;

          // Broadcasting webView loaded event to subscribers
          Timer(const Duration(milliseconds: 2000), () {
            // Delay 2 seconds to notify subscribers, making sure that the webView loaded completely
            GlobalState.webViewLoadedEventHandler
                .notifySubscribersThatWebViewHasLoaded(
                    GlobalState.hasWebViewLoaded);
          });
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
          // multi image picker // trigger multi image picker
          // call multi picker // call image picker

          try {
            await MultiImagePicker.pickImages(maxImages: 9, enableCamera: true)
                .then((assets) async {
              var uniqueKeyString = UniqueKey().toString();
              var batchId = uniqueKeyString.substring(
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
                    await FileHandler.hasFileAtDocumentDirectory(fileName);
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
                var compressedImageUint8List =
                    await FileHandler.compressUint8List(
                  imageUint8List,
                );

                GlobalState.flutterWebviewPlugin.evalJavascript(
                    "javascript:insertImagesByMultiImagePicker($compressedImageUint8List, '$imageId', $assetsCount);");

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
          // trigger photo view // show photo view

          // Get json object from json string
          var jsonObject = json.decode(message.message);

          var imageId = jsonObject['imageId'];
          // var imageSrc = jsonObject['src'];

          // Mark the photo view is showing
          GlobalState.shouldHideWebView = true;

          print(message.message);

          // Convert image index to int
          // GlobalState.appState.firstImageIndex = int.parse(message.message);
          GlobalState.appState.firstImageIndex = imageId;

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
            var _imageSrc = latestImageSyncItemList[i].imageSrc;
            if (_imageSrc == '') {
              _imageSrc = null;
            }
            var _syncId = latestImageSyncItemList[i].syncId;

            // Record each image id for notifying js they are synced
            imageIdList.add(_imageId);

            if (_syncId == 1) {
              // For add operation

              // add image sync item to list
              GlobalState.imageSyncItemList.add(ImageSyncItem(
                  imageId: _imageId,
                  imageIndex: _imageIndex,
                  imageSrc: _imageSrc,
                  syncId: 0));
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
                ImageHandler.convertBase64ToUint8List(imageSyncItem.base64);
            imageSyncItem.base64 = null;
          }

          new Timer(const Duration(milliseconds: 500), () {
            GlobalState.appState.firstImageIndex = imageIndex;
          });
        }), // GetBase64ByImageIdFromWebView
    JavascriptChannel(
        name: 'GetAllImagesBase64FromImageFiles',
        onMessageReceived: (JavascriptMessage message) async {
          // get image base64 // set webview image base64

          var jsonString = message.message;
          var jsonResponse = jsonDecode(jsonString);
          var imageIdMapList = jsonResponse as List;

          // Get the file name of the image
          imageIdMapList.forEach((imageIdMap) async {
            var imageId = imageIdMap['imageId'].toString();
            var imageExtension = imageIdMap['imageExtension'] ?? 'jpg';
            var imageMd5FileName =
                ImageHandler.getImageMd5FileNameByImageId(imageId);
            var imageUint8List = await FileHandler
                .getFileUint8ListFromDocumentDirectoryByFileNameWithoutExtension(
                    fileNameWithoutExtension: imageMd5FileName);

            if (imageUint8List != null) {
              // When there is the image at the document directory

              var imageBase64 =
                  ImageHandler.convertUint8ListToBase64(imageUint8List);

              var imageExtensionType =
                  ImageHandler.getImageExtensionTypeByEnumValueString(
                      enumValueString: imageExtension);

              ImageHandler.updateWebViewImagesByBase64(
                  imageMd5FileNameToBeUpdated: imageMd5FileName,
                  newBase64: imageBase64,
                  imageExtensionType: imageExtensionType);

              // ImageHandler.updateWebViewImageByImageUint8List(
              //     imageUint8List: imageUint8List, imageId: imageId);
            } else {
              // When no image found at the document directory

              // Show loading gif in the WebView first when no image found
              ImageHandler.updateWebViewToShowLoadingGif(
                  imageMd5FileNameToBeUpdated: imageMd5FileName);

              // Get the right image extension by extension string
              var imageExtensionType =
                  ImageHandler.getImageExtensionTypeByEnumValueString(
                      enumValueString: imageExtension);

              updateWebViewImageByImageLoadedFromTCBAsync(
                imageMd5FileName: imageMd5FileName,
                imageExtensionType: imageExtensionType,
              );
            }
          });
        }), // GetAllImagesBase64FromImageFiles
    JavascriptChannel(
        // auto save // auto save to db
        name: 'SaveNoteToDb',
        onMessageReceived: (JavascriptMessage message) async {
          var jsonObject = json.decode(message.message);
          var newNoteEncodedHtml = jsonObject['newNoteEncodedHtml'];
          var forceToSave = jsonObject['forceToSave'];

          // Only in edit mode, we will update the note content
          if (forceToSave || !GlobalState.isQuillReadOnly) {
            // Update the note list by updating the related note model
            // GlobalState.selectedNoteModel.content = message.message;
            GlobalState.selectedNoteModel.content = newNoteEncodedHtml;
          }

          // It won't execute the save operation to db until something is changed in the note content
          if (_shouldSaveNoteToDb(forceToSave: forceToSave)) {
            // Check if this is a new note
            if (GlobalState.selectedNoteModel.id > 0) {
              // Old note

              _setToReadingOldNoteStatus(resetCounter: false);

              // Save the changes into sqlite every time
              var notesCompanion = NotesCompanion(
                  id: Value(GlobalState.selectedNoteModel.id),
                  content: Value(GlobalState.selectedNoteModel.content),
                  created: Value(GlobalState.selectedNoteModel.created),
                  updated: Value(TimeHandler.getNowForLocal()));

              // Retry to enhance the robustness
              for (var i = 0; i <= GlobalState.retryTimesToSaveDb; i++) {
                var effectedRowsCount = await GlobalState.database
                    .updateNote(notesCompanion: notesCompanion);

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
              // create new note to db // save new note to db

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
                              forceToSetBackgroundColorToFirstItemIfBackgroundNeeded:
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
        }), // SaveNoteToDb // SaveNoteEncodedHtmlToSqlite
    JavascriptChannel(
        name: 'ConfirmNoteReviewDialog',
        onMessageReceived: (JavascriptMessage message) {
          var theNote = GlobalState.selectedNoteModel;

          print(message.message);
          GlobalState.noteDetailWidgetState.currentState
              .hideWebView(forceToSyncWithShouldHideWebViewVar: false);

          // Check if the note has finished its reviews,
          // if yes, we should notify the user if he is going to review the note again.
          // See improvement: https://github.com/jims57/seal_note/issues/350
          if (theNote.isReviewFinished) {
            // When the note has finished its reviews
            AlertDialogHandler()
                .showAlertDialog(
              parentContext: GlobalState.noteDetailWidgetContext,
              captionText: '重置复习进度？',
              remark: '此笔记已经复习完成。你是否打算『重置进度』，以便重新复习（巩固记忆）？',
              centerRemark: true,
              barrierDismissible: true,
              restoreWebViewToShowIfNeeded: true,
              buttonTextForOK: '重置进度',
              buttonColorForOK: Colors.red,
              cancelAndOKButtonMainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
                .then((shouldReviewAgain) async {
              if (shouldReviewAgain) {
                var theNote = GlobalState.selectedNoteModel;

                // Record the last selected note mode for undo operation
                GlobalState.lastSelectedNoteModel =
                    GlobalState.selectedNoteModel;

                var effectedRowsCount = await GlobalState.database
                    .reviewNoteAgain(noteId: theNote.id);

                if (effectedRowsCount > 0) {
                  await _goBackToNoteListAndRefreshIt();

                  FlushBarHandler().showFlushBar(
                    title: '重置成功',
                    message: '复习时间：现在',
                    context: GlobalState.noteListPageContext,
                    showUndoButton: true,
                    callbackForUndo: () async {
                      var effectRowsCount = await _undoReviewRelatedOperation(
                          theLastSelectedNoteModel:
                              GlobalState.lastSelectedNoteModel);

                      if (effectRowsCount > 0) {
                        // Refresh the note list to reflect the change
                        GlobalState.noteListWidgetForTodayState.currentState
                            .triggerSetState(
                          forceToRefreshNoteListByDb: true,
                          refreshFolderListPageFromDbByTheWay: true,
                        );

                        FlushBarHandler().showFlushBar(
                          title: '撤消成功',
                          message: '当前复习状态：已完成',
                          context: GlobalState.noteListPageContext,
                        );
                      }
                    },
                  );
                }
              }
            });
          } else {
            // Check if this is a new note
            if (theNote.title == GlobalState.defaultTitleForNewNote) {
              theNote.title = GlobalState
                  .noteListWidgetForTodayState.currentState
                  .getNoteTitleFormatForNoteList(
                encodedContent: theNote.content,
                removeOlTagAndReplaceLiTagByPTag: true,
              );
            }

            // When it hasn't finished its reviews
            AlertDialogHandler()
                .showAlertDialog(
              // review note confirm dialog // note review confirm dialog
              parentContext: GlobalState.noteDetailWidgetContext,
              captionText: '完成这次复习？',
              remark: theNote.title,
              remarkMaxLines: 6,
              restoreWebViewToShowIfNeeded: true,
              barrierDismissible: true,
              decodeAndRemoveAllHtmlTagsForRemark: true,
              buttonTextForOK: '我已复习',
              cancelAndOKButtonMainAxisAlignment: MainAxisAlignment.spaceEvenly,
              expandRemarkToMaxFinite: false,
            )
                .then((isFinished) async {
              if (isFinished) {
                // confirm review // confirm note review
                // note review confirm event

                // Record the last selected note mode for undo operation
                GlobalState.lastSelectedNoteModel =
                    GlobalState.selectedNoteModel;

                var theNoteId = GlobalState.selectedNoteModel.id;

                var effectRowsCount = await GlobalState.database
                    .setNoteToNextReviewPhrase(theNoteId);

                if (effectRowsCount > 0) {
                  await _goBackToNoteListAndRefreshIt();

                  var nextReviewTimeFormat = await GlobalState
                      .noteDetailWidgetState.currentState
                      .getNextReviewTimeFormatByNoteId(noteId: theNoteId);

                  // Don't show next review time label, see bug: https://github.com/jims57/seal_note/issues/351
                  if (nextReviewTimeFormat.contains('完成')) {
                    nextReviewTimeFormat = '状态：复习$nextReviewTimeFormat';
                  } else {
                    nextReviewTimeFormat = '下次复习：$nextReviewTimeFormat';
                  }

                  FlushBarHandler().showFlushBar(
                      title: '复习成功',
                      message: nextReviewTimeFormat,
                      context: GlobalState.noteListPageContext,
                      showUndoButton: true,
                      callbackForUndo: () async {
                        // revert review // undo review event

                        var theLastSelectedNoteModel =
                            GlobalState.lastSelectedNoteModel;

                        var effectedRowsCount =
                            await _undoReviewRelatedOperation(
                                theLastSelectedNoteModel:
                                    GlobalState.lastSelectedNoteModel);

                        if (effectedRowsCount > 0) {
                          var dateTimeFormatOfLastSelectedNote = GlobalState
                              .noteDetailWidgetState.currentState
                              .getDateTimeFormatForNote(
                            updated: theLastSelectedNoteModel.updated,
                            nextReviewTime:
                                theLastSelectedNoteModel.nextReviewTime,
                            isReviewFinished:
                                theLastSelectedNoteModel.isReviewFinished,
                            shouldIncludeReviewKeyword: true,
                          );

                          // Refresh the note list to reflect the change
                          GlobalState.noteListWidgetForTodayState.currentState
                              .triggerSetState(
                            forceToRefreshNoteListByDb: true,
                            refreshFolderListPageFromDbByTheWay: true,
                          );

                          FlushBarHandler().showFlushBar(
                            icon: Icons.undo_outlined,
                            title: '撤消成功',
                            message: dateTimeFormatOfLastSelectedNote,
                            context: GlobalState.noteListPageContext,
                            showUndoButton: false,
                          );
                        }
                      });
                }
              }
            });
          }
        }), // ConfirmNoteReviewDialog
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

                                await clickOnDetailPageBackButton();
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
                                  // edit note detail button

                                  if (GlobalState.isQuillReadOnly) {
                                    // When it is read only mode
                                    await GlobalState
                                        .noteDetailWidgetState.currentState
                                        .setWebViewToEditMode(
                                            keepNoteDetailPageOpen: true,
                                            notifyAppStateAboutIsEditorReadOnly:
                                                true);
                                  } else {
                                    // When it is edit mode

                                    // Always to set the web view to read only mode and save the note to db
                                    await GlobalState
                                        .noteDetailWidgetState.currentState
                                        .setWebViewToReadOnlyMode(
                                            keepNoteDetailPageOpen: true,
                                            saveNoteToDbOnlyWhenHasChanges:
                                                true,
                                            notifyAppStateAboutIsEditorReadOnly:
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
                  child: Consumer<AppState>(builder: (cxt, appState, child) {
                    return Container(
                        child: (appState.hasDataInNoteListPage)
                            ? Container()
                            : Text(
                                GlobalState.tipBeforeWebViewShown,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w200),
                              ));
                  }),
                  // child: Text(
                  //   GlobalState.tipBeforeWebViewShown,
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  // ),
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

  static bool _shouldSaveNoteToDb({bool forceToSave = false}) {
    var shouldSave = false;

    if (GlobalState.selectedNoteModel != null) {
      if ((GlobalState.selectedNoteModel.content !=
                  GlobalState.noteContentEncodedInDb &&
              !GlobalState.isQuillReadOnly) ||
          forceToSave) {
        shouldSave = true;
      }
    }

    return shouldSave;
  }

  static Future<void> _goBackToNoteListAndRefreshIt() async {
    if (GlobalState.screenType == 1) {
      await GlobalState.noteDetailWidgetState.currentState
          .clickOnDetailPageBackButton();
    }

    // Refresh the note list to reflect the change
    GlobalState.noteListWidgetForTodayState.currentState.triggerSetState(
      forceToRefreshNoteListByDb: true,
      refreshFolderListPageFromDbByTheWay: true,
    );
  }

  static Future<int> _undoReviewRelatedOperation({
    @required NoteWithProgressTotal theLastSelectedNoteModel,
  }) async {
    var theNotesCompanion = NotesCompanion(
      id: Value(theLastSelectedNoteModel.id),
      nextReviewTime: Value(theLastSelectedNoteModel.nextReviewTime),
      reviewProgressNo: Value(theLastSelectedNoteModel.reviewProgressNo),
      isReviewFinished: Value(theLastSelectedNoteModel.isReviewFinished),
      updated: Value(theLastSelectedNoteModel.updated),
    );

    var effectedRowsCount = await GlobalState.database
        .updateNote(notesCompanion: theNotesCompanion);

    return effectedRowsCount;
  }

  Future<bool> _canWebViewGoBack() async {
    return await GlobalState.flutterWebviewPlugin.canGoBack();
  }

  // Public methods
  void showWebView({bool forceToSyncWithShouldHideWebViewVar = true}) {
    if (forceToSyncWithShouldHideWebViewVar) {
      GlobalState.shouldHideWebView = false;
    }

    if (GlobalState.isLoggedIn) {
      // When login

      GlobalState.flutterWebviewPlugin.show();
    } else {
      // When not login

      // Check if it is a review app, if yes, show the web view forcibly
      if (GlobalState.isReviewApp) {
        GlobalState.flutterWebviewPlugin.show();
      } else {
        GlobalState.flutterWebviewPlugin.hide();
      }
    }
  }

  void hideWebView({
    bool forceToSyncWithShouldHideWebViewVar = true,
    int retryTimes = 1,
  }) {
    if (forceToSyncWithShouldHideWebViewVar) {
      GlobalState.shouldHideWebView = true;
    }

    RetryHandler.retryExecutionWithTimerDelay(
      retryTimes: retryTimes,
      millisecondsToDelay: 100,
      callback: () {
        GlobalState.flutterWebviewPlugin.hide();
      },
    );
  }

  void restoreWebViewToShowIfNeeded() {
    if (!GlobalState.shouldHideWebView) {
      GlobalState.noteDetailWidgetState.currentState
          .showWebView(forceToSyncWithShouldHideWebViewVar: true);
    }
  }

  Future<void> setWebViewToReadOnlyMode(
      {bool keepNoteDetailPageOpen = true,
      bool saveNoteToDbOnlyWhenHasChanges = false,
      bool forceToSaveNoteToDb = false,
      bool notifyAppStateAboutIsEditorReadOnly = false,
      Future<VoidCallback> callback}) async {
    if (forceToSaveNoteToDb) {
      await saveNoteToDb(forceToSave: true, canSaveInReadOnly: true);
    } else if (saveNoteToDbOnlyWhenHasChanges) {
      await saveNoteToDb(forceToSave: false, canSaveInReadOnly: true);
    }

    if (!GlobalState.isQuillReadOnly) {
      await toggleQuillModeBetweenReadOnlyAndEdit(
          keepNoteDetailPageOpen: keepNoteDetailPageOpen,
          executeAutoSaveNoteWhenSettingToReadOnlyMode: false);

      // Show the note review button if necessary
      // Timer(const Duration(milliseconds: 1000), () async {
      //   await showNoteReviewButtonOrNot();
      // });

      await showNoteReviewButtonOrNot();

      if (notifyAppStateAboutIsEditorReadOnly) {
        GlobalState.appState.isEditorReadOnly = true;
      }

      await callback;
    }
  }

  Future<void> setWebViewToEditMode(
      {bool keepNoteDetailPageOpen = true,
      bool notifyAppStateAboutIsEditorReadOnly = false}) async {
    if (GlobalState.isQuillReadOnly) {
      await toggleQuillModeBetweenReadOnlyAndEdit(
          keepNoteDetailPageOpen: keepNoteDetailPageOpen);

      // Hide the note review button forcibly
      await hideNoteReviewButton();

      if (notifyAppStateAboutIsEditorReadOnly) {
        GlobalState.appState.isEditorReadOnly = false;
      }
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
        await saveNoteToDb(forceToSave: false, canSaveInReadOnly: true);
      }

      await GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:setQuillToReadOnly(true);");
    }

    // Switch the readonly status
    GlobalState.isQuillReadOnly = !GlobalState.isQuillReadOnly;
  }

  Future<void> saveNoteToDb({
    bool forceToSave = true,
    bool canSaveInReadOnly = false,
  }) async {
    // save note to db function // save note to db method
    // force to save note to db // save note to db

    var evalString =
        "javascript:saveNoteToDb($forceToSave, $canSaveInReadOnly);";

    await GlobalState.flutterWebviewPlugin.evalJavascript(evalString);
  }

  Future<void> setEditorHeightWithNewWebViewScreenHeight({
    @required double newWebViewScreenHeight,
    double bottomPanelHeight = 0.0,
    bool keepHeightToShowToolbar = true,
    bool goToCursorPosition = true,
  }) async {
    await GlobalState.flutterWebviewPlugin.evalJavascript(
        "javascript:setEditorHeightWithNewWebViewScreenHeight($newWebViewScreenHeight, $bottomPanelHeight, $keepHeightToShowToolbar, $goToCursorPosition);");
  }

  Future<void> triggerEditorToAutoFitScreen({
    bool goToCursorPosition = true,
  }) async {
    // adjust editor height // adjust editor to fit screen
    // edit fit screen event // auto quill height
    // trigger auto quill height // trigger quill auto height

    var keepHeightToShowToolbar = true;

    // The tool bar is only shown in edit mode
    if (GlobalState.isQuillReadOnly) {
      // When it is read only mode, don't keep height for tool bar
      keepHeightToShowToolbar = false;
    }

    var bottomPanelHeight = GlobalState.keyboardHeight;
    if (GlobalState.pickerIsBeingShown) {
      bottomPanelHeight = GlobalState.bottomPanelHeight;
    }

    await GlobalState.noteDetailWidgetState.currentState
        .setEditorHeightWithNewWebViewScreenHeight(
      newWebViewScreenHeight:
          GlobalState.screenHeight - GlobalState.appBarHeight,
      bottomPanelHeight: bottomPanelHeight,
      keepHeightToShowToolbar: keepHeightToShowToolbar,
      goToCursorPosition: goToCursorPosition,
    );
  }

  void executionCallbackToAvoidBeingBlockedByWebView(
      // This method able to make sure that the WebView won't black widget, such as Alert Dialog
      {@required VoidCallback callback}) {
    hideWebView(
      forceToSyncWithShouldHideWebViewVar: false,
      retryTimes: 10,
    );

    callback();
  }

  String getDateTimeFormatForNote({
    @required DateTime updated,
    @required DateTime nextReviewTime,
    @required bool isReviewFinished,
    bool shouldIncludeReviewKeyword = true,
  }) {
    var dateTimeFormat = TimeHandler.getDateTimeFormatForAllKindOfNote(
        updated: updated,
        nextReviewTime: nextReviewTime,
        isReviewFinished: isReviewFinished);

    if (!shouldIncludeReviewKeyword && dateTimeFormat.contains('复习')) {
      dateTimeFormat = dateTimeFormat.replaceAll('复习', '').trim();
    }

    return dateTimeFormat;
  }

  Future<String> getNextReviewTimeFormatByNoteId({@required int noteId}) async {
    // Get up-to-date note from db, since the next review time has been changed
    var theNoteEntry =
        await GlobalState.database.getNoteEntryByNoteId(noteId: noteId);

    // Get new next review time for the note
    var nextReviewTimeFormat = getDateTimeFormatForNote(
      updated: theNoteEntry.updated,
      nextReviewTime: theNoteEntry.nextReviewTime,
      isReviewFinished: theNoteEntry.isReviewFinished,
      shouldIncludeReviewKeyword: false,
    );

    return nextReviewTimeFormat;
  }

  Future<void> showNoteReviewButtonOrNot() async {
    var theNote = GlobalState.selectedNoteModel;

    // Check if it should show the note review button or not
    var dateTimeFormat = getDateTimeFormatForNote(
      updated: theNote.updated,
      nextReviewTime: theNote.nextReviewTime,
      isReviewFinished: theNote.isReviewFinished,
    );
    if (dateTimeFormat.contains('复习') && GlobalState.isQuillReadOnly) {
      await GlobalState.flutterWebviewPlugin.evalJavascript(
          "javascript:showNoteReviewButton('$dateTimeFormat');");
    } else {
      await GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:hideNoteReviewButton();");
    }
  }

  Future<void> hideNoteReviewButton() async {
    await GlobalState.flutterWebviewPlugin
        .evalJavascript("javascript:hideNoteReviewButton()");
  }

  void initSelectedNoteModelForNewNote() {
    var now = TimeHandler.getNowForLocal();

    GlobalState.selectedNoteModel.id =
        0; // Every time when clicking on the Add button, making the note id equals zero
    GlobalState.selectedNoteModel.title = GlobalState.defaultTitleForNewNote;
    GlobalState.selectedNoteModel.updated = now;
    GlobalState.selectedNoteModel.isReviewFinished = false;

    if (GlobalState.isReviewFolderSelected) {
      GlobalState.selectedNoteModel.nextReviewTime = now;
    } else {
      GlobalState.selectedNoteModel.nextReviewTime = null;
    }
  }

  Future<void> clickOnDetailPageBackButton() async {
    var canGoBack = await _canWebViewGoBack();
    if (canGoBack) {
      return await goBackWebView();
    }

    GlobalState.isHandlingNoteDetailPage = true;
    GlobalState.isInNoteDetailPage = false;

    // If the Quill is in edit mode, we set it back to read only after clicking the back button
    if (!GlobalState.isQuillReadOnly) {
      // When the note is in edit mode

      // Force to fetch the note content encoded from the WebView anyway
      var noteContentEncodedFromWebView = await GlobalState.flutterWebviewPlugin
          .evalJavascript("javascript:getNoteContentEncoded();");

      // Update the note content encoded stored at global variable
      GlobalState.selectedNoteModel.content = noteContentEncodedFromWebView;

      // Save the changes again if the user edited the note content
      if (_shouldSaveNoteToDb()) {
        await saveNoteToDb(forceToSave: true);
      }

      await toggleQuillModeBetweenReadOnlyAndEdit(
          keepNoteDetailPageOpen: false);
    }

    GlobalState.masterDetailPageState.currentState
        .updatePageShowAndHide(shouldTriggerSetState: true);

    //Refresh the note list if a new note is noted
    if (GlobalState.isEditingOrCreatingNote) {
      // If it is creating a new note, we need to refresh the note list to reflect its changes
      GlobalState.noteListWidgetForTodayState.currentState.triggerSetState(
          forceToRefreshNoteListByDb: true,
          updateNoteListPageTitle: false,
          millisecondToDelayExecution: 1500);
    }
  }

  String getDecodedNoteTitleOfSelectedNoteModel() {
    var decodedNoteTitle = '';

    if (GlobalState.selectedNoteModel != null) {
      decodedNoteTitle = HtmlHandler.decodeAndRemoveAllHtmlTags(
          GlobalState.selectedNoteModel.title);
    }

    return decodedNoteTitle;
  }

  static Future<void> updateWebViewImageByImageLoadedFromTCBAsync({
    @required String imageMd5FileName,
    @required SupportedImageExtensionType imageExtensionType,
  }) async {
    // Remark: This is a static method, since it will be executed inside JavascriptChannel() of the WebView,
    // which only support static one, so I make this method static

    // Try to load the corresponding image at TCB Storage asynchronously
    var imageExtension = EnumHandler.getEnumValue(
      enumType: imageExtensionType,
      forceToLowerCase: true,
    );
    var imageFileNameAtTCBStorage = '$imageMd5FileName.$imageExtension';

    var responseModel =
        await TCBStorageHandler.downloadFileFromTCBToDocumentDirectory(
      fileName: imageFileNameAtTCBStorage,
    );

    if (responseModel.code == ErrorCodeModel.SUCCESS_CODE) {
      // When it succeeds

      var imageBase64 =
          await ImageHandler.getImageBase64FromImageFileAtDocumentDirectory(
        fileNameWithoutExtension: imageMd5FileName,
      );

      ImageHandler.updateWebViewImagesByBase64(
          imageMd5FileNameToBeUpdated: imageMd5FileName,
          newBase64: imageBase64,
          imageExtensionType: imageExtensionType);
    } else {
      // When load failed, do nothing
    }
  }

  Future<String> removeImageSrcAttributeInWebView(
      {@required String imageId}) async {
    var responseMessage = await GlobalState.flutterWebviewPlugin.evalJavascript(
        "javascript:removeImageSrcAttributeByImageId('" + imageId + "');");

    return responseMessage;
  }

  Future<void> goBackWebView() async {
    await GlobalState.flutterWebviewPlugin.goBack();
  }

  Future<void> goBackToFirstPageForWebView() async {
    var canGoBack = await _canWebViewGoBack();

    while (canGoBack) {
      await goBackWebView();
      canGoBack = await _canWebViewGoBack();
    }
  }
}
