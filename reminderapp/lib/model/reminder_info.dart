import 'dart:ffi';
//import 'dart:js';
import 'package:flutter/material.dart';

class ReminderInfo {
  int? id;
  String? title;
  DateTime? reminderDate;
  TimeOfDay? reminderTime;
  Bool? isPending;

  ReminderInfo(
      {this.id,
      this.title,
      this.reminderDate,
      this.reminderTime,
      this.isPending});

  static TimeOfDay timeFromString(String formattedTime) {
    var splitTime = formattedTime.split(":");
    int hour = int.parse(splitTime[0]);
    int min = int.parse(splitTime[1]);
    return TimeOfDay(hour: hour, minute: min);
  }

  factory ReminderInfo.fromMap(Map<String, dynamic> json) => ReminderInfo(
        id: json["id"],
        title: json["title"],
        reminderDate: DateTime.parse(json["reminderDate"]),
        reminderTime: timeFromString(json["reminderTime"]),
        isPending: json["isPending"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "reminderDate": reminderDate?.toIso8601String(),
        "reminderTime": reminderTime!.hour.toString() +
            ":" +
            reminderTime!.minute.toString(),
        "isPending": isPending,
      };

  DateTime getReminderTime() {
    DateTime dateTime = DateTime(reminderDate!.year, reminderDate!.month,
        reminderDate!.day, reminderTime!.hour, reminderTime!.minute);
    return dateTime;
  }
}
