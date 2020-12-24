import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:seal_note/data/appstate/GlobalState.dart';

class RetryHandler {
  // static retryOperation(
  //     {@required Function() function, int retryTimesToSaveDb}) {
  //   var retryTimes = GlobalState.retryTimesToSaveDb;
  //   if (retryTimesToSaveDb != null) {
  //     retryTimes = retryTimesToSaveDb;
  //   }
  //
  //   // Retry to enhance the robustness
  //   for (var i = 0; i <= retryTimes; i++) {
  //     function();
  //   }
  // }

  static void retryExecutionWithTimerDelay(
      {int retryTimes = 2,
      int currentExecutionTimes = 0,
      int millisecondsToDelay = 500,
      @required VoidCallback callback}) async {
    var executionTimes = currentExecutionTimes;

    Timer(Duration(milliseconds: millisecondsToDelay), () async {
      callback();

      executionTimes++;

      if (executionTimes < retryTimes) {
        retryExecutionWithTimerDelay(
            retryTimes: retryTimes,
            currentExecutionTimes: executionTimes,
            millisecondsToDelay: millisecondsToDelay,
            callback: callback);
      }
    });
  }
}
