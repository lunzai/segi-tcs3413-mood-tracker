
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_tracker/core/helpers/utils.dart';
import 'package:mood_tracker/core/utils/constants.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings {
  @HiveField(0)
  bool useBiometricAuthentication = false;
  @HiveField(3)
  bool didBiometricAuthentication = false;
  @HiveField(1)
  bool skipIntroduction = false;
  @HiveField(4)
  bool enableReminder = false;
  @HiveField(2)
  TimeOfDay? reminderTime;

  Settings({
    this.useBiometricAuthentication = false,
    this.skipIntroduction = false,
    this.didBiometricAuthentication = false,
    this.enableReminder = false,
    TimeOfDay? reminderTime,
  }) : 
    reminderTime = reminderTime ?? Utils.minuteToTime(
      AppConstants.reminderDefaultMinute.toDouble()
    );
}