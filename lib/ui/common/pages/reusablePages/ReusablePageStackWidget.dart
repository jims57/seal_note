import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ReusablePageChangeNotifier.dart';
import 'package:seal_note/data/appstate/ReusablePageWidthChangeNotifier.dart';
import 'package:seal_note/model/ReusablePage/ReusablePageModel.dart';
import 'package:seal_note/ui/common/pages/reusablePages/ReusablePageWidget.dart';

class ReusablePageStackWidget extends StatefulWidget {
  ReusablePageStackWidget({
    @required Key key,
    this.firstReusablePageTitle = '',
    @required this.child,
  }) : super(key: key);

  final String firstReusablePageTitle;
  final Widget child;

  @override
  ReusablePageStackWidgetState createState() => ReusablePageStackWidgetState();
}

class ReusablePageStackWidgetState extends State<ReusablePageStackWidget> {
  List<Consumer<ReusablePageChangeNotifier>> _reusablePageChangeNotifierList;
  var theReusablePageWidth;

  @override
  void initState() {
    _initReusablePage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ReusablePageStackWidget oldWidget) {
    // Execute the _initReusablePage method only when it is opening the new reusable page rather than closing it
    if (GlobalState.reusablePageChangeNotifier.upcomingReusablePageIndex == 0) {
      _initReusablePage();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalState.themeGreyColorAtiOSTodoForBackground,
      height: GlobalState.screenHeight,
      width: getReusablePageWidth(),
      // width: double.infinity,
      // width: 1500,
      child: Stack(
        children: _reusablePageChangeNotifierList,
      ),
    );
  }

  // Private methods
  List<Consumer<ReusablePageChangeNotifier>> _buildReusablePageList() {
    List<Consumer<ReusablePageChangeNotifier>> list =
        <Consumer<ReusablePageChangeNotifier>>[];

    for (var i = 0; i < GlobalState.reusablePageWidgetList.length; i++) {
      var theReusablePageModel = GlobalState.reusablePageWidgetList[i];

      list.add(Consumer<ReusablePageChangeNotifier>(
          builder: (cxt, reusablePageChangeNotifier, child) {
        return SlideTransition(
          position: _getAnimation(
              currentReusablePageIndex: i,
              upcomingReusablePageIndex:
                  reusablePageChangeNotifier.upcomingReusablePageIndex),
          child: ReusablePageWidget(
            index: i,
            child: theReusablePageModel.reusablePageWidget,
            title: theReusablePageModel.reusablePageTitle,
            isSubPage: (i == 0) ? true : false,
          ),
        );
      }));
    }

    return list;
  }

  Animation<Offset> _getAnimation(
      {@required int currentReusablePageIndex,
      @required int upcomingReusablePageIndex}) {
    var _reusablePageFromDx;
    var _reusablePageToDx;

    if (GlobalState.isUpcomingReusablePageMovingToLeft) {
      // When it is opening the sub page
      if (currentReusablePageIndex == upcomingReusablePageIndex) {
        _reusablePageFromDx = 1.0;
        _reusablePageToDx = 0.0;
      } else if (currentReusablePageIndex > upcomingReusablePageIndex) {
        _reusablePageFromDx = 1.0;
        _reusablePageToDx = 1.0;
      } else {
        _reusablePageFromDx = 0.0;
        _reusablePageToDx = 0.0;
      }
    } else {
      // When it is exiting the sub page
      var existingReusablePageIndex = upcomingReusablePageIndex + 1;
      if (currentReusablePageIndex == existingReusablePageIndex) {
        _reusablePageFromDx = 0.0;
        _reusablePageToDx = 1.0;
      } else if (currentReusablePageIndex > existingReusablePageIndex) {
        _reusablePageFromDx = 1.0;
        _reusablePageToDx = 1.0;
      } else {
        _reusablePageFromDx = 0.0;
        _reusablePageToDx = 0.0;
      }
    }

    return GlobalState.masterDetailPageState.currentState
        .getAnimation(fromDx: _reusablePageFromDx, toDx: _reusablePageToDx);
  }

  void _postHandleReusablePageWidgetList(
      {@required bool shouldTriggerSetState,
      @required int upcomingReusablePageIndex}) {
    _reusablePageChangeNotifierList = _buildReusablePageList();

    if (shouldTriggerSetState) {
      triggerSetState();
    }
  }

