import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:moor/moor.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/ui/FolderListItemWidget.dart';

class FolderListWidget extends StatefulWidget {
  FolderListWidget({Key key, @required this.userFolderTotal}) : super(key: key);

  final int userFolderTotal;

  @override
  State<StatefulWidget> createState() => FolderListWidgetState();
}

class FolderListWidgetState extends State<FolderListWidget> {
  bool isPointerDown = false;

  int defaultFolderTotal = 3;

  double folderListPanelMarginForTopOrBottom = 5.0;
  List<FolderListItemWidget> childrenWidgetList = List<FolderListItemWidget>();

  ScrollController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    //Always clear the existing record
    GlobalState.defaultFolderIndexList.clear();

    _getAllFolders();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: folderListPanelMarginForTopOrBottom,
          bottom: folderListPanelMarginForTopOrBottom,
          left: 15.0,
          right: 15.0),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: GlobalState.screenHeight -
              GlobalState.appBarHeight -
              GlobalState.folderPageBottomContainerHeight -
              folderListPanelMarginForTopOrBottom * 2,
          child: ReorderableListView(
            children: childrenWidgetList,
            onReorder: (oldIndex, newIndex) {
              // reorder folder event // order folder event
              // order folder

              setState(() {
                // These two lines are workarounds for ReorderableListView problems
                if (newIndex > childrenWidgetList.length)
                  newIndex = childrenWidgetList.length;
                if (oldIndex < newIndex) newIndex--;

                var isDefaultFolder = _checkIfDefaultFolder(index: oldIndex);

                if (newIndex != oldIndex &&
                    !isDefaultFolder &&
                    GlobalState.shouldReorderFolderListItem) {
                  var oldWidget = childrenWidgetList.removeAt(oldIndex);

                  childrenWidgetList.insert(newIndex, oldWidget);

                  // update folder order // change folder order
                  // Update the folders' order
                  var foldersCompanionList = List<FoldersCompanion>();
                  var order = 1;

                  // Get latest folders' order
                  childrenWidgetList.forEach((item) {
                    foldersCompanionList.add(FoldersCompanion(
                        id: Value(item.folderId), order: Value(order)));

                    order++;
                  });

                  // Save folders' orders into db
                  GlobalState.database.reorderFolders(foldersCompanionList);
                }
              });
            },
          ),
        ),
      ),
    );
  }

  // Public methods
  void triggerSetState({bool forceToFetchFoldersFromDB = false}) {
    setState(() {
      if (forceToFetchFoldersFromDB) {
        _getAllFolders();
      }
    });
  }

  // Private method
  bool _checkIfDefaultFolder({@required index}) {
    bool isDefaultFolder = false;

    if (GlobalState.defaultFolderIndexList.contains(index)) {
      isDefaultFolder = true;
    }

    return isDefaultFolder;
  }

  void _getAllFolders() {
    childrenWidgetList.clear();
    // get folder data // get all folder data
    // get all folder // get folder list data

    GlobalState.database.getListForFoldersWithUnreadTotal().then((folders) {
      GlobalState.userFolderTotal = folders.length;
      GlobalState.allFolderTotal = GlobalState.userFolderTotal;

      for (var index = 0; index < folders.length; index++) {
        var theFolder = folders[index];
        var isDefaultFolder = theFolder.isDefaultFolder;
        var folderId = theFolder.id;
        var folderName = '${theFolder.name}';
        var numberToShow = theFolder.numberToShow;
        var isReviewFolder = (theFolder.reviewPlanId != null) ? true : false;
        var isTodayFolder = (isDefaultFolder &&
            folderName == GlobalState.defaultFolderNameForToday);
        var isAllNotesFolder = (isDefaultFolder &&
            folderName == GlobalState.defaultFolderNameForAllNotes);
        var isDeletionFolder = (isDefaultFolder &&
            folderName == GlobalState.defaultFolderNameForDeletion);

        // childrenWidgetList.add(getFolderListItem(
        childrenWidgetList.add(FolderListItemWidget(
          key: Key('FolderListItemWidget$index'),
          icon: (isTodayFolder)
              ? Icons.today_outlined
              : ((isAllNotesFolder)
                  ? Icons.archive_outlined
                  : ((isDeletionFolder)
                      ? Icons.delete_sweep_outlined
                      : Icons.folder_open_outlined)),
          iconColor: (isTodayFolder)
              ? GlobalState.themeOrangeColorAtiOSTodo
              : ((isAllNotesFolder)
                  ? GlobalState.themeBrownColorAtiOSTodo
                  : ((isDeletionFolder)
                      ? GlobalState
                          .themeGreyColorAtiOSTodoForFolderGroupBackground
                      : GlobalState.themeLightBlueColorAtiOSTodo)),
          index: index,
          isDefaultFolder: isDefaultFolder,
          folderId: folderId,
          folderName: folderName,
          numberToShow: numberToShow,
          isReviewFolder: isReviewFolder,
          badgeBackgroundColor: (isTodayFolder)
              ? GlobalState.themeOrangeColorAtiOSTodo
              : GlobalState.themeOrangeColorAtiOSTodo,
          showBadgeBackgroundColor: (isTodayFolder) ? true : false,
          showDivider: true,
          showZero: true,
          canSwipe: (isDefaultFolder) ? false : true,
          isRoundTopCorner: (isTodayFolder) ? true : false,
          isRoundBottomCorner: (isDeletionFolder) ? true : false,
          folderListPanelMarginForTopOrBottom:
              folderListPanelMarginForTopOrBottom,
        ));
      }
    });
  }
}
