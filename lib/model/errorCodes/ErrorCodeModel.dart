class ErrorCodeModel {
  // Reference: https://open.weibo.com/wiki/Error_code
  // Or TCB CloudBaseExceptionCode class

  // Normal
  static const int SUCCESS_CODE = 0;
  static const String SUCCESS_MESSAGE = '成功';

  static const int UNKNOWN_ERROR_CODE = 1;
  static const String UNKNOWN_ERROR_MESSAGE = '系统发生未知错误，请重试';

  static const int NETWORK_PROBLEM_CODE = 2;
  static const String NETWORK_PROBLEM_MESSAGE = '请求失败，请检查网络连接';

  // System level [1xxx]

  // DB [2xxx]
  static const int UPDATE_FOLDERS_IN_BATCH_FAILED_CODE = 2000;
  static const String UPDATE_FOLDERS_IN_BATCH_FAILED_MESSAGE = '批量更新文件夹时失败';
  static const int UPDATE_NOTES_IN_BATCH_FAILED_CODE = 2001;
  static const String UPDATE_NOTES_IN_BATCH_FAILED_MESSAGE = '批量更新笔记时失败';
  static const int UPDATE_REVIEW_PLANS_IN_BATCH_FAILED_CODE = 2002;
  static const String UPDATE_REVIEW_PLANS_IN_BATCH_FAILED_MESSAGE =
      '批量更新复习计划时失败';
  static const int UPDATE_REVIEW_PLAN_CONFIGS_IN_BATCH_FAILED_CODE = 2003;
  static const String UPDATE_REVIEW_PLAN_CONFIGS_IN_BATCH_FAILED_MESSAGE =
      '批量更新复习计划配置时失败';
  static const int REORDER_FOLDERS_FAILED_CODE = 2004;
  static const String REORDER_FOLDERS_FAILED_MESSAGE =
      '排序文件夹时失败';

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
  static const String GET_TCB_LATEST_APP_VERSION_RELEASED_FAILED_MESSAGE =
      '从服务器获取已发布应用最新版本失败';

  // TCB Storage [7xxx]
  static const int TCB_STORAGE_FILE_NOT_EXISTENT_CODE = 7000;
  static const String TCB_STORAGE_FILE_NOT_EXISTENT_MESSAGE = '服务器不存在此文件';
  static const String TCB_STORAGE_FILE_NOT_EXISTENT_CODE_FROM_TCB =
      'FILE_NOT_EXIST';

// Synchronization [6xxx]

// Public methods

}
