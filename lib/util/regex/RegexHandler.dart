import 'package:flutter/material.dart';

class RegexHandler {
  static List<String> getMatchedStringList(
      {@required String sourceString, @required String regexString}) {
    List<String> matchedStringList = List<String>();

    RegExp exp = new RegExp(regexString);
    Iterable<Match> matches = exp.allMatches(sourceString);

    for (var i = 0; i < matches.length; i++) {
      final matchedString = matches.elementAt(i).group(0);
      matchedStringList.add(matchedString);
    }

    return matchedStringList;
  }
}
