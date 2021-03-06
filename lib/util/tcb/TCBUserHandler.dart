import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/util/tcb/TCBInitHandler.dart';
import 'package:seal_note/util/tcb/TCBLoginHandler.dart';

class TCBUserHandler {
  // Public methods
  static Future<ResponseModel<CloudBaseUserInfo>> getUserInfo({
    bool forceToLoginWhenNotLoggedIn = false,
    bool forceToFetchUserInfoFromTCB = false,
  }) async {
    var responseModelForCloudBaseUserInfo =
        ResponseModel.getResponseModelForSuccess<CloudBaseUserInfo>();
    var responseModelForLogin = ResponseModel.getResponseModelForSuccess();

    if (!GlobalState.isLoggedIn && forceToLoginWhenNotLoggedIn) {
      responseModelForLogin = await TCBLoginHandler.login(
        autoUseAnonymousWayToLoginInSimulator: true,
        forceToUseAnonymousLogin: false,
        delay3SecondsToLogin: false,
      );
    }

    if (responseModelForLogin.code == 0) {
      if (GlobalState.cloudBaseUserInfo == null) {
        responseModelForCloudBaseUserInfo = await _getUserInfoFromTCB();
      } else {
        if (forceToFetchUserInfoFromTCB) {
          responseModelForCloudBaseUserInfo = await _getUserInfoFromTCB();
        } else {
          responseModelForCloudBaseUserInfo =
              ResponseModel.getResponseModelForSuccess<CloudBaseUserInfo>(
                  result: GlobalState.cloudBaseUserInfo);
        }
      }
    }

    return responseModelForCloudBaseUserInfo;
  }

  // Private methods
  static Future<ResponseModel<CloudBaseUserInfo>> _getUserInfoFromTCB() async {
    var response;

    var auth = TCBInitHandler.getCloudBaseAuth();

    await auth.getUserInfo().then((userInfo) {
      response = ResponseModel.getResponseModelForSuccess<CloudBaseUserInfo>(
        result: userInfo,
      );
    }).catchError((err) {
      response = ResponseModel.getResponseModelForError<CloudBaseUserInfo>(
        code: ErrorCodeModel.GET_TCB_USER_INFO_FAILED_CODE,
        message: err?.message,
      );
    });

    return response;
  }
}
