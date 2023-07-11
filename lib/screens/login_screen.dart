// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:asm_sales_tracker/constant.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login_Screen extends StatefulWidget {
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _isloading = false;

  Future<void> _login(String mobile, String password) async {
    setState(() {
      _isloading = true;
    });
    final response = await http
        .post(Uri.parse('https://api.asmtrichy.com/api/Login'), body: {
      'mobile': mobile,
      'password': password,
      'enc_string': 'HSjLAS82146',
    });
    var data = jsonDecode(response.body.toString());
    setState(() {
      _isloading = false;
    });
    if (response.statusCode == 200) {
      // Login successful.
      // You can save the user's session token or navigate to the next screen here.
      if (data['status'] == 'Success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('login_enc_id', data['enc_id']);
        prefs.setString(
            'login_mobile_number', _mobileController.text.toString());
        prefs.setBool('login_islogin', true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Nav_Screen()));
      } else if (data['status'] == 'User') {
        setState(() {
          _isloading = false;
        });
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
              child: Center(child: Text("User Not Found")),
            )));
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
            child: Text("Login Failed"),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusScopeNode.hasFocus) {
          _focusScopeNode.unfocus();
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Login'),
        // ),
        body: FocusScope(
          node: _focusScopeNode,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Container(
                      height: 250,
                      width: 250,
                      child: Image.asset("assets/images/asmbgremove.png"),
                    ),
                    const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(171, 0, 0, 0)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Mobile',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Mobile Number';
                        }
                        if (value.length != 10) {
                          return 'Please enter the correct Mobile Number';
                        }
                        // You can add more email validation rules here.
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        // You can add more password validation rules here.
                        return null;
                      },
                    ),
                    SizedBox(height: 32.0),
                    SizedBox(
                      height: 50,
                      width: 140,
                      child: ElevatedButton(
                        child: _isloading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                            : Text('Login'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Perform login here.
                            // You can use _emailController.text and _passwordController.text to get the user's input.
                            // If the login is successful, you can navigate to the next screen.

                            _login(_mobileController.text.toString(),
                                _passwordController.text.toString());
                          }
                        },
                      ),
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
