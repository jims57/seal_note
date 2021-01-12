import 'package:flutter/cupertino.dart';

class ReusablePageModel {
  ReusablePageModel({
    @required String reusablePageTitle,
    @required Widget reusablePageWidget,
  }) {
    this._reusablePageTitle = reusablePageTitle;
    this._reusablePageWidget = reusablePageWidget;
  }

  String _reusablePageTitle;

  // ignore: unnecessary_getters_setters
  String get reusablePageTitle => _reusablePageTitle;

  // ignore: unnecessary_getters_setters
  set reusablePageTitle(String value) {
    _reusablePageTitle = value;
  }

  Widget _reusablePageWidget;

  // ignore: unnecessary_getters_setters
  Widget get reusablePageWidget => _reusablePageWidget;

  // ignore: unnecessary_getters_setters
  set reusablePageWidget(Widget value) {
    _reusablePageWidget = value;
  }
}
