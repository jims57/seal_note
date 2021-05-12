import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/model/tcbModels/TCBSystemInfoModel.dart';
import 'package:seal_note/util/tcb/TCBInitHandler.dart';

class TCBSystemInfoHandler {
  static Future<ResponseModel> getSystemInfo({
    bool forceToGetSystemInfoFromTCB = true,
  }) async {
    var response;

    if (forceToGetSystemInfoFromTCB) {
      // When fetching system info from TCB forcibly

      response = await _getSystemInfoFromTCB();
    } else {
      // When don't fetch system info from TCB forcibly
      // Try to get the system info from GlobalState first

      if (GlobalState.tcbSystemInfo != null) {
        response = ResponseModel.getResponseModelForSuccess(
            result: GlobalState.tcbSystemInfo);
      } else {
        response = await _getSystemInfoFromTCB();
      }
    }

    return response;
  }

  // Private methods
  static Future<ResponseModel> _getSystemInfoFromTCB() async {
    var response;

    await TCBInitHandler.getTCBCollection(collectionName: 'systemInfos')
        .where({
          'systemInfoVersion':
              GlobalState.tcbCommand.eq(GlobalState.systemInfoVersion),
        })
        .get()
        .then((result) {
          var systemInfoHashMap = result.data[0];

          // Convert HashMap to model
          GlobalState.tcbSystemInfo =
              TCBSystemInfoModel.fromJson(systemInfoHashMap);

          response = ResponseModel.getResponseModelForSuccess(
              result: GlobalState.tcbSystemInfo);
        })
        .catchError((err) {
          response = ResponseModel.getResponseModelForError(
            result: err,
            code: ErrorCodeModel.GET_TCB_SYSTEM_INFO_FAILED_CODE,
            message: ErrorCodeModel.GET_TCB_SYSTEM_INFO_FAILED_MESSAGE,
          );
        });

    return response;
  }
}
