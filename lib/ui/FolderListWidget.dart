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

  int defaultFolderTotal = 1;

  double folderListPanelMarginForTopOrBottom = 5.0;
  List<Widget> childrenWidgetList;

  ScrollController controller;

  @override
  void initState() {
    GlobalState.userFolderTotal = widget.userFolderTotal;
    GlobalState.allFolderTotal = GlobalState.userFolderTotal;

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

    childrenWidgetList = List.generate(widget.userFolderTotal, (index) {
      return getFolderListItem(
          iconColor: GlobalState.themeLightBlueColorAtiOSTodo,
          index: index,
          folderName: '英语知识$index',
          numberToShow: index,
          showDivider: true,
          showZero: true);
    });

    childrenWidgetList.insert(
        0,
        getFolderListItem(
          icon: Icons.today_outlined,
          iconColor: GlobalState.themeOrangeColorAtiOSTodo,
          index: 0,
          isDefaultFolder: true,
          folderName: '${GlobalState.defaultFolderNameForToday}',
          numberToShow: 546,
          badgeBackgroundColor: GlobalState.themeOrangeColorAtiOSTodo,
          showBadgeBackgroundColor: true,
          canSwipe: false,
          isRoundTopCorner: true,
        ));

    childrenWidgetList.insert(
        1,
        getFolderListItem(
            icon: Icons.archive_outlined,
            iconColor: GlobalState.themeBrownColorAtiOSTodo,
            index: 1,
            isDefaultFolder: true,
            folderName: '${GlobalState.defaultFolderNameForAllNotes}',
            numberToShow: 2203,
            canSwipe: false));

    childrenWidgetList.add(getFolderListItem(
      icon: Icons.delete_sweep_outlined,
      iconColor: GlobalState.themeGreyColorAtiOSTodoForFolderGroupBackground,
      index: GlobalState.allFolderTotal,
      isDefaultFolder: true,
      folderName: '${GlobalState.defaultFolderNameForDeletion}',
      numberToShow: 43,
      canSwipe: false,
      showDivider: false,
      isRoundBottomCorner: true,
    ));

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
  void triggerSetState() {
    setState(() {});
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
      @required String folderName,
      @required int numberToShow,
      bool canSwipe = true,
      bool isFirstItem = false,
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
        // click on folder item // click folder item
        GlobalState.isHandlingFolderPage = true;
        GlobalState.isInFolderPage = false;

        GlobalState.masterDetailPageState.currentState
            .updatePageShowAndHide(shouldTriggerSetState: true);
      },
    );
  }
}
