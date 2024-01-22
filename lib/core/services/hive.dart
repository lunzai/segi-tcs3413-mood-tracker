import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_tracker/core/adapters/time_of_day_adapter.dart';
import 'package:mood_tracker/core/models/settings.dart';
import 'package:mood_tracker/core/utils/constants.dart';

class HiveService {
  static late Box<Settings> settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(TimeOfDayAdapter());
    settingsBox = await Hive.openBox<Settings>(AppConstants.hiveSettingsBox);
  }

  static Settings getSettings() {
    if (settingsBox.isEmpty) {
      // Initialize default settings on first launch
      final defaultSettings = Settings()
        ..reminderTime = const TimeOfDay(hour: 20, minute: 0);
      settingsBox.add(defaultSettings);
      return defaultSettings;
    } else {
      return settingsBox.values.first;
    }
  }

  static Future<void> saveSettings(Settings settings) async {
    await settingsBox.put(0, settings);
  }

  static Future<void> resetSettings() async {
    await saveSettings(Settings());
  }
}