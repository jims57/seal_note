import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class FolderListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FolderListWidgetState();
}

class _FolderListWidgetState extends State<FolderListWidget> {
  List<GestureDetector> childrenWidgetList = List.generate(100, (index) {
    return GestureDetector(
      key: Key('FolderListWidget$index'),
      child: Container(
        height: 60.0,
        child: Column(
          children: [
            Container(
              height: 59.0,
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 25.0,
                    // color: Color(0xfffffbb5),
                    color: Color(0xff696a6b),
                    // color: Color.fromRGBO(0, 0, 0, 0.5),
                    // color: Color.fromRGBO(0, 0, 255, 0.5),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        '英语知识$index',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      )),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black12,
              thickness: 1,
              indent: 15.0,
              endIndent: 15.0,
            )
          ],
        ),
      ),
      onTap: () {
        // click on folder item // click folder item
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
      // height: (GlobalState.screenHeight -
      //     GlobalState.folderPageBottomContainerHeight -
      //     GlobalState.appBarHeight -
      //     GlobalState.keyboardHeight),
      // color: Colors.yellow,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: ReorderableListView(
        children: childrenWidgetList,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            // These two lines are workarounds for ReorderableListView problems
            if (newIndex > childrenWidgetList.length)
              newIndex = childrenWidgetList.length;
            if (oldIndex < newIndex) newIndex--;

            var oldWidget = childrenWidgetList.removeAt(oldIndex);

            childrenWidgetList.insert(newIndex, oldWidget);
          });
        },
      ),
    );
  }
}
