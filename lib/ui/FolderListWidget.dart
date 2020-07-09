import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class FolderListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(child: Text('I am folder list')),
      onTap: () {
        if (GlobalState.screenType != 3)
          Navigator.pop(GlobalState.noteListPageContext);
      },
    );
  }
}
