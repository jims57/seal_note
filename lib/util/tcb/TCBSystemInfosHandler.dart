import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/util/tcb/TCBInitHandler.dart';

class TCBSystemInfosHandler {
  static Future<ResponseModel> getSystemInfos() async {
    var response;

    await TCBInitHandler.getTCBCollection(collectionName: 'systemInfos')
        .where({
          '_id': GlobalState.tcbCommand.eq(GlobalState.systemInfosDocId),
          'systemInfoVersion': GlobalState.tcbCommand.eq(1),
        })
        .get()
        .then((result) {
          response = ResponseModel.getResponseModelForSuccess(result: result);
        })
        .catchError((err) {
          response = ResponseModel.getResponseModelForError(
            result: err,
            code: ErrorCodeModel.GET_TCB_SYSTEM_INFOS_FAILED_CODE,
            message: ErrorCodeModel.GET_TCB_SYSTEM_INFOS_FAILED_MESSAGE,
          );
        });

    return response;
  }
}
