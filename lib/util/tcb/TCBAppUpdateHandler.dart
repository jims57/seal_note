import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/util/tcb/TCBSystemInfoHandler.dart';

class TCBAppUpdateHandler {
  // static Future<ResponseModel<String>> getLatestAppVersionReleased({
  //   bool forceToFetchLatestAppVersionReleasedFromTCB = true,
  // }) async {
  //   var response;
  //
  //   var responseForSystemInfo = await TCBSystemInfoHandler.getSystemInfo(
  //       forceToGetSystemInfoFromTCB: false);
  //
  //   if (responseForSystemInfo.code == 0) {
  //     // Succeed to get system info
  //
  //     response = ResponseModel.getResponseModelForSuccess<String>(
  //       result: GlobalState.tcbSystemInfo.latestAppVersionReleased,
  //     );
  //   } else {
  //     // Fail to get system info
  //
  //     response = ResponseModel.getResponseModelForError<String>(
  //       code: responseForSystemInfo.code,
  //       message: responseForSystemInfo.message,
  //     );
  //   }
  //
  //   return response;
  // }
}
