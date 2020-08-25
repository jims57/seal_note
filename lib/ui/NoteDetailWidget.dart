import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:keyboard_utils/keyboard_listener.dart';
import 'package:keyboard_utils/keyboard_utils.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/Note.dart';
import 'package:seal_note/util/route/ScaleRoute.dart';

import 'common/PhotoViewWidget.dart';

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

  bool _isWebViewInitialized = false;

//  int _firstPageIndex = 0 ;
//  String _imageId = '';

  @override
  void initState() {
    super.initState();

    GlobalState.flutterWebviewPlugin = _flutterWebviewPlugin;
    GlobalState.noteDetailWidgetContext = context;
//    GlobalState.myWebViewPluginContext = context;

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
              GlobalState.imageDataList.clear();

              int timestamp = DateTime.now().millisecondsSinceEpoch;
              int insertOrder = 1;
              int assetsCount = assets.length;

              assets.forEach((asset) async {
                // Get imageId, format = timestamp+insertOrder[3 bits]
                String paddedInsertOrder =
                    insertOrder.toString().padLeft(3, '0');
                String imageId = '$timestamp$paddedInsertOrder';
                GlobalState.imageId = imageId;

//                int theInsertOrder = insertOrder;
                insertOrder++;

                ByteData byteData = await asset.getByteData(quality: 20);

                ByteData imageByteData = byteData;
                Uint8List imageData = imageByteData.buffer.asUint8List();

                // [TEST]
//                if (GlobalState.tempImageDataList.length <= 1) {
//                  AssetImage assetImage =
//                      AssetImage("assets/appImages/loading.gif");
////                  a
//
//                  GlobalState.tempImageDataList.add(imageData);
//                }
                // [END TEST]

                GlobalState.imageDataList.add(imageData);

                GlobalState.flutterWebviewPlugin.evalJavascript(
                    "javascript:insertImagesByMultiImagePicker($imageData, '$imageId', $assetsCount);");
              });

              // Reorder images inserted just and remove their *data-insertorder* attribute to prevent another operation of Multi Image Picker will use it again
//              GlobalState.flutterWebviewPlugin.evalJavascript("javascript:orderImagesInserted();");
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
          GlobalState.firstImageIndex = int.parse(message.message);

          GlobalState.appState.widgetNo = 2;

          Navigator.push(
              GlobalState.noteDetailWidgetContext,
              ScaleRoute(
                  page: PhotoViewWidget(
                firstImageIndex: GlobalState.firstImageIndex,
              )));

          GlobalState.flutterWebviewPlugin.hide();
        }), // TriggerPhotoView
    JavascriptChannel(
        name: 'GetBase64ByImageId',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
        }), //
    JavascriptChannel(
        name: 'SyncImagesSyncArrayToDart',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
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

              //GlobalState.flutterWebviewPlugin.evalJavascript("javascript:setQuillToEditMode(false);");

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
