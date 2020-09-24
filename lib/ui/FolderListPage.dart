import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:after_layout/after_layout.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';

import 'FolderListWidget.dart';

class FolderListPage extends StatefulWidget {
  FolderListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FolderListPageState();
}

class FolderListPageState extends State<FolderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        forceToShowLeadingWidgets: true,
        showSyncStatus: false,
        leadingWidth: GlobalState.currentFolderPageWidth / 2,
        leadingChildren: [
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              '文件夹',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
        tailChildren: [
          IconButton(
              icon: Icon(
                Icons.create_new_folder,
                color: Colors.white,
              ),
              onPressed: null)
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(child: FolderListWidget()),
            Container(
              height: GlobalState.folderPageBottomContainerHeight,
              child: Column(
                children: [
                  Container(
                    // alignment: Alignment.centerLeft,
                    height: GlobalState.folderPageBottomContainerHeight,
                    // color: Colors.green,
                    // color: Color(0xfff9fafb),
                    color: Color(0xffecedee),
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.settings,
                                size: 20,
                              ),
                              Text(
                                '设置',
                                style: TextStyle(fontSize: 10),
                              )
                            ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void triggerSetState() {
    setState(() {});
  }
}
