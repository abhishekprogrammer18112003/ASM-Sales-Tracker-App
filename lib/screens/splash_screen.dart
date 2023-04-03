import 'dart:async';
import 'package:asm_sales_tracker/screens/login_screen.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  bool islogin = false;

  void checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      islogin = prefs.getBool("login_islogin")!;
    });
  }

  @override
  void initState() {
    super.initState();
    checklogin();

    Timer(Duration(seconds: 3), () {
      islogin
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Nav_Screen()),
            )
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login_Screen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue,
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          height: 250,
          width: 250,
          child: Image.asset("assets/images/asmbgremove.png"),
        ),
        const SizedBox(
          height: 20,
        ),
        CircularProgressIndicator(),
      ]),
    ));
  }
}
