import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/model/common/ResponseModel.dart';
import 'package:seal_note/util/file/FileHandler.dart';
import 'package:seal_note/util/tcb/TCBInitHandler.dart';

class TCBStorageHandler {
  static CloudBaseStorage _getCloudBaseStorage() {
    if (GlobalState.tcbCloudBaseStorage == null) {
      var core = TCBInitHandler.getCloudBaseCore();
      GlobalState.tcbCloudBaseStorage = CloudBaseStorage(core);
    }

    return GlobalState.tcbCloudBaseStorage;
  }

  static String _getTCBFileIdAtCloud({@required String fileName}) {
    // Format: cloud://seal-note-app-env-8ei8de6728d969.7365-seal-note-app-env-8ei8de6728d969-1258184445/seal/flutter/294.jpeg

    var fileId = '${GlobalState.tcbStorageCloudUrlPrefix}$fileName';

    return fileId;
  }

  static Future<void> uploadFileAtDocumentDirectoryToTCBStorage(
      {String fileName}) async {
    var storage = _getCloudBaseStorage();

    var fullFileName =
        await FileHandler.getFullFileNameAtDocumentDirectory(fileName);

    await storage.uploadFile(
        cloudPath: 'flutter/$fileName',
        filePath: fullFileName,
        onProcess: (int count, int total) {
          // 当前进度
          print(count);
          // 总进度
          print(total);
        });
  }

  static Future<ResponseModel> downloadFileFromTCBToDocumentDirectory(
      {@required String fileName}) async {
    // download tcb file // download file from tcb

    var response;
    var storage = _getCloudBaseStorage();

    var fileId = _getTCBFileIdAtCloud(fileName: fileName);

    var fullFileNameToSave =
        await FileHandler.getFullFileNameAtDocumentDirectory(fileName);

    await storage
        .downloadFile(
            fileId: fileId,
            savePath: fullFileNameToSave,
            onProcess: (int count, int total) {
              // 当前进度
              print(count);
              // 总进度
              print(total);
            })
        .then((value) {
      response = ResponseModel.getResponseModelForSuccess();
    }).catchError((err) {
      response =
          ResponseModel.getResponseModelForErrorAccordingToErrorType(err: err);
    });

    return response;
  }
}
