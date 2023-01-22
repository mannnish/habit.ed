import 'package:cloud_firestore/cloud_firestore.dart';

class IntervalModel {
  late DateTime startDate;
  late DateTime endDate;

  int get intervalStreak {
    DateTime s = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime e = DateTime(endDate.year, endDate.month, endDate.day);
    Duration count = e.difference(s);
    // print("int get intervalStreak: ${toJson()} && ${count.inDays + 1}");
    return count.inDays + 1;
  }

  IntervalModel({required this.startDate, required this.endDate});

  IntervalModel.fromJson(Map<String, dynamic> json) {
    startDate = (json["start_date"] as Timestamp).toDate();
    endDate = (json["end_date"] as Timestamp).toDate();
  }

  toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data["start_date"] = startDate;
    data["end_date"] = endDate;
    return data;
  }
}
