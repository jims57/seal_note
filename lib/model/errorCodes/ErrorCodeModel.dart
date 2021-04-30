class ErrorCodeModel {
  // Reference: https://open.weibo.com/wiki/Error_code
  // Or TCB CloudBaseExceptionCode class

  // Normal
  static const int SUCCESS_CODE = 0;
  static const String SUCCESS_MESSAGE = '成功';

  // System level [1xxxx]
  // Service level [2xxxx]

  // Login [3xxxx]
  static const int WX_AUTH_LOGIN_FAILED_CODE = 3000;
  static const String WX_AUTH_LOGIN_FAILED_MESSAGE = '微信授权登录失败';

  static const int WX_AUTH_ANONYMOUS_LOGIN_FAILED_CODE = 3001;
  static const String WX_AUTH_ANONYMOUS_LOGIN_FAILED_MESSAGE = '微信匿名登录失败';

  // User [4xxxx]
  static const int GET_TCB_USER_INFO_FAILED_CODE = 4000;
  static const String GET_TCB_USER_INFO_FAILED_Message = '获取TCB用户信息失败';
  // static const String Success_Message = '成功';

  // Public methods

}
