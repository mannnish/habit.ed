import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habited/models/user.model.dart';
import 'package:habited/utils/appcolors.dart';
import 'package:habited/utils/auth.repo.dart';

class UserPane extends StatefulWidget {
  const UserPane({Key? key}) : super(key: key);

  @override
  State<UserPane> createState() => _UserPaneState();
}

class _UserPaneState extends State<UserPane> {
  double borderRadius = 7.0;
  double padding = 9;
  int hoveredIndex = -1;
  int selectedIndex = 0;
  Color selectedFrontColor = Colors.white;
  Color selectedBackColor = AppColors.Blue;
  Color unselectedFrontColor = AppColors.DarkGrayBorder;
  Color unselectedHoverFrontColor = Colors.black;
  Color unselectedBackColor = Colors.transparent;

  Widget singleButton(int i, var callback, {IconData? icon, String? text}) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: selectedIndex == i ? selectedBackColor : unselectedBackColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: () {
          setState(() => selectedIndex = i);
          callback();
        },
        onHover: (value) {
          if (value && selectedIndex != i) {
            setState(() => hoveredIndex = i);
          } else {
            setState(() => hoveredIndex = -1);
          }
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: selectedIndex == i
                  ? selectedFrontColor
                  : hoveredIndex != i
                      ? unselectedFrontColor
                      : unselectedHoverFrontColor,
            ),
            const SizedBox(width: 10),
            Text(
              text!,
              style: TextStyle(
                  color: selectedIndex == i
                      ? selectedFrontColor
                      : hoveredIndex != i
                          ? unselectedFrontColor
                          : unselectedHoverFrontColor,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(color: AppColors.LightGray),
      child: Column(
        children: [
          // flutter user left pane UI
          const SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: AppColors.DarkGray,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColors.DarkGrayBorder, width: 0.05),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: AppColors.Red,
                  foregroundImage: NetworkImage(UserModel.photoUrl),
                ),
                SizedBox(width: padding),
                Text(
                  UserModel.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          singleButton(0, () {}, icon: CupertinoIcons.rectangle_stack, text: 'All Habits'),
          singleButton(1, () {}, icon: Icons.radio_button_unchecked, text: 'Pending'),
          singleButton(2, () {}, icon: Icons.settings, text: 'Settings'),
          const Spacer(),
          const Divider(color: AppColors.DarkGrayBorder, thickness: 0.2),
          const SizedBox(height: 2),
          singleButton(3, () {}, icon: Icons.format_quote_rounded, text: 'Have an Issue'),
          singleButton(4, () async {
            await AuthRepo.signOut(context);
          }, icon: Icons.logout, text: 'Logout'),
          Text(
            UserModel.uid,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }
}
