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
    // get update option method

    var updateAppOption = UpdateAppOption.NoUpdate;

    if ((Platform.isIOS || Platform.isAndroid)) {
      // Currently, only iOS and Android need to show update dialog,
      // and making sure the user has logged in, don't show update dialog before login

      var response = await TCBAppUpdateHandler.getLatestAppVersionReleased(
        forceToFetchLatestAppVersionReleasedFromTCB: false,
      );

      if (response.code == 0) {
        // Succeed to get latest app version released

        if (GlobalState.appVersion < response.result) {
          // When there is a update

          updateAppOption = UpdateAppOption.OptionalUpdate;
          // updateAppOption = UpdateAppOption.CompulsoryUpdate;
        } else {
          // When no update

          updateAppOption = UpdateAppOption.NoUpdate;
        }
      } else {
        // Fail to get latest app version released

        var s = 's';
      }
    }

    return updateAppOption;
  }
}
