class TCBSystemInfoModel {
  final double latestAppVersionReleased;
  final double minSupportedAppVersion;

  TCBSystemInfoModel({
    this.latestAppVersionReleased,
    this.minSupportedAppVersion,
  });

  factory TCBSystemInfoModel.fromJson(Map<dynamic, dynamic> tcbSystemInfoJson) {
    return TCBSystemInfoModel(
      latestAppVersionReleased: tcbSystemInfoJson['latestAppVersionReleased'],
      minSupportedAppVersion: tcbSystemInfoJson['minSupportedAppVersion'],
    );
  }
}