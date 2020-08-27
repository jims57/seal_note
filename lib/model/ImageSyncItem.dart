import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class ImageSyncItem {
  String imageId;
  int imageIndex;
  int syncId = 0; // By default, it is synced
  String base64;
  Uint8List byteData;

  ImageSyncItem(
      {@required this.imageId,
      @required this.imageIndex,
      this.syncId,
      this.base64,
      this.byteData});

  factory ImageSyncItem.fromJson(dynamic json) {
    return ImageSyncItem(
      imageId: json['imageId'],
      imageIndex: json['imageIndex'],
      syncId: json['syncId'],
      base64: json['base64'],
    );
  }

  @override
  String toString() {
    return '{ ${this.imageId}, ${this.imageIndex}, ${this.syncId}, ${this.base64} }';
  }
}
