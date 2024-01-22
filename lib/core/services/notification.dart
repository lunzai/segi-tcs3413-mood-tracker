import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mood_tracker/core/models/reminder_notification.dart';
import 'package:mood_tracker/core/utils/constants.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService notificationService = NotificationService._internal(); 
  final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await localNotificationsPlugin.initialize(
      initSettings,
    );
  }

  void requestIOSPermissions() {
    localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  }

  final AndroidNotificationDetails androidDetails = const AndroidNotificationDetails(
    'moodTracker',   //Required for Android 8.0 or after
    'DailyReminder', //Required for Android 8.0 or after
    channelDescription: 'Mood Tracker Daily Reminders', //Required for Android 8.0 or after
  );

  final DarwinNotificationDetails iOSDetails = const DarwinNotificationDetails();
  
  Future<void> scheduleReminder(TimeOfDay? time) async {
    if (time == null) {
      return;
    }
    var message = ReminderNotification.random();
    final noticeDetail = NotificationDetails(
      iOS: iOSDetails,
      android: androidDetails,
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    await localNotificationsPlugin.zonedSchedule(
      AppConstants.notificationReminderId, 
      message['title'], 
      message['content'], 
      tz.TZDateTime.from(today, tz.local), 
      noticeDetail, 
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder() async {
    await localNotificationsPlugin.cancel(AppConstants.notificationReminderId);
  }

}