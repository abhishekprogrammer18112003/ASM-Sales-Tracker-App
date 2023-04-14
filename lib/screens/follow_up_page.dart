import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:asm_sales_tracker/screens/follow_lead_list.dart';
import 'package:asm_sales_tracker/screens/follow_up_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'follow_up_update.dart';

class Follow_Up_Page extends StatefulWidget {
  const Follow_Up_Page({super.key});

  @override
  State<Follow_Up_Page> createState() => _Follow_Up_PageState();
}

class _Follow_Up_PageState extends State<Follow_Up_Page> {
  String? loginenc_id;
  String? phone_number;
  String? follow_count;

  Future<String> getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    loginenc_id = prefs.getString("login_enc_id");
    return loginenc_id!;
  }

  Future<String?> getfollowcount() async {
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

      follow_count = jsonData['today_count'];

      return follow_count;
    } else {
      print("something went wrong");
      return follow_count;
    }
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

    String url = "https://asm.sortbe.com/api/Follow-Leads";
    var response = await Dio().post(url, data: formData);
    var jsonData = response.data;
    print(jsonData);
    follow_count = await getfollowcount();

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
        // backgroundColor:
        //     LinearGradient(colors: [Colors.blue, Colors.blue.shade300]),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 66, 190, 221),
            Color.fromARGB(255, 64, 162, 207),
            Color.fromARGB(255, 0, 162, 255),
            Color.fromARGB(255, 0, 119, 255)
          ])),
        ),
        // leading: Icon(Icons.follow_the_signs),
        automaticallyImplyLeading: false,
        // leading: Padding(padding: EdgeInsets.all(0.5)),
        title: const Text(
          "Follow-Up's",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.location_history_rounded),
      //     onPressed: () {
      //       print(loginenc_id);
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //               builder: (context) => Follow_Lead_List_Page(
      //                     enc_id: loginenc_id,
      //                   )));
      //     }),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: FutureBuilder(
          future: getleadlist(),
          builder: (context, snapshot) {
            if (follow_count.toString() != '0' && !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // print(widget.todays_count.toString());
            if (follow_count.toString() == '0') {
              return const Center(
                  child: Text(
                "There is no Follow-Ups",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ));
            }
            return Padding(
              padding: const EdgeInsets.all(7.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // mainAxisSpacing: 20,
                    // childAspectRatio: 1,
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.34,
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
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: const Icon(
                                      Icons.info,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      // Handle info button press
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              child: Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Container(
                                                      // color: Colors.amber,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      // height: 500,
                                                      decoration: BoxDecoration(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color
                                                                    .fromARGB(
                                                                        199,
                                                                        158,
                                                                        158,
                                                                        158)
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 15.0,
                                                                horizontal: 20),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          // crossAxisAlignment:
                                                          //     CrossAxisAlignment
                                                          //         .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
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
                                                                snapshot.data![
                                                                        index]
                                                                    ['name'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 22,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 4),
                                                            Center(
                                                              child: Text(
                                                                snapshot.data![
                                                                        index][
                                                                    'client_type'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        width:
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
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
                                                                                FontWeight.bold),
                                                                      ),
                                                                      // SizedBox(width: 9),
                                                                      Text(snapshot
                                                                              .data![index]
                                                                          [
                                                                          'mobile']),
                                                                      // SizedBox(width: 1),
                                                                    ],
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        width:
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
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
                                                                                FontWeight.bold),
                                                                      ),
                                                                      // SizedBox(width: 9),
                                                                      Text(snapshot
                                                                              .data![index]
                                                                          [
                                                                          'follow_date']),
                                                                      // SizedBox(width: 1),
                                                                    ],
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        width:
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      // SizedBox(width: 1),
                                                                      Text(
                                                                        "Building",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      // SizedBox(width: 9),
                                                                      Text(snapshot
                                                                              .data![index]
                                                                          [
                                                                          'building_type']),
                                                                      // SizedBox(width: 1),
                                                                    ],
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        width:
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
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
                                                                                FontWeight.bold),
                                                                      ),
                                                                      // SizedBox(width: 9),
                                                                      Text(snapshot
                                                                              .data![index]
                                                                          [
                                                                          'steel_name']),
                                                                      // SizedBox(width: 1),
                                                                    ],
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        width:
                                                                            1)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
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
                                                                                FontWeight.bold),
                                                                      ),
                                                                      // SizedBox(width: 9),
                                                                      Text(snapshot
                                                                              .data![index]
                                                                          [
                                                                          'cement_name']),
                                                                      // SizedBox(width: 1),
                                                                    ],
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0.0,
                                                    right: 0.0,
                                                    child: FloatingActionButton(
                                                      child: Icon(
                                                        Icons.close,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          80)),
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 160, 13, 13),
                                                      mini: true,
                                                      elevation: 5.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    })
                              ],
                            ),
                            Image(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                image: AssetImage("assets/images/avatar.png")),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.016,
                            ),
                            Text(
                              snapshot.data![index]['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.016,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Follow_Up_update(
                                                          lead_id: snapshot
                                                                  .data![index]
                                                              ['lead_id'])))
                                          .then((value) {
                                        setState(() {});
                                      });
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

                                  // SizedBox(
                                  //   width: 15,
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(height: 3),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          },
        ),
      ),
    );
  }
}

