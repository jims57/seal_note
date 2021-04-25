import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/tcb/TCBLoginHandler.dart';

class TCBUserHandler {
  static Future<CloudBaseUserInfo> getUserInfo({
    bool forceToLoginWhenNotLoggedIn = false,
  }) async {
    var auth = TCBLoginHandler.getCloudBaseAuth();

    if (!GlobalState.isLoggedIn && forceToLoginWhenNotLoggedIn) {
      GlobalState.isLoggedIn = await TCBLoginHandler.login(
        autoUseAnonymousWayToLoginInSimulator: true,
      );
    }

    await auth.getUserInfo().then((userInfo) {
      // 获取用户信息成功
      GlobalState.cloudBaseUserInfo = userInfo;
    }).catchError((err) {
      // 获取用户信息失败
      var e = err;
    });

    return GlobalState.cloudBaseUserInfo;
  }
}
