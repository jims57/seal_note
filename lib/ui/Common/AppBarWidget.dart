import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/mixin/check_device.dart';

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

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
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
  final String title;
  final double leadingWidth;
  final double tailWidth;

  @override
  Widget build(BuildContext context) {
    // Get title size
    double _titleWidth =
        _getAppBarTitleWidth(GlobalState.screenWidth, leadingWidth, tailWidth);

    double _offsetToRight = leadingWidth - tailWidth;

    // Get AppBar height
    double _appBarHeight = preferredSize.height;

    // Margin width
    double marginWidth =
        (GlobalState.screenType == 1 ? leadingWidth : tailWidth);

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
                        width: leadingWidth,
                        height: _appBarHeight,
                        child: Stack(
                          children: _getContainerList(leadingChildren),
                          alignment: Alignment.centerLeft,
                        ),
                      )),
                Container(
                  width: tailWidth,
                  height: _appBarHeight,
                  alignment: Alignment.centerRight,
                  child: Stack(
                    children: _getContainerList(tailChildren),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: GlobalState.screenWidth,
            height: _appBarHeight,
            margin: EdgeInsets.only(left: marginWidth, right: marginWidth),
            child: Text('$title'),
          )
        ],
      ),
      titleSpacing: 0.0,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); //>>get appbar height
}
