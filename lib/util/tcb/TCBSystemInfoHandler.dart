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

    // Update folders in batch
    var oldFoldersCreatedBySystemInfoList = await GlobalState.database
        .getFoldersCreatedBySystemInfo(); // Record old folders created by system info first
    var foldersCompanionList =
        await TCBFolderModel.convertTCBFolderModelListToFoldersCompanionList(
      tcbFolderModelList: tcbSystemInfoModel.tcbSystemInfoFolderList,
    );
    response = await GlobalState.database.upsertFoldersInBatch(
      foldersCompanionList: foldersCompanionList,
    );

    // Update notes in batch
    var oldNotesCreatedBySystemInfoList = await GlobalState.database
        .getNotesCreatedBySystemInfo(); // Record old notes created by system info first
    var notesCompanionList;
    if (response.code == ErrorCodeModel.SUCCESS_CODE) {
      notesCompanionList =
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
            oldFoldersCreatedBySystemInfoList.firstWhere((oldFolder) {
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
    var oldReviewPlansCreatedBySystemInfoList = await GlobalState.database
        .getReviewPlansCreatedBySystemInfo(); // Record old review plans created by system info first
    var reviewPlansCompanionList;
    if (response.code == ErrorCodeModel.SUCCESS_CODE) {
      reviewPlansCompanionList = TCBReviewPlanModel
          .convertTCBReviewPlanModelListToReviewPlansCompanionList(
        tcbReviewPlanModelList: tcbSystemInfoModel.tcbSystemInfoReviewPlanList,
      );
      response = await GlobalState.database.upsertReviewPlansInBatch(
        reviewPlansCompanionList: reviewPlansCompanionList,
      );
    }

    // Update review plan configs in batch
    var oldReviewPlanConfigsCreatedBySystemInfoList = await GlobalState.database
        .getReviewPlanConfigsCreatedBySystemInfo(); // Record old review plan configs created by system info first
    var reviewPlanConfigsCompanionList = <ReviewPlanConfigsCompanion>[];
    if (response.code == ErrorCodeModel.SUCCESS_CODE) {
      reviewPlanConfigsCompanionList = TCBReviewPlanConfigModel
          .convertTCBReviewPlanConfigModelListToReviewPlanConfigsCompanionList(
        tcbReviewPlanConfigModelList:
            tcbSystemInfoModel.tcbSystemInfoReviewPlanConfigList,
      );
      response = await GlobalState.database.upsertReviewPlanConfigsInBatch(
        reviewPlanConfigsCompanionList: reviewPlanConfigsCompanionList,
      );
    }

    // [Additional action] Delete those records except those created by the user that are not existent in system info any more
    if (response.code == ErrorCodeModel.SUCCESS_CODE) {
      // When all previous operation finished

      // Delete review plan configs
      await _deleteReviewPlanConfigsNotAtSystemInfo(
        oldReviewPlanConfigsCreatedBySystemInfoList:
            oldReviewPlanConfigsCreatedBySystemInfoList,
        reviewPlanConfigsCompanionList: reviewPlanConfigsCompanionList,
      );

      // Delete review plans
      await _deleteReviewPlansNotAtSystemInfo(
        oldReviewPlansCreatedBySystemInfoList:
            oldReviewPlansCreatedBySystemInfoList,
        reviewPlansCompanionList: reviewPlansCompanionList,
      );

      // Delete notes
      await _deleteNotesNotAtSystemInfo(
        oldNotesCreatedBySystemInfoList: oldNotesCreatedBySystemInfoList,
        notesCompanionList: notesCompanionList,
      );

      // Delete folders
      await _deleteFoldersNotAtSystemInfo(
        oldFoldersCreatedBySystemInfoList: oldFoldersCreatedBySystemInfoList,
        foldersCompanionList: foldersCompanionList,
        forceToDeleteFolderEvenItHasUserNotes: false,
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

  static bool _isRecordCreatedBySystemInfo({@required int id}) {
    var isRecordCreatedBySystemInfo = false;

    if (id < GlobalState.beginIdForUserOperationInDB) {
      isRecordCreatedBySystemInfo = true;
    }

    return isRecordCreatedBySystemInfo;
  }

  static Future<void> _deleteFoldersNotAtSystemInfo({
    @required oldFoldersCreatedBySystemInfoList,
    @required foldersCompanionList,
    bool forceToDeleteFolderEvenItHasUserNotes = false,
  }) async {
    for (var oldFoldersCreatedBySystemInfo
        in oldFoldersCreatedBySystemInfoList) {
      var oldFolderId = oldFoldersCreatedBySystemInfo.id;

      var foldersCompanion = foldersCompanionList.firstWhere(
          (foldersCompanion) => foldersCompanion.id.value == oldFolderId,
          orElse: () {
        return null;
      });

      // Check if the folder has notes created by the user, if yes, we shouldn't delete the folder,
      // because in this case, the folder has belonged to the user.
      var isFolderWithUserNotes = await GlobalState.database
          .isFolderWithUserNotes(folderId: oldFolderId);

      if (foldersCompanion == null) {
        // When the old id doesn't exist in System info any more, we delete it from sqlite.
        // And making sure that the folder hasn't notes created by the user

        if (!isFolderWithUserNotes || forceToDeleteFolderEvenItHasUserNotes) {
          // When the folder has notes created by the user

          await GlobalState.database.deleteFolder(folderId: oldFolderId);
        }
      }
    }
  }

  static Future<void> _deleteNotesNotAtSystemInfo({
    @required oldNotesCreatedBySystemInfoList,
    @required notesCompanionList,
  }) async {
    for (var oldNotesCreatedBySystemInfo in oldNotesCreatedBySystemInfoList) {
      var oldNoteId = oldNotesCreatedBySystemInfo.id;

      var notesCompanion = notesCompanionList.firstWhere(
          (notesCompanion) => notesCompanion.id.value == oldNoteId, orElse: () {
        return null;
      });

      if (notesCompanion == null) {
        // When the old id doesn't exist in System info any more, we delete it from sqlite

        await GlobalState.database.deleteNote(oldNoteId);
      }
    }
  }

  static Future<void> _deleteReviewPlansNotAtSystemInfo({
    @required oldReviewPlansCreatedBySystemInfoList,
    @required reviewPlansCompanionList,
  }) async {
    for (var oldReviewPlansCreatedBySystemInfo
        in oldReviewPlansCreatedBySystemInfoList) {
      var oldReviewPlanId = oldReviewPlansCreatedBySystemInfo.id;

      var reviewPlansCompanion = reviewPlansCompanionList.firstWhere(
          (reviewPlansCompanion) =>
              reviewPlansCompanion.id.value == oldReviewPlanId, orElse: () {
        return null;
      });

      if (reviewPlansCompanion == null) {
        // When the old id doesn't exist in System info any more, we delete it from sqlite

        await GlobalState.database
            .deleteReviewPlan(reviewPlanId: oldReviewPlanId);
      }
    }
  }

  static Future<void> _deleteReviewPlanConfigsNotAtSystemInfo({
    @required oldReviewPlanConfigsCreatedBySystemInfoList,
    @required reviewPlanConfigsCompanionList,
  }) async {
    for (var oldReviewPlanConfigsCreatedBySystemInfo
        in oldReviewPlanConfigsCreatedBySystemInfoList) {
      var oldReviewPlanConfigId = oldReviewPlanConfigsCreatedBySystemInfo.id;

      var reviewPlanConfigsCompanion = reviewPlanConfigsCompanionList
          .firstWhere(
              (reviewPlanConfigsCompanion) =>
                  reviewPlanConfigsCompanion.id.value == oldReviewPlanConfigId,
              orElse: () {
        return null;
      });

      if (reviewPlanConfigsCompanion == null) {
        // When the old id doesn't exist in System info any more, we delete it from sqlite

        await GlobalState.database
            .deleteReviewPlanConfig(reviewPlanConfigId: oldReviewPlanConfigId);
      }
    }
  }
}
