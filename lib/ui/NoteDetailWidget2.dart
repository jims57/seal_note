import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

// import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/DetailPageState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/converter/ImageConverter.dart';
import 'package:seal_note/util/crypto/CryptoHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';
import 'package:seal_note/util/route/ScaleRoute.dart';
import 'package:uuid/uuid.dart';

import 'common/PhotoViewWidget.dart';
import 'package:seal_note/model/ImageSyncItem.dart';

class NoteDetailWidget2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteDetailWidget2State();
  }
}

class NoteDetailWidget2State extends State<NoteDetailWidget2> {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  // final _flutterWebviewPlugin = FlutterWebviewPlugin();

  // String htmlString = '';

  int _idKeyboardListener;

  @override
  void initState() {
    super.initState();

    // if(GlobalState.flutterWebviewPlugin2 == null) {
    //   GlobalState.flutterWebviewPlugin2 = FlutterWebviewPlugin();
    // }
    GlobalState.noteDetailWidgetContext = context;

    _idKeyboardListener = _keyboardUtils.add(
        listener: KeyboardListener(willHideKeyboard: () {
          GlobalState.flutterWebviewPlugin.evalJavascript("javascript:hideKeyboard();");
        }, willShowKeyboard: (double keyboardHeight) {
          GlobalState.flutterWebviewPlugin
              .evalJavascript("javascript:showKeyboard($keyboardHeight);");
        }));

    // rootBundle.loadString('assets/QuillEditor.html').then((value) {
    //   setState(() {
    //     GlobalState.appState.widgetNo = 2;
    //     htmlString = value;
    //   });
    // });

    // GlobalState.flutterWebviewPlugin2.close();
  }

