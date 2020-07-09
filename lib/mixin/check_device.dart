import 'package:flutter/material.dart';

mixin CheckDeviceMixin {
  int checkScreenType(double screenWidth) {
    int _screenType = 1;

    if (screenWidth > 810) {
      _screenType = 3;
    } else if (screenWidth <= 600) {
      _screenType = 1;
    } else {
      _screenType = 2;
    }

    return _screenType;
  }

  double getScreenWidth(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return _screenWidth;
  }

  double getScreenHeight(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;

    return _screenHeight;
  }
}
