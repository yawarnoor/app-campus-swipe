import 'package:campus_swipe/routes.dart';
import 'package:campus_swipe/screens/home_screen/home_screen.dart';
import 'package:campus_swipe/screens/login_screen/login_screen.dart';
import 'package:campus_swipe/screens/splash_screen/splash_screen.dart';
import 'package:campus_swipe/theme.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  print('Token from SharedPreferences: $token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  final Future<SharedPreferences> prefs;

  MyApp({
    Key? key,
    this.token,
  })  : prefs = SharedPreferences.getInstance(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: prefs,
      builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          SharedPreferences prefs = snapshot.data!;
          return Sizer(builder: (context, orientation, device) {
            if (token != null) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Campus Swipe',
                theme: CustomTheme().baseTheme,
                home: SplashScreen(token: token!, prefs: prefs),
                routes: getRoutes(token!, prefs),
                onGenerateRoute: (settings) {
                  print('Route name: ${settings.name}');
                  print('Token from SharedPreferences: $token');
                  print('Token is expired: ${JwtDecoder.isExpired(token!)}');
                  if (settings.name == HomeScreen.routeName) {
                    print('Validating token...');
                    return MaterialPageRoute(
                      builder: (context) {
                        if (!JwtDecoder.isExpired(token!)) {
                          print('Token is valid, navigating to HomeScreen');
                          return HomeScreen(token: token, prefs: prefs);
                        } else {
                          print('Token is invalid, navigating to LoginScreen');
                          return LoginScreen();
                        }
                      },
                    );
                  }
                  return null;
                },
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Campus Swipe',
                theme: CustomTheme().baseTheme,
                home: LoginScreen(),
              );
            }
          });
        }
        return CircularProgressIndicator();
      },
    );
  }
}
