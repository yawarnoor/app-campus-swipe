import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:campus_swipe/components/custom_buttons.dart';
import 'package:campus_swipe/constants.dart';
import 'package:campus_swipe/screens/home_screen/home_screen.dart';

late bool _passwordVisible;
const String login = 'https://backend-campus-swipe.vercel.app/login';

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  bool _isLoading = false; // Add this line

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      var response = await http.post(
        Uri.parse(login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      if (response.statusCode == 200 &&
          response.headers['content-type']?.contains('application/json') ==
              true) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status']) {
          var myToken = jsonResponse['token'];
          var email = emailController.text;

          prefs.setString('token', myToken);
          // Fetch user data using the token
          await fetchUserData(myToken, email);
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (route) => false);
        } else {
          // Assuming the server sends an error message when the password is incorrect
          String errorMessage =
              jsonResponse['message'] ?? 'Something went wrong';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _isLoading = false; // Set loading state to false
                      });
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle non-JSON response
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: kPrimaryColor,
              title:
                  Text('Error', style: Theme.of(context).textTheme.titleMedium),
              content: Text('Incorrect Email/Password',
                  style: Theme.of(context).textTheme.titleMedium),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isLoading = false; // Set loading state to false
                    });
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  Future<void> fetchUserData(String token, String email) async {
    var response = await http.get(
      Uri.parse(
          'https://backend-campus-swipe.vercel.app//user/${email}'), // Replace with your API endpoint
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      var userData = jsonDecode(response.body);
      // Save the user data to SharedPreferences or state as needed
      prefs.setString('first_name', userData['first_name'].toString());
      prefs.setString('last_name', userData['last_name'].toString());
      prefs.setString('cms_id', userData['cms_id'].toString());
      prefs.setString('email', userData['email'].toString());
      prefs.setString('phone_no', userData['phone_no'].toString());
      prefs.setString('address', userData['address'].toString());
      prefs.setString('semester', userData['semester'].toString());
      prefs.setString('degree_name', userData['degree_name'].toString());
      // ... (save other user data)

      print('User data fetched: $userData');
    } else {
      print('Failed to fetch user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      height: 20.h,
                      width: 40.w,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Hi Student!',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        Text('Sign in to continue',
                            style: Theme.of(context).textTheme.titleSmall),
                        sizedBox,
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                decoration: BoxDecoration(
                  color: kOtherColor,
                  borderRadius: kTopBorderRadius,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sizedBox,
                        buildEmailField(),
                        sizedBox,
                        buildPasswordField(),
                        sizedBox,
                        _isLoading
                            ? CircularProgressIndicator() // Display loading indicator
                            : DefaultButton(
                                onPress: loginUser,
                                title: 'SIGN IN',
                                iconData: Icons.arrow_forward_outlined,
                              ),
                        sizedBox,
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Forgot Password',
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailField() {
    return TextFormField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Mobile Number/Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      style: TextStyle(color: kPrimaryColor),
      controller: emailController,
      validator: (value) {
        RegExp regExp = new RegExp(emailPattern);
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_off_outlined,
          ),
          iconSize: kDefaultPadding,
        ),
      ),
      style: TextStyle(color: kPrimaryColor),
      controller: passwordController,
      validator: (value) {
        if (value!.length < 5) {
          return 'Must be more than 5 characters';
        }
      },
    );
  }
}
