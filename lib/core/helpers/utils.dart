import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/core/utils/constants.dart';

class Utils {
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static DateTime getDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String formatTime(TimeOfDay? time) {
    String period = 'AM';
    if (time != null && time.hour >= 12 && time.hour < 24) {
      period = 'PM';
    }
    return time == null ? '-' : '${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  static TimeOfDay minuteToTime(double minute) {
    return TimeOfDay(
      hour: (minute / 60).floor(), 
      minute: (minute % 60).toInt(),
    );
  }

  static double timeToMin(TimeOfDay? time) {
    if (time == null) {
      return 1200;
    }
    return (time.hour * 60 + time.minute).toDouble();
  }

}