  @override
  void dispose() {
    // _flutterWebviewPlugin.dispose();

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

            if (isInMyPhone) {
              // For my phone to debug the old note
              responseJsonString =
              '{"isCreatingNote": false, "encodedHtml":"&lt;p&gt;这个是好东西2。&lt;/p&gt;&lt;p&gt;&lt;img id=&quot;f9cab6db822c98712beb4212099af82f-12c94-001&quot;&gt;&lt;/p&gt;&lt;p&gt;一样的图片。&lt;/p&gt;"}';
            } else {
              // For simulator to debug
              responseJsonString =
              '{"isCreatingNote": false, "encodedHtml":"&lt;p&gt;这个是好东西2。&lt;/p&gt;&lt;p&gt;&lt;img id=&quot;d9ddb2824e1053b4ed1c8a3633477a07-12c94-001&quot;&gt;&lt;/p&gt;&lt;p&gt;一样的图片。&lt;/p&gt;&lt;p&gt;&lt;img id=&quot;30e4bae2b5dc6bc7e922efab62543c42-12c94-002&quot;&gt;&lt;/p&gt;"}';
            }

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
                // ByteData imageBytes90 = await asset.getByteData(quality: 90);

                Uint8List imageUint8List = imageBytes.buffer.asUint8List();

                // Uint8List imageUint8List90 = imageBytes90.buffer.asUint8List();

                // Get the image md5, directly use image Uint8List as string to crypto it
                // String imageUint8ListString = imageUint8List.toString();
                // var imageMd5 =
                //     CryptoHandler.convertStringToMd5(imageUint8ListString);

                // imageId format: {imageMd5}-{batchId}-{3 bit insertOrder}
                // String imageId = '$imageMd5-$batchId-$paddedInsertOrder';
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

              // TODO: Try to insert <br> after image
              // Reorder images inserted just and remove their *data-insertorder* attribute to prevent another operation of Multi Image Picker will use it again
              // GlobalState.flutterWebviewPlugin.evalJavascript("javascript:orderImagesInserted();");
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

          // TODO: For Debug, insert an additional ImageSyncItem
//          GlobalState.imageSyncItemList.add(ImageSyncItem(imageId: '1598237287220013', imageIndex: 1, syncId: 1));
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

          // print(message.message);
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
    var s = 's';

    return Consumer<DetailPageChangeNotifier>(
      builder: (ctx, detailPageChangeNotifier, child) {
        switch (GlobalState.appState.widgetNo) {
          case 2:
            {
              // if (GlobalState.webViewScaffold == null) {
              //   GlobalState.webViewScaffold = WebviewScaffold(
              //     url: new Uri.dataFromString(GlobalState.htmlString2,
              //             mimeType: 'text/html',
              //             encoding: Encoding.getByName('utf-8'))
              //         .toString(),
              //     appBar: AppBar(
              //       // title: Text("Note detail2"),
              //       actions: [
              //         IconButton(
              //             icon: (GlobalState.isQuillReadOnly
              //                 ? Icon(Icons.edit)
              //                 : Icon(Icons.done)),
              //             onPressed: () {
              //               setState(() {
              //                 GlobalState.appState.detailPageStatus = 2;
              //                 if (GlobalState.isQuillReadOnly) {
              //                   // If it is currently in readonly mode
              //                   GlobalState.flutterWebviewPlugin.evalJavascript(
              //                       "javascript:setQuillToReadOnly(false);");
              //                 } else {
              //                   // If it is in edit mode
              //                   GlobalState.flutterWebviewPlugin.evalJavascript(
              //                       "javascript:setQuillToReadOnly(true);");
              //                 }
              //
              //                 // Switch the readonly status
              //                 GlobalState.isQuillReadOnly =
              //                     !GlobalState.isQuillReadOnly;
              //               });
              //             }),
              //         IconButton(
              //             icon: Icon(Icons.text_fields),
              //             onPressed: () {
              //               GlobalState.flutterWebviewPlugin
              //                   .evalJavascript("javascript:getPageHtml();");
              //             }),
              //         IconButton(
              //             icon: Icon(Icons.shop),
              //             onPressed: () {
              //               GlobalState.flutterWebviewPlugin.evalJavascript(
              //                   "javascript:getBase64ByImageIdFromWebView('${GlobalState.imageId}',true);");
              //             }),
              //       ],
              //     ),
              //     javascriptChannels: jsChannels,
              //     initialChild: Container(
              //       child: Center(
              //         child: Container(),
              //         // child: CircularProgressIndicator(),
              //       ),
              //     ),
              //     hidden: true,
              //     scrollBar: false,
              //     withJavascript: true,
              //     withLocalStorage: true,
              //     withZoom: false,
              //     allowFileURLs: true,
              //   );
              // } else {
              //   // GlobalState.flutterWebviewPlugin.reload();
              //   /*if (GlobalState.needRefreshWebView) {
              //   GlobalState.flutterWebviewPlugin.reload();
              //   GlobalState.needRefreshWebView = false;
              // }*/
              //   // Timer(const Duration(seconds: 5), () {
              //   //   setState(() {
              //   //     GlobalState.htmlString2 = '<div>jims58</div>';
              //   //     GlobalState.flutterWebviewPlugin.reloadUrl('http://www.baidu.com');
              //   //   });
              //   //   // GlobalState.flutterWebviewPlugin.reload();
              //   // });
              //
              // }

              // if(GlobalState.webViewScaffold !=null){
              //   GlobalState.htmlString2 = '<div>jims58</div>';
              // }

              // GlobalState.rotationCounter +=1;
              // GlobalState.htmlString2 = '${GlobalState.rotationCounter}';

              return  WebviewScaffold(
                url: new Uri.dataFromString(GlobalState.htmlString2,
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'))
                    .toString(),
                appBar: AppBar(
                  // title: Text("Note detail2"),
                  actions: [
                    IconButton(
                        icon: (GlobalState.isQuillReadOnly
                            ? Icon(Icons.edit)
                            : Icon(Icons.done)),
                        onPressed: () {
                          setState(() {
                            GlobalState.appState.detailPageStatus = 2;
                            if (GlobalState.isQuillReadOnly) {
                              // If it is currently in readonly mode
                              GlobalState.flutterWebviewPlugin.evalJavascript(
                                  "javascript:setQuillToReadOnly(false);");
                            } else {
                              // If it is in edit mode
                              GlobalState.flutterWebviewPlugin.evalJavascript(
                                  "javascript:setQuillToReadOnly(true);");
                            }

                            // Switch the readonly status
                            GlobalState.isQuillReadOnly =
                            !GlobalState.isQuillReadOnly;
                          });
                        }),
                    IconButton(
                        icon: Icon(Icons.text_fields),
                        onPressed: () {
                          GlobalState.flutterWebviewPlugin
                              .evalJavascript("javascript:getPageHtml();");
                        }),
                    IconButton(
                        icon: Icon(Icons.shop),
                        onPressed: () {
                          GlobalState.flutterWebviewPlugin.evalJavascript(
                              "javascript:getBase64ByImageIdFromWebView('${GlobalState.imageId}',true);");
                        }),
                  ],
                ),
                javascriptChannels: jsChannels,
                initialChild: Container(
                  child: Center(
                    child: Container(),
                    // child: CircularProgressIndicator(),
                  ),
                ),
                hidden: true,
                scrollBar: false,
                withJavascript: true,
                withLocalStorage: true,
                withZoom: false,
                allowFileURLs: true,
              );

              // return GlobalState.webViewScaffold2;
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
}
