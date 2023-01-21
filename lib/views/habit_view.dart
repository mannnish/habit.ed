import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habited/utils/appcolors.dart';
import 'package:habited/utils/appconfig.dart';
import 'package:habited/utils/dummy.data.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitView extends StatefulWidget {
  final int selectedHabitId;
  const HabitView({Key? key, required this.selectedHabitId}) : super(key: key);

  @override
  State<HabitView> createState() => _HabitViewState();
}

class _HabitViewState extends State<HabitView> {
  double horizontalPadding = 15.0;
  double verticalPadding = 15.0;
  EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 15, vertical: 15);
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 15);
  double radius = 10.0;
  BoxDecoration decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: AppColors.DarkGrayBorder, width: 0.3),
  );
  late List<int> intervalInfo;

  @override
  void initState() {
    super.initState();
    intervalInfo = DummyData.habits[widget.selectedHabitId].intervalInfo;
  }

  Divider divider() {
    return const Divider(
      height: 0,
      color: AppColors.DarkGrayBorder,
      thickness: 0.3,
    );
  }

  Widget headerStyle(String headerText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        children: [
          ScreenTypeLayout(
            mobile: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                // padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(5),
                //   border: Border.all(color: AppColors.Blue, width: 0.3),
                // ),
                child: const Icon(Icons.arrow_back, color: AppColors.DarkGrayBorder, size: 30),
              ),
            ),
            desktop: const SizedBox(),
          ),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColors.DarkGrayBorder, width: 0.3),
            ),
            child: const Icon(
              Icons.highlight_alt_rounded,
              color: AppColors.DarkGrayBorder,
              size: 16,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              headerStyle(DummyData.habits[widget.selectedHabitId].title),
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
                      DummyData.habits[widget.selectedHabitId].currentStreak.toString(),
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
                        DummyData.habits[widget.selectedHabitId].lastStreakDateFormatted,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: margin.left),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: padding,
                        decoration: decoration,
                        child: Row(
                          children: [
                            const Text(
                              'Max Streak',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 5),
                            const Icon(CupertinoIcons.flame_fill, color: AppColors.Red, size: 21),
                            const SizedBox(width: 5),
                            Text(
                              intervalInfo[3].toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Container(
                        // margin: margin,
                        padding: padding,
                        decoration: decoration,
                        child: Row(
                          children: [
                            const Text(
                              'Total Days',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 5),
                            const Icon(CupertinoIcons.calendar, color: AppColors.Orange, size: 21),
                            const SizedBox(width: 5),
                            Text(
                              intervalInfo[0].toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Text('total days : ${intervalInfo[0]}'),
              // Text('total success : ${intervalInfo[1]}'),
              // Text('total fail : ${intervalInfo[2]}'),
              // Text('max streak : ${intervalInfo[3]}'),
              // const SizedBox(height: 5),
              Container(
                margin: margin,
                padding: padding,
                decoration: decoration,
                child: TableCalendar(
                  onFormatChanged: (format) => {},
                  onDaySelected: (date, events) {
                    if (DummyData.habits[widget.selectedHabitId].isInRange(date)) {
                      DummyData.habits[widget.selectedHabitId].removeInterval(date);
                    } else {
                      DummyData.habits[widget.selectedHabitId].addDate(date);
                    }
                    setState(() {});
                  },
                  selectedDayPredicate: (DateTime randomDate) {
                    return DummyData.habits[widget.selectedHabitId].isInRange(randomDate);
                  },
                  firstDay: AppConfig.firstDate,
                  focusedDay: DateTime.now(),
                  lastDay: DateTime.now(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
