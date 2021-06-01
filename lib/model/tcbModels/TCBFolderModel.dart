import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';

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

  static Future<List<FoldersCompanion>>
      convertTCBFolderModelListToFoldersCompanionList({
    @required List<TCBFolderModel> tcbFolderModelList,
  }) async {
    var foldersCompanionList = <FoldersCompanion>[];

    for (var tcbFolderModel in tcbFolderModelList) {
      var folderId = tcbFolderModel.id;
      var reviewPlanId = tcbFolderModel.reviewPlanId;

      // Check if the folder has notes created by the user or not
      var isFolderWithUserNotes =
          await GlobalState.database.isFolderWithUserNotes(folderId: folderId);

      if (!isFolderWithUserNotes) {
        // When it has no notes created by the user

        foldersCompanionList.add(FoldersCompanion(
          id: Value(tcbFolderModel.id),
          name: Value(tcbFolderModel.name),
          order: Value(tcbFolderModel.order),
          isDefaultFolder: Value(tcbFolderModel.isDefaultFolder),
          reviewPlanId: Value(reviewPlanId),
          isDeleted: Value(tcbFolderModel.isDeleted),
        ));
      }
    }

    return foldersCompanionList;
  }
}
