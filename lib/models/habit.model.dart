import 'package:flutter/material.dart';

class HabitModel {
  late String title;
  late Color color;
  late bool isBad;
  late DateTime lastStreakDate;

  HabitModel({
    required this.title,
    required this.color,
    required this.isBad,
    required this.lastStreakDate,
  });

  HabitModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    color = Color(json['color']);
    isBad = json['isBad'] ?? false;
    lastStreakDate = DateTime.parse(json['last_streak_date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['color'] = color.value.toString();
    data['isBad'] = isBad;
    data['last_streak_date'] = lastStreakDate.toString();
    return data;
  }

  int get streakDays {
    // if (lastStreakDate == null) return 0;
    final DateTime today = DateTime.now();
    final Duration diff = today.difference(lastStreakDate);
    return diff.inDays;
  }

  String get lastStreakDateFormatted {
    return '${lastStreakDate.day} ${lastStreakDate.month} ${lastStreakDate.year}';
  }
}
