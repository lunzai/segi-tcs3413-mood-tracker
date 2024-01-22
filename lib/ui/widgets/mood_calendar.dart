// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mood_tracker/core/helpers/utils.dart';
import 'package:mood_tracker/core/models/mood.dart';
import 'package:mood_tracker/core/utils/colors.dart';
import 'package:mood_tracker/ui/widgets/mood_calendar_cell.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mood_tracker/core/utils/constants.dart';
import 'package:intl/intl.dart';

class MoodCalendar extends StatefulWidget {
  Map<String, Mood> moodMap;
  Function(DateTime date, Mood? mood)? onTap;

  MoodCalendar({
    super.key,
    Map<String, Mood>? moodMap,
    this.onTap,
  }) : 
    moodMap = moodMap ?? {};

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  @override
  Widget build(BuildContext context) {
    CalendarFormat calendarFormat = CalendarFormat.month;
    DateTime? selectedDay;
    DateTime focusedDay = DateTime.now();
    final DateTime start = focusedDay.subtract(Duration(days: AppConstants.allowedDaysBefore));
    final DateTime end = focusedDay.add(Duration(days: AppConstants.allowedDaysAfter));
    final DateFormat dateFormatter = DateFormat(AppConstants.calendarHeaderDateFormat);

    return TableCalendar(
      rowHeight: 75,
      daysOfWeekHeight: 25,
      focusedDay: focusedDay, 
      firstDay: start, 
      lastDay: end,
      calendarFormat: calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
        isTodayHighlighted: false,
        defaultTextStyle: TextStyle(
          color: AppColors.gray950,
        )
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: AppColors.gray950,
        ),
        weekendStyle: TextStyle(
          color: AppColors.gray950,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) {
          return dateFormatter.format(date);
        },
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (BuildContext context, DateTime day, events) {
          return GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!(day, widget.moodMap[ Utils.formatDate(day) ]);
              }
            },
            child: MoodCalendarCell(date: day, mood: widget.moodMap[ Utils.formatDate(day) ]),
          );
        },
        disabledBuilder: (BuildContext context, DateTime day, events) {
          return MoodCalendarCell(
            date: day, 
            isDisabled: true
          );
        },
      ),
      selectedDayPredicate: (day) {
        return isSameDay(selectedDay, day);
      },
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        if (!isSameDay(selectedDay, selectedDay)) {
          setState(() {
            selectedDay = selectedDay;
          });
        }
      },
      onPageChanged: (DateTime focusedDay) {
        focusedDay = focusedDay;
      },
    );
  }
}