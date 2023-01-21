import 'package:flutter/material.dart';
import 'package:habited/views/user_pane.dart';

import 'habit_pane.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Future<bool>.value(false),
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: const [
              // 1-2--3---
              Expanded(child: UserPane(), flex: 1),
              Expanded(child: HabitPane(), flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}
