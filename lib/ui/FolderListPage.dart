import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/SelectedNoteModel.dart';
import 'package:seal_note/function/checkScreenType.dart';
import 'package:after_layout/after_layout.dart';

class FolderListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage>
    with AfterLayoutMixin<FolderListPage> {
  int _screenType = 1; // 1 = Small, 2 = Medium, 3 = Large
  double _screenWidth = 0;

  BuildContext _noteListPageContext;
  bool _canPop = false;

  @override
  void initState() {
//    Provider.of<SelectedNoteModel>(context, listen: false)

    _noteListPageContext =
        Provider.of<SelectedNoteModel>(context, listen: false)
            .noteListPageContext;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _screenType = checkScreenType(_screenWidth);

    return Scaffold(
      body: GestureDetector(
        child: Center(child: Text('I am folder list')),
        onTap: () {
          if (_screenType != 3) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (_screenType == 3) {
      _canPop = Navigator.canPop(context);
      _canPop = Navigator.canPop(GlobalState.noteListPageContext);
      if (_canPop) Navigator.pop(GlobalState.noteListPageContext);
    }
  }
}
