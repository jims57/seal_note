import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';

class FolderHandler {
  static void recordDefaultFolderIndexAtGlobalState(
      {@required List<FolderEntry> folderEntryList}) {
    GlobalState.defaultFolderIndexList.clear();
    for (var folderEntry in folderEntryList) {
      if (folderEntry.isDefaultFolder) {
        GlobalState.defaultFolderIndexList.add(folderEntry.id);
      }
    }
  }

// static void updateBasicDataFolderNamesBySystemInfoFolderList({
//   @required List<TCBFolderModel> tcbSystemInfoFolderList,
// }) {
//   for (var tcbFolderModel in tcbSystemInfoFolderList) {
//     if (tcbFolderModel.id == GlobalState.defaultFolderIdForToday) {
//       // Update Today folder default name
//
//       GlobalState.defaultFolderNameForToday = tcbFolderModel.name;
//     }
//
//     if (tcbFolderModel.id == GlobalState.defaultFolderIdForAllNotes) {
//       // Update All Notes folder default name
//
//       GlobalState.defaultFolderNameForAllNotes = tcbFolderModel.name;
//     }
//
//     if (tcbFolderModel.id == GlobalState.defaultFolderIdForDeletion) {
//       // Update Deleted Notes folder default name
//
//       GlobalState.defaultFolderNameForDeletion = tcbFolderModel.name;
//     }
//
//     if (tcbFolderModel.id == GlobalState.defaultUserFolderIdForMyNotes) {
//       // Update My Notes folder default name
//
//       GlobalState.defaultUserFolderNameForMyNotes = tcbFolderModel.name;
//     }
//   }
// }
}
