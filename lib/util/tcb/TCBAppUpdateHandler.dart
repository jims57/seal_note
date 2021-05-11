import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/util/tcb/TCBSystemInfosHandler.dart';

class TCBAppUpdateHandler {
  static Future<ResponseModel> getLatestAppVersionReleased({
    bool forceToFetchLatestAppVersionReleasedFromTCB = true,
  }) async {
    var response;
    ResponseModel responseForSystemInfos;

    if (forceToFetchLatestAppVersionReleasedFromTCB ||
        GlobalState.tcbSystemInfosData == null) {
      responseForSystemInfos = await TCBSystemInfosHandler.getSystemInfos();

      if (responseForSystemInfos.code == 0) {
        GlobalState.tcbSystemInfosData = responseForSystemInfos.result.data[0];
      }
    } else {
      responseForSystemInfos = ResponseModel.getResponseModelForSuccess();
    }

    if (responseForSystemInfos.code == 0) {
      // When succeed

      response = ResponseModel.getResponseModelForSuccess(
        result: GlobalState.tcbSystemInfosData['latestAppVersionReleased'],
      );
    } else {
      // When failed
      response = responseForSystemInfos;
    }

    return response;
  }
}
