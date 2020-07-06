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
