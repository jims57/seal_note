import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/DetailPageState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/AppBarBackButtonWidget.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';
import 'package:seal_note/util/converter/ImageConverter.dart';
import 'package:seal_note/util/crypto/CryptoHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';
import 'package:seal_note/util/route/ScaleRoute.dart';

import 'common/PhotoViewWidget.dart';
import 'package:seal_note/model/ImageSyncItem.dart';
import 'package:after_layout/after_layout.dart';

class NoteDetailWidget extends StatefulWidget {
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
  double appBarTailWidth = 90.0;

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

          var requestJson = json.decode(message.message);

          var responseJsonString;

          if (GlobalState.isCreatingNote) {
            // If it is create a new note
            // Need to replace the Quill's content with the encoded html from the note
            responseJsonString = '{"isCreatingNote": true, "encodedHtml":""}';

            GlobalState.flutterWebviewPlugin.evalJavascript(
                "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString');");
          } else {
            // If it is an old note

            // Check which dummy data should be used
            var isInMyPhone = requestJson['isInMyPhone'];

            // if (isInMyPhone) {
            //   // For my phone to debug the old note
            //   responseJsonString =
            //       '{"isCreatingNote": false, "encodedHtml":"&lt;p&gt;jim这个是好东西&lt;br&gt;2&lt;/br&gt;这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西这个是好东西224。&lt;/p&gt;&lt;p&gt;&lt;img id=&quot;f9cab6db822c98712beb4212099af82f-12c94-001&quot;&gt;&lt;/p&gt;&lt;p&gt;一样的图片。&lt;/p&gt;"}';
            // } else {
            //   // For simulator to debug
            //   responseJsonString =
            //       '{"isCreatingNote": false, "encodedHtml":"&lt;p&gt;这个是好东西&lt;br&gt;2。&lt;/p&gt;&lt;p&gt;&lt;img id=&quot;d9ddb2824e1053b4ed1c8a3633477a07-12c94-001&quot;&gt;&lt;/p&gt;&lt;p&gt;一样的图片。&lt;/p&gt;&lt;p&gt;&lt;img id=&quot;30e4bae2b5dc6bc7e922efab62543c42-12c94-002&quot;&gt;&lt;/p&gt;"}';
            // }

            GlobalState.flutterWebviewPlugin.evalJavascript(
                "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString');");
          }
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
                // byteData: imageUint8List);
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
          print(message.message);

          // Convert image index to int
          GlobalState.appState.firstImageIndex = int.parse(message.message);

          GlobalState.appState.widgetNo = 2;

          Navigator.push(GlobalState.noteDetailWidgetContext,
              ScaleRoute(page: PhotoViewWidget()));

