import 'package:flutter/foundation.dart';

class LoadingWidgetChangeNotifier extends ChangeNotifier {
  bool _shouldShowLoadingWidget = false;

  // ignore: unnecessary_getters_setters
  bool get shouldShowLoadingWidget => _shouldShowLoadingWidget;

  // ignore: unnecessary_getters_setters
  set shouldShowLoadingWidget(bool value) {
    _shouldShowLoadingWidget = value;
    notifyListeners();
  }
}
