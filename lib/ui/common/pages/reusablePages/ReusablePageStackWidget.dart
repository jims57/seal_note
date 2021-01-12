import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ReusablePageChangeNotifier.dart';
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
  double reusablePageFromDx = 0.0;
  double reusablePageToDx = 0.0;

  List<Consumer<ReusablePageChangeNotifier>> _reusablePageChangeNotifierList;

  @override
  void didChangeDependencies() {
    GlobalState.reusablePageWidgetList.clear();

    showReusablePage(
        reusablePageTitle: widget.firstReusablePageTitle,
        reusablePageWidget: widget.child,
        upcomingReusablePageIndex: 0,
        updateReusablePageChangeNotifier: false);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GlobalState.themeGreyColorAtiOSTodoForBackground,
      height: double.maxFinite,
      width: _getReusablePageWidth(),
      child: Stack(
        children: _reusablePageChangeNotifierList,
      ),
    );
  }

  // Private methods
  double _getReusablePageWidth() {
    var reusablePageWidth;

    if (GlobalState.screenType == 1) {
      reusablePageWidth = GlobalState.screenWidth;
    } else if (GlobalState.screenType == 2) {
      reusablePageWidth = GlobalState.currentFolderPageWidth;
    } else {
      reusablePageWidth = GlobalState.currentFolderPageWidth +
          GlobalState.currentNoteListPageWidth;
    }

    GlobalState.currentReusablePageWidth = reusablePageWidth;

    return reusablePageWidth;
  }

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

  // Public methods
  void triggerSetState() {
    setState(() {});
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

  void removeLastReusablePageWidgetFromList(
      {@required int upcomingReusablePageIndex,
      bool shouldTriggerSetState = true}) {
    GlobalState.reusablePageWidgetList.removeLast();

    _postHandleReusablePageWidgetList(
      shouldTriggerSetState: shouldTriggerSetState,
      upcomingReusablePageIndex: upcomingReusablePageIndex,
    );
  }
}
