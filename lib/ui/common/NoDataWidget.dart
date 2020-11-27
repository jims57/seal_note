import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class NoDataWidget extends StatefulWidget {
  @override
  _NoDataWidgetState createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget> {
  var remarkForNoNoteCurrently = '暂无笔记';
  var remarkForCreatingNewNote = '说明：你可点击右下角的蓝色按钮，添加新笔记。';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(
          _showNoDataTitle(),
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        (GlobalState.isAppFirstTimeToLaunch)
            ? Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 24,
                  width: 24,
                ),
              )
            : Container(),
        Container(
          width: 250.0,
          alignment: Alignment.bottomCenter,
          child: Text(
            _showNoDataRemark(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
          ),
        ),
      ],
    ));
  }

  // Private methods
  String _showNoDataTitle() {
    var noDataTitle = '';

    // Check if the app is first time to launch
    if (GlobalState.isAppFirstTimeToLaunch) {
      noDataTitle = 'App初始化...请耐心等待';
    } else if (GlobalState.isDefaultFolderSelected) {
      // Show the right title for no data according to the folder id the user is using currently
      if (GlobalState.selectedFolderNameCurrently ==
          GlobalState.defaultFolderNameForToday) {
        // For Today folder
        noDataTitle = '暂无复习内容';
      } else if (GlobalState.selectedFolderNameCurrently ==
          GlobalState.defaultFolderNameForDeletion) {
        // For Deleted folder
        noDataTitle = '暂无删除的笔记';
      } else {
        noDataTitle = remarkForNoNoteCurrently;
      }
    } else {
      noDataTitle = remarkForNoNoteCurrently;
    }

    return noDataTitle;
  }

  String _showNoDataRemark() {
    var noDataRemark = '';

    if (GlobalState.isAppFirstTimeToLaunch) {
      noDataRemark = '';
    } else if (GlobalState.isDefaultFolderSelected) {
      // Show the right title for no data according to the folder id the user is using currently
      if (GlobalState.selectedFolderNameCurrently ==
          GlobalState.defaultFolderNameForToday) {
        // For Today folder
        noDataRemark = '说明：所有需要今天复习的笔记，都会出现在此，方便你统一复习。';
      } else if (GlobalState.selectedFolderNameCurrently ==
          GlobalState.defaultFolderNameForDeletion) {
        // For Deleted folder
        noDataRemark = '说明：所有删除的笔记会保留在此，默认保留：30天。之后将永久删除。';
      } else {
        noDataRemark = remarkForCreatingNewNote;
      }
    } else {
      noDataRemark = remarkForCreatingNewNote;
    }

    return noDataRemark;
  }
}
