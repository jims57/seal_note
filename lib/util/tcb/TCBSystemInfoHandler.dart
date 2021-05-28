import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/model/tcbModels/TCBFolderModel.dart';
import 'package:seal_note/model/tcbModels/TCBNoteModel.dart';
import 'package:seal_note/model/tcbModels/TCBReviewPlanConfigModel.dart';
import 'package:seal_note/model/tcbModels/TCBReviewPlanModel.dart';
import 'package:seal_note/model/tcbModels/systemInfo/TCBSystemInfoGlobalDataModel.dart';
import 'package:seal_note/model/tcbModels/systemInfo/TCBSystemInfoModel.dart';
import 'package:seal_note/util/tcb/TCBInitHandler.dart';

class TCBSystemInfoHandler {
  // Public methods
  static Future<ResponseModel<TCBSystemInfoGlobalDataModel>> getSystemInfo({
    bool forceToGetSystemInfoFromTCB = true,
  }) async {
    var response;

    if (forceToGetSystemInfoFromTCB) {
      // When fetching system info from TCB forcibly

      response = await _getSystemInfoFromTCB(
        updateSystemInfoBasicDataWhenDataVersionIsDifferent: true,
      );
    } else {
      // When don't fetch system info from TCB forcibly
      // Try to get the system info from GlobalState first

      if (GlobalState.tcbSystemInfo.tcbSystemInfoGlobalData != null) {
        response = ResponseModel.getResponseModelForSuccess<
                TCBSystemInfoGlobalDataModel>(
            result: GlobalState.tcbSystemInfo.tcbSystemInfoGlobalData);
      } else {
        response = await _getSystemInfoFromTCB(
          updateSystemInfoBasicDataWhenDataVersionIsDifferent: true,
        );
      }
    }

    return response;
  }

  // static Future<ResponseModel> updateSystemInfoBasicData(
  //     {@required TCBSystemInfoModel tcbSystemInfoModel}) async {
  //   ResponseModel response;
  //
  //   // Update folders in batch
  //   var foldersCompanionList =
  //       TCBFolderModel.convertTCBFolderModelListToFoldersCompanionList(
  //     tcbFolderModelList: tcbSystemInfoModel.tcbSystemInfoFolderList,
  //   );
  //   response = await GlobalState.database.updateFoldersByTransaction(
  //     foldersCompanionList: foldersCompanionList,
  //   );
  //
  //   // Update notes in batch
  //   if (response.code == ErrorCodeModel.SUCCESS_CODE) {
  //     var notesCompanionList =
  //         TCBNoteModel.convertTCBNoteModelListToNotesCompanionList(
  //       tcbNoteModelList: tcbSystemInfoModel.tcbSystemInfoNoteList,
  //     );
  //     response = await GlobalState.database.updateNotesByTransaction(
  //       notesCompanionList: notesCompanionList,
  //     );
  //   }
  //
  //   // Update review plans in batch
  //   if (response.code == ErrorCodeModel.SUCCESS_CODE) {
  //     var reviewPlansCompanionList = TCBReviewPlanModel
  //         .convertTCBReviewPlanModelListToReviewPlansCompanionList(
  //       tcbReviewPlanModelList: tcbSystemInfoModel.tcbSystemInfoReviewPlanList,
  //     );
  //     response = await GlobalState.database.updateReviewPlansByTransaction(
  //       reviewPlansCompanionList: reviewPlansCompanionList,
  //     );
  //   }
  //
  //   // Update review plan configs in batch
  //   if (response.code == ErrorCodeModel.SUCCESS_CODE) {
  //     var reviewPlanConfigsCompanionList = TCBReviewPlanConfigModel
  //         .convertTCBReviewPlanConfigModelListToReviewPlanConfigsCompanionList(
  //       tcbReviewPlanConfigModelList:
  //           tcbSystemInfoModel.tcbSystemInfoReviewPlanConfigList,
  //     );
  //     response =
  //         await GlobalState.database.updateReviewPlanConfigsByTransaction(
  //       reviewPlanConfigsCompanionList: reviewPlanConfigsCompanionList,
  //     );
  //   }
  //
  //   return response;
  // }


