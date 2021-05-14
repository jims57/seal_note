class TCBSystemInfoBasicDataModel {
  final int structureVersion;
  final int dataVersion;

  TCBSystemInfoBasicDataModel({
    this.structureVersion,
    this.dataVersion,
  });

  factory TCBSystemInfoBasicDataModel.fromHashMap(
      Map<dynamic, dynamic> tcbSystemInfoBasicDataHashMap) {
    return TCBSystemInfoBasicDataModel(
      structureVersion:
          tcbSystemInfoBasicDataHashMap['structureVersion'],
      dataVersion: tcbSystemInfoBasicDataHashMap['dataVersion'],
    );
  }
}
