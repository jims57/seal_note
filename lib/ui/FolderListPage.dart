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
        tailWidth: GlobalState.currentFolderPageWidth / 4,
        leadingChildren: [
          // folder page title // folder page caption
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
          // folder page add button // add folder button
          // new folder button
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.create_new_folder,
                color: Colors.white,
                size: 28.0,
              ),
            ),
            onTap: () {},
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(child: FolderListWidget()),
            Container( // folder page bottom panel // setting panel
              height: GlobalState.folderPageBottomContainerHeight,
              child: Column(
                children: [
                  Container(
                    height: GlobalState.folderPageBottomContainerHeight,
                    // color: Colors.green,
                    // color: Color(0xfff9fafb),
                    color: GlobalState.themeGreyColor,
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
