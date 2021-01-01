import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RetryHandler {
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
