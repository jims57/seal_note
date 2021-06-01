import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
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

  static Future<ResponseModel> upsertSystemInfoBasicData(
      {@required TCBSystemInfoModel tcbSystemInfoModel}) async {
    ResponseModel response;

    // Record old folder created by system info first
    var oldFoldersCreatedBySystemInfo =
        await GlobalState.database.getFoldersCreatedBySystemInfo();

    // Update folders in batch
    var foldersCompanionList =
        await TCBFolderModel.convertTCBFolderModelListToFoldersCompanionList(
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

      // [Additional action]  Update the next review time of notes according to folder review plan,
      // which may be updated by system info in previous folder related operation.

      // Get all user folders which aren't default folder, that is isDefaultFolder = false
      var nonDefaultFoldersCreatedBySystemInfoList =
          foldersCompanionList.where((foldersCompanion) {
        return foldersCompanion.isDefaultFolder.value == false;
      });
      for (var nonDefaultFoldersCreatedBySystemInfo
          in nonDefaultFoldersCreatedBySystemInfoList) {
        var folderId = nonDefaultFoldersCreatedBySystemInfo.id.value;
        var newReviewPlanId =
            nonDefaultFoldersCreatedBySystemInfo.reviewPlanId.value ?? 0;

        // Get old review plan id
        var oldReviewPlanId;
        var oldFolderEntry =
            oldFoldersCreatedBySystemInfo.firstWhere((oldFolder) {
          return oldFolder.id == folderId;
        }, orElse: () {
          // return null;
          return FolderEntry(
              id: null,
              name: null,
              order: null,
              isDefaultFolder: null,
              created: null,
              isDeleted: null,
              createdBy: null);
        });
        oldReviewPlanId = oldFolderEntry.reviewPlanId ?? 0;

        // Update next review time of notes belonging to the folder
        if (oldReviewPlanId != newReviewPlanId) {
          // Make sure the review plan id has been changed,
          // making sure that setting the next review time of notes properly,
          // because it will cause some odd problems, such as make oldNextReviewTime NULL
          // when both review plan id is same, i.e. both are zero.

          await GlobalState.database.updateFolderReviewPlanId(
              folderId: folderId,
              oldReviewPlanId: oldReviewPlanId,
              newReviewPlanId: newReviewPlanId);
        }
      }
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
      response = await GlobalState.database.upsertReviewPlanConfigsInBatch(
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
