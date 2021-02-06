import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/util/time/TimeHandler.dart';

class ReviewHandler {
  static Future<int> delayNoteReviewToTomorrowInDB({
    @required int noteId,
    @required DateTime currentNextReviewTime,
  }) async {
    // Get tomorrow date time
    var newNextReviewTime = TimeHandler.getSameTimeForTomorrow(
        nextReviewTime: currentNextReviewTime,
        forceToUseTomorrowBasedOnNow: true);

    // Set the next review time to tomorrow on the same time
    var effectedRowCount = await GlobalState.database.updateNoteNextReviewTime(
        noteId: noteId, nextReviewTime: newNextReviewTime);

    return effectedRowCount;
  }
}
