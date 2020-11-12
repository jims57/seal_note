import 'package:flutter/cupertino.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class RetryHandler {
  static retryOperation(
      {@required Function() function, int retryTimesToSaveDb}) {
    var retryTimes = GlobalState.retryTimesToSaveDb;
    if (retryTimesToSaveDb != null) {
      retryTimes = retryTimesToSaveDb;
    }

    // Retry to enhance the robustness
    for (var i = 0; i <= retryTimes; i++) {
      function();
    }
  }
}
