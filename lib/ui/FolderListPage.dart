import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:after_layout/after_layout.dart';

import 'FolderListWidget.dart';

class FolderListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage>
    with AfterLayoutMixin<FolderListPage> {
  bool _canPop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FolderListWidget(),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (GlobalState.screenType == 3) {
      _canPop = Navigator.canPop(GlobalState.noteListPageContext);
      if (_canPop) Navigator.pop(GlobalState.noteListPageContext);
    }
  }
}
