import 'package:asm_sales_tracker/screens/follow_up_page.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:asm_sales_tracker/screens/today_lead.dart';
import 'package:asm_sales_tracker/screens/upcomingleads.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  // bool istodaylead = true;
  // bool isupcominglead = false;
  String? loginenc_id;

  Future<String> getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    loginenc_id = prefs.getString("login_enc_id");
    return loginenc_id!;
  }

  String? todayscount = '0';
  String? follow_up_count = '0';
  List<dynamic> _dashboard = [];
  Future<String?> getleadlist() async {
    print('****************************');

    loginenc_id = await getdetails() as String?;
    print(loginenc_id.toString());
    FormData formData = FormData.fromMap({
      'enc_string': 'HSjLAS82146',
      'enc_id': loginenc_id,
    });

    String url = "https://asm.sortbe.com/api/Dashboard-Data";
    var response = await Dio().post(url, data: formData);
    var jsonData = response.data;
    print(jsonData);

    if (response.statusCode == 200) {
      // if(jsonData['today_count'] != '0'){
      //   todayscount = jsonData['today_count'];
      //   follow_up_count = jsonData['follow_count'];
      // }
      print("done lead list");
      print(loginenc_id.toString());

      todayscount = jsonData['today_count'];
      follow_up_count = jsonData['follow_count'];

      return todayscount;
    } else {
      print("something went wrong");
      return todayscount;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetails();
    getleadlist();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 66, 190, 221),
              Color.fromARGB(255, 64, 162, 207),
              Color.fromARGB(255, 0, 162, 255),
              Color.fromARGB(255, 0, 119, 255)
            ])),
          ),
          // leading: Icon(Icons.construction),
          automaticallyImplyLeading: false,
          title: Text('Dashboard'),
        ),
        body: FutureBuilder(
          future: getleadlist(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Todays_Lead())).then((value) {
                      setState(() {
                        // Call setState to refresh the page.
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      height: 170.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(199, 158, 158, 158)
                                .withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Today's Follow-Up Leads",
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 9),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  todayscount.toString(),
                                  style: TextStyle(
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey),
                                ),
                                Text(
                                  "/${follow_up_count.toString()}",
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                minHeight: 15,

                                value: double.parse(
                                            follow_up_count.toString()) !=
                                        0
                                    ? (double.parse(todayscount.toString())) /
                                        double.parse(follow_up_count.toString())
                                    : 1 / 1,
                                // backgroundColor:
                                //     Color.fromARGB(255, 130, 206, 224)),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text("Try completing all Follow-Up ",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            SizedBox(height: 3),
                          ],
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
