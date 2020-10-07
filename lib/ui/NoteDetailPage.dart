import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/DetailPageState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

import 'NoteDetailWidget.dart';

class NoteDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailPageChangeNotifier>(
        builder: (ctx, detailPageChangeNotifier, child) {
          if (GlobalState.webViewScaffold != null) {
            return NoteDetailWidget();
          } else {
            return NoteDetailWidget();
          }
        },
      ),
    );
  }
}
