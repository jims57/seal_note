import 'dart:convert';
import 'package:html_unescape/html_unescape.dart';

class HtmlHandler {
  static String encodeHtmlString(String htmlString) {
    return HtmlEscape().convert(htmlString);
  }

  static String decodeHtmlString(String encodedHtmlString) {
    return HtmlUnescape().convert(encodedHtmlString);
  }

  static String removeAllHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlString.replaceAll(exp, '');
  }

  static String decodeAndRemoveAllHtmlTags(String encodedHtmlString) {
    var decodedHtmlString = decodeHtmlString(encodedHtmlString);

    return removeAllHtmlTags(decodedHtmlString);
  }
}
