import 'dart:async';

import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/tcb/TCBAppUpdateHandler.dart';
import 'dart:io' show Platform;

import 'package:seal_note/util/tcb/TCBSystemInfoHandler.dart';

enum UpdateAppOption {
  NoUpdate,
  OptionalUpdate,
  CompulsoryUpdate,
  HasError,
}

class AppUpdateHandler {
  static Future<UpdateAppOption> getUpdateAppOption({
    bool forceToGetUpdateAppOptionFromTCB = true,
  }) async {
    // get update option method

    var updateAppOption = UpdateAppOption.NoUpdate;

    if ((Platform.isIOS || Platform.isAndroid)) {
      // Currently, only iOS and Android need to show update dialog,
      // and making sure the user has logged in, don't show update dialog before login

      // var response = await TCBAppUpdateHandler.getLatestAppVersionReleased(
      //   forceToFetchLatestAppVersionReleasedFromTCB: false,
      // );
      var response = await TCBSystemInfoHandler.getSystemInfo(
        forceToGetSystemInfoFromTCB: forceToGetUpdateAppOptionFromTCB,
      );

      if (response.code == 0) {
        // Succeed to get latest app version released

        var systemInfo = response.result;

        if (GlobalState.appVersion < systemInfo.minSupportedAppVersion) {
          // When the app version < minSupportedVersion,
          // we need update the app forcibly

          updateAppOption = UpdateAppOption.CompulsoryUpdate;
        } else if (GlobalState.appVersion <
            systemInfo.latestAppVersionReleased) {
          // When the app version isn't less than minSupportedVersion,
          // but there is a latest version greater than the app version

          updateAppOption = UpdateAppOption.OptionalUpdate;
        } else {
          // When no update

          updateAppOption = UpdateAppOption.NoUpdate;
        }
      } else {
        // Fail to get latest app version released

        updateAppOption = UpdateAppOption.HasError;

        var s = 's';
      }
    }

    return updateAppOption;
  }
}
