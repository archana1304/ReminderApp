import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminderapp/main.dart';
import 'package:reminderapp/model/reminder_info.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationClass {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;
  final String? Date;
  NotificationClass({this.id, this.body, this.payload, this.title, this.Date});

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null);

//initialize timezone package
    tz.initializeTimeZones();

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });

    Future<void> scheduleNotification(
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
        String id,
        String body,
        DateTime scheduledNotificationDateTime) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        id,
        'Reminder notifications',
        //'Remember about it',
        icon: 'app_icon',
      );

      final details =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      //var iOSPlatformChannelSpecifics = IOSNotificationDetails();

      // await flutterLocalNotificationsPlugin.schedule(
      //     0, 'Reminder', body, scheduledNotificationDateTime, details);
    }
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    //'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  late final NotificationDetails _notificationDetails =
      NotificationDetails(android: _androidNotificationDetails, iOS: null);

  // Future<void> showNotifications() async {
  //   await flutterLocalNotificationsPlugin.show(
  //       id!, title, body, _notificationDetails);
  // }

  Future<void> scheduleNotifications(ReminderInfo reminderInfo) async {
    DateTime dateTime = reminderInfo.getReminderTime().toUtc();
    await flutterLocalNotificationsPlugin.zonedSchedule(
        reminderInfo.id!,
        reminderInfo.title,
        Date,
        tz.TZDateTime.utc(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute),
        _notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
