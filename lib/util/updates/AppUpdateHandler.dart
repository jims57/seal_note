import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/tcb/TCBAppUpdateHandler.dart';
import 'dart:io' show Platform;

enum UpdateAppOption {
  NoUpdate,
  OptionalUpdate,
  CompulsoryUpdate,
}

class AppUpdateHandler {
  static Future<UpdateAppOption> getUpdateAppOption() async {
    var updateAppOption = UpdateAppOption.NoUpdate;

    if ((Platform.isIOS || Platform.isAndroid) && GlobalState.isLoggedIn) {
      // Currently, only iOS and Android need to show update dialog,
      // and making sure the user has logged in, don't show update dialog before login

      var maxAppVersionReleased =
      await TCBAppUpdateHandler.getMaxAppVersionReleased();

      if (GlobalState.appVersion < maxAppVersionReleased) {
        // updateAppOption = UpdateAppOption.OptionalUpdate;
        updateAppOption = UpdateAppOption.CompulsoryUpdate;
      }
    }

    return updateAppOption;
  }

  // static Future<bool> getUpdateAppOption() async {
  //   var shouldShowUpdateDialog = false;
  //
  //   if ((Platform.isIOS || Platform.isAndroid) && GlobalState.isLoggedIn) {
  //     // Currently, only iOS and Android need to show update dialog,
  //     // and making sure the user has logged in, don't show update dialog before login
  //
  //     var maxAppVersionReleased =
  //         await TCBAppUpdateHandler.getMaxAppVersionReleased();
  //
  //     if (GlobalState.appVersion < maxAppVersionReleased) {
  //       shouldShowUpdateDialog = true;
  //     }
  //   }
  //
  //   return shouldShowUpdateDialog;
  // }
}
