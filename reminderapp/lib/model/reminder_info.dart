import 'dart:ffi';
import 'package:flutter/material.dart';

class ReminderInfo {
  int? id;
  String? title;
  DateTime? reminderDate;
  TimeOfDay? reminderTime;
  Bool? isPending;

  ReminderInfo(
    {
        this.id,
        this.title,
        this.reminderDate,
        this.reminderTime,
        this.isPending
      });

factory ReminderInfo.fromMap(Map<String, dynamic> json) => ReminderInfo(
        id: json["id"],
        title: json["title"],
        reminderDate: DateTime.parse(json["reminderDate"]),
        reminderTime: json["reminderTime"],
        isPending: json["isPending"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "reminderDate": reminderDate?.toIso8601String(),
        "reminderTime": reminderTime,
        "isPending": isPending,
    };
}
