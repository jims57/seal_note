import 'package:flutter/material.dart';
import 'package:moor/moor.dart' show Value;
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/ui/common/AppBarWidget.dart';
import 'package:after_layout/after_layout.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

import 'FolderListItemWidget.dart';
import 'FolderListWidget.dart';
import 'common/TextFieldWithClearButtonWidget.dart';

class FolderListPage extends StatefulWidget {
  FolderListPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FolderListPageState();
}

class FolderListPageState extends State<FolderListPage>
    with AfterLayoutMixin<FolderListPage> {
  @override
  void initState() {
    GlobalState.folderListWidgetState = GlobalKey<FolderListWidgetState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        // folder page app bar // folder list page app bar
        backgroundColor: GlobalState.themeGreyColorAtiOSTodoForBackground,
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
                  color: GlobalState.themeBlackColorForFont,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
        tailChildren: [
          // folder page add button // add folder button
          // new folder button // folder page folder button
          GestureDetector(
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 15.0),
              child: Icon(
                Icons.create_new_folder,
                color: GlobalState.themeBlueColor,
                size: 28.0,
              ),
            ),
            onTap: () async {
              // click on new folder button // click new folder button
              // new folder button // create folder button
              // click on create folder button // click create folder button
              // click to create folder button

              var newFolderName;

              var isOKButtonClicked = await AlertDialogHandler.showAlertDialog(
                  parentContext: context,
                  captionText: '新建文件夹',
                  remark: '请为此文件夹输入名称',
                  alwaysEnableOKButton: false,
                  child: TextFieldWithClearButtonWidget(
                    onTextChanged: (input) {
                      setState(() {
                        newFolderName = input.trim();

                        if (newFolderName.length > 0) {
                          GlobalState.appState.enableOKButton = true;
                        } else {
                          GlobalState.appState.enableOKButton = false;
                        }
                      });
                    },
                  ));

              // Check the user's action
              if (isOKButtonClicked) {
                // Insert the new folder into the db
                var foldersCompanion = FoldersCompanion(
                    name: Value(newFolderName),
                    order: Value(3),
                    isDefaultFolder: Value(false),
                    created: Value(TimeHandler.getNowForLocal()),
                    createdBy: Value(GlobalState.currentUserId));

                var createdFolderId =
                    await GlobalState.database.insertFolder(foldersCompanion);

                // Increase other user folders' order by one step except the newly created folder
                var effectedRowCount = await GlobalState.database
                    .increaseUserFoldersOrderByOneExceptNewlyCreatedOne(
                        createdFolderId);

                if (effectedRowCount > 0) {
                  // Trigger the folder list page to refresh
                  GlobalState.folderListWidgetState.currentState
                      .triggerSetState(forceToFetchFoldersFromDB: true);
                }
              }
            },
          )
        ],
      ),
      backgroundColor: GlobalState.themeGreyColorAtiOSTodoForBackground,
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: FolderListWidget(
                key: GlobalState.folderListWidgetState,
                // folder count // user folder total // user folder count
                userFolderTotal: 20,
              ),
            ),
            Container(
              // folder page bottom panel // setting panel
              // folder page setting panel
              height: GlobalState.folderPageBottomContainerHeight,
              child: Column(
                children: [
                  Container(
                    height: GlobalState.folderPageBottomContainerHeight,
                    color: GlobalState.themeGreyColorAtiOSTodoForBackground,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            child: Column(
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
                                ]),
                            color: Colors.transparent,
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          ),
                          onTap: () {
                            // setting event // click setting event
                          },
                        )
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

  @override
  void afterFirstLayout(BuildContext context) {
    GlobalState.isFolderListPageLoaded = true;
  }

  // Public Methods
  void triggerSetState() {
    setState(() {});
  }

  List<int> getDefaultFolderIds() {
    // Get all default folder Ids

    var defaultFolderIds = List<int>();
    var folderListItemList =
        GlobalState.folderListWidgetState.currentState.getFolderListItemList();

    folderListItemList.forEach((folderListItem) {
      if (folderListItem.isDefaultFolder) {
        defaultFolderIds.add(folderListItem.folderId);
      }
    });

    return defaultFolderIds;
  }

  FolderListItemWidget getFolderListItemWidgetByFolderId({@required folderId}) {
    // Get folder list item widget from by a folder id

    var folderListItemList =
        GlobalState.folderListWidgetState.currentState.getFolderListItemList();

    var theFolderListItemWidget = folderListItemList
        .where((folderListItem) => folderListItem.folderId == folderId)
        .first;

    return theFolderListItemWidget;
  }

  List<FolderListItemWidget> getUserFolderListItemList() {
    var folderListItemList =
        GlobalState.folderListWidgetState.currentState.getFolderListItemList();

    var userFolderListItemList = folderListItemList
        .where((folderListItem) => !folderListItem.isDefaultFolder)
        .toList();

    return userFolderListItemList;
  }

  bool isDefaultFolder({@required folderId}) {
    // Check if the folder is a default folder or not
    var isDefault = false;

    if (getDefaultFolderIds().contains(folderId)) {
      isDefault = true;
    }

    return isDefault;
  }
}
