import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:asm_sales_tracker/screens/closeleadtoday.dart';
import 'package:asm_sales_tracker/screens/today_lead.dart';
import 'package:dio/dio.dart';

import 'package:asm_sales_tracker/screens/follow_up_page.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'closeleadfollowup.dart';

class Follow_Up_update_todays extends StatefulWidget {
  final String lead_id;
  // Follow_Up_update({super.key, required lead_id});

  Follow_Up_update_todays({Key? key, required this.lead_id}) : super(key: key);

  @override
  State<Follow_Up_update_todays> createState() =>
      _Follow_Up_update_todaysState();
}

class _Follow_Up_update_todaysState extends State<Follow_Up_update_todays> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool _isloading = false;
  TextEditingController dateinput = TextEditingController();
  TextEditingController _closereason = TextEditingController();
  String? loginenc_id;
  String? client_id;

  //text editing controller for text field
  Future<String?> getencid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginenc_id = prefs.getString("login_enc_id");
    // client_id = prefs.getString("client_id");
    return loginenc_id;
  }

  @override
  void initState() {
    dateinput.text = ""; //set the initial value of text field
    super.initState();
    // getencid();
    getfollowstatus();
  }

  Future<void> _submit() async {
    setState(() {
      _isloading = true;
    });
    print(dateinput.text.toString());
    loginenc_id = await getencid();
    client_id = widget.lead_id.toString();
    print(loginenc_id);
    print(client_id);

    final response = await http
        .post(Uri.parse('https://asm.sortbe.com/api/Follow-Update'), body: {
      'enc_string': 'HSjLAS82146',
      'enc_id': loginenc_id.toString(),
      'client_id': client_id.toString(),
      'follow_up_date': dateinput.text.toString(),
      'follow_up_status_id': follow_statusindex.toString(),
      'reason': _reason.text.toString(),
    });
    var data = jsonDecode(response.body.toString());

    setState(() {
      _isloading = false;
    });
    if (response.statusCode == 200) {
      // Login successful.
      // You can save the user's session token or navigate to the next screen here.
      if (data['status'] == 'Success') {
        print(data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("Follow_up_date", dateinput.toString());
        // Navigator.pushReplacement(
        //     this.context,
        //     MaterialPageRoute(
        //         builder: (context) => const Nav_Screen(
        //               initialIndex: 2,
        //             )));
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => Nav_Screen(
        //               initialIndex: 0,
        //             )));

        Navigator.pop(context);
      } else {}
    } else {
      // Login failed.
      // You can display an error message here.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: EdgeInsets.all(16),
            height: 50,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 0, 0),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(child: Text("Something Went Wrong")),
          )));
    }
  }

  String? selectfollowstatus;
  String? follow_statusindex;
  List<dynamic> follow_status = [];

  Future<List?> getfollowstatus() async {
    print('****************************');
    final response = await http
        .post(Uri.parse("https://asm.sortbe.com/api/Follow-Status"), body: {
      'enc_string': 'HSjLAS82146',
    });

    if (response.statusCode == 200) {
      print("done follow status");
      final data = jsonDecode(response.body.toString());
      follow_status.addAll(data['status_name']);
      return follow_status;
    } else {
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  final _reason = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_focusScopeNode.hasFocus) {
          _focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
        body: FocusScope(
          node: _focusScopeNode,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Text("Follow-Up Details",
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(height: 25.0),
                    //name
                    TextFormField(
                      controller:
                          dateinput, //editing controller of this TextField
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        suffixIcon:
                            Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date", //label text of field
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      validator: (value) {
                        //
                        if (value == null || value.isEmpty) {
                          return "Please select Date";
                        }
                        return null;
                      }, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              intl.DateFormat('dd-MM-yyyy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateinput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          print("Date is not selected");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          // filled: true,
                          // labelText: 'Option',
                          hintText: 'Select the Follow Status',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select the Follow Status';
                          }
                          return null;
                        },
                        readOnly: true,
                        controller:
                            TextEditingController(text: selectfollowstatus),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      'Select the Follow Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  content: Container(
                                    width: double.maxFinite,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: follow_status.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectfollowstatus =
                                                  follow_status[index]
                                                      ['follow_status'];
                                              follow_statusindex =
                                                  follow_status[index]['id'];
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(follow_status[index]
                                                ['follow_status']),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    //brand
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _reason,
                      // obscureText: true,
                      maxLines: 4,
                      validator: (value) {
                        //
                        if (value == null || value.isEmpty) {
                          return "Enter the Reason";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Reason',
                        border: OutlineInputBorder(),
                      ),

                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //pricForm
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            client_id = widget.lead_id.toString();
                            print(client_id);
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => closeleadtoday(
                                            lead_id: client_id.toString())))
                                .then((value) {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color.fromARGB(255, 175, 91, 76),
                            ),
                            height: 46,
                            width: 90,
                            child: Center(
                                child: const Text(
                              'Close Lead',
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _submit();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.green,
                            ),
                            height: 46,
                            width: 80,
                            child: _isloading
                                ? Center(
                                    child: Container(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
