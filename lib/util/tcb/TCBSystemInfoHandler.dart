import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/model/errorCodes/ErrorCodeModel.dart';
import 'package:seal_note/model/tcbModels/systemInfo/TCBSystemInfoGlobalDataModel.dart';
import 'package:seal_note/model/tcbModels/systemInfo/TCBSystemInfoModel.dart';
import 'package:seal_note/util/tcb/TCBInitHandler.dart';

class TCBSystemInfoHandler {
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

      // // Update note according to the latest data version
      // var note = GlobalState.tcbSystemInfo.tcbSystemInfoNoteList[0];
      // var notesCompanion =
      //     NotesCompanion(id: Value(note.id), content: Value(note.content));
      // GlobalState.database
      //     .updateNote(notesCompanion: notesCompanion)
      //     .then((value) {
      //   var v = value;
      //   var version = GlobalState.database.schemaVersion;
      //   GlobalState.noteListWidgetForTodayState.currentState
      //       .triggerSetState(forceToRefreshNoteListByDb: true);
      // }).catchError((err) {
      //   var e = err;
      // });

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
