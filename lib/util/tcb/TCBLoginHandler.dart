import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/util/simulators/SimulatorHandler.dart';
import 'package:seal_note/util/tcb/TCBInitHandler.dart';

class TCBLoginHandler {
  // Private methods
  // static void _initCloudBaseCore() {
  //   // 初始化 CloudBase
  //   if (GlobalState.tcbCloudBaseCore == null) {
  //     GlobalState.tcbCloudBaseCore = CloudBaseCore.init({
  //       // 填写您的云开发 env
  //       'env': GlobalState.tcbEnvironment,
  //       // 填写您的移动应用安全来源凭证
  //       // 生成凭证的应用标识必须是 Android 包名或者 iOS BundleID
  //       'appAccess': {
  //         // 凭证
  //         'key': GlobalState.tcbAppAccessKey,
  //         // 版本
  //         'version': GlobalState.tcbAppAccessVersion
  //       },
  //       // 请求超时时间（选填）
  //       'timeout': 3000
  //     });
  //   }
  // }

  // static CloudBaseCore _getCloudBaseCore() {
  //   if (GlobalState.tcbCloudBaseCore == null) {
  //     _initCloudBaseCore();
  //   }
  //
  //   return GlobalState.tcbCloudBaseCore;
  // }

  // static Future<CloudBaseAuthState> _getCloudBaseAuthState() async {
  //   var auth = getCloudBaseAuth();
  //
  //   GlobalState.tcbCloudBaseAuthState = await auth.getAuthState();
  //
  //   return GlobalState.tcbCloudBaseAuthState;
  // }

  static Future<ResponseModel> _loginWXAnonymously() async {
    ResponseModel responseModel;
    var auth = TCBInitHandler.getCloudBaseAuth();

    await auth.signInAnonymously().then((success) {
      GlobalState.tcbAccessToken = success.accessToken ?? null;
      GlobalState.tcbRefreshToken = success.refreshToken ?? null;
      GlobalState.isLoggedIn = true;
      GlobalState.isAnonymousLogin = true;

      responseModel =
          ResponseModel.getResponseModelForSuccess<CloudBaseAuthState>(
        result: success,
      );
    }).catchError((err) {
      GlobalState.isLoggedIn = false;

      responseModel =
          ResponseModel.getResponseModelForError<CloudBaseException>(
        // result: err,
        code: ErrorCodeModel.WX_AUTH_ANONYMOUS_LOGIN_FAILED_CODE,
        message: ErrorCodeModel.WX_AUTH_ANONYMOUS_LOGIN_FAILED_MESSAGE,
      );
    });

    return responseModel;
  }

  static Future<ResponseModel> _loginWX() async {
    var responseModel = ResponseModel();
    var auth = TCBInitHandler.getCloudBaseAuth();

    await auth
        .signInByWx(
            wxAppId: GlobalState.wxAppId, wxUniLink: GlobalState.wxUniLink)
        .then((success) {
      GlobalState.isLoggedIn = true;
      GlobalState.isAnonymousLogin = false;

      responseModel =
          ResponseModel.getResponseModelForSuccess<CloudBaseAuthState>(
        result: success,
      );
    }).catchError((err) {
      responseModel =
          ResponseModel.getResponseModelForError<CloudBaseException>(
        // result: err,
        message: ErrorCodeModel.WX_AUTH_LOGIN_FAILED_MESSAGE,
        code: ErrorCodeModel.WX_AUTH_LOGIN_FAILED_CODE,
      );
      GlobalState.isLoggedIn = false;
      GlobalState.loadingWidgetChangeNotifier.shouldShowLoadingWidget = false;
    });

    return responseModel;
  }

  // Public methods
  // static CloudBaseAuth getCloudBaseAuth() {
  //   var core = _getCloudBaseCore();
  //
  //   if (GlobalState.tcbCloudBaseAuth == null) {
  //     GlobalState.tcbCloudBaseAuth = CloudBaseAuth(core);
  //   }
  //
  //   return GlobalState.tcbCloudBaseAuth;
  // }

  static Future<bool> hasLoginTCB() async {
    // var authState = await _getCloudBaseAuthState();
    var authState = await TCBInitHandler.getCloudBaseAuthState();

    if (authState != null) {
      GlobalState.isLoggedIn = true;
    } else {
      GlobalState.isLoggedIn = false;
    }

    return GlobalState.isLoggedIn;
  }

  static Future<bool> isLoginExpired() async {
    var auth = TCBInitHandler.getCloudBaseAuth();

    return await auth.hasExpiredAuthState();
  }

  static Future<ResponseModel> login({
    bool autoUseAnonymousWayToLoginInSimulator = true,
  }) async {
    await Future.delayed(Duration(seconds: 3));

    var responseModel = ResponseModel();

    var isSimulator = await SimulatorHandler.isSimulatorOrEmulator();
    var isReviewApp = await GlobalState.checkIfReviewApp(
      forceToSetIsReviewAppVar: true,
    );

    // If this is a review app, use anonymous way to login
    if (isReviewApp || (isSimulator && autoUseAnonymousWayToLoginInSimulator)) {
      // GlobalState.isLoggedIn = await _loginWXAnonymously();
      responseModel = await _loginWXAnonymously();
    } else {
      responseModel = await _loginWX();
    }

    return responseModel;
  }

  static Future<ResponseModel> signOutWX() async {
    // Id doesn't need to execute sign out method of tcb if on simulator
    var isSimulator = await SimulatorHandler.isSimulatorOrEmulator();
    var hasLogin = await TCBLoginHandler.hasLoginTCB();
    var response;

    // By default, it responses as a success one
    GlobalState.isLoggedIn = false;
    response = ResponseModel.getResponseModelForSuccess();

    if (!isSimulator && hasLogin) {
      var auth = TCBInitHandler.getCloudBaseAuth();

      await auth.signOut().catchError((err) {
        GlobalState.isLoggedIn =
            true; // If failed, we set it back to login status

        response = ResponseModel.getResponseModelForError(
          // result: err,
          code: ErrorCodeModel.WX_SIGN_OUT_FAILED_CODE,
          message: ErrorCodeModel.WX_SIGN_OUT_FAILED_MESSAGE,
        );
      });
    }

    return response;
  }
}
