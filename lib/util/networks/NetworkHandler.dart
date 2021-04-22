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
    bool _hasNetwork = true;

    ConnectivityResult connectivityResult = await getNetworkConnectivityType();

    // When it is none(index = 2), no network connection
    if (connectivityResult.index == 2) {
      _hasNetwork = false;
    }

    return _hasNetwork;
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
