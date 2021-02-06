import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class TimeHandler {
  static String getDateTimeFormatForAllKindOfNote({
    DateTime updated,
    DateTime nextReviewTime,
    bool isReviewFinished = false,
  }) {
    // Check if this note finished its review
    if (isReviewFinished) {
      return GlobalState.titleForReviewFinished;
    }

    if (GlobalState.isReviewFolderSelected ||
        GlobalState.isDefaultFolderSelected) {
      return _getAutoTimeFormatByDateTimeAvailability(nextReviewTime, updated);
    } else {
      return _getDateTimeForNormalNote(updated);
    }
  }

  static DateTime getSmallHoursOfToday() {
    var now = DateTime.now().toLocal();
    var smallHoursOfToday = DateTime(now.year, now.month, now.day);

    return smallHoursOfToday;
  }

  static DateTime getSmallHoursOfTomorrow() {
    var smallHoursOfToday = getSmallHoursOfToday();
    return smallHoursOfToday.add(Duration(days: 1));
  }

  static DateTime getYesterdayDateTime() {
    return getNowForLocal().subtract(Duration(days: 1));
  }

  static DateTime getSameTimeForTomorrow(
      {@required DateTime nextReviewTime,
      bool forceToUseTomorrowBasedOnNow = true}) {
    // This method will force to get the same time for tomorrow, even the date time is a few days ago
    // This means: keeping the same time but change the year, month and day to tomorrow
    // If forceToUseTomorrowBasedOnNow = true, we will force to use year, month and day of now()'s tomorrow, rather than those of the nextReviewTime

    DateTime tomorrow;
    int year;
    int month;
    int day;

    if (forceToUseTomorrowBasedOnNow) {
      tomorrow = TimeHandler.getSmallHoursOfTomorrow();
    } else {
      tomorrow = nextReviewTime.add(Duration(days: 1));
    }

    year = tomorrow.year;
    month = tomorrow.month;
    day = tomorrow.day;

    DateTime sameTimeForTomorrow = DateTime(
        year,
        month,
        day,
        nextReviewTime.hour,
        nextReviewTime.minute,
        nextReviewTime.second,
        nextReviewTime.millisecond,
        nextReviewTime.microsecond);

    return sameTimeForTomorrow;
  }

//   // If *basedOnDateTime* is null, we use Now().local() to get the tomorrow datetime
//
//   DateTime dateTimeBase;
//
//   if (basedOnDateTime == null) {
//   dateTimeBase = TimeHandler.getNowForLocal();
//   } else {
//   dateTimeBase = basedOnDateTime;
//   }
//
//   return dateTimeBase.add(Duration(days: 1));
// }static DateTime getTomorrowDateTime({DateTime basedOnDateTime}) {

  static bool isYesterdayDateTime(DateTime dateTime) {
    var isYesterdayDateTime = false;
    var yesterday = TimeHandler.getYesterdayDateTime();

    if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      isYesterdayDateTime = true;
    }

    return isYesterdayDateTime;
  }

  static DateTime getNowForLocal() {
    return DateTime.now().toLocal();
  }

  static DateTime getNextReviewTimeForNoteFinishingReview() {
    // This date time is going to be stored to the nextReviewTime field for notes which finish review
    // We make all these review finishing notes have the same nextReviewTime, so that updated field can be ordered by desc
    // We make it to Jan. 1st, 3000

    var dateTimeForReviewFinishing = DateTime(3000, 1, 1);

    return dateTimeForReviewFinishing;
  }

  // Private methods
  static String _getAutoTimeFormatByDateTimeAvailability(
      DateTime nextReviewTime, DateTime updated) {
    var result = '';

    if (nextReviewTime != null) {
      // When the next review time isn't null, showing the review time format

      result = _getReviewTimeFormatForReviewNote(nextReviewTime);
    } else {
      result = _getDateTimeForNormalNote(updated);
    }

    return result;
  }

  static String _getReviewTimeFormatForReviewNote(DateTime nextReviewTime) {
    var result = '';

    var now = DateTime.now().toLocal();
    var yesterday = TimeHandler.getYesterdayDateTime();

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
        result =
            '${_getTimePrefix(now, nextReviewTime)} $years年${_getTimeSuffix(now, nextReviewTime)} 复习';
      } else if (months > 0) {
// For month
        result =
            '${_getTimePrefix(now, nextReviewTime)} $months个月${_getTimeSuffix(now, nextReviewTime)} 复习';
      } else {
// For day

        if (isYesterdayDateTime(nextReviewTime)) {
// For yesterday
          result = '应 昨天 复习';
        } else {
// For other days less than a month
          result =
              '${_getTimePrefix(now, nextReviewTime)} $days天${_getTimeSuffix(now, nextReviewTime)} 复习';
        }
      }
    } else if (hoursDifference > 0) {
      if (isYesterdayDateTime(nextReviewTime)) {
        result = '应 昨天 复习';
      } else {
        result =
            '${_getTimePrefix(now, nextReviewTime)} $hoursDifference小时${_getTimeSuffix(now, nextReviewTime)} 复习';
      }
    } else {
      if (minutesDifference <= 5) {
        result = '现在 复习';
      } else {
        result =
            '${_getTimePrefix(now, nextReviewTime)} $minutesDifference分钟${_getTimeSuffix(now, nextReviewTime)} 复习';
      }
    }

    return result;
  }

  static String _getDateTimeForNormalNote(DateTime updated) {
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
      result = '${updated.hour}:${_getLeftPadMinute(minutes: updated.minute)}';
    } else if (updated.year == yesterday.year &&
        updated.month == yesterday.month &&
        updated.day == yesterday.day) {
// For yesterday
      result =
          '昨天${updated.hour}:${_getLeftPadMinute(minutes: updated.minute)}';
    } else if (updated.compareTo(smallHoursOfSevenDaysAgo) >= 0) {
// For these 6 days between seven days and the day before yesterday
      result = _getWeekdayName(updated.weekday);
    } else {
      result = '${updated.year}-${updated.month}-${updated.day}';
    }

    return result;
  }

  static String _getTimePrefix(DateTime now, DateTime nextReviewTime) {
    var timePrefix = '';

    if (nextReviewTime.isBefore(now)) timePrefix = '应';

    return timePrefix;
  }

  static String _getTimeSuffix(DateTime now, DateTime nextReviewTime) {
    var timeSuffix = '后';

    if (nextReviewTime.isBefore(now)) timeSuffix = '前';

    return timeSuffix;
  }

  static String _getWeekdayName(int weekday) {
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

  static String _getLeftPadMinute({@required int minutes}) {
    return minutes.toString().padLeft(2, '0');
  }
}
