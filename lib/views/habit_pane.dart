import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habited/models/habit.model.dart';
import 'package:habited/utils/appcolors.dart';
import 'package:habited/utils/dummy.data.dart';

class HabitPane extends StatefulWidget {
  const HabitPane({Key? key}) : super(key: key);

  @override
  State<HabitPane> createState() => _HabitPaneState();
}

class _HabitPaneState extends State<HabitPane> {
  double horizontalPadding = 15.0;
  double verticalPadding = 15.0;
  int hoveredIndex = -1;
  int selectedHabitIndex = 1;
  Color selectedBgColor = AppColors.LightGray;
  Color unselectedBgColor = Colors.transparent;

  closeHabitView() {
    setState(() => selectedHabitIndex = -1);
  }

  Widget headerStyle(String headerText, {bool isAddButton = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        children: [
          Text(
            headerText,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              color: isAddButton ? AppColors.Blue : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: isAddButton ? AppColors.Blue : AppColors.DarkGrayBorder, width: 0.3),
            ),
            child: Row(
              children: [
                Icon(
                  isAddButton ? Icons.add : Icons.highlight_alt_rounded,
                  color: isAddButton ? Colors.white : AppColors.DarkGrayBorder,
                  size: 16,
                ),
                if (isAddButton)
                  Text(
                    ' Add Habit ',
                    style: TextStyle(
                      color: isAddButton ? Colors.white : AppColors.DarkGrayBorder,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerStyle('All Habits', isAddButton: true),
                  divider(),
                  Column(
                    children: [
                      for (int i = 0; i < DummyData.habits.length; ++i) singleHabit(i, DummyData.habits[i]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(flex: 4, child: habitView()),
        ],
      ),
    );
  }

  Divider divider() {
    return const Divider(height: 0, color: AppColors.DarkGrayBorder, thickness: 0.3);
  }

  Widget habitView() {
    if (selectedHabitIndex == -1) return Container();
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 15, vertical: 15);
    EdgeInsets padding = EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding);
    double radius = 10.0;
    BoxDecoration decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.DarkGrayBorder, width: 0.3),
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          headerStyle(DummyData.habits[selectedHabitIndex].title, isAddButton: false),
          divider(),
          Container(
            margin: margin,
            padding: padding,
            decoration: decoration,
            child: Row(
              children: [
                const Icon(CupertinoIcons.flame_fill, color: AppColors.Red, size: 35),
                const SizedBox(width: 5),
                Text(
                  DummyData.habits[selectedHabitIndex].streakDays.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.LightGray,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    'from ${DummyData.habits[selectedHabitIndex].lastStreakDateFormatted}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.DarkGrayBorder,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // TODO : add calender here
        ],
      ),
    );
  }

  Widget singleHabit(int i, HabitModel habit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: hoveredIndex == i ? selectedBgColor : unselectedBgColor,
      ),
      child: InkWell(
        onTap: () => setState(() => selectedHabitIndex = i),
        onHover: (value) {
          if (value) {
            setState(() => hoveredIndex = i);
          } else {
            setState(() => hoveredIndex = -1);
          }
        },
        child: Column(
          children: [
            SizedBox(height: verticalPadding),
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.Blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      habit.isBad ? "You can quit this habit" : "You can do this habit",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.DarkGrayBorder,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(habit.streakDays.toString(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const Icon(CupertinoIcons.flame_fill, color: AppColors.Red, size: 18),
                const SizedBox(width: 13),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black87, width: 0.5),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check, color: Colors.black87, size: 16),
                      Text(
                        ' Done ',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 7),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.black87, width: 0.5),
                  ),
                  child: const Icon(CupertinoIcons.calendar_badge_plus, color: Colors.black87, size: 16),
                ),
              ],
            ),
            SizedBox(height: verticalPadding),
            Padding(
              padding: EdgeInsets.only(left: horizontalPadding * 2),
              child: divider(),
            ),
          ],
        ),
      ),
    );
  }
}
