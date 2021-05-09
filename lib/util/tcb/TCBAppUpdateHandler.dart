class TCBAppUpdateHandler {
  static Future<double> getMaxAppVersionReleased() async {
    await Future.delayed(Duration(seconds: 2), () {});

    return 1.9;
  }
}
