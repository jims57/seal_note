import 'package:flutter/material.dart';

double _getAppBarTitleWidth(
    double screenWidth, double leadingWidth, double tailWidth) {
  return (screenWidth - leadingWidth - tailWidth);
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
    // Get screen size
    double _screenWidth = MediaQuery.of(context).size.width;

    // Get title size
    double _titleWidth =
        _getAppBarTitleWidth(_screenWidth, leadingWidth, tailWidth);

    double _offsetToRight = leadingWidth - tailWidth;

    return AppBar(
      title: Row(
        children: [
          Container(
            width: leadingWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: leadingChildren,
            ),
          ),
          Container(
            color: Colors.green,
            width: _titleWidth,
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: Container(
              padding: EdgeInsets.only(right: _offsetToRight),
              color: Colors.deepPurpleAccent,
              child: Center(
                child: Text('$title'),
              ),
            ),
          ),
          Container(
            color: Colors.amber,
            width: tailWidth,
            child: Row(
              children: tailChildren,
            ),
          )
        ],
      ),
      titleSpacing: 0.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
