import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeHandler {
  static String getDateTimeFormatForAllKindOfNote(
      {DateTime updated, DateTime nextReviewTime}) {
    var result = '';

    if (nextReviewTime != null) {
      // When it has the next review time, meaning that this is a note subject to be reviewed
      result = getReviewTimeFormatForReviewNote(nextReviewTime);
    } else {
      // When it hasn't the next review time, meaning this is a normal note
      result = getDateTimeForNormalNote(updated);
    }

    return result;
  }

  static String getReviewTimeFormatForReviewNote(DateTime nextReviewTime) {
    var result = '';

    DateTime now = DateTime.now().toLocal();

    // Unit for the value. { 1 = minute, 2 = hour, 3 = day, 4 = week, 5 = month, 6 = year }
    int minutesDifference = nextReviewTime.difference(now).inMinutes.abs();
    int hoursDifference = nextReviewTime.difference(now).inHours.abs();
    int daysDifference = nextReviewTime.difference(now).inDays.abs();

    if (daysDifference > 0) {
      // Check if it is for year
      int years = (daysDifference / 365).floor();
      int months = (daysDifference / 30).floor();
      int days = (daysDifference / 1).floor();

      if (years > 0) {
        // For year
        result = '应在$years年${getTimeSuffix(now, nextReviewTime)}复习';
      } else if (months > 0) {
        // For month
        result = '应在$months个月${getTimeSuffix(now, nextReviewTime)}复习';
      } else {
        // For day
        result = '应在$days天${getTimeSuffix(now, nextReviewTime)}复习';
      }
    } else if (hoursDifference > 0) {
      result = '应在$hoursDifference小时${getTimeSuffix(now, nextReviewTime)}复习';
    } else {
      if (minutesDifference <= 5) {
        result = '应现在复习';
      } else {
        result =
            '应在$minutesDifference分钟${getTimeSuffix(now, nextReviewTime)}复习';
      }
    }

    return result;
  }

  static String getDateTimeForNormalNote(DateTime updated) {
    String result = '';

    var now = DateTime.now().toLocal();
    var yesterday = now.subtract(Duration(days: 1));
    var smallHoursOfToday = DateTime(now.year, now.month, now.day);
    var smallHoursOfSevenDaysAgo =
        smallHoursOfToday.subtract(Duration(days: 7));

    if (updated.year == now.year &&
        updated.month == now.month &&
        updated.day == now.day) {
      // For today
      result = '${updated.hour}:${updated.minute}';
    } else if (updated.year == yesterday.year &&
        updated.month == yesterday.month &&
        updated.day == yesterday.day) {
      // For yesterday
      result = '昨天${updated.hour}:${updated.minute}';
    } else if (updated.compareTo(smallHoursOfSevenDaysAgo) >= 0) {
      // For these 6 days between seven days and the day before yesterday
      result = getWeekdayName(updated.weekday);
    } else {
      result = '${updated.year}-${updated.month}-${updated.day}';
    }

    return result;
  }

  static String getTimeSuffix(DateTime now, DateTime nextReviewTime) {
    var timeSuffix = '后';

    if (nextReviewTime.isBefore(now)) timeSuffix = '前';

    return timeSuffix;
  }

  static String getWeekdayName(int weekday) {
    var weekdayName = '';
    switch (weekday) {
      case 1:
        {
          weekdayName = '星期一';
        }
        break;

      case 2:
        {
          weekdayName = '星期二';
        }
        break;

      case 3:
        {
          weekdayName = '星期三';
        }
        break;

      case 4:
        {
          weekdayName = '星期四';
        }
        break;

      case 5:
        {
          weekdayName = '星期五';
        }
        break;

      case 6:
        {
          weekdayName = '星期六';
        }
        break;

      default:
        {
          weekdayName = '星期天';
        }
        break;
    }

    return weekdayName;
  }
}
