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
      @required this.tailChildren,
      @required this.title,
      this.leadingWidth: 110,
      this.tailWidth: 30})
      : super(key: key);

  final List<Widget> leadingChildren;
  final List<Widget> tailChildren;
  final Widget title;
  final double leadingWidth;
  final double tailWidth;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  State<StatefulWidget> createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<AppBarWidget> {
  AppState _appState;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    _appState = Provider.of<AppState>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get title size
    double _titleWidth = _getAppBarTitleWidth(
        GlobalState.screenWidth, widget.leadingWidth, widget.tailWidth);

    double _offsetToRight = widget.leadingWidth - widget.tailWidth;

    // Get AppBar height
    double _appBarHeight = widget.preferredSize.height;

    // Margin width
    double marginWidth =
        (GlobalState.screenType == 1 ? widget.leadingWidth : widget.tailWidth);

    return AppBar(
      elevation: 0.0,
      title: Stack(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (GlobalState.screenType == 3
                    ? Container()
                    : Container(
                        width: widget.leadingWidth,
                        height: _appBarHeight,
                        child: Stack(
                          children: _getContainerList(widget.leadingChildren),
                          alignment: Alignment.centerLeft,
                        ),
                      )),
                Container(
                  width: widget.tailWidth,
                  height: _appBarHeight,
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: _getContainerList(widget.tailChildren),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: _titleWidth,
            height: _appBarHeight,
            margin: EdgeInsets.only(left: marginWidth, right: marginWidth),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(child: widget.title),
                Consumer<AppState>(
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
                                  angle: _animationController.value * 2 * pi,
                                  child: child,
                                );
                              },
                              child: Icon(
                                Icons.sync,
                                size: 8.0,
                              ),
                            ),
                            Text(
                              '同步中...',
                              style: TextStyle(fontSize: 8.0),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
      titleSpacing: 0.0,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _appState.isExecutingSync = true;
  }
}
