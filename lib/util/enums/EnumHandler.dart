import 'package:flutter/foundation.dart';

class EnumHandler {
  static String getEnumValue(
      {@required dynamic enumType, bool forceToLowerCase = false}) {
    var enumString = enumType.toString();

    var enumValue = enumString.split('.').last;

    if (forceToLowerCase) {
      enumValue = enumValue.toLowerCase();
    }

    return enumValue;
  }
}
