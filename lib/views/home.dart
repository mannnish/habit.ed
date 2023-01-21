import 'package:flutter/material.dart';
import 'package:habited/models/habit.model.dart';
import 'package:habited/utils/appcolors.dart';
import 'package:habited/views/habit_view.dart';
import 'package:habited/views/user_pane.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:habited/utils/dummy.data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double horizontalPadding = 15.0;
  double verticalPadding = 15.0;
  int hoveredIndex = -1;
  int selectedHabitIndex = -1;
  Color selectedBgColor = AppColors.LightGray;
  Color unselectedBgColor = Colors.transparent;

  closeHabitView() {
    setState(() => selectedHabitIndex = -1);
  }

  void openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future<bool>.value(false),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const Drawer(child: UserPane(), elevation: 0.0),
          endDrawer: Drawer(child: HabitView(selectedHabitId: selectedHabitIndex), elevation: 0.0),
          body: ScreenTypeLayout(
            mobile: habitPane(),
            desktop: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  const Expanded(child: UserPane(), flex: 2),
                  Expanded(child: habitPane(), flex: 5),
                  Expanded(child: habitView(), flex: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget habitPane() {
    return Container(
      color: Colors.yellow,
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
                for (int i = 0; i < DummyData.habits.length; ++i) singleHabit(i),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget headerStyle(String headerText, {bool isAddButton = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        children: [
          if (isAddButton)
            ScreenTypeLayout(
              mobile: InkWell(
                onTap: () => openDrawer(),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.Blue, width: 0.3),
                  ),
                  child: const Icon(Icons.menu, color: AppColors.DarkGrayBorder, size: 21),
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
          InkWell(
            onTap: () async {
              // popup to take input of Habit model
              String title = '';
              List isBad = ['Yes', 'No'];
              List colors = [Colors.purple, Colors.blue, Colors.green, Colors.yellow, Colors.orange, Colors.red];
              Color selectedColor = colors[0];
              String selectedIsBad = 'No';
              const textStyle = TextStyle(fontSize: 13);

              await showCupertinoDialog(
                context: context,
                builder: (ctx) {
                  return StatefulBuilder(builder: (ctx, setState) {
                    return CupertinoAlertDialog(
                      title: const Text('Add Habit'),
                      content: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            CupertinoTextField(
                                placeholder: 'Habit Title',
                                onChanged: (val) {
                                  title = val;
                                }),
                            const SizedBox(height: 5),
                            // dropdown for yes or no
                            Row(
                              children: [
                                const Text('Is Bad Habit?'),
                                const Spacer(),
                                DropdownButton(
                                  underline: const SizedBox(),
                                  value: selectedIsBad,
                                  items: isBad.map((e) {
                                    return DropdownMenuItem(child: Text(e, style: textStyle), value: e);
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedIsBad = val.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                            // drop down for color
                            Row(
                              children: [
                                const Text('Select Color'),
                                const Spacer(),
                                DropdownButton(
                                  underline: const SizedBox(),
                                  value: selectedColor,
                                  items: colors.map((e) {
                                    return DropdownMenuItem(
                                      child: Container(color: e, width: 30, height: 30),
                                      value: e,
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selectedColor = val as Color;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Cancel', style: TextStyle(color: AppColors.DarkGrayBorder)),
                          onPressed: () => Navigator.pop(context),
                        ),
                        CupertinoDialogAction(
                            child: const Text('Add'),
                            onPressed: () {
                              if (title.isEmpty) {
                                return;
                              }
                              HabitModel obj = HabitModel(
                                title: title,
                                isBad: selectedIsBad == 'Yes',
                                color: selectedColor,
                                intervals: [],
                              );
                              setState(() {
                                DummyData.habits.add(obj);
                              });
                              Navigator.pop(context);
                            }),
                      ],
                    );
                  });
                },
              );
              setState(() {});
            },
            child: Container(
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
            ),
          )
        ],
      ),
    );
  }

  Divider divider() {
    return const Divider(
      height: 0,
      color: AppColors.DarkGrayBorder,
      thickness: 0.3,
    );
  }

  Widget habitView() {
    if (selectedHabitIndex == -1) return Container();
    return HabitView(selectedHabitId: selectedHabitIndex);
  }

  Widget singleHabit(int i) {
    var column = Column(
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
                  DummyData.habits[i].title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  // DummyData.habits[i].quoteToSelf != ""
                  // ? DummyData.habits[i].quoteToSelf
                  // :
                  (DummyData.habits[i].isBad ? "You can quit this habit" : "You can do this habit"),
                  style: const TextStyle(fontSize: 14, color: AppColors.DarkGrayBorder),
                ),
              ],
            ),
            const Spacer(),
            if (DummyData.habits[i].currentStreak != 0)
              Text(DummyData.habits[i].currentStreak.toString(),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            if (DummyData.habits[i].currentStreak != 0)
              const Icon(CupertinoIcons.flame_fill, color: AppColors.Red, size: 18),
            const SizedBox(width: 13),
            (!DummyData.habits[i].doneForToday())
                ? InkWell(
                    onTap: () {
                      DummyData.habits[i].addDate(DateTime.now());
                      setState(() {});
                    },
                    child: Container(
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
                  )
                : InkWell(
                    onTap: () {
                      DummyData.habits[i].removeInterval(DateTime.now());
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 7),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black87, width: 0.5),
                      ),
                      child: const Icon(Icons.undo_rounded, color: Colors.black87, size: 16),
                    ),
                  ),
          ],
        ),
        SizedBox(height: verticalPadding),
        Padding(
          padding: EdgeInsets.only(left: horizontalPadding * 2),
          child: divider(),
        ),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: hoveredIndex == i ? selectedBgColor : unselectedBgColor,
      ),
      child: ScreenTypeLayout(
        mobile: InkWell(
          onTap: () async {
            setState(() => selectedHabitIndex = i);
            await Navigator.push(
                context, MaterialPageRoute(builder: (_) => HabitView(selectedHabitId: selectedHabitIndex)));
            setState(() {});
          },
          child: column,
        ),
        desktop: InkWell(
          onTap: () {
            setState(() => selectedHabitIndex = i);
          },
          onHover: (value) {
            if (value) {
              setState(() => hoveredIndex = i);
            } else {
              setState(() => hoveredIndex = -1);
            }
          },
          child: column,
        ),
      ),
    );
  }
}
