import 'package:seal_note/model/common/ResponseModel.dart';

class SyncHandler {
  static Future<ResponseModel> syncData() async {
    var response = ResponseModel.getResponseModelForSuccess();

    await Future.delayed(Duration(seconds: 3), () {
      var s = 's';
    });

    return response;
  }
}
