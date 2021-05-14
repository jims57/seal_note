import 'dart:async';

class WebViewLoadedEventHandler {
  // ignore: close_sinks
  StreamController webViewLoadedController = new StreamController.broadcast();

  Stream get onWebViewLoaded {
    return webViewLoadedController.stream;
  }

  void notifySubscribersThatWebViewHasLoaded(bool hasWebViewLoaded) {
    webViewLoadedController.add(hasWebViewLoaded); // send an arbitrary event
  }
}
