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
  double folderListPanelMarginForTopOrBottom = 5.0;
  List<FolderListItemWidget> folderListItemWidgetList =
      <FolderListItemWidget>[];
  List<GetFoldersWithUnreadTotalResult> foldersWithUnreadTotalResultList =
      <GetFoldersWithUnreadTotalResult>[];

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
    // Always clear the existing record
    GlobalState.defaultFolderIndexList.clear();

    _getAllFolders(triggerSetState: true);

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
            children: folderListItemWidgetList,
            onReorder: (oldIndex, newIndex) {
              // reorder folder event // order folder event
              // order folder

              setState(() {
                // These two lines are workarounds for ReorderableListView problems
                if (newIndex > folderListItemWidgetList.length)
                  newIndex = folderListItemWidgetList.length;
                if (oldIndex < newIndex) newIndex--;

                var isDefaultFolder = _checkIfDefaultFolder(index: oldIndex);

                if (newIndex != oldIndex &&
                    !isDefaultFolder &&
                    GlobalState.shouldReorderFolderListItem) {
                  var oldWidget = folderListItemWidgetList.removeAt(oldIndex);

                  folderListItemWidgetList.insert(newIndex, oldWidget);

                  // update folder order // change folder order
                  // Update the folders' order
                  var foldersCompanionList = <FoldersCompanion>[];
                  var order = 1;

                  // Get latest folders' order
                  folderListItemWidgetList.forEach((item) {
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

  // Private method
  bool _checkIfDefaultFolder({@required index}) {
    bool isDefaultFolder = false;

    if (GlobalState.defaultFolderIndexList.contains(index)) {
      isDefaultFolder = true;
    }

    return isDefaultFolder;
  }

  void _getAllFolders(
      {bool forceToFetchFoldersFromDb = true,
      bool triggerSetState = false}) async {
    // get folder data // get all folder data
    // get all folder // get folder list data

    if (forceToFetchFoldersFromDb) {
      foldersWithUnreadTotalResultList.clear();
    }

    GlobalState.defaultFolderIndexList.clear();

    if (forceToFetchFoldersFromDb) {
      foldersWithUnreadTotalResultList =
          await GlobalState.database.getListForFoldersWithUnreadTotal();
      _buildFolderListItemsByList(
          foldersWithUnreadTotalResultList: foldersWithUnreadTotalResultList);
    } else {
      _buildFolderListItemsByList(
          foldersWithUnreadTotalResultList: foldersWithUnreadTotalResultList);
    }

    if (triggerSetState) {
      setState(() {});
    }
  }

  void _buildFolderListItemsByList(
      {@required
          List<GetFoldersWithUnreadTotalResult>
              foldersWithUnreadTotalResultList}) {
    GlobalState.userFolderTotal = foldersWithUnreadTotalResultList.length;
    GlobalState.allFolderTotal = GlobalState.userFolderTotal;

    folderListItemWidgetList.clear(); // Always to clear items in the list

    for (var index = 0;
        index < foldersWithUnreadTotalResultList.length;
        index++) {
      var theFolder = foldersWithUnreadTotalResultList[index];
      var isDefaultFolder = theFolder.isDefaultFolder;
      var folderId = theFolder.id;
      var folderName = '${theFolder.name}';
      var reviewPlanId = theFolder.reviewPlanId;
      var numberToShow = theFolder.numberToShow;
      var isReviewFolder = (theFolder.reviewPlanId != null) ? true : false;
      var isTodayFolder = (isDefaultFolder &&
          folderName == GlobalState.defaultFolderNameForToday);
      var isAllNotesFolder = (isDefaultFolder &&
          folderName == GlobalState.defaultFolderNameForAllNotes);
      var isDeletionFolder = (isDefaultFolder &&
          folderName == GlobalState.defaultFolderNameForDeletion);
      var showZero = true;

      // Check if this is an item selected by the user currently
      var isItemSelected = false;
      if (GlobalState.screenType == 3 &&
          GlobalState.selectedFolderIdCurrently == folderId) {
        isItemSelected = true;
      }

      // Record the review plan id for the default selected folder
      if (folderId == GlobalState.selectedFolderIdByDefault) {
        GlobalState.selectedFolderReviewPlanId = reviewPlanId;
      }

      // If this is Today folder, it doesn't show zero by default
      if (isDefaultFolder &&
          folderName == GlobalState.defaultFolderNameForToday) {
        showZero = false;
      }

      folderListItemWidgetList.add(FolderListItemWidget(
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
        reviewPlanId: reviewPlanId,
        isReviewFolder: isReviewFolder,
        badgeBackgroundColor: (isTodayFolder)
            ? GlobalState.themeOrangeColorAtiOSTodo
            : GlobalState.themeOrangeColorAtiOSTodo,
        showBadgeBackgroundColor: (isTodayFolder) ? true : false,
        showDivider: true,
        showZero: showZero,
        canSwipe: (isDefaultFolder) ? false : true,
        isRoundTopCorner: (isTodayFolder) ? true : false,
        isRoundBottomCorner: (isDeletionFolder) ? true : false,
        folderListPanelMarginForTopOrBottom:
            folderListPanelMarginForTopOrBottom,
        isItemSelected: isItemSelected,
      ));
    }
  }

  // Public methods
  void triggerSetState({bool forceToFetchFoldersFromDb = false}) {
    setState(() {
      _getAllFolders(forceToFetchFoldersFromDb: forceToFetchFoldersFromDb);
    });
  }

  List<FolderListItemWidget> getFolderListItemList() {
    return folderListItemWidgetList;
  }
}
