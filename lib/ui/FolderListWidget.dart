import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class FolderListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  List<GestureDetector> childrenWidgetList = List.generate(100, (index) {
    return GestureDetector(
      key: Key('$index'),
      child: Text(
        'index=>$index',
        // key: Key('$index'),
      ),
      onTap: () {
        GlobalState.isHandlingFolderPage = true;
        GlobalState.isInFolderPage = false;
        GlobalState.masterDetailPageState.currentState
            .updatePageShowAndHide(shouldTriggerSetState: true);
      },
    );
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (GlobalState.screenHeight -
          GlobalState.folderPageTopContainerHeight -
          GlobalState.folderPageBottomContainerHeight),
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: ReorderableListView(
        children: childrenWidgetList,
        onReorder: (oldIndex, newIndex) {
          var oldWidget = childrenWidgetList.removeAt(oldIndex);

          childrenWidgetList.insert(newIndex, oldWidget);
        },
      ),
    );
  }
}
