import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'dart:math';
import 'package:after_layout/after_layout.dart';

double _getAppBarTitleWidth(
    double screenWidth, double leadingWidth, double tailWidth) {
  return (screenWidth - leadingWidth - tailWidth);
}

List<Widget> _getContainerList(List<Widget> leadingChildren) {
  int _currentIndex = 0;

  return leadingChildren.map((e) {
    _currentIndex += 1;
    return Container(
      margin: EdgeInsets.only(
          left: ((_currentIndex == 1) ? 0.0 : ((_currentIndex - 1) * 35.0))),
      child: e,
    );
  }).toList();
}

class AppBarWidget extends StatefulWidget with PreferredSizeWidget {
  AppBarWidget(
      {Key key,
      @required this.leadingChildren,
      this.title,
      @required this.tailChildren,
      this.showSyncStatus =
          true, // Check if we should show the sync text and icon below the title
      this.forceToShowLeadingWidgets = false,
      this.leadingWidth: 100,
      this.tailWidth: 60,
      this.backgroundColor})
      : super(key: key);

  final List<Widget> leadingChildren;
  final Widget title;
  final List<Widget> tailChildren;
  final bool showSyncStatus;
  final bool forceToShowLeadingWidgets;
  final double leadingWidth;
  final double tailWidth;
  final Color backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => AppBarWidgetState();
}

class AppBarWidgetState extends State<AppBarWidget>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<AppBarWidget> {
  AppState _appState;
  AnimationController _animationController;

  Color backgroundColor;

  @override
  void initState() {
    if (widget.backgroundColor == null) {
      backgroundColor = GlobalState.themeBlueColor;
    } else {
      backgroundColor = widget.backgroundColor;
    }

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    _appState = Provider.of<AppState>(context, listen: false);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    GlobalState.appBarHeight = Scaffold.of(context).appBarMaxHeight;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // App bar widget build method
    // Get title size
    double _titleWidth = _getAppBarTitleWidth(
        GlobalState.screenWidth, widget.leadingWidth, widget.tailWidth);

    // Get AppBar height
    double _appBarHeight = widget.preferredSize.height;

    // Margin width
    double marginWidth =
        (GlobalState.screenType == 1 ? widget.leadingWidth : widget.tailWidth);

    return AppBar(
      elevation: 0.0,
      backgroundColor: backgroundColor,
      title: Stack(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ((GlobalState.screenType == 3 &&
                        !widget.forceToShowLeadingWidgets)
                    ? Container()
                    : Container(
                        width: widget.leadingWidth,
                        color: Colors.transparent,
                        height: _appBarHeight,
                        child: Stack(
                          children: _getContainerList(widget.leadingChildren),
                          alignment: Alignment.centerLeft,
                        ),
                      )), // Leading container
                Container(
                  width: widget.tailWidth,
                  height: _appBarHeight,
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: _getContainerList(widget.tailChildren),
                  ),
                ) // Tailing container
              ],
            ),
          ), // App bar left and right container(leading and tailing parts)
          Container(
            // App bar title container including sync statuc
            alignment: Alignment.center,
            width: _titleWidth,
            height: _appBarHeight,
            margin: EdgeInsets.only(left: marginWidth, right: marginWidth),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    child: (widget.title == null) ? Text('') : widget.title),
                (widget.showSyncStatus)
                    ? Consumer<AppState>(
                        builder: (ctx, appState, child) {
                          if (!appState.isExecutingSync) {
                            return Container();
                          } else {
                            return Container(
                              margin: EdgeInsets.only(top: 40.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedBuilder(
                                    animation: _animationController,
                                    builder: (ctx, child) {
                                      return Transform.rotate(
                                        angle:
                                            _animationController.value * 2 * pi,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      Icons.sync,
                                      size: 8.0,
                                    ),
                                  ),
                                  Text(
                                    // sync status // sync label
                                    '同步中...',
                                    style: TextStyle(
                                        fontSize: 8.0,
                                        color:
                                            GlobalState.themeBlackColorForFont),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      )
                    : Container(), // Show sync status
              ],
            ),
          ) // Title container
        ],
      ),
      titleSpacing: 0.0,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _appState.isExecutingSync = true;
  }

  // Private methods
  double getAppBarHeight() {
    var appBarHeight = Scaffold.of(context).appBarMaxHeight;

    return appBarHeight;
  }
}
