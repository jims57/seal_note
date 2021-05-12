import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/util/tcb/TCBSystemInfoHandler.dart';

class TCBAppUpdateHandler {
  static Future<ResponseModel> getLatestAppVersionReleased({
    bool forceToFetchLatestAppVersionReleasedFromTCB = true,
  }) async {
    var response;

    var responseForSystemInfo = await TCBSystemInfoHandler.getSystemInfo(
        forceToGetSystemInfoFromTCB: false);

    if (responseForSystemInfo.code == 0) {
      response = ResponseModel.getResponseModelForSuccess(
        result: GlobalState.tcbSystemInfo.latestAppVersionReleased,
      );
    } else {
      response = ResponseModel.getResponseModelForError(
        result: responseForSystemInfo.result,
        code: ErrorCodeModel.GET_TCB_LATEST_APP_VERSION_RELEASED_FAILED_CODE,
        message:
            ErrorCodeModel.GET_TCB_LATEST_APP_VERSION_RELEASED_FAILED_MESSAGE,
      );
    }

    return response;
  }
}
