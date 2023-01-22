import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habited/models/habit.model.dart';
import 'package:habited/models/user.model.dart';
import 'package:habited/utils/appcolors.dart';
import 'package:habited/views/components/divider.dart';
import 'package:habited/views/habit_view.dart';
import 'package:habited/views/user_pane.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double horizontalPadding = 15.0;
  double verticalPadding = 15.0;
  String hoveredHabitId = '';
  String selectedHabitId = '';
  Color selectedBgColor = AppColors.LightGray;
  Color unselectedBgColor = Colors.transparent;
  CollectionReference userHabitCollection =
      FirebaseFirestore.instance.collection('users').doc(UserModel.uid).collection('habits');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future<bool>.value(false),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const Drawer(child: UserPane(), elevation: 0.0),
          body: ScreenTypeLayout(
            mobile: habitPane(),
            desktop: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Row(
                children: [
                  const Expanded(child: UserPane(), flex: 2),
                  Expanded(child: habitPane(), flex: 5),
                  Expanded(
                    child: selectedHabitId == ''
                        ? const SizedBox()
                        : HabitView(
                            selectedHabitId: selectedHabitId,
                          ),
                    flex: 4,
                  ),
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
            headerStyle('All Habits'),
            const DefaultDivider(),
            Expanded(
              child: StreamBuilder(
                stream: userHabitCollection.snapshots(),
                builder: (ctx, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length == 0) {
                      return const Center(
                        child: Text('User found, but no habits'),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        HabitModel habit = HabitModel.fromJson(ds.data() as Map<String, dynamic>);
                        return singleHabit(habit, ds.id);
                      },
                    );
                  } else {
                    return const Center(child: Text('No snapshot data'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerStyle(String headerText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        children: [
          ScreenTypeLayout(
            mobile: InkWell(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
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
                          onPressed: () async {
                            title = title.trim();
                            if (title.isEmpty) {
                              return;
                            }
                            HabitModel obj = HabitModel(
                              title: title,
                              isBad: selectedIsBad == 'Yes',
                              color: selectedColor,
                              intervals: [],
                            );
                            Navigator.pop(context);
                            await userHabitCollection.add(obj.toJson());
                          },
                        ),
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
                color: AppColors.Blue,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.Blue, width: 0.3),
              ),
              child: Row(
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  Text(
                    ' Add Habit ',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget singleHabit(HabitModel habit, String docId) {
    var column = Column(
      children: [
        SizedBox(height: verticalPadding),
        Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: habit.color,
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
                  // habit.quoteToSelf != "" ? habit.quoteToSelf :
                  (habit.isBad ? "You can quit this habit" : "You can do this habit"),
                  style: const TextStyle(fontSize: 14, color: AppColors.DarkGrayBorder),
                ),
              ],
            ),
            const Spacer(),
            if (habit.currentStreak != 0)
              Text(
                habit.currentStreak.toString(),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            if (habit.currentStreak != 0)
              Icon(
                CupertinoIcons.flame_fill,
                color: habit.color,
                size: 18,
              ),
            const SizedBox(width: 13),
            (!habit.doneForToday())
                ? InkWell(
                    onTap: () {
                      // TODO : ADD DATE
                      habit.addDate(DateTime.now());
                      userHabitCollection.doc(docId).update(habit.toJson());
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
                      // TODO : REMOVE DATE
                      habit.removeInterval(DateTime.now());
                      userHabitCollection.doc(docId).update(habit.toJson());
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
        DefaultDivider(leftPadding: horizontalPadding * 2),
      ],
    );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: hoveredHabitId == docId ? selectedBgColor : unselectedBgColor,
      ),
      child: ScreenTypeLayout(
        mobile: InkWell(
          onTap: () async {
            // setState(() => selectedHabitId = docId);
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HabitView(selectedHabitId: docId)),
            );
          },
          child: column,
        ),
        desktop: InkWell(
          onTap: () {
            setState(() => selectedHabitId = docId);
            // print('updating selected habit id to $selectedHabitId');
            // Navigator.push(
            //   context,
            //   CupertinoPageRoute(builder: (_) => HabitView(selectedHabitId: docId)),
            // );
          },
          onHover: (value) {
            if (value) {
              setState(() => hoveredHabitId = docId);
            } else {
              setState(() => hoveredHabitId = '');
            }
          },
          child: column,
        ),
      ),
    );
  }
}
