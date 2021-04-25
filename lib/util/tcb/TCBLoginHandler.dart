import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/simulators/SimulatorHandler.dart';

class TCBLoginHandler {
  // Private methods
  static void _initCloudBaseCore() {
    // 初始化 CloudBase
    if (GlobalState.tcbCloudBaseCore == null) {
      GlobalState.tcbCloudBaseCore = CloudBaseCore.init({
        // 填写您的云开发 env
        'env': GlobalState.tcbEnvironment,
        // 填写您的移动应用安全来源凭证
        // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
        'appAccess': {
          // 凭证
          'key': GlobalState.tcbAppAccessKey,
          // 版本
          'version': GlobalState.tcbAppAccessVersion
        },
        // 请求超时时间（选填）
        'timeout': 3000
      });
    }
  }

  static CloudBaseCore _getCloudBaseCore() {
    if (GlobalState.tcbCloudBaseCore == null) {
      _initCloudBaseCore();
    }

    return GlobalState.tcbCloudBaseCore;
  }

  static Future<CloudBaseAuthState> _getCloudBaseAuthState() async {
    var auth = getCloudBaseAuth();

    GlobalState.tcbCloudBaseAuthState = await auth.getAuthState();

    return GlobalState.tcbCloudBaseAuthState;
  }

  static Future<bool> _loginWXAnonymously() async {
    var isLoginSuccessful = false;
    var auth = getCloudBaseAuth();

    // GlobalState.tcbCloudBaseAuthState = await auth.signInAnonymously();
    await auth.signInAnonymously().then((success) {
      // 登录成功
      GlobalState.tcbAccessToken = success.accessToken ?? null;
      GlobalState.tcbRefreshToken = success.refreshToken ?? null;
      GlobalState.isLoggedIn = true;

      isLoginSuccessful = true;
    }).catchError((err) {
      // 登录失败
      GlobalState.isLoggedIn = false;
      isLoginSuccessful = false;
    });

    return isLoginSuccessful;
  }

  static Future<bool> _loginWX() async {
    var isLoginSuccessful = false;

    var auth = getCloudBaseAuth();

    await auth
        .signInByWx(
            wxAppId: GlobalState.wxAppId, wxUniLink: GlobalState.wxUniLink)
        .then((success) {
      var s = success;

      isLoginSuccessful = true;
      // 登录成功
    }).catchError((err) {
      // 登录失败
      var e = err;
      isLoginSuccessful = false;
    });

    return isLoginSuccessful;
  }

  // Public methods
  static CloudBaseAuth getCloudBaseAuth() {
    var core = _getCloudBaseCore();

    if (GlobalState.tcbCloudBaseAuth == null) {
      GlobalState.tcbCloudBaseAuth = CloudBaseAuth(core);
    }

    return GlobalState.tcbCloudBaseAuth;
  }

  static Future<bool> hasLoginWX() async {
    var authState = await _getCloudBaseAuthState();

    if (authState != null) {
      GlobalState.isLoggedIn = true;
    } else {
      GlobalState.isLoggedIn = false;
    }

    return GlobalState.isLoggedIn;
  }

  static Future<bool> login({
    bool autoUseAnonymousWayToLoginInSimulator = true,
  }) async {
    var isLoginSuccessful = false;
    var isSimulator = await SimulatorHandler.isSimulatorOrEmulator();

    if (isSimulator && autoUseAnonymousWayToLoginInSimulator) {
      isLoginSuccessful = await _loginWXAnonymously();
    } else {
      isLoginSuccessful = await _loginWX();
    }

    return isLoginSuccessful;
  }

  static Future<bool> signOutWX() async {
    var auth = getCloudBaseAuth();

    await auth.signOut();

    return true;
  }
}
