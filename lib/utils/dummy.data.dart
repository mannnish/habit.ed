import 'package:habited/models/habit.model.dart';
import 'appcolors.dart';

class DummyData {
  static List<HabitModel> habits = [
    HabitModel(
      title: 'Drink Water',
      color: AppColors.Blue,
      isBad: false,
      lastStreakDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    HabitModel(
      title: 'Workout',
      color: AppColors.Red,
      isBad: false,
      lastStreakDate: DateTime.now().subtract(const Duration(days: 4)),
    ),
    HabitModel(
      title: 'Leetcode daily',
      color: AppColors.Yellow,
      isBad: false,
      lastStreakDate: DateTime.now().subtract(const Duration(days: 11)),
    ),
  ];
}
