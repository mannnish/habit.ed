import 'package:habited/models/habit.model.dart';
import 'package:habited/models/interval.model.dart';
import 'appcolors.dart';

class DummyData {
  static List<HabitModel> habits = [
    HabitModel(
      title: 'Go Gym',
      icon: '',
      color: AppColors.Blue,
      isBad: false,
      quoteToSelf: 'No intervals',
      intervals: [
        IntervalModel(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 6),
        ),
      ],
    ),
    HabitModel(
      title: 'Go College',
      icon: '',
      color: AppColors.Orange,
      isBad: false,
      quoteToSelf: 'intervals, but no ongoing streak',
      intervals: [
        // dummy data of intervalModels
        IntervalModel(
          startDate: DateTime(2023, 1, 1),
          endDate: DateTime(2023, 1, 6),
        ),
        IntervalModel(
          startDate: DateTime(2023, 1, 8),
          endDate: DateTime(2023, 1, 8),
        ),
        IntervalModel(
          startDate: DateTime(2023, 1, 10),
          endDate: DateTime(2023, 1, 14),
        ),
      ],
    ),
    HabitModel(
      title: 'Leetcode Daily',
      icon: '',
      color: AppColors.Green,
      isBad: false,
      quoteToSelf: 'intervals, and ongoing streak',
      intervals: [
        IntervalModel(
          startDate: DateTime(2023, 1, 4),
          endDate: DateTime(2023, 1, 6),
        ),
        IntervalModel(
          startDate: DateTime(2023, 1, 13),
          endDate: DateTime(2023, 1, 17),
        ),
      ],
    ),
  ];
}