  void _initReusablePage() {
    GlobalState.reusablePageWidgetList.clear();

    showReusablePage(
        reusablePageTitle: widget.firstReusablePageTitle,
        reusablePageWidget: widget.child,
        upcomingReusablePageIndex: 0,
        updateReusablePageChangeNotifier: false);
  }

  // Public methods
  void triggerSetState() {
    setState(() {});
  }

  double getReusablePageWidth({
    bool forceToUpdateCurrentReusablePageWidthVarAtGlobalState = true,
  }) {
    // get reusable page width // reusable page width

    var reusablePageWidth;

    if (GlobalState.screenType == 1) {
      reusablePageWidth = GlobalState.screenWidth;
    } else if (GlobalState.screenType == 2) {
      reusablePageWidth = GlobalState.currentFolderPageWidth;
    } else {
      reusablePageWidth = GlobalState.currentFolderPageWidth +
          GlobalState.currentNoteListPageWidth;
    }

    if (forceToUpdateCurrentReusablePageWidthVarAtGlobalState) {
      GlobalState.currentReusablePageWidth = reusablePageWidth;
    }

    return reusablePageWidth;
  }

  void showReusablePage({
    @required String reusablePageTitle,
    @required Widget reusablePageWidget,
    @required int upcomingReusablePageIndex,
    bool updateReusablePageChangeNotifier = true,
  }) {
    GlobalState.reusablePageStackWidgetState.currentState
        .appendReusablePageWidgetToList(
            reusablePageTitle: reusablePageTitle,
            widget: reusablePageWidget,
            upcomingReusablePageIndex: upcomingReusablePageIndex);

    if (updateReusablePageChangeNotifier) {
      GlobalState.reusablePageChangeNotifier.upcomingReusablePageIndex =
          upcomingReusablePageIndex;
    }
  }

  void appendReusablePageWidgetToList({
    String reusablePageTitle = '',
    @required Widget widget,
    @required int upcomingReusablePageIndex,
    bool shouldTriggerSetState = true,
  }) {
    // Mark it is opening the sub page
    GlobalState.isUpcomingReusablePageMovingToLeft = true;

    // First we remove the items whose index is greater or equal the upcoming reusable page index
    var listLength = GlobalState.reusablePageWidgetList.length;
    var lastPageIndex = listLength - 1;
    if (lastPageIndex >= upcomingReusablePageIndex) {
      GlobalState.reusablePageWidgetList
          .removeRange(upcomingReusablePageIndex, listLength);
    }

    GlobalState.reusablePageWidgetList.add(ReusablePageModel(
        reusablePageTitle: reusablePageTitle, reusablePageWidget: widget));

    _postHandleReusablePageWidgetList(
      shouldTriggerSetState: shouldTriggerSetState,
      upcomingReusablePageIndex: upcomingReusablePageIndex,
    );
  }

  void clickOnReusablePageBackButton({
    @required int reusablePageIndex,
    bool refreshFolderListWhenClosingLastReusablePage = false,
  }) {
    // Only the back button on the reusable page will move the upcoming reusable page to right
    GlobalState.isUpcomingReusablePageMovingToLeft = false;

    var upcomingReusablePageIndex = reusablePageIndex - 1;
    GlobalState.reusablePageChangeNotifier.upcomingReusablePageIndex =
        upcomingReusablePageIndex;

    if (upcomingReusablePageIndex == -1) {
      // close reusable page // exist reusable page

      GlobalState.masterDetailPageState.currentState
          .triggerToHideReusablePage();

      // When the reusable page is going to hide, we clear all items from the reusablePageWidgetList variable
      GlobalState.reusablePageWidgetList.clear();

      // Check if we should refresh the folder page to reflect its up-to-date
      if (refreshFolderListWhenClosingLastReusablePage) {
        GlobalState.folderListWidgetState.currentState
            .triggerSetState(forceToFetchFoldersFromDb: true);
      }
    }

    // If the user doesn't login, and show Login Page forcibly
    if (!GlobalState.isLoggedIn) {
      GlobalState.loginPageState.currentState.showLoginPage();
    }
  }
}
