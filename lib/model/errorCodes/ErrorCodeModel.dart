class ErrorCodeModel {
  // Reference: https://open.weibo.com/wiki/Error_code
  // Or TCB CloudBaseExceptionCode class

  // Normal
  static const int SUCCESS_CODE = 0;
  static const String SUCCESS_MESSAGE = '成功';

  // System level [1xxxx]
  // Service level [2xxxx]

  // Login [3xxxx]
  static const int WX_AUTH_LOGIN_FAILED = 3000;
  // static const String SUCCESS_MESSAGE = '成功';

  // User [4xxxx]
  static const int GET_TCB_USER_INFO_FAIL_CODE = 4000;
  // static const String Success_Message = '成功';

  // Public methods

}
