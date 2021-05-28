import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

class TCBFolderModel {
  final int id;
  final String name;
  final int order;
  final bool isDefaultFolder;
  final int reviewPlanId;
  final bool isDeleted;

  TCBFolderModel({
    this.id,
    this.name,
    this.order,
    this.isDefaultFolder,
    this.reviewPlanId,
    this.isDeleted,
  });

  factory TCBFolderModel.fromHashMap(Map<dynamic, dynamic> tcbFolderHashMap) {
    return TCBFolderModel(
      id: tcbFolderHashMap['id'],
      name: tcbFolderHashMap['name'],
      order: tcbFolderHashMap['order'],
      isDefaultFolder: tcbFolderHashMap['isDefaultFolder'],
      reviewPlanId: tcbFolderHashMap['reviewPlanId'],
      isDeleted: tcbFolderHashMap['isDeleted'],
    );
  }

  static List<TCBFolderModel> convertHashMapListToModelList(
      {List<dynamic> hashMapList}) {
    var folderHashMapList = hashMapList;

    var folderList = folderHashMapList
        .map((folder) => TCBFolderModel.fromHashMap(folder))
        .toList();

    return folderList;
  }

  static List<FoldersCompanion>
      convertTCBFolderModelListToFoldersCompanionList({
    @required List<TCBFolderModel> tcbFolderModelList,
  }) {
    // var now = TimeHandler.getNowForLocal();
    var foldersCompanionList = <FoldersCompanion>[];

    for (var tcbFolderModel in tcbFolderModelList) {
      foldersCompanionList.add(FoldersCompanion(
        id: Value(tcbFolderModel.id),
        name: Value(tcbFolderModel.name),
        order: Value(tcbFolderModel.order),
        isDefaultFolder: Value(tcbFolderModel.isDefaultFolder),
        reviewPlanId: Value(tcbFolderModel.reviewPlanId),
        // created: Value(now),
        isDeleted: Value(tcbFolderModel.isDeleted),
      ));
    }

    return foldersCompanionList;
  }
}
