import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:moor/moor.dart';
import 'package:seal_note/model/download/DownloadedFileModel.dart';
import 'package:seal_note/util/crypto/CryptoHandler.dart';
import 'package:seal_note/util/file/FileHandler.dart';

class DownloadHandler {
  static Future<DownloadedFileModel> downloadFileByUrlToDocumentDirectory({
    @required String url,
    // extensionName should be like jpg, jpeg, txt etc, without dot
    @required String extensionName,
  }) async {
    // var fileUnit8List;
    var downloadedFileModel;

    var response = await http.get(url).catchError((err) {
      return null;
    });

    // Convert url to md5 as the file name
    var fileMd5 = CryptoHandler.convertStringToMd5(url);
    var fileName = '$fileMd5.$extensionName';
    var fullFileName = await FileHandler.getFullFileNameAtDocumentDirectory(
        fileName); // Get full file name at Document Directory
    var fileUint8List = response.bodyBytes;

    // Save the downloaded file to Document Directory
    var fileObject = await File(fullFileName).writeAsBytes(fileUint8List);

    downloadedFileModel = DownloadedFileModel(
      fileMd5FileName: fileMd5,
      fullFileName: fullFileName,
      extensionName: extensionName,
      fileUint8List: fileUint8List,
      fileObject: fileObject,
    );

    return downloadedFileModel;
  }
}
