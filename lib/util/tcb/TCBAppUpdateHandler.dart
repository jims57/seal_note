import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/util/tcb/TCBSystemInfosHandler.dart';
import 'package:seal_note/model/tcbModels/TCBSystemInfoModel.dart';

class TCBAppUpdateHandler {
  static Future<ResponseModel> getLatestAppVersionReleased({
    bool forceToFetchLatestAppVersionReleasedFromTCB = true,
  }) async {
    var response;
    ResponseModel responseForSystemInfos;

    if (forceToFetchLatestAppVersionReleasedFromTCB ||
        GlobalState.tcbSystemInfo == null) {
      responseForSystemInfos = await TCBSystemInfosHandler.getSystemInfo();

      if (responseForSystemInfos.code == 0) {
        // Get SystemInfo HashMap from TCB
        var systemInfoHashMap = responseForSystemInfos.result.data[0];

        // Convert HashMap to model
        GlobalState.tcbSystemInfo =
            TCBSystemInfoModel.fromJson(systemInfoHashMap);
      }
    } else {
      responseForSystemInfos = ResponseModel.getResponseModelForSuccess();
    }

    if (responseForSystemInfos.code == 0) {
      // When succeed

      response = ResponseModel.getResponseModelForSuccess(
        result: GlobalState.tcbSystemInfo.latestAppVersionReleased,
      );
    } else {
      // When failed
      response = responseForSystemInfos;
    }

    return response;
  }
}
