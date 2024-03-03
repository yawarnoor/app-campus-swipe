import 'package:campus_swipe/screens/login_screen/login_screen.dart';
import 'package:campus_swipe/screens/splash_screen/splash_screen.dart';
import 'package:campus_swipe/screens/transaction_screen/transaction_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/assignment_screen/assignment_screen.dart';
import 'screens/datesheet_screen/datesheet_screen.dart';
import 'screens/fee_screen/fee_screen.dart';
import 'screens/package_screen/package_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/my_profile/my_profile.dart';

Map<String, WidgetBuilder> getRoutes(String token, SharedPreferences prefs) {
  return {
    //all screens will be registered here like manifest in android
    SplashScreen.routeName: (context) =>
        SplashScreen(token: token, prefs: prefs),
    LoginScreen.routeName: (context) => LoginScreen(),
    HomeScreen.routeName: (context) => HomeScreen(token: token, prefs: prefs),
    MyProfileScreen.routeName: (context) => MyProfileScreen(prefs: prefs),
    FeeScreen.routeName: (context) => FeeScreen(),
    PackageScreen.routeName: (context) => PackageScreen(prefs: prefs),
    AssignmentScreen.routeName: (context) => AssignmentScreen(),
    DateSheetScreen.routeName: (context) => DateSheetScreen(),
    TransactionScreen.routeName: (context) =>
        TransactionScreen(cms_id: prefs.getString('cms_id')!),
  };
}
