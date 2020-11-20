import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:seal_note/util/regex/RegexHandler.dart';

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

  static List<String> getHtmlTagList(
      {@required String encodedHtmlString,
      @required String tagNameToMatch,
      bool forceToAddTagWhenNotExistent = false,
      List<String> regexTagNameListToExclude = const [
        '<p><br></p>',
        '<img(.+?)>'
      ]}) {
    var regexTagName = '<$tagNameToMatch(.*?)>(.+?)</$tagNameToMatch>';
    var htmlTagStringList = List<String>();
    var indexListToDelete = List<int>();
    var breakRecursionForExcludedList = false;

    var decodedHtmlString = HtmlHandler.decodeHtmlString(encodedHtmlString);

    // Check if the string contains the target tag or not
    if (!decodedHtmlString.contains('<$tagNameToMatch>') &&
        !decodedHtmlString.contains('</$tagNameToMatch>') &&
        forceToAddTagWhenNotExistent) {
      decodedHtmlString =
          '<$tagNameToMatch>$decodedHtmlString</$tagNameToMatch>';
    }

    htmlTagStringList.addAll(RegexHandler.getMatchedStringList(
        sourceString: decodedHtmlString, regexString: regexTagName));

    for (var i = 0; i < htmlTagStringList.length; i++) {
      breakRecursionForExcludedList = false;
      var theHtmlTagString = htmlTagStringList[i];

      for (var j = 0; j < regexTagNameListToExclude.length; j++) {
        if (breakRecursionForExcludedList) break;

        var theRegexTagNameToExclude = regexTagNameListToExclude[j];
        var tagNameToExcludeList = RegexHandler.getMatchedStringList(
            sourceString: theHtmlTagString,
            regexString: theRegexTagNameToExclude);

        for (var k = 0; k < tagNameToExcludeList.length; k++) {
          var theTagNameToExclude = tagNameToExcludeList[k];
          var theOldHtmlTagString =
              theHtmlTagString; // Record the old string to compare in future
          theHtmlTagString =
              theHtmlTagString.replaceAll(theTagNameToExclude, '');

          // Check if there is any change or not
          if (theHtmlTagString != theOldHtmlTagString) {
            // When there are some updates
            htmlTagStringList[i] =
                theHtmlTagString; // Update the original string by index
          }

          // Check if the remaining string is valid or not
          if (theHtmlTagString.trim().isEmpty ||
              theHtmlTagString == '<$tagNameToMatch></$tagNameToMatch>') {
            // When the remaining tag string is empty or there is no child inside the tag any more
            indexListToDelete.add(
                i); // Mark this index at htmlTagStringList is subject to be removed form it

            breakRecursionForExcludedList = true;
            break;
          }
        }
      }
    }

    // After completing comparison, removing these items marked as deleted from the list
    for (var i = indexListToDelete.length - 1; i >= 0; i--) {
      var theIndexToDelete = indexListToDelete[i];
      htmlTagStringList.removeAt(theIndexToDelete);
    }

    return htmlTagStringList;
  }
}
