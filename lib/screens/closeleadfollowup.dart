import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'nav_screen.dart';

class closeleadfollowup extends StatefulWidget {
  // const closeleadfollowup({super.key});
  final String lead_id;
  // Follow_Up_update({super.key, required lead_id});

  closeleadfollowup({Key? key, required this.lead_id}) : super(key: key);

  @override
  State<closeleadfollowup> createState() => _closeleadfollowupState();
}

class _closeleadfollowupState extends State<closeleadfollowup> {
  String? loginenc_id;
  String? client_id;
  bool _isloading1 = false;
  TextEditingController _closereason = TextEditingController();
  final _formKey1 = GlobalKey<FormState>();

  //text editing controller for text field
  Future<String?> getencid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginenc_id = prefs.getString("login_enc_id");
    // client_id = prefs.getString("client_id");
    return loginenc_id;
  }

  @override
  // void initState() {
  //   dateinput.text = ""; //set the initial value of text field
  //   super.initState();
  //   // getencid();
  //   getfollowstatus();
  // }

  Future<void> _closelead() async {
    print("********************close lead *******************");
    setState(() {
      _isloading1 = true;
    });

    loginenc_id = await getencid();
    client_id = widget.lead_id.toString();
    print(loginenc_id);
    print(client_id);

    final response = await http
        .post(Uri.parse('https://asm.sortbe.com/api/Close-Lead'), body: {
      'enc_string': 'HSjLAS82146',
      'enc_id': loginenc_id.toString(),
      'client_id': client_id.toString(),
      'reason': _closereason.text.toString(),
    });
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      // Login successful.
      // You can save the user's session token or navigate to the next screen here.
      print("Close lead sucessfully");
      if (data['status'] == 'Success') {
        print(data);

        // Navigator.pushReplacement(
        //     this.context,
        //     MaterialPageRoute(
        //         builder: (context) => const Nav_Screen(
        //               initialIndex: 2,
        //             )));
        setState(() {
          _isloading1 = false;
        });
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Nav_Screen(
                      initialIndex: 2,
                    )));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => Follow_Up_Page()),
        // ).then((value) => setState(() {}));
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: Stack(children: [
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  // color: Colors.amber,
                  width: MediaQuery.of(context).size.width,
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(199, 158, 158, 158).withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment:
                      //     CrossAxisAlignment
                      //         .start,
                      // crossAxisAlignment:
                      //     CrossAxisAlignment
                      //         .stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Do you want to close the Lead ? ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 25),
                        Form(
                          key: _formKey1,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _closereason,
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
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            if (_formKey1.currentState!.validate()) {
                              // _submit()
                              _closelead();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color.fromARGB(255, 175, 91, 76),
                            ),
                            height: 46,
                            width: 85,
                            child: _isloading1
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Center(
                                    child: const Text(
                                    'Close Lead',
                                    style: TextStyle(color: Colors.white),
                                  )),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
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
                    borderRadius: BorderRadius.circular(80)),
                backgroundColor: Color.fromARGB(255, 160, 13, 13),
                mini: true,
                elevation: 5.0,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
