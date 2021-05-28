import 'package:flutter/material.dart';
import 'package:moor/moor.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

class TCBNoteModel {
  final int id;
  final int folderId;
  final String content;
  final bool isDeleted;

  TCBNoteModel({
    this.id,
    this.folderId,
    this.content,
    this.isDeleted,
  });

  factory TCBNoteModel.fromHashMap(Map<dynamic, dynamic> tcbNoteHashMap) {
    return TCBNoteModel(
      id: tcbNoteHashMap['id'],
      folderId: tcbNoteHashMap['folderId'],
      content: tcbNoteHashMap['content'],
      isDeleted: tcbNoteHashMap['isDeleted'],
    );
  }

  static List<TCBNoteModel> convertHashMapListToModelList(
      {List<dynamic> hashMapList}) {
    var noteHashMapList = hashMapList;

    var noteList =
        noteHashMapList.map((note) => TCBNoteModel.fromHashMap(note)).toList();

    return noteList;
  }

  static List<NotesCompanion> convertTCBNoteModelListToNotesCompanionList({
    @required List<TCBNoteModel> tcbNoteModelList,
  }) {
    var now = TimeHandler.getNowForLocal();
    var notesCompanionList = <NotesCompanion>[];

    for (var tcbNoteModel in tcbNoteModelList) {
      notesCompanionList.add(NotesCompanion(
        id: Value(tcbNoteModel.id),
        folderId: Value(tcbNoteModel.folderId),
        content: Value(tcbNoteModel.content),
        created: Value(now),
        isDeleted: Value(tcbNoteModel.isDeleted),
      ));
    }

    return notesCompanionList;
  }
}
