class TimeHandler {
  static String showShouldReviewTimeFormat(DateTime nextReviewTime) {
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

  static String getTimeSuffix(DateTime now, DateTime nextReviewTime) {
    var timeSuffix = '后';

    if (nextReviewTime.isBefore(now)) timeSuffix = '前';

    return timeSuffix;
  }
}
