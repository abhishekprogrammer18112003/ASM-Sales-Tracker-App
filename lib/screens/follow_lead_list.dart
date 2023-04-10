import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Follow_Lead_List_Page extends StatefulWidget {
  late String enc_id;

  Follow_Lead_List_Page({super.key, required enc_id});

  @override
  State<Follow_Lead_List_Page> createState() => _Follow_Lead_List_PageState();
}

class _Follow_Lead_List_PageState extends State<Follow_Lead_List_Page> {
  String? loginenc_id;
  List<dynamic> _leadlist = [];
  Future<List?> getleadlist() async {
    print('****************************');
    final response = await http
        .post(Uri.parse("https://asm.sortbe.com/api/Follow-Leads"), body: {
      'enc_string': 'HSjLAS82146',
      'enc_id': loginenc_id,
    });

    print("post");

    if (response.statusCode == 200) {
      print("done lead list");
      print(loginenc_id.toString());
      final data = jsonDecode(response.body.toString());
      _leadlist.addAll(data['follow_list']);
      print(_leadlist);
      print(data);
      return _leadlist;
    } else {
      print("something went wrong");
      return null;
    }
  }

  void getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginenc_id = prefs.getString("login_enc_id");
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
        title: Center(child: Text("All Follow- Up Leads")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder(
          future: getleadlist(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 300.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data![index]['name'],
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            snapshot.data![index]['mobile'],
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            snapshot.data![index]['follow_date'],
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
