import 'package:flutter/foundation.dart';

class ViewAgreementPageChangeNotifier extends ChangeNotifier {
  String _title = '『海豚笔记』';

  // ignore: unnecessary_getters_setters
  String get title => _title;

  // ignore: unnecessary_getters_setters
  set title(String value) {
    _title = value;
  }

  bool _shouldAvoidTransitionEffect = true;

  // ignore: unnecessary_getters_setters
  bool get shouldAvoidTransitionEffect => _shouldAvoidTransitionEffect;

  // ignore: unnecessary_getters_setters
  set shouldAvoidTransitionEffect(bool value) {
    _shouldAvoidTransitionEffect = value;
  }

  bool _shouldShowViewAgreementPage = false;

  bool get shouldShowViewAgreementPage => _shouldShowViewAgreementPage;

  void showViewAgreementPage() {
    _shouldShowViewAgreementPage = true;
    notifyListeners();
  }

  void hideViewAgreementPage() {
    _shouldShowViewAgreementPage = false;
    notifyListeners();
  }
}
