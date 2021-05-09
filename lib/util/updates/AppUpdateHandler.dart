import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/tcb/TCBAppUpdateHandler.dart';
import 'dart:io' show Platform;

class AppUpdateHandler {
  static Future<bool> shouldShowUpdateDialogIfNeeded() async {
    var shouldShowUpdateDialog = false;

    if ((Platform.isIOS || Platform.isAndroid) && GlobalState.isLoggedIn) {
      // Currently, only iOS and Android need to show update dialog,
      // and making sure the user has logged in, don't show update dialog before login

      var maxAppVersionReleased =
          await TCBAppUpdateHandler.getMaxAppVersionReleased();

      if (GlobalState.appVersion < maxAppVersionReleased) {
        shouldShowUpdateDialog = true;
      }
    }

    return shouldShowUpdateDialog;
  }
}
