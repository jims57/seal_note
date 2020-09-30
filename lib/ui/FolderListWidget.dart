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
  String todayTitle = '今日';
  bool isPointerDown = false;

  int defaultFolderTotal = 1;

  double folderListPanelMarginForTopOrBottom = 5.0;
  List<Widget> childrenWidgetList;

  @override
  void initState() {
    GlobalState.userFolderTotal = widget.userFolderTotal;
    GlobalState.allFolderTotal = GlobalState.userFolderTotal;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    //Always clear the existing record
    GlobalState.defaultFolderIndexList.clear();

    childrenWidgetList = List.generate(widget.userFolderTotal, (index) {
      return getFolderListItem(
          index: index,
          folderName: '英语知识$index',
          numberToShow: index,
          showDivider: true,
          showZero: true);
    });

    childrenWidgetList.insert(
        0,
        getFolderListItem(
          index: 0,
          isDefaultFolder: true,
          folderName: '$todayTitle',
          numberToShow: 546,
          showBadgeBackgroundColor: true,
          canSwipe: false,
          isRoundTopCorner: true,
        ));

    childrenWidgetList.insert(
        1,
        getFolderListItem(
            index: 1,
            isDefaultFolder: true,
            folderName: '全部笔记',
            numberToShow: 2203,
            canSwipe: false));

    childrenWidgetList.add(getFolderListItem(
      index: GlobalState.allFolderTotal,
      isDefaultFolder: true,
      folderName: '删除笔记',
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
      // color: Colors.red,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          // color: (todayTitle == '今日3333') ? Colors.red : Colors.green,
          height: GlobalState.screenHeight -
              GlobalState.appBarHeight -
              GlobalState.folderPageBottomContainerHeight -
              folderListPanelMarginForTopOrBottom * 2,
          // color: Colors.green,
          child: ReorderableListView(
            // header: Container(,child: Text('Folder')),
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
      @required String folderName,
      @required int numberToShow,
      bool canSwipe = true,
      bool isFirstItem = false,
      bool showDivider = true,
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
        folderName: folderName,
        numberToShow: numberToShow,
        isDefaultFolder: isDefaultFolder,
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
