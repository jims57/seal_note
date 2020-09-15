import 'package:flutter/cupertino.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class DetailPageChangeNotifier extends ChangeNotifier {
  void refreshDetailPage() {
    notifyListeners();
  }
}