import 'package:connectivity/connectivity.dart';

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
}
