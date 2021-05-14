import 'dart:async';

import 'package:seal_note/model/tcbModels/systemInfo/TCBSystemInfoModel.dart';

class SystemInfoEventHandler {
  // ignore: close_sinks
  StreamController systemInfoDownloadedController =
      new StreamController.broadcast();

  // ignore: close_sinks
  StreamController systemInfoDataVersionChangedController =
      new StreamController.broadcast();

  Stream get onSystemInfoDownloaded {
    return systemInfoDownloadedController.stream;
  }

  void notifySubscribersThatSystemInfoHasDownloaded(
      TCBSystemInfoModel tcbSystemInfoModel) {
    systemInfoDownloadedController
        .add(tcbSystemInfoModel); // send an arbitrary event
  }

  Stream get onSystemInfoDataVersionChanged {
    return systemInfoDataVersionChangedController.stream;
  }

  void notifySubscribersThatSystemInfoDataVersionHasChanged(
      int newDataVersion) {
    systemInfoDataVersionChangedController
        .add(newDataVersion); // send an arbitrary event
  }


}
