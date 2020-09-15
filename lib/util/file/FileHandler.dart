import 'dart:io';

// import 'dart:io' show io ;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    print(directory.path);

    return directory.path;
  }

  static Future<File> _getLocalFile(String fileName) async {
    final path = await _localPath;

    String fullFileName = '$path/$fileName';
    print(fullFileName);
    return File(fullFileName);
  }

  static Future<bool> checkIfFileExistsOrNot(String fileName) async {
    var file = await _getLocalFile(fileName);
    var filePath = file.path;
    var existOrNot = File(filePath).exists();
    return existOrNot;
  }

  static Future<String> readFileContentAsString(String fileName) async {
    try {
      final file = await _getLocalFile(fileName);

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      return '';
    }
  }

  static Future<Uint8List> readFileAsUint8List(String fileName) async {
    try {
      final file = await _getLocalFile(fileName);

      // Read the file
      Uint8List contents = await file.readAsBytes();

      return contents;
    } catch (e) {
      return null;
    }
  }

  static Future<File> writeStringToFile(
      String stringContentToWrite, String fileName) async {
    final file = await _getLocalFile(fileName);

    // Write the file
    return file.writeAsString('$stringContentToWrite');
  }

  static Future<File> writeUint8ListToFile(
      Uint8List uint8list, String fileName) async {
    final file = await _getLocalFile(fileName);

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
