import 'package:flutter/cupertino.dart';

class NoteWithProgressTotal {
  int id;
  int folderId;
  String title;
  String content;
  DateTime created;
  DateTime updated;
  DateTime nextReviewTime;
  int reviewProgressNo;
  bool isReviewFinished;
  bool isDeleted;
  int createdBy;
  int progressTotal;

  NoteWithProgressTotal({
    @required this.id,
    @required this.folderId,
    @required this.title,
    @required this.content,
    @required this.created,
    @required this.updated,
    @required this.nextReviewTime,
    @required this.reviewProgressNo,
    @required this.isReviewFinished,
    @required this.isDeleted,
    @required this.createdBy,
    @required this.progressTotal,
  });
}
