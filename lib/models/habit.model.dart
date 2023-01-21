import 'dart:math';
import 'package:flutter/material.dart';
import 'package:habited/models/interval.model.dart';
import 'package:intl/intl.dart';

class HabitModel {
  late String title;
  // late String icon;
  late Color color;
  late bool isBad;
  // late String quoteToSelf;
  late List<IntervalModel> intervals;

  bool isInRange(DateTime date) {
    if (intervals.isEmpty) return false;
    for (var i = 0; i < intervals.length; i++) {
      if (date.year == intervals[i].startDate.year &&
          date.month == intervals[i].startDate.month &&
          date.day == intervals[i].startDate.day) return true;
      if (date.year == intervals[i].endDate.year &&
          date.month == intervals[i].endDate.month &&
          date.day == intervals[i].endDate.day) return true;
      if (date.isAfter(intervals[i].startDate) && date.isBefore(intervals[i].endDate)) {
        return true;
      }
    }
    return false;
  }

  bool get onGoing {
    if (intervals.isEmpty) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final lastMarkedDate = DateTime(
      intervals.last.endDate.year,
      intervals.last.endDate.month,
      intervals.last.endDate.day,
    );

    return lastMarkedDate == today || lastMarkedDate == yesterday;
  }

  int get currentStreak {
    return onGoing ? intervals.last.intervalStreak : 0;
  }

  String get lastStreakDateFormatted {
    if (onGoing) {
      String format = DateFormat('dd MMM yyyy').format(intervals.last.startDate);
      return "Last streak: $format";
    } else {
      return "No ongoing streak";
    }
  }

  List<int> get intervalInfo {
    if (intervals.isEmpty) return [0, 0, 0, 0];

    int maxStreak = 0, totalDays = 0;
    int totalSuccess = 0, totalFail = 0;
    for (var i = 0; i < intervals.length; i++) {
      totalSuccess += intervals[i].intervalStreak;
      maxStreak = max(maxStreak, intervals[i].intervalStreak);
    }

    // inlcuding today also
    totalDays = DateTime.now().difference(intervals.first.startDate).inDays + 1;
    totalFail = totalDays - totalSuccess;

    return [totalDays, totalSuccess, totalFail, maxStreak];
  }

  HabitModel({
    required this.title,
    // required this.icon,
    required this.color,
    required this.isBad,
    // required this.quoteToSelf,
    required this.intervals,
  }) {
    sortAndMergeInterval();
  }

  HabitModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    // icon = json['icon'];
    color = Color(json['color']);
    isBad = json['isBad'] ?? false;
    // quoteToSelf = json['quoteToSelf'] ?? '';
    if (json['intervals'] != null) {
      intervals = <IntervalModel>[];
      json['intervals'].forEach((v) {
        intervals.add(IntervalModel.fromJson(v));
      });
    }
    sortAndMergeInterval();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    // data['icon'] = icon;
    data['color'] = color.value.toString();
    data['isBad'] = isBad;
    // data['quoteToSelf'] = quoteToSelf;
    if (intervals.isNotEmpty) {
      data['intervals'] = intervals.map((v) => v.toJson()).toList();
    }
    return data;
  }

  void sortAndMergeInterval() {
    intervals.sort((a, b) => a.startDate.compareTo(b.startDate));

    // if two intervals are overlapping then merge them
    for (var i = 0; i < intervals.length - 1; i++) {
      if (intervals[i].endDate.isAfter(intervals[i + 1].startDate)) {
        intervals[i].endDate = intervals[i + 1].endDate;
        intervals.removeAt(i + 1);
        i--;
        // ignore: avoid_print
        print("If this is called then there have been some inconsistency. Please report this bug.");
      }
    }
  }

  void removeInterval(DateTime date) {
    if (intervals.isEmpty) return;

    for (var i = 0; i < intervals.length; i++) {
      bool isStart = date.year == intervals[i].startDate.year &&
          date.month == intervals[i].startDate.month &&
          date.day == intervals[i].startDate.day;
      bool isEnd = date.year == intervals[i].endDate.year &&
          date.month == intervals[i].endDate.month &&
          date.day == intervals[i].endDate.day;

      if (isStart && isEnd && intervals[i].intervalStreak == 1) {
        intervals.removeAt(i);
        return;
      }
      if (isStart) {
        intervals[i].startDate = date.add(const Duration(days: 1));
        return;
      }
      if (isEnd) {
        intervals[i].endDate = date.subtract(const Duration(days: 1));
        return;
      }
      if (date.isAfter(intervals[i].startDate) && date.isBefore(intervals[i].endDate)) {
        final newInterval = IntervalModel(
          startDate: date.add(const Duration(days: 1)),
          endDate: intervals[i].endDate,
        );
        intervals[i].endDate = date.subtract(const Duration(days: 1));
        intervals.insert(i + 1, newInterval);
        return;
      }
    }
  }

  void addDate(DateTime date) {
    if (intervals.isEmpty) {
      intervals.add(IntervalModel(startDate: date, endDate: date));
      return;
    }

    if (date.isBefore(intervals.first.startDate)) {
      if (intervals.first.startDate.difference(date).inDays == 1) {
        intervals.first.startDate = date;
      } else {
        intervals.insert(0, IntervalModel(startDate: date, endDate: date));
      }
      return;
    }

    if (date.isAfter(intervals.last.endDate)) {
      if (date.difference(intervals.last.endDate).inDays == 1) {
        intervals.last.endDate = date;
      } else {
        intervals.add(IntervalModel(startDate: date, endDate: date));
      }
      return;
    }

    for (var i = 0; i < intervals.length - 1; i++) {
      if (date.isAfter(intervals[i].endDate) && date.isBefore(intervals[i + 1].startDate)) {
        if (date.difference(intervals[i].endDate).inDays == 1 &&
            intervals[i + 1].startDate.difference(date).inDays == 1) {
          intervals[i].endDate = intervals[i + 1].endDate;
          intervals.removeAt(i + 1);
        } else if (date.difference(intervals[i].endDate).inDays == 1) {
          intervals[i].endDate = date;
        } else if (intervals[i + 1].startDate.difference(date).inDays == 1) {
          intervals[i + 1].startDate = date;
        } else {
          intervals.insert(i + 1, IntervalModel(startDate: date, endDate: date));
        }
        return;
      }
    }
  }

  bool doneForToday() {
    // check if the habit is already done for today
    if (intervals.isEmpty) return false;
    var today = DateTime.now();
    return (today.year == intervals.last.endDate.year &&
        today.month == intervals.last.endDate.month &&
        today.day == intervals.last.endDate.day);
  }
}
