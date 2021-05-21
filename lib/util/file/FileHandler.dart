import 'dart:async';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:seal_note/util/enums/EnumHandler.dart';

enum SupportedFileExtensionType { Jpg, Png, Gif }

class FileHandler {
  static Future<String> _getDocumentDirectoryPath(
      {bool appendSlashAtLast = false}) async {
    // Return example: /Users/mac/Library/Developer/CoreSimulator/Devices/FDD59BB8-BB05-45B3-AF0F-72DFEF48FC92/data/Containers/Data/Application/94C787BA-9685-44F9-A77C-4558288F264E/Documents

    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;

    if (appendSlashAtLast) {
      directoryPath = '$directoryPath/';
    }

    return directoryPath;
  }

  static String generateFileNameWithExtension({
    // fileNameWithoutExtension format: img123 (without extension, such as .jpg, .png etc)
    @required String fileNameWithoutExtension,
    @required SupportedFileExtensionType extensionType,
  }) {
    String extString;

    switch (extensionType) {
      case SupportedFileExtensionType.Png:
        {
          extString = 'png';
        }
        break;
      case SupportedFileExtensionType.Gif:
        {
          extString = 'gif';
        }
        break;
      default:
        {
          extString = 'jpg';
        }
        break;
    }

    var fileName = '$fileNameWithoutExtension.$extString';

    return fileName;
  }

  static String getFileNameFromFullFileName({
    // fileName format: /Users/mac/loading2.gif
    // Return: loading2.gif
    @required String fullFileName,
  }) {
    var fileName = fullFileName.split('/').last;

    return fileName;
  }

  static String getFileNameWithoutExtension({
    // fileName format: loading2.gif
    // Return: loading2
    @required String fileName,
  }) {
    String fileNameWithoutExtension = fileName.split('.').first;

    return fileNameWithoutExtension;
  }

  static Future<String> getFullFileNameAtDocumentDirectory(
      String fileName) async {
    final path = await _getDocumentDirectoryPath();

    String fullFileName = '$path/$fileName';

    return fullFileName;
  }

  static Future<File> _getFileObjectAtDocumentDirectory(String fileName) async {
    var fullFileName = await getFullFileNameAtDocumentDirectory(fileName);

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

  static Future<Uint8List>
      getFileUint8ListFromDocumentDirectoryByFileNameWithoutExtension(
          {@required String fileNameWithoutExtension}) async {
    // This will try all possible file extensions mentioned in SupportedFileExtensionType enum to find a file object,
    // for example: if there is a file name is: abc.jpg, the so-called *fileNameWithoutExtension* is abc (without .jpg)

    var fileExtensionTypeList = SupportedFileExtensionType.values;
    var listLength = fileExtensionTypeList.length;
    var fileUint8List;

    for (var i = 0; i < listLength; i++) {
      var fileExtensionType = fileExtensionTypeList[i];

      var fileExtension = EnumHandler.getEnumValue(
        enumType: fileExtensionType,
        forceToLowerCase: true,
      );

      var fileName = '$fileNameWithoutExtension.$fileExtension';

      // Try to get the file object
      fileUint8List = await getFileUint8ListFromDocumentDirectory(fileName);

      if (fileUint8List != null) {
        break; // When it returns an object, and then break the loop
      }
    }

    return fileUint8List;
  }

  static Future<Uint8List> getFileUint8ListFromDocumentDirectory(
    String fileName,
  ) async {
    // get file uint8list by file name // get file data by file name

    try {
      var fileObject = await _getFileObjectAtDocumentDirectory(fileName);

      if (!fileObject.existsSync()) {
        // When the file doesn't exist

        return null;
      } else {
        // When the file exist
        // Read the file
        Uint8List contents = await fileObject.readAsBytes();

        return contents;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Uint8List> getFileUint8ListFromAssetsFolder({
    String path = 'assets/appImages/',
    // fileName format: loading2.gif
    @required String fileName,
  }) async {
    // This is the assets folder: https://user-images.githubusercontent.com/1920873/118915552-c00c5f00-b95f-11eb-96b1-cd8643a33535.png

    var imageByteData = await rootBundle.load("$path$fileName");
    Uint8List imageUint8List = imageByteData.buffer.asUint8List();

    return imageUint8List;
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
}
