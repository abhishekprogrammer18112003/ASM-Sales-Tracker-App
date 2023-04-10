import 'dart:convert';
// import 'dart:ffi';
import 'package:asm_sales_tracker/screens/follow_up_update.dart';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Todays_Lead extends StatefulWidget {
  const Todays_Lead({super.key});

  @override
  State<Todays_Lead> createState() => _Todays_LeadState();
}

class _Todays_LeadState extends State<Todays_Lead> {
  String? loginenc_id;
  String? phone_number;

  Future<String?> getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    loginenc_id = prefs.getString("login_enc_id");
    return loginenc_id!;
  }

  Future<void> getmobilenumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    phone_number = prefs.getString("login_mobile_number");
    // return phone;
  }

  List<dynamic> _todaysleadlist = [];
  Future<List> getleadlist() async {
    print('****************************');

    loginenc_id = await getdetails() as String?;
    print(loginenc_id.toString());
    FormData formData = FormData.fromMap({
      'enc_string': 'HSjLAS82146',
      'enc_id': loginenc_id,
    });

    String url = "https://asm.sortbe.com/api/Today-Leads";
    var response = await Dio().post(url, data: formData);
    var jsonData = response.data;
    print(jsonData);

    if (response.statusCode == 200) {
      print("done lead list");
      print(loginenc_id.toString());
      _todaysleadlist.addAll(jsonData['follow_list']);
      print(_todaysleadlist);
      return _todaysleadlist;
    } else {
      print("something went wrong");
      return _todaysleadlist;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today's Lead"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: FutureBuilder(
          future: getleadlist(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  // mainAxisSpacing: 40,
                  // childAspectRatio: 1,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.32,
                  //  crossAxisCount: 2,

                  // childAspectRatio: 0.65,
                  // mainAxisSpacing: 10,
                  // crossAxisSpacing: 10,
                  // Set the height of each item in the grid
                  // Here, each item is given a height of 150
                  // You can change the height to whatever you need
                  // Alternatively, you can use `childAspectRatio` to control the item's aspect ratio and adjust the height accordingly
                  // childAspectRatio: 1,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10.0),
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
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.info),
                                  onPressed: () {
                                    // Handle info button press
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            // title: Text('Business Type'),
                                            content: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                height: 500,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 40,
                                                            width: 40,
                                                            decoration: BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        185,
                                                                        189,
                                                                        190),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: Center(
                                                                child: Icon(Icons
                                                                    .arrow_back)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Image(
                                                          height: 75,
                                                          image: AssetImage(
                                                              "assets/images/avatar.png")),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        snapshot.data![index]
                                                            ['name'],
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Center(
                                                      child: Text(
                                                        snapshot.data![index]
                                                            ['client_type'],
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // SizedBox(width: 1),
                                                              Text(
                                                                "Mobile",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // SizedBox(width: 9),
                                                              Text(snapshot
                                                                          .data![
                                                                      index]
                                                                  ['mobile']),
                                                              // SizedBox(width: 1),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // SizedBox(width: 1),
                                                              Text(
                                                                "Follow-Date",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // SizedBox(width: 9),
                                                              Text(snapshot
                                                                          .data![
                                                                      index][
                                                                  'follow_date']),
                                                              // SizedBox(width: 1),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // SizedBox(width: 1),
                                                              Text(
                                                                "Building Type",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // SizedBox(width: 9),
                                                              Text(snapshot
                                                                          .data![
                                                                      index][
                                                                  'building_type']),
                                                              // SizedBox(width: 1),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // SizedBox(width: 1),
                                                              Text(
                                                                "Steel",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // SizedBox(width: 9),
                                                              Text(snapshot
                                                                          .data![
                                                                      index][
                                                                  'steel_name']),
                                                              // SizedBox(width: 1),
                                                            ],
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                        width: double.infinity,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    255),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                width: 1)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // SizedBox(width: 1),
                                                              Text(
                                                                "Cement",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              // SizedBox(width: 9),
                                                              Text(snapshot
                                                                          .data![
                                                                      index][
                                                                  'cement_name']),
                                                              // SizedBox(width: 1),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                            Image(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                image: AssetImage("assets/images/avatar.png")),
                            // SizedBox(
                            //   height:
                            //       MediaQuery.of(context).size.height * 0.016,
                            // ),
                            Text(
                              snapshot.data![index]['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(
                            //   height:
                            //       MediaQuery.of(context).size.height * 0.016,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      print(snapshot.data![index]['lead_id']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Follow_Up_update(
                                                      lead_id:
                                                          snapshot.data![index]
                                                              ['lead_id'])));
                                    },
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                      199, 158, 158, 158)
                                                  .withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text("Update",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400)),
                                        )),
                                  ),
                                  // SizedBox(
                                  //   width: 15,
                                  // ),
                                  GestureDetector(
                                    onTap: () async {
                                      await getmobilenumber();
                                      final Uri url = Uri(
                                        scheme: 'tel',
                                        path: phone_number,
                                      );
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        print("can't launch this url");
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.09,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                    199, 158, 158, 158)
                                                .withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Icon(Icons.phone),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
