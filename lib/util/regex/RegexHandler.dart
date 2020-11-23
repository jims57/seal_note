import 'package:flutter/material.dart';
import 'package:seal_note/util/html/HtmlHandler.dart';

class RegexHandler {
  static List<String> getMatchedEncodedStringList(
      {@required String encodedSourceString, @required String regexString}) {
    List<String> matchedEncodedStringList = List<String>();

    RegExp exp = new RegExp(HtmlHandler.encodeHtmlString(regexString));
    // RegExp exp = new RegExp(regexString);
    Iterable<Match> matches = exp.allMatches(encodedSourceString);

    for (var i = 0; i < matches.length; i++) {
      final matchedString = matches.elementAt(i).group(0);
      matchedEncodedStringList.add(matchedString);
    }

    return matchedEncodedStringList;
  }
}