          GlobalState.flutterWebviewPlugin.hide();
        }), // TriggerPhotoView
    JavascriptChannel(
        name: 'SyncImageSyncArrayToDart',
        onMessageReceived: (JavascriptMessage message) {
          var jsonString = message.message;
          var jsonResponse = jsonDecode(jsonString);
          var imageSyncArray = jsonResponse['imageSyncArray'] as List;
          var shouldClearArrayInDart =
              jsonResponse['shouldClearArrayInDart'] as bool;
          var imageIdList = List<String>();

          // If the page is being initialized, we should clear all old data from imageSyncItemList to avoid duplicate data
          if (shouldClearArrayInDart) GlobalState.imageSyncItemList.clear();

          var latestImageSyncItemList = imageSyncArray.map((imageSync) {
            var _imageSyncItem = ImageSyncItem.fromJson(imageSync);
            return _imageSyncItem;
          }).toList();

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
        onMessageReceived: (JavascriptMessage message) {
          var jsonString = message.message;
          var jsonResponse = jsonDecode(jsonString);
          var imageIdMapList = jsonResponse as List;

          // Get the file name of the image
          imageIdMapList.forEach((imageIdMap) {
            var imageId = imageIdMap['imageId'].toString();
            var imageMd5 = imageId.substring(0, 32);
            var fileName = '$imageMd5.jpg';
            FileHandler.readFileAsUint8List(fileName).then((imageUint8List) {
              // Anyway to compress the image before passing to the WebView
              FileHandler.compressUint8List(imageUint8List,
                      minWidth: 250, minHeight: 250)
                  .then((compressedImageUint8List) {
                GlobalState.flutterWebviewPlugin.evalJavascript(
                    "javascript:updateImageBase64($compressedImageUint8List,'$imageId');");
              });
            });
          });
        }), // GetAllImagesBase64FromImageFiles
    JavascriptChannel(
        name: 'SaveNoteEncodedHtmlToSqlite',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);

          GlobalState.flutterWebviewPlugin.evalJavascript(
              "javascript:beginToCountElapsingMillisecond(500, true);");
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
                    leadingWidth: getAppBarLeadingWidth(),
                    tailWidth: appBarTailWidth,
                    leadingChildren: [
                      (GlobalState.screenType == 1)
                          ? AppBarBackButtonWidget(
                              // note detail back button // detail back button
                              // detail page back button // webView back button
                              textWidth: 180.0,
                              // title: '英语知识',
                              title: '  ',
                              onTap: () {
                                GlobalState.isHandlingNoteDetailPage = true;
                                GlobalState.isInNoteDetailPage = false;

                                // If the Quill is in edit mode, we set it back to read only after clicking the back button
                                if (!GlobalState.isQuillReadOnly)
                                  toggleQuillModeBetweenReadOnlyAndEdit(
                                      keepNoteDetailPageOpen: false);

                                GlobalState.masterDetailPageState.currentState
                                    .updatePageShowAndHide(
                                        shouldTriggerSetState: true);
                              })
                          : Container()
                    ],
                    tailChildren: [
                      // edit web view button // edit note button
                      // web view action button // note detail edit button
                      // edit detail button // detail edit button
                      IconButton(
                          icon: (GlobalState.isQuillReadOnly
                              ? Icon(
                                  Icons.edit,
                                  color: GlobalState.themeBlueColor,
                                )
                              : Icon(
                                  Icons.done,
                                  color: GlobalState.themeBlueColor,
                                )),
                          onPressed: () {
                            toggleQuillModeBetweenReadOnlyAndEdit(
                                keepNoteDetailPageOpen: true);
                          }),
                      IconButton(
                          // web view test button // test button // run button // test run button
                          icon: Icon(
                            Icons.directions_run,
                            color: GlobalState.themeBlueColor,
                          ),
                          onPressed: () {
                            var responseJsonString =
                                '{"isCreatingNote": false, "folderId":3, "noteId":4, "encodedHtml":"&lt;p&gt;2jim这个是好东西&lt;br&gt;2&lt;/br&gt;这是好东西224。&lt;/p&gt;&lt;p&gt;&lt;img id=&quot;d9ddb2824e1053b4ed1c8a3633477a07&quot;&gt;&lt;/p&gt;&lt;p&gt;一样的图片。&lt;/p&gt;"}';
                                // '{"isCreatingNote": false, "folderId":3, "noteId":4, "encodedHtml":""}';

                            GlobalState.flutterWebviewPlugin.evalJavascript(
                                "javascript:replaceQuillContentWithOldNoteContent('$responseJsonString');");
                          }),
                    ]),
                javascriptChannels: jsChannels,
                initialChild: Container(
                  color: GlobalState.themeGreyColorAtiOSTodoForBackground,
                  child: Center(
                    child: Container(),
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
  void afterFirstLayout(BuildContext context) {}

// Private methods
  void toggleQuillModeBetweenReadOnlyAndEdit(
      {bool keepNoteDetailPageOpen = true}) {
    // toggle edit mode // toggle read only mode

    setState(() {
      // Both edit and read only mode will view it as handling the detail page
      GlobalState.isHandlingNoteDetailPage = true;

      // Check if it keeps stay at the detail page or note after executing this
      if (keepNoteDetailPageOpen) {
        GlobalState.isInNoteDetailPage = true;
      } else {
        GlobalState.isInNoteDetailPage = false;
      }

      if (GlobalState.isQuillReadOnly) {
        // If it is currently in readonly mode

        // Set it to the edit mode
        GlobalState.flutterWebviewPlugin
            .evalJavascript("javascript:setQuillToReadOnly(false);");
      } else {
        // If it is in edit mode

        // Set it to the read only mode

        GlobalState.flutterWebviewPlugin
            .evalJavascript("javascript:setQuillToReadOnly(true);");
      }

      // Switch the readonly status
      GlobalState.isQuillReadOnly = !GlobalState.isQuillReadOnly;
    });
  }

  double getAppBarLeadingWidth() {
    double leadingWidth = 0.0;
    double appBarWidth = 0.0;

    if (GlobalState.screenType == 1) {
      appBarWidth = GlobalState.screenWidth;
    } else if (GlobalState.screenType == 2) {
      appBarWidth =
          GlobalState.screenWidth - GlobalState.noteListPageDefaultWidth;
    } else {
      appBarWidth = GlobalState.screenWidth -
          GlobalState.folderPageDefaultWidth -
          GlobalState.noteListPageDefaultWidth;
    }

    leadingWidth = (appBarWidth - appBarTailWidth);

    return leadingWidth;
  }
}
