import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/util/tcb/TCBLoginHandler.dart';

class TCBUserHandler {
  // Public methods
  static Future<ResponseModel<CloudBaseUserInfo>> getUserInfo({
    bool forceToLoginWhenNotLoggedIn = false,
    bool forceToFetchUserInfoFromTCB = false,
  }) async {
    var response;

    if (!GlobalState.isLoggedIn && forceToLoginWhenNotLoggedIn) {
      GlobalState.isLoggedIn = await TCBLoginHandler.login(
        autoUseAnonymousWayToLoginInSimulator: true,
      );
    }

    if (GlobalState.cloudBaseUserInfo == null) {
      response = await _getUserInfoFromTCB();
    } else {
      if (forceToFetchUserInfoFromTCB) {
        response = await _getUserInfoFromTCB();
      } else {
        response = ResponseModel.getResponseModelForSuccess<CloudBaseUserInfo>(
            result: GlobalState.cloudBaseUserInfo);
      }
    }

    return response;
  }

  // Private methods
  static Future<ResponseModel<CloudBaseUserInfo>> _getUserInfoFromTCB() async {
    var response;

    var auth = TCBLoginHandler.getCloudBaseAuth();

    await auth.getUserInfo().then((userInfo) {
      response = ResponseModel.getResponseModelForSuccess<CloudBaseUserInfo>(
          result: userInfo);
    }).catchError((err) {
      response = ResponseModel.getResponseModelForTCBError(err: err);
    });

    return response;
  }
}
