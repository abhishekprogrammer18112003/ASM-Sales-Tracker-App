import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import 'follow_up_update.dart';

class Follow_Up_Page extends StatefulWidget {
  const Follow_Up_Page({super.key});

  @override
  State<Follow_Up_Page> createState() => _Follow_Up_PageState();
}

class _Follow_Up_PageState extends State<Follow_Up_Page> {
  TextEditingController searchcontroller = TextEditingController();

  String? loginenc_id;
  String? phone_number;
  String? follow_count;

  Future<String> getdetails() async {
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
    // filteredItems.clear();
    print('****');

    loginenc_id = await getdetails() as String?;
    print(loginenc_id.toString());
    FormData formData = FormData.fromMap({
      'enc_string': 'HSjLAS82146',
      'enc_id': loginenc_id.toString(),
    });

    String url = apiurl + "Follow-Leads";
    var response = await Dio().post(url, data: formData);
    var jsonData = response.data;
    // print(jsonData);
    // follow_count = await getfollowcount();
    // follow_count = await jsonData['follow_count'];
    // print(follow_count);

    // _todaysleadlist.clear();
    if (response.statusCode == 200) {
      // print("done lead list");
      // print(loginenc_id.toString());
      follow_count = jsonData['follow_count'].toString();
      _todaysleadlist = [];

      follow_count != '0'
          ? _todaysleadlist.addAll(jsonData['follow_list'])
          : null;
      // print(_todaysleadlist);
      // filteredItems = _todaysleadlist;
      // filteredItems.addAll(_todaysleadlist);
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
    // filteredItems.addAll(_todaysleadlist);
  }

  List<dynamic> filteredItems = [];
  void filterItems(String query) {
    filteredItems = !query[0].contains(new RegExp(r'[0-9]'))
        ? _todaysleadlist
            .where((item) => (item['name'] as String)
                .trim()
                .toLowerCase()
                .contains(query.trim().toLowerCase()))
            .toList()
        : _todaysleadlist
            .where((item) => (item['mobile'] as String)
                .trim()
                .toLowerCase()
                .contains(query.trim().toLowerCase()))
            .toList();
    // List<dynamic> searchList = [];
    // searchList.addAll(_todaysleadlist);
    // if (query.isNotEmpty) {
    //   List<String> tempList = [];
    //   searchList.forEach((item) {
    //     if (item.toLowerCase().contains(query.toLowerCase())) {
    //       tempList.add(item);
    //     }
    //   });
    //   setState(() {
    //     filteredItems.clear();
    //     filteredItems.addAll(tempList);
    //   });
    //   return;
    // } else {
    //   setState(() {
    //     filteredItems.clear();
    //     filteredItems.addAll(_todaysleadlist);
    //   });
    // }
  }

  void filterItemsmobile(String query) {
    filteredItems = _todaysleadlist
        .where((item) => (item['mobile'] as String)
            .trim()
            .toLowerCase()
            .contains(query.trim().toLowerCase()))
        .toList();
    // List<dynamic> searchList = [];
    // searchList.addAll(_todaysleadlist);
    // if (query.isNotEmpty) {
    //   List<String> tempList = [];
    //   searchList.forEach((item) {
    //     if (item.toLowerCase().contains(query.toLowerCase())) {
    //       tempList.add(item);
    //     }
    //   });
    //   setState(() {
    //     filteredItems.clear();
    //     filteredItems.addAll(tempList);
    //   });
    //   return;
    // } else {
    //   setState(() {
    //     filteredItems.clear();
    //     filteredItems.addAll(_todaysleadlist);
    //   });
    // }
  }

  // List<String> searchtext = ["Search with name", "Search with mobile number"];
  // List<Icon> icons = [
  //   Icon(Icons.send_to_mobile_outlined),
  //   Icon(Icons.text_fields)
  // ];
  // int index = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        searchcontroller.clear();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: Scaffold(
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
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (value) {
                          // filterItems(value);
                          setState(() {
                            _todaysleadlist.clear();
                          });
                        },
                        controller: searchcontroller,
                        // autofocus: ,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            // icon: new Icon(Icons.search),
                            hintText: "Search by name or mobile...",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  )
                ],
              ),

              // SizedBox(
              //   height: 2,
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       // filterItems(value);
              //       setState(() {
              //         _todaysleadlist.clear();
              //       });
              //     },
              //     controller: searchcontroller,
              //     keyboardType: TextInputType.name,
              //     decoration: InputDecoration(
              //         hintText: 'Search with mobile ',
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(20))),
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FutureBuilder(
                    future: getleadlist(),
                    builder: (context, snapshot) {
                      // filteredItems = snapshot.data!;
                      if (follow_count.toString() != '0' &&
                          snapshot.connectionState == ConnectionState.waiting) {
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
                      if (searchcontroller.text.isNotEmpty) {
                        // index == 0
                        filterItems(searchcontroller.text);
                        // : filterItemsmobile(searchcontroller.text);
                      }
                      return Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // mainAxisSpacing: 20,
                              // childAspectRatio: 1,
                              mainAxisExtent:
                                  MediaQuery.of(context).size.height * 0.34,
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
                            itemCount: searchcontroller.text.isEmpty
                                ? _todaysleadlist.length
                                : filteredItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (searchcontroller.text.isEmpty) {
                                return data(_todaysleadlist, index);
                              } else {
                                return data(filteredItems, index);
                              }
                            }),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget data(List followUpList, int index) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(199, 158, 158, 158).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      // color: Colors.amber,
                                      width: MediaQuery.of(context).size.width,
                                      // height: 500,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(16.0),
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment
                                          //         .start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
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
                                                followUpList[index]['name'],
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Center(
                                              child: Text(
                                                followUpList[index]
                                                    ['client_type'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
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
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border:
                                                        Border.all(width: 1)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                      Text(followUpList[index]
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
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border:
                                                        Border.all(width: 1)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                      Text(followUpList[index]
                                                          ['follow_date']),
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
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border:
                                                        Border.all(width: 1)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // SizedBox(width: 9),
                                                      Text(followUpList[index]
                                                          ['building_type']),
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
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border:
                                                        Border.all(width: 1)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                      Text(followUpList[index]
                                                          ['steel_name']),
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
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border:
                                                        Border.all(width: 1)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                      Text(followUpList[index]
                                                          ['cement_name']),
                                                      // SizedBox(width: 1),
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: double.infinity,
                                                // height: 50,
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border:
                                                        Border.all(width: 1)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 14.0,
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // SizedBox(width: 1),
                                                      Text(
                                                        "Reason",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // SizedBox(width: 9),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                        child: Text(
                                                          followUpList[index]
                                                              ['reason'],
                                                          // "I am postponing this because i have to go somewhere and will not be able to do.",
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                      // SizedBox(width: 1),
                                                    ],
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            )
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80)),
                                      backgroundColor:
                                          Color.fromARGB(255, 160, 13, 13),
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
                height: MediaQuery.of(context).size.height * 0.1,
                image: AssetImage("assets/images/avatar.png")),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.016,
            ),
            Text(
              followUpList[index]['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.016,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Follow_Up_update(
                                      lead_id: followUpList[index]['lead_id'])))
                          .then((value) {
                        print(value);
                        setState(() {
                          _todaysleadlist.clear();
                        });

                        //   //   Navigator.pushReplacement(
                        //   //       context,
                        //   //       MaterialPageRoute(
                        //   //           builder: (context) =>
                        //   //               Nav_Screen(
                        //   //                 initialIndex: 2,
                        //   //               )));
                      });
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.05,
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
                        child: Center(
                          child: Text("Update",
                              style: TextStyle(fontWeight: FontWeight.w400)),
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await getmobilenumber();
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: followUpList[index]['mobile'],
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        print("can't launch this url");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.09,
                      height: MediaQuery.of(context).size.height * 0.05,
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
  }
}
