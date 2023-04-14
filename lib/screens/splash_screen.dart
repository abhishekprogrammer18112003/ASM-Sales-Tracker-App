import 'dart:async';
import 'dart:convert';
import 'package:asm_sales_tracker/screens/login_screen.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  bool? islogin;
  String? loginencid;
  Future<void> checklogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // setState(() {
    islogin = prefs.getBool("login_islogin");
    // });
  }

  Future<String?> getclientid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_enc_id");
  }

  Future<void> checkclient() async {
    print("*********************");
    loginencid = await getclientid();

    final response = await http
        .post(Uri.parse('https://asm.sortbe.com/api/User-Check'), body: {
      'user_id': loginencid.toString(),
      'enc_string': 'HSjLAS82146',
    });
    print("done posting");
    var data = jsonDecode(response.body.toString());
    print(data);

    if (response.statusCode == 200) {
      // Login successful.
      print("done fetching");
      // You can save the user's session token or navigate to the next screen here.
      if (data['status'] == 'Available') {
        Timer(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Nav_Screen()),
          );
          // : Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => Login_Screen()));
        });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // title: Text('Business Type'),
                content: Container(
                    width: double.maxFinite,
                    child: Center(
                      child: Text("User Access Denied"),
                    )),
              );
            });
      }
    } else {
      // Login failed.
      // You can display an error message here.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: EdgeInsets.all(16),
            height: 90,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 0, 0),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text("Something went Wrong"),
          )));
    }
  }

  // Future<String?> getmobile() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   mobile_number = prefs.getString("login_mobile_number");
  //   return mobile_number;
  // }
  void login() async {
    await checklogin();
    if (islogin == null) {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login_Screen()));
      });
    } else {
      islogin!
          ? checkclient()
          : Timer(Duration(seconds: 3), () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Login_Screen()));
            });
    }
  }

  @override
  void initState() {
    super.initState();
    login();
    // Timer(Duration(seconds: 3), () {
    //   islogin
    //       ? Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(builder: (context) => Nav_Screen()),
    //         )
    //       : Navigator.pushReplacement(
    //           context, MaterialPageRoute(builder: (context) => Login_Screen()));
    // });
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
