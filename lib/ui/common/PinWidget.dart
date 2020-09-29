import 'package:flutter/material.dart';

class PinWidget extends StatelessWidget {
  PinWidget(
      {Key key,
      @required this.child,
      this.dx = 0.0,
      this.dy = 0.0,
      this.height = 10.0,
      this.width = 10.0})
      : super(key: key);

  final Widget child;
  final double dx;
  final double dy;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    print('dx = $dx, dy = $dy. \nheight = $height, width = $width.');
    return Transform(
        transform: Matrix4.translationValues(dx, dy, 0.0),
        child: Container(
          height: height,
          width: width,
          color: Colors.purple,
          child: child,
        ));
  }
}
