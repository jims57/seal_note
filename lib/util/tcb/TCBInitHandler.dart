import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class TCBInitHandler {
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

  // Public methods
  static CloudBaseAuth getCloudBaseAuth() {
    var core = _getCloudBaseCore();

    if (GlobalState.tcbCloudBaseAuth == null) {
      GlobalState.tcbCloudBaseAuth = CloudBaseAuth(core);
    }

    return GlobalState.tcbCloudBaseAuth;
  }

  static Future<CloudBaseAuthState> getCloudBaseAuthState() async {
    var auth = getCloudBaseAuth();

    GlobalState.tcbCloudBaseAuthState = await auth.getAuthState();

    return GlobalState.tcbCloudBaseAuthState;
  }

  static CloudBaseDatabase _getCloudBaseDatabase() {
    if (GlobalState.tcbCloudBaseDatabase == null) {
      var core = _getCloudBaseCore();

      GlobalState.tcbCloudBaseDatabase = CloudBaseDatabase(core);
    }

    return GlobalState.tcbCloudBaseDatabase;
  }

  static Command _initTCBCommand() {
    if (GlobalState.tcbCommand == null) {
      GlobalState.tcbCommand = _getCloudBaseDatabase().command;
    }

    return GlobalState.tcbCommand;
  }

  static Collection getTCBCollection({
    @required String collectionName,
  }) {
    _initTCBCommand();

    return _getCloudBaseDatabase().collection(collectionName);
  }
}
