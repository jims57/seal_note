import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:seal_note/model/tcbModels/TCBReviewPlanModel.dart';
import '../TCBFolderModel.dart';
import '../TCBNoteModel.dart';
import '../TCBReviewPlanConfigModel.dart';
import 'TCBSystemInfoBasicDataModel.dart';
import 'TCBSystemInfoGlobalDataModel.dart';

class TCBSystemInfoModel {
  final TCBSystemInfoGlobalDataModel tcbSystemInfoGlobalData;
  final TCBSystemInfoBasicDataModel tcbSystemInfoBasicData;
  final List<TCBFolderModel> tcbSystemInfoFolderList;
  final List<TCBNoteModel> tcbSystemInfoNoteList;
  final List<TCBReviewPlanModel> tcbSystemInfoReviewPlanList;
  final List<TCBReviewPlanConfigModel> tcbSystemInfoReviewPlanConfigList;

  TCBSystemInfoModel({
    this.tcbSystemInfoGlobalData,
    this.tcbSystemInfoBasicData,
    this.tcbSystemInfoFolderList,
    this.tcbSystemInfoNoteList,
    this.tcbSystemInfoReviewPlanList,
    this.tcbSystemInfoReviewPlanConfigList,
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

    var tcbSystemInfoNoteList = TCBNoteModel.convertHashMapListToModelList(
      hashMapList: systemInfoBasicDataHashMap['notes'],
    );

    var tcbSystemInfoReviewPlanList =
        TCBReviewPlanModel.convertHashMapListToModelList(
      hashMapList: systemInfoBasicDataHashMap['reviewPlans'],
    );

    var tcbSystemInfoReviewPlanConfigList =
        TCBReviewPlanConfigModel.convertHashMapListToModelList(
      hashMapList: systemInfoBasicDataHashMap['reviewPlanConfigs'],
    );

    return TCBSystemInfoModel(
      tcbSystemInfoGlobalData: tcbSystemInfoGlobalData,
      tcbSystemInfoBasicData: tcbSystemInfoBasicData,
      tcbSystemInfoFolderList: tcbSystemInfoFolderList,
      tcbSystemInfoNoteList: tcbSystemInfoNoteList,
      tcbSystemInfoReviewPlanList: tcbSystemInfoReviewPlanList,
      tcbSystemInfoReviewPlanConfigList: tcbSystemInfoReviewPlanConfigList,
    );
  }
}
