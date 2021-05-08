import 'dart:async';
import 'package:seal_note/model/common/ResponseModel.dart';

class WebViewLoadedEventHandler {
  // ignore: close_sinks
  StreamController webViewLoadedController = new StreamController.broadcast();

  Stream get onWebViewLoaded {
    return webViewLoadedController.stream;
  }

  // void notifySubscribersWebViewHasLoaded(ResponseModel response) {
  //   webViewLoadedController.add(response); // send an arbitrary event
  // }

  void notifySubscribersWebViewHasLoaded(bool hasWebViewLoaded) {
    webViewLoadedController.add(hasWebViewLoaded); // send an arbitrary event
  }
}
