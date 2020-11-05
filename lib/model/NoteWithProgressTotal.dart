import 'package:flutter/cupertino.dart';

class NoteWithProgressTotal {
  int id; // If the selected note id ==0 , meaning it is a new note
  int folderId; // This is the folder id the note belongs to, note that it isn't the same folder id as the selected folder id if the user is clicking a note from a default folder, i.e. Today folder
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
