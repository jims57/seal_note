import 'package:flutter/foundation.dart';

class ImageUuidItem {
  String uuid;

  ImageUuidItem({@required this.uuid});

  factory ImageUuidItem.fromJson(dynamic json) {
    return ImageUuidItem(
      uuid: json['uuid'],
    );
  }

  @override
  String toString() {
    return '{ ${this.uuid} }';
  }
}
