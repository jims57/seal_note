import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'folderPageWidgets/UserFolderListListenerWidget.dart';

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
  List<Widget> childrenWidgetList = List<Widget>();

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

    getAllFolders();

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
              setState(() {
                // These two lines are workarounds for ReorderableListView problems
                if (newIndex > childrenWidgetList.length)
                  newIndex = childrenWidgetList.length;
                if (oldIndex < newIndex) newIndex--;

                var isDefaultFolder = checkIfDefaultFolder(index: oldIndex);

                if (newIndex != oldIndex &&
                    !isDefaultFolder &&
                    GlobalState.shouldReorderFolderListItem) {
                  var oldWidget = childrenWidgetList.removeAt(oldIndex);

                  childrenWidgetList.insert(newIndex, oldWidget);
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
        getAllFolders();
      }
    });
  }

  // Private method
  bool checkIfDefaultFolder({@required index}) {
    bool isDefaultFolder = false;

    if (GlobalState.defaultFolderIndexList.contains(index)) {
      isDefaultFolder = true;
    }

    return isDefaultFolder;
  }

  Widget getFolderListItem(
      {int index = 0,
      bool isDefaultFolder = false,
      IconData icon = Icons.folder_open_outlined,
      Color iconColor = GlobalState.themeLightBlueColor07,
      @required int folderId,
      @required String folderName,
      @required int numberToShow,
      bool isReviewFolder = false,
      bool canSwipe = true,
      bool showDivider = true,
      Color badgeBackgroundColor = GlobalState.themeBlueColor,
      bool showBadgeBackgroundColor = false,
      bool showZero = true,
      bool isRoundTopCorner = false,
      bool isRoundBottomCorner = false}) {
    // Check if this is a default folder, if yes, we need to add the folder total
    if (isDefaultFolder) {
      GlobalState.allFolderTotal += 1;

      // Record the default folder index to list
      GlobalState.defaultFolderIndexList.add(index);
    }

    return GestureDetector(
      key: (isDefaultFolder)
          ? Key('defaultFolderListItem$index')
          : Key('userFolderListItem$index'),
      child: UserFolderListListenerWidget(
        icon: icon,
        iconColor: iconColor,
        folderName: folderName,
        numberToShow: numberToShow,
        isReviewFolder: isReviewFolder,
        isDefaultFolder: isDefaultFolder,
        badgeBackgroundColor: badgeBackgroundColor,
        showBadgeBackgroundColor: showBadgeBackgroundColor,
        showZero: showZero,
        showDivider: showDivider,
        canSwipe: canSwipe,
        folderListItemHeight: GlobalState.folderListItemHeight,
        folderListPanelMarginForTopOrBottom:
            folderListPanelMarginForTopOrBottom,
        isRoundTopCorner: isRoundTopCorner,
        isRoundBottomCorner: isRoundBottomCorner,
      ),
      onTap: () {
        // click on folder item // click folder item // click folder list item event
        // click folder item event

        // Update the note list
        GlobalState.isDefaultFolderSelected = isDefaultFolder;
        GlobalState.selectedFolderId = folderId;
        GlobalState.selectedFolderName = folderName;
        GlobalState.isReviewFolderSelected = isReviewFolder;
        GlobalState.noteListWidgetForTodayState.currentState.triggerSetState();

        // Switch the page
        GlobalState.isHandlingFolderPage = true;
        GlobalState.isInFolderPage = false;
        GlobalState.masterDetailPageState.currentState
            .updatePageShowAndHide(shouldTriggerSetState: true);
      },
    );
  }

  void getAllFolders() {
    childrenWidgetList.clear();

    GlobalState.database.getAllFolders().then((folders) {
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

        childrenWidgetList.add(getFolderListItem(
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
        ));
      }
    });
  }
}
