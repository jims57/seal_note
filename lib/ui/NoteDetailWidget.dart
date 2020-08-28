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
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/converter/ImageConverter.dart';
import 'package:seal_note/util/route/ScaleRoute.dart';

import 'common/PhotoViewWidget.dart';
import 'package:seal_note/model/ImageSyncItem.dart';

class NoteDetailWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteDetailWidgetState();
  }
}

class NoteDetailWidgetState extends State<NoteDetailWidget> {
  KeyboardUtils _keyboardUtils = KeyboardUtils();
  final _flutterWebviewPlugin = FlutterWebviewPlugin();

  String htmlString = '';

  int _idKeyboardListener;

  @override
  void initState() {
    super.initState();

    GlobalState.flutterWebviewPlugin = _flutterWebviewPlugin;
    GlobalState.noteDetailWidgetContext = context;

    _idKeyboardListener = _keyboardUtils.add(
        listener: KeyboardListener(willHideKeyboard: () {
      _flutterWebviewPlugin.evalJavascript("javascript:hideKeyboard();");
    }, willShowKeyboard: (double keyboardHeight) {
      _flutterWebviewPlugin
          .evalJavascript("javascript:showKeyboard($keyboardHeight);");
    }));

    rootBundle.loadString('assets/QuillEditor.html').then((value) {
      setState(() {
        GlobalState.appState.widgetNo = 2;
        htmlString = value;
      });
    });

    _flutterWebviewPlugin.close();
  }

  @override
  void dispose() {
    _flutterWebviewPlugin.dispose();

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
        name: 'UpdateQuillStatus',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
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
              int timestamp = DateTime.now().millisecondsSinceEpoch;
              int insertOrder = 1;
              int assetsCount = assets.length;

              assets.forEach((asset) async {
                // Get imageId, format = timestamp+insertOrder[3 bits]
                String paddedInsertOrder =
                    insertOrder.toString().padLeft(3, '0');

                int expectedImageIndex = insertOrder - 1; // Index is always less than its order

                insertOrder++;

                String imageId = '$timestamp$paddedInsertOrder';
                GlobalState.imageId = imageId;

                ByteData imageBytes = await asset.getByteData(quality: 80);

                Uint8List imageUint8List = imageBytes.buffer.asUint8List();

                // Save the image to imageSyncList
                var imageSyncItem = ImageSyncItem(
                    imageId: imageId,
                    imageIndex: expectedImageIndex,
                    syncId: 1,
                    byteData: imageUint8List);
                GlobalState.imageSyncItemList.add(imageSyncItem);

                GlobalState.flutterWebviewPlugin.evalJavascript(
                    "javascript:insertImagesByMultiImagePicker($imageUint8List, '$imageId', $assetsCount);");

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
        name: 'GetBase64ByImageId',
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
        }), // GetBase64ByImageId
  ].toSet();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (ctx, appState, child) {
        switch (GlobalState.appState.widgetNo) {
          case 2:
            {
              var wewbviewScaffold = WebviewScaffold(
                url: new Uri.dataFromString(htmlString,
                        mimeType: 'text/html',
                        encoding: Encoding.getByName('utf-8'))
                    .toString(),
                appBar: AppBar(
                  title: Text("Note detail2"),
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
                              "javascript:getBase64ByImageId('${GlobalState.imageId}',true);");
                        }),
                  ],
                ),
                javascriptChannels: jsChannels,
                initialChild: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                hidden: true,
                scrollBar: false,
                withJavascript: true,
                withLocalStorage: true,
                withZoom: false,
                allowFileURLs: true,
              );

              return wewbviewScaffold;
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
