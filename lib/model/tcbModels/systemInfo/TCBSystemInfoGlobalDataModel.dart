class TCBSystemInfoGlobalDataModel {
  final double latestAppVersionReleased;
  final double minSupportedAppVersion;
  final double reviewedAppVersion;

  TCBSystemInfoGlobalDataModel({
    this.latestAppVersionReleased,
    this.minSupportedAppVersion,
    this.reviewedAppVersion,
  });

  factory TCBSystemInfoGlobalDataModel.fromHashMap(
      Map<dynamic, dynamic> tcbSystemInfoGlobalDataHashMap) {
    return TCBSystemInfoGlobalDataModel(
      latestAppVersionReleased:
          double.parse(tcbSystemInfoGlobalDataHashMap['latestAppVersionReleased']),
      minSupportedAppVersion:
          double.parse(tcbSystemInfoGlobalDataHashMap['minSupportedAppVersion']),
      reviewedAppVersion:
          double.parse(tcbSystemInfoGlobalDataHashMap['reviewedAppVersion']),
    );
  }
}
