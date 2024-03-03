import 'package:campus_swipe/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:campus_swipe/screens/home_screen/home_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  //route name for our screen
  final String token;
  final SharedPreferences prefs;
  static String routeName = 'SplashScreen';

  SplashScreen({required this.token, required this.prefs});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   //we use future to go from one screen to other via duration time
  //   Future.delayed(Duration(seconds: 5), () {
  //     //no return when user is on login screen and press back, it will not return the
  //     //user to the splash screen
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, LoginScreen.routeName, (route) => false);
  //   });
  // }

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              widget.token.isNotEmpty && !JwtDecoder.isExpired(widget.token)
                  ? HomeScreen(
                      token: widget.token,
                      prefs: widget.prefs,
                    )
                  : LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //scaffold color set to primary color in main in our text theme
    return Scaffold(
      //its a row with a column
      body: Center(
        child: Container(
          child: Image.asset(
            'assets/images/splash.png',
            //25% of height & 50% of width
            height: 50.h,
            width: 75.w,
          ),
        ),
      ),
    );
  }
}
