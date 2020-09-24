import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

import 'folderPageWidgets/FolderListItemRightPartWidget.dart';

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
        // folder list item // folder item
        child: Column(
          children: [
            Container(
              height: 59.0,
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Icon(
                          // folder list item icon // folder item icon // folder icon
                          Icons.folder_open_outlined,
                          size: 25.0,
                          // color: Color(0xfffffbb5),
                          // color: Color(0xff696a6b),
                          // color: Color(0xff2b98f0),
                          // color: Color.fromRGBO(0, 0, 0, 0.5),
                          // color: Color.fromRGBO(43, 152, 240, 0.7),
                          color: GlobalState.themeLightBlueColor07,
                        ),
                        Container(
                            // folder name // folder list item name
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text(
                              (index == 0) ? '今日' : '英语知识$index',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FolderListItemRightPartWidget(
                      numberToShow: (index == 0) ? 653 : index,
                      showBadgeBackgroundColor: (index == 0) ? true : false,
                      showZero: false,
                    ),
                  ),
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
