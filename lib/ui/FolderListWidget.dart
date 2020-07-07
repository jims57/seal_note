import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/EditingNoteModel.dart';
import 'package:seal_note/function/checkScreenType.dart';

class FolderListWidget extends StatefulWidget {
  BuildContext _context;

  BuildContext get context => _context;

  set context(BuildContext value) {
    _context = value;
  }

  @override
  State<StatefulWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  int _screenType = 1; // 1 = Small, 2 = Medium, 3 = Large
  double _screenWidth = 0;
  bool _canPop = false;

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenType = checkScreenType(_screenWidth);

    BuildContext noteListContext =
        Provider.of<EditingNoteModel>(context, listen: false).context;
    if (noteListContext != null) {
      bool canPop = Navigator.canPop(noteListContext);
      if (canPop && _screenType == 3) {
        Navigator.pop(noteListContext);
      }

      bool canPop2 = Navigator.canPop(context);
      String s = 's';
    }

    return Scaffold(
      body: GestureDetector(
        child: Center(child: Text('I am folder list')),
        onTap: () {
          String s = 's';
          _canPop = Navigator.canPop(noteListContext);
          if (_canPop) Navigator.pop(noteListContext);
        },
      ),
    );
  }
}
