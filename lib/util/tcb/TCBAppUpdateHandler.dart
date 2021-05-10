import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/util/tcb/TCBSystemInfosHandler.dart';

class TCBAppUpdateHandler {
  // static Future<double> getLatestAppVersionReleased() async {
  //   // await Future.delayed(Duration(seconds: 2), () {});
  //
  //   // var response;
  //
  //
  //
  //   return 1.0;
  // }

  static Future<ResponseModel> getLatestAppVersionReleased() async {
    var responseForSystemInfos = await TCBSystemInfosHandler.getSystemInfos();
    var response;

    if (responseForSystemInfos.code == 0) {
      // When succeed
      response = ResponseModel.getResponseModelForSuccess(
        // result: responseForSystemInfos.result.data.latestAppVersionReleased,
        result: responseForSystemInfos.result.data[0]['latestAppVersionReleased'],
      );
    } else {
      // When failed
      response = responseForSystemInfos;
    }

    return response;
  }
}
