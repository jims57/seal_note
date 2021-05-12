class ErrorCodeModel {
  // Reference: https://open.weibo.com/wiki/Error_code
  // Or TCB CloudBaseExceptionCode class

  // Normal
  static const int SUCCESS_CODE = 0;
  static const String SUCCESS_MESSAGE = '成功';

  // System level [1xxx]
  // Service level [2xxx]

  // Login [3xxx]
  static const int WX_AUTH_LOGIN_FAILED_CODE = 3000;
  static const String WX_AUTH_LOGIN_FAILED_MESSAGE = '微信授权登录失败';

  static const int WX_AUTH_ANONYMOUS_LOGIN_FAILED_CODE = 3001;
  static const String WX_AUTH_ANONYMOUS_LOGIN_FAILED_MESSAGE = '微信匿名登录失败';

  // Sign out [4xxx]
  static const int WX_SIGN_OUT_FAILED_CODE = 4001;
  static const String WX_SIGN_OUT_FAILED_MESSAGE = '退出登录失败，请重试';

  // User [5xxx]
  static const int GET_TCB_USER_INFO_FAILED_CODE = 5000;
  static const String GET_TCB_USER_INFO_FAILED_Message = '从服务器获取用户信息失败';

  // SystemInfos [6xxx]
  static const int GET_TCB_SYSTEM_INFO_FAILED_CODE = 6000;
  static const String GET_TCB_SYSTEM_INFO_FAILED_MESSAGE = '从服务器获取系统信息失败';

  static const int GET_TCB_LATEST_APP_VERSION_RELEASED_FAILED_CODE = 6001;
  static const String GET_TCB_LATEST_APP_VERSION_RELEASED_FAILED_MESSAGE = '从服务器获取已发布应用最新版本失败';

  // Synchronization [6xxx]

// Public methods

}
