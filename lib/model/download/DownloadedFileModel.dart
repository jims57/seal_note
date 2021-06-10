import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';

class DownloadedFileModel {
  String fileMd5FileName;
  String fullFileName;
  String extensionName;
  Uint8List fileUint8List;
  File fileObject;

  DownloadedFileModel({
    @required this.fileMd5FileName,
    @required this.fullFileName,
    @required this.extensionName,
    @required this.fileUint8List,
    @required this.fileObject,
  });
}
