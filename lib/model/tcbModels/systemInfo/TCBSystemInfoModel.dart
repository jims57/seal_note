import 'package:cloudbase_database/cloudbase_database.dart';

import '../TCBFolderModel.dart';
import 'TCBSystemInfoBasicDataModel.dart';
import 'TCBSystemInfoGlobalDataModel.dart';

class TCBSystemInfoModel {
  final TCBSystemInfoGlobalDataModel tcbSystemInfoGlobalData;
  final TCBSystemInfoBasicDataModel tcbSystemInfoBasicData;
  final List<TCBFolderModel> tcbSystemInfoFolderList;

  TCBSystemInfoModel({
    this.tcbSystemInfoGlobalData,
    this.tcbSystemInfoBasicData,
    this.tcbSystemInfoFolderList,
  });

  factory TCBSystemInfoModel.fromHashMap(
      DbQueryResponse tcbSystemInfoResultHashMap) {
    var systemInfoGlobalDataHashMap = tcbSystemInfoResultHashMap.data[0];
    var systemInfoBasicDataHashMap = tcbSystemInfoResultHashMap.data[1];

    // Convert HashMap to model
    var tcbSystemInfoGlobalData =
        TCBSystemInfoGlobalDataModel.fromHashMap(systemInfoGlobalDataHashMap);
    var tcbSystemInfoBasicData =
        TCBSystemInfoBasicDataModel.fromHashMap(systemInfoBasicDataHashMap);
    var tcbSystemInfoFolderList = TCBFolderModel.convertHashMapListToModelList(
      hashMapList: systemInfoBasicDataHashMap['folders'],
    );

    return TCBSystemInfoModel(
      tcbSystemInfoGlobalData: tcbSystemInfoGlobalData,
      tcbSystemInfoBasicData: tcbSystemInfoBasicData,
      tcbSystemInfoFolderList: tcbSystemInfoFolderList,
    );
  }
}
