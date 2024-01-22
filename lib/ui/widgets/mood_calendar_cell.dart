// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mood_tracker/core/models/mood.dart';
import 'package:mood_tracker/core/utils/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendarCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isFocused;
  final bool isDisabled;
  final Mood? mood;
  bool isToday = false;

  Color cellColor = AppColors.indigo200;
  Color labelColor = AppColors.gray950;
  Color cellBorderColor = AppColors.indigo400;

  MoodCalendarCell({
    super.key,
    required this.date,
    this.isSelected = false,
    this.isFocused = false,
    this.isDisabled = false,
    this.mood,
  }) {
    isToday = isSameDay(date, DateTime.now());
    if (isToday) {
      labelColor = AppColors.indigo500;
      cellColor = AppColors.indigo200;
    }
    if (isDisabled) {
      cellColor = AppColors.indigo100;
      labelColor = AppColors.gray300;
    }
    if (mood != null) {
      switch (mood!.value.value) {
        case 5:
          cellColor = AppColors.emerald200;
          break;
        case 4:
          cellColor = AppColors.sky200;
          break;
        case 3:
          cellColor = AppColors.indigo200;
          break;
        case 2:
          cellColor = AppColors.yellow200;
          break;
        case 1:
          cellColor = AppColors.red200;
          break;
        default: 
          cellColor = AppColors.white;
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: AppColors.gray100,
                  blurRadius: 1,
                  spreadRadius: 0,
                )
              ],
              shape: BoxShape.circle,
              color: cellColor,
              border: isToday && mood == null ? Border.all(
                color: cellBorderColor,
                width: 2
              ) : null,
            ),
            padding: EdgeInsets.zero,
            child: mood == null ? null : Image.asset(
              mood!.value.asset, 
              fit: BoxFit.fill,
              height: 45, 
              width: 45,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            date.day.toString(),
            style: TextStyle(
              color: labelColor, 
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              fontSize: 10,
            )
          ),
        ],
      );
  }
}