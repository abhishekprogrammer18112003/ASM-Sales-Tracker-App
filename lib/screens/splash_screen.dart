import 'dart:async';
import 'package:asm_sales_tracker/screens/login_screen.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:flutter/material.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Splash_Screen()),
      );
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
