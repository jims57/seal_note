import 'package:flutter/cupertino.dart';

class KeyboardHandler {
  FocusScopeNode currentFocus;

  void hideKeyboard({@required BuildContext context}) {
    currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
