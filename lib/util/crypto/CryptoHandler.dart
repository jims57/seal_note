import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoHandler {
  static String convertStringToMd5(String string) {
    return md5.convert(utf8.encode(string)).toString();
  }
}