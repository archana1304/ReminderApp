import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:rxdart/subjects.dart' as rxSub;

class NotificationClass {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  NotificationClass({this.id, this.body, this.payload, this.title});

  final rxSub.BehaviorSubject<NotificationClass>
      didReceiveLocalNotificationSubject =
      rxSub.BehaviorSubject<NotificationClass>();
  final rxSub.BehaviorSubject<String> selectNotificationSubject =
      rxSub.BehaviorSubject<String>();

  Future<void> initNotifications(
      notifs.FlutterLocalNotificationsPlugin notifsPlugin) async {
    var initializationSettingsAndroid =
        notifs.AndroidInitializationSettings('icon_image');

    var initializationSettings =
        notifs.InitializationSettings(initializationSettingsAndroid, null);

    await notifsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
    print("Notifications initialised successfully");
  }

  Future<void> scheduleNotification(
      notifs.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      String id,
      String body,
      DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = notifs.AndroidNotificationDetails(
      id,
      'Reminder notifications',
      'Remember about it',
      icon: 'app_icon',
    );

    var details =
        notifs.NotificationDetails(androidPlatformChannelSpecifics, null);
    //var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    await flutterLocalNotificationsPlugin.schedule(
        0, 'Reminder', body, scheduledNotificationDateTime, details);
  }
}
