import 'dart:io';

// import 'dart:io' show io ;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  static Future<String> get _documentDirectoryPath async {
    final directory = await getApplicationDocumentsDirectory();

    print(directory.path);

    return directory.path;
  }

  static Future<String> _getFullFileNameAtDocumentDirectory(
      String fileName) async {
    final path = await _documentDirectoryPath;

    String fullFileName = '$path/$fileName';

    return fullFileName;
  }

  static Future<File> _getFileObjectAtDocumentDirectory(String fileName) async {
    // final path = await _documentDirectoryPath;
    // String fullFileName = '$path/$fileName';

    var fullFileName = await _getFullFileNameAtDocumentDirectory(fileName);

    // print(fullFileName);
    return File(fullFileName);
  }

  static Future<bool> deleteFileFromDocumentDirectory({String fileName}) async {
    var isSuccessful;
    var fileObject = await _getFileObjectAtDocumentDirectory(fileName);

    if (fileObject.existsSync()) {
      // delete file
      await fileObject
          .delete(
        recursive: true,
      )
          .then((fileSystemEntity) {
        isSuccessful = true;
      }).catchError((err) {
        isSuccessful = false;
      });
    }

    return isSuccessful;

    // var hasFile = await hasFileAtDocumentDirectory(fileName);
    // if(hasFile){
    //   var fileObject = await _getFileObjectAtDocumentDirectory(fileName);
    //   var fileSystemEntity = await fileObject.delete(recursive: true,);
    //   fileSystemEntity.
    // }
  }

  static Future<bool> hasFileAtDocumentDirectory(String fileName) async {
    var file = await _getFileObjectAtDocumentDirectory(fileName);
    var filePath = file.path;
    var existOrNot = File(filePath).exists();
    return existOrNot;
  }

  static Future<String> readFileContentAsString(String fileName) async {
    try {
      final file = await _getFileObjectAtDocumentDirectory(fileName);

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  static Future<Uint8List> readFileAsUint8List(String fileName) async {
    try {
      final file = await _getFileObjectAtDocumentDirectory(fileName);

      // Read the file
      Uint8List contents = await file.readAsBytes();

      return contents;
    } catch (e) {
      return null;
    }
  }

  static Future<File> writeStringToFile(
      String stringContentToWrite, String fileName) async {
    final file = await _getFileObjectAtDocumentDirectory(fileName);

    // Write the file
    return file.writeAsString('$stringContentToWrite');
  }

  static Future<File> writeUint8ListToFile(
      Uint8List uint8list, String fileName) async {
    final file = await _getFileObjectAtDocumentDirectory(fileName);

    // Write the file
    return file.writeAsBytes(uint8list);
  }

  static Future<Uint8List> compressUint8List(
    Uint8List uint8List, {
    minHeight = 250,
    minWidth = 250,
    quality = 100,
  }) async {
    var compressedUint8List = await FlutterImageCompress.compressWithList(
      uint8List,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: quality,
    );

    return compressedUint8List;
  }

  static String getFileNameByImageId(String imageId) {
    return imageId.substring(0, 32);
  }
}
