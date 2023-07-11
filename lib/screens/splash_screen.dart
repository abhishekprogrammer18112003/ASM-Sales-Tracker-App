import 'dart:async';
import 'dart:convert';
import 'package:asm_sales_tracker/screens/login_screen.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asm_sales_tracker/constant.dart';

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

    final response = await http.post(Uri.parse(apiurl + 'User-Check'), body: {
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
    _getCurrentLocation();
    give_permission();
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

  String? latitude;
  String? longitude;
  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = position.latitude as String?;
      longitude = position.longitude as String?;

      // "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  Future<double> getlatitude() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position.latitude;
  }

  Future<double> getlongitude() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position.longitude;
  }

  Future<String> getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    loginencid = prefs.getString("login_enc_id");
    return loginencid!;
  }

  Future<void> send_location() async {
    print('****************************');

    loginencid = await getdetails() as String?;

    latitude = (await getlatitude()).toString();
    longitude = (await getlongitude()).toString();
    print("${latitude.toString()}     ${longitude.toString()}");
    print(loginencid.toString());
    FormData formData = FormData.fromMap({
      'enc_string': 'HSjLAS82146',
      'enc_id': loginencid.toString(),
      'lat': latitude.toString(),
      'long': longitude.toString(),
    });

    String url = "https://asm.sortbe.com/api/User-Tracker";
    var response = await Dio().post(url, data: formData);
    var jsonData = response.data;
    print(jsonData);
    print(latitude);
    print(longitude);
    // follow_count = await getfollowcount();
    // follow_count = await jsonData['follow_count'];
    // print(follow_count);

    // _todaysleadlist.clear();
    if (response.statusCode == 200) {
      print("done location post list");
      print(loginencid.toString());
      print("******done location*********");
    } else {
      print("something went wrong");
    }
  }

  Future<void> give_permission() async {
    var permissionStatus = await Permission.location.request();
    print("Permission given");
    location_permission(permissionStatus);
  }

  Future<void> location_permission(var permissionStatus) async {
    if (permissionStatus == PermissionStatus.granted) {
      print("Location access given successfully");
      if (loginencid != Null) {
        print("sending location");
        await send_location();
        // give_permission();
      }
    } else {
      print("give permission");
      give_permission();
    }
    Timer.periodic(Duration(minutes: 2), (Timer t) async {
      if (permissionStatus == PermissionStatus.granted) {
        print("Location access given successfully");
        if (loginencid != Null) {
          print("sending location");
          await send_location();
          // give_permission();
        }
      } else {
        print("give permission");
        give_permission();
      }
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
