import 'package:habited/utils/appconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static String name = 'name';
  static String uid = 'errorId';
  static String email = 'email';
  static String photoUrl = AppConfig.tempdp;

  static fromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? 'name';
    uid = prefs.getString('uid') ?? 'errorId';
    email = prefs.getString('email') ?? 'email';
    photoUrl = prefs.getString('photoUrl') ?? AppConfig.tempdp;
  }

  static Future toPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('uid', uid);
    prefs.setString('email', email);
    prefs.setString('photoUrl', photoUrl);
  }

  static Future<void> reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    name = 'name';
    uid = 'errorId';
    email = 'email';
    photoUrl = AppConfig.tempdp;
  }
}
