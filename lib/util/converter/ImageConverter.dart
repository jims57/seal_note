import 'dart:convert';
import 'dart:typed_data';

class ImageConverter {
  static final ImageConverter _singleton = ImageConverter._internal();

  factory ImageConverter() => _singleton;

  ImageConverter._internal();

  static Uint8List convertBase64ToUint8List(base64String) {
    return base64.decode(base64String);
  }

  static String convertUint8ListToBase64(uint8List) {
    return base64.encode(uint8List);
  }
}