// Container(
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.7,
//                                                   height: 500,
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Center(
//                                                         child: Image(
//                                                             height: 75,
//                                                             image: AssetImage(
//                                                                 "assets/images/avatar.png")),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 12,
//                                                       ),
//                                                       Center(
//                                                         child: Text(
//                                                           snapshot.data![index]
//                                                               ['name'],
//                                                           style: TextStyle(
//                                                             fontSize: 22,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: 4),
//                                                       Center(
//                                                         child: Text(
//                                                           snapshot.data![index]
//                                                               ['client_type'],
//                                                           style: TextStyle(
//                                                             fontSize: 18,
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       SizedBox(
//                                                         height: 20,
//                                                       ),
//                                                       Container(
//                                                           width: double
//                                                               .infinity,
//                                                           height: 50,
//                                                           decoration: BoxDecoration(
//                                                               color:
//                                                                   Color
//                                                                       .fromARGB(
//                                                                           255,
//                                                                           255,
//                                                                           255,
//                                                                           255),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               border:
//                                                                   Border.all(
//                                                                       width:
//                                                                           1)),
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(8.0),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 // SizedBox(width: 1),
//                                                                 Text(
//                                                                   "Mobile",
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                                 // SizedBox(width: 9),
//                                                                 Text(snapshot
//                                                                             .data![
//                                                                         index]
//                                                                     ['mobile']),
//                                                                 // SizedBox(width: 1),
//                                                               ],
//                                                             ),
//                                                           )),
//                                                       SizedBox(
//                                                         height: 10,
//                                                       ),
//                                                       Container(
//                                                           width: double
//                                                               .infinity,
//                                                           height: 50,
//                                                           decoration: BoxDecoration(
//                                                               color:
//                                                                   Color
//                                                                       .fromARGB(
//                                                                           255,
//                                                                           255,
//                                                                           255,
//                                                                           255),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               border:
//                                                                   Border.all(
//                                                                       width:
//                                                                           1)),
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(8.0),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 // SizedBox(width: 1),
//                                                                 Text(
//                                                                   "Follow-Date",
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                                 // SizedBox(width: 9),
//                                                                 Text(snapshot
//                                                                             .data![
//                                                                         index][
//                                                                     'follow_date']),
//                                                                 // SizedBox(width: 1),
//                                                               ],
//                                                             ),
//                                                           )),
//                                                       SizedBox(
//                                                         height: 10,
//                                                       ),
//                                                       Container(
//                                                           width: double
//                                                               .infinity,
//                                                           height: 50,
//                                                           decoration: BoxDecoration(
//                                                               color:
//                                                                   Color
//                                                                       .fromARGB(
//                                                                           255,
//                                                                           255,
//                                                                           255,
//                                                                           255),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               border:
//                                                                   Border.all(
//                                                                       width:
//                                                                           1)),
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(8.0),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 // SizedBox(width: 1),
//                                                                 Text(
//                                                                   "Building",
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                                 // SizedBox(width: 9),
//                                                                 Text(snapshot
//                                                                             .data![
//                                                                         index][
//                                                                     'building_type']),
//                                                                 // SizedBox(width: 1),
//                                                               ],
//                                                             ),
//                                                           )),
//                                                       SizedBox(
//                                                         height: 10,
//                                                       ),
//                                                       Container(
//                                                           width: double
//                                                               .infinity,
//                                                           height: 50,
//                                                           decoration: BoxDecoration(
//                                                               color:
//                                                                   Color
//                                                                       .fromARGB(
//                                                                           255,
//                                                                           255,
//                                                                           255,
//                                                                           255),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               border:
//                                                                   Border.all(
//                                                                       width:
//                                                                           1)),
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(8.0),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 // SizedBox(width: 1),
//                                                                 Text(
//                                                                   "Steel",
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                                 // SizedBox(width: 9),
//                                                                 Text(snapshot
//                                                                             .data![
//                                                                         index][
//                                                                     'steel_name']),
//                                                                 // SizedBox(width: 1),
//                                                               ],
//                                                             ),
//                                                           )),
//                                                       SizedBox(
//                                                         height: 10,
//                                                       ),
//                                                       Container(
//                                                           width: double
//                                                               .infinity,
//                                                           height: 50,
//                                                           decoration: BoxDecoration(
//                                                               color:
//                                                                   Color
//                                                                       .fromARGB(
//                                                                           255,
//                                                                           255,
//                                                                           255,
//                                                                           255),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10),
//                                                               border:
//                                                                   Border.all(
//                                                                       width:
//                                                                           1)),
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(8.0),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceBetween,
//                                                               children: [
//                                                                 // SizedBox(width: 1),
//                                                                 Text(
//                                                                   "Cement",
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold),
//                                                                 ),
//                                                                 // SizedBox(width: 9),
//                                                                 Text(snapshot
//                                                                             .data![
//                                                                         index][
//                                                                     'cement_name']),
//                                                                 // SizedBox(width: 1),
//                                                               ],
//                                                             ),
//                                                           )),
//                                                     ],
//                                                   ),
//                                                 ),

// GestureDetector(
//                                     onTap: () async {
//                                       await getmobilenumber();
//                                       final Uri url = Uri(
//                                         scheme: 'tel',
//                                         path: phone_number,
//                                       );
//                                       if (await canLaunchUrl(url)) {
//                                         await launchUrl(url);
//                                       } else {
//                                         print("can't launch this url");
//                                       }
//                                     },
//                                     child: Container(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.09,
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.05,
//                                       decoration: BoxDecoration(
//                                         color:
//                                             Color.fromARGB(255, 255, 255, 255),
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Color.fromARGB(
//                                                     199, 158, 158, 158)
//                                                 .withOpacity(0.3),
//                                             spreadRadius: 2,
//                                             blurRadius: 5,
//                                             offset: Offset(0,
//                                                 3), // changes position of shadow
//                                           ),
//                                         ],
//                                       ),
//                                       child: Icon(Icons.phone),
//                                     ),
//                                   ),
