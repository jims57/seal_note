class StringHandler {
  static String removeSpecialChars(String string) {
    // Remove the special chars from the chars, such as #efbbbf

    List<int> stringBytes = string.codeUnits;
    List<int> stringBytesCloned = []..addAll(stringBytes);

    stringBytesCloned.removeWhere((element) => element == 65279);

    var handledString = String.fromCharCodes(stringBytesCloned);

    return handledString;
  }
}
