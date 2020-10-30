import 'package:flutter/cupertino.dart';

class NoteWithProgressTotal {
  final int id;
  final int folderId;
  final String title;
  final String content;
  final DateTime created;
  final DateTime updated;
  final DateTime nextReviewTime;
  final int reviewProgressNo;
  final bool isReviewFinished;
  final bool isDeleted;
  final int createdBy;
  final int progressTotal;

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