  static Future<ResponseModel> upsertSystemInfoBasicData(
      {@required TCBSystemInfoModel tcbSystemInfoModel}) async {
    ResponseModel response;

    // Update folders in batch
    var foldersCompanionList =
    TCBFolderModel.convertTCBFolderModelListToFoldersCompanionList(
      tcbFolderModelList: tcbSystemInfoModel.tcbSystemInfoFolderList,
    );
    response = await GlobalState.database.upsertFoldersInBatch(
      foldersCompanionList: foldersCompanionList,
    );

    // Update notes in batch
    if (response.code == ErrorCodeModel.SUCCESS_CODE) {
      var notesCompanionList =
      TCBNoteModel.convertTCBNoteModelListToNotesCompanionList(
        tcbNoteModelList: tcbSystemInfoModel.tcbSystemInfoNoteList,
      );
      response = await GlobalState.database.upsertNotesInBatch(
        notesCompanionList: notesCompanionList,
      );
    }

    // Update review plans in batch
    if (response.code == ErrorCodeModel.SUCCESS_CODE) {
      var reviewPlansCompanionList = TCBReviewPlanModel
          .convertTCBReviewPlanModelListToReviewPlansCompanionList(
        tcbReviewPlanModelList: tcbSystemInfoModel.tcbSystemInfoReviewPlanList,
      );
      response = await GlobalState.database.upsertReviewPlansInBatch(
        reviewPlansCompanionList: reviewPlansCompanionList,
      );
    }

    // Update review plan configs in batch
    if (response.code == ErrorCodeModel.SUCCESS_CODE) {
      var reviewPlanConfigsCompanionList = TCBReviewPlanConfigModel
          .convertTCBReviewPlanConfigModelListToReviewPlanConfigsCompanionList(
        tcbReviewPlanConfigModelList:
        tcbSystemInfoModel.tcbSystemInfoReviewPlanConfigList,
      );
      response =
      await GlobalState.database.upsertReviewPlanConfigsInBatch(
        reviewPlanConfigsCompanionList: reviewPlanConfigsCompanionList,
      );
    }

    return response;
  }

  // Private methods
  static Future<ResponseModel<TCBSystemInfoGlobalDataModel>>
      _getSystemInfoFromTCB({
    bool updateSystemInfoBasicDataWhenDataVersionIsDifferent = false,
  }) async {
    var response;

    await TCBInitHandler.getTCBCollection(collectionName: 'systemInfos')
        .where(GlobalState.tcbCommand.or([
          {
            '_id': GlobalState.tcbCommand
                .eq(GlobalState.systemInfoGlobalDataDocId),
          },
          {
            'structureVersion': GlobalState.tcbCommand
                .eq(GlobalState.systemInfoBasicDataStructureVersion),
          }
        ]))
        .get()
        .then((result) async {
      GlobalState.tcbSystemInfo = TCBSystemInfoModel.fromHashMap(result);

      // Notify system info events
      GlobalState.systemInfoEventHandler
          .notifySubscribersThatSystemInfoHasDownloaded(
              GlobalState.tcbSystemInfo);

      // If the data version has changed, notify the subscribers
      if (updateSystemInfoBasicDataWhenDataVersionIsDifferent) {
        GlobalState.systemInfoDataVersion =
            await GlobalState.database.getSystemInfoDataVersion();
        var newDataVersion =
            GlobalState.tcbSystemInfo.tcbSystemInfoBasicData.dataVersion;

        if (newDataVersion != GlobalState.systemInfoDataVersion) {
          GlobalState.systemInfoEventHandler
              .notifySubscribersThatSystemInfoDataVersionHasChanged(
            GlobalState.tcbSystemInfo.tcbSystemInfoBasicData.dataVersion,
          );
        }
      }

      response = ResponseModel.getResponseModelForSuccess<
          TCBSystemInfoGlobalDataModel>(
        result: GlobalState.tcbSystemInfo.tcbSystemInfoGlobalData,
      );
    }).catchError((err) {
      response =
          ResponseModel.getResponseModelForError<TCBSystemInfoGlobalDataModel>(
        code: ErrorCodeModel.GET_TCB_SYSTEM_INFO_FAILED_CODE,
        message: ErrorCodeModel.GET_TCB_SYSTEM_INFO_FAILED_MESSAGE,
      );
    });

    return response;
  }
}
