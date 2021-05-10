import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class NetworkHandler {
  static Future<ConnectivityResult> getNetworkConnectivityType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    return connectivityResult;
  }

  static Future<bool> hasNetworkConnection() async {
    // hasNetwork: please keep using this local variable rather than GlobalState.hasNetwork,
    // because it will effect the auto login from the login page if the user has logged in,
    // if you use GlobalState.hasNetwork to replace this local variable
    var hasNetwork = true;

    ConnectivityResult connectivityResult = await getNetworkConnectivityType();

    // When it is none(index = 2), no network connection
    if (connectivityResult.index == 2) {
      hasNetwork = false;
    }

    return hasNetwork;
  }

  static void checkNetworkPeriodically(
      {@required VoidCallback callbackWhenHasNetwork,
      int intervalMillisecond = 1000}) {
    Timer _timer;

    _timer?.cancel();

    _timer = Timer.periodic(Duration(milliseconds: intervalMillisecond),
        (timer) async {
      GlobalState.hasNetwork = await hasNetworkConnection();
      if (GlobalState.hasNetwork) {
        callbackWhenHasNetwork();

        _timer.cancel();
      }
    });
  }
}
