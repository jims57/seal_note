import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/enums/EnumHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';

enum SupportedImageExtensionType { Jpg, Png, Gif }

class ImageHandler {
  static Future<String> getImageBase64FromImageFileAtDocumentDirectory({
    @required String fileNameWithoutExtension,
  }) async {
    var imageUint8List = await FileHandler
        .getFileUint8ListFromDocumentDirectoryByFileNameWithoutExtension(
            fileNameWithoutExtension: fileNameWithoutExtension);

    var imageBase64 = convertUint8ListToBase64(imageUint8List);

    return imageBase64;
  }

  static Uint8List convertBase64ToUint8List(String base64String) {
    return base64.decode(base64String);
  }

  static String convertUint8ListToBase64(Uint8List uint8List) {
    return base64.encode(uint8List);
  }

  static String getImageMd5FileNameByImageId(String imageId) {
    // imageId format: d9ddb2824e1053b4ed1c8a3633477a08-46503-001
    // imageMd5 file name: d9ddb2824e1053b4ed1c8a3633477a08

    return imageId.substring(0, 32);
  }

  static Future<void> updateWebViewImageByImageUint8List({
    @required Uint8List imageUint8List,
    // imageId format: d9ddb2824e1053b4ed1c8a3633477a08-46503-001
    @required String imageId,
  }) async {
    // Anyway to compress the image before passing to the WebView
    var compressedImageUint8List = await FileHandler.compressUint8List(
      imageUint8List,
      minWidth: 250,
      minHeight: 250,
    );

    // update image base64 // update base64 by image Id
    await GlobalState.flutterWebviewPlugin.evalJavascript(
        "javascript:updateImageBase64($compressedImageUint8List,'$imageId');");
  }

  static Future<void> updateWebViewImagesByBase64(
      {@required String imageMd5FileNameToBeUpdated,
      @required String newBase64,
      SupportedFileExtensionType fileExtensionType}) async {
    // Remark: https://github.com/jims57/seal_note/wiki/Methods-explanation#updateimagebase64byimagemd5filenamenewbase64-imagemd5filename

    var fileExtension = EnumHandler.getEnumValue(
      enumType: fileExtensionType,
      forceToLowerCase: true,
    );

    await GlobalState.flutterWebviewPlugin.evalJavascript(
        "javascript:updateImageBase64ByImageMd5FileName('$imageMd5FileNameToBeUpdated','$newBase64', '$fileExtension');");
  }

  static Future<void> updateWebViewImagesByAssetImage({
    @required String imageMd5FileNameToBeUpdated,
    String path = 'assets/appImages/',
    // fileName format: loading2.gif
    @required String assetImageFileNameWithoutExtension,
    @required SupportedImageExtensionType imageExtensionType,
  }) async {
    var imageExtension = EnumHandler.getEnumValue(
      enumType: imageExtensionType,
      forceToLowerCase: true,
    );
    var fileName = '$assetImageFileNameWithoutExtension.$imageExtension';

    var imageUint8List = await FileHandler.getFileUint8ListFromAssetsFolder(
      path: path,
      fileName: fileName,
    );

    var imageBase64 = convertUint8ListToBase64(imageUint8List);

    await updateWebViewImagesByBase64(
        imageMd5FileNameToBeUpdated: imageMd5FileNameToBeUpdated,
        newBase64: imageBase64);
  }
}
