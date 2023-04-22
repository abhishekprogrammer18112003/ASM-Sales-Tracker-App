import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  // await location_permission();

  runApp(const MyApp());
  // getencid();
}

// Future<List> location_send() async {
//   print('****************************');

//   loginenc_id = await getdetails() as String?;
//   print(loginenc_id.toString());
//   FormData formData = FormData.fromMap({
//     'enc_string': 'HSjLAS82146',
//     'enc_id': loginenc_id.toString(),
//   });

//   String url = "https://asm.sortbe.com/api/Follow-Leads";
//   var response = await Dio().post(url, data: formData);
//   var jsonData = response.data;
//   print(jsonData);
//   // follow_count = await getfollowcount();
//   // follow_count = await jsonData['follow_count'];
//   // print(follow_count);

//   // _todaysleadlist.clear();
//   if (response.statusCode == 200) {
//     print("done lead list");
//     print(loginenc_id.toString());
//     follow_count = jsonData['follow_count'].toString();
//     follow_count != '0'
//         ? _todaysleadlist.addAll(jsonData['follow_list'])
//         : null;
//     print(_todaysleadlist);
//     return _todaysleadlist;
//   } else {
//     print("something went wrong");
//     return _todaysleadlist;
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Splash_Screen(),
    );
  }
}
