import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/images/CachedImageItem.dart';
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
    // forceToLoadItFromAssetImage = true, it will ignore the cached image in memory and load it again forcibly from the asset folder
    bool forceToLoadItFromAssetImage = false,
  }) async {
    var imageExtension = EnumHandler.getEnumValue(
      enumType: imageExtensionType,
      forceToLowerCase: true,
    );
    var fileName = '$assetImageFileNameWithoutExtension.$imageExtension';
    var imageUint8List;

    // Check if there is the image cached at GlobalState
    // GlobalState.cachedImageItemList.contains(element)
    var cachedImageItem = GlobalState.cachedImageItemList.firstWhere(
        (cachedImageItem) =>
            cachedImageItem.imageMd5FileName ==
            assetImageFileNameWithoutExtension, orElse: () {
      return CachedImageItem(
          imageMd5FileName: assetImageFileNameWithoutExtension,
          imageUint8List: null);
    });

    if (cachedImageItem.imageUint8List == null || forceToLoadItFromAssetImage) {
      // When the image isn't cached yet, or load it forcibly according to the parameter

      // Load it as Unit8List from the asset folder
      imageUint8List = await FileHandler.getFileUint8ListFromAssetsFolder(
        path: path,
        fileName: fileName,
      );

      // Cache it to GlobalState
      if (imageUint8List != null) {
        GlobalState.cachedImageItemList.add(CachedImageItem(
          imageMd5FileName: assetImageFileNameWithoutExtension,
          imageUint8List: imageUint8List,
        ));
      }
    } else {
      // When the image has been cached

      imageUint8List = cachedImageItem.imageUint8List;
    }

    var s = 's';

    var imageBase64 = convertUint8ListToBase64(imageUint8List);

    await updateWebViewImagesByBase64(
        imageMd5FileNameToBeUpdated: imageMd5FileNameToBeUpdated,
        newBase64: imageBase64);
  }

  static Future<void> updateWebViewToShowLoadingGif(
      {@required String imageMd5FileNameToBeUpdated}) async {
    await ImageHandler.updateWebViewImagesByAssetImage(
      imageMd5FileNameToBeUpdated: imageMd5FileNameToBeUpdated,
      assetImageFileNameWithoutExtension:
          GlobalState.loadingGifFileNameWithoutExtension,
      imageExtensionType: SupportedImageExtensionType.Gif,
      forceToLoadItFromAssetImage: false,
    );
  }

  static SupportedImageExtensionType getImageExtensionTypeByEnumValueString(
      {@required String enumValueString}) {
    var imageExtensionType;
    enumValueString = enumValueString.toLowerCase();

    switch (enumValueString) {
      case 'jpg':
        {
          imageExtensionType = SupportedImageExtensionType.Jpg;
        }
        break;
      case 'png':
        {
          imageExtensionType = SupportedImageExtensionType.Png;
        }
        break;
      default:
        {
          imageExtensionType = SupportedImageExtensionType.Gif;
        }
        break;
    }

    return imageExtensionType;
  }
}
