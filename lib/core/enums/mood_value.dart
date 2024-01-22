// ignore_for_file: constant_identifier_names

import 'dart:ui';
import 'package:mood_tracker/core/utils/assets.dart';
import 'package:mood_tracker/core/utils/colors.dart';

enum MoodValue {
  Angry(1, AppAssets.moodVerySad, AppColors.red400),
  Unhappy(2, AppAssets.moodSad, AppColors.yellow400),
  Neutral(3, AppAssets.moodNeutral, AppColors.violet400),
  Happy(4, AppAssets.moodHappy, AppColors.sky400),
  Delighted(5, AppAssets.moodVeryHappy, AppColors.emerald400);

  final int value;
  final String asset;
  final Color color;

  const MoodValue(this.value, this.asset, this.color);

  static MoodValue? byValue(int value) {
    for (var item in MoodValue.values) {
      if (item.value == value) {
        return item;
      }
    }
    return null;
  }

  static MoodValue? byNearestDoubleValue(double value) {
    int intValue = value.ceil() > 5 ? 5 : value.ceil();
    return MoodValue.byValue(intValue);
  }
}
