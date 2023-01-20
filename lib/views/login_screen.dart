import 'package:flutter/material.dart';
import 'package:habited/utils/appcolors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            //
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.Blue.withOpacity(0.5),
              // boxShadow: kElevationToShadow[4],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Image(
                  image: AssetImage('assets/google.png'),
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 10),
                Text(
                  'Login with Google',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
