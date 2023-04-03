import 'dart:io';

import 'package:asm_sales_tracker/screens/follow_up_page.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Follow_Up_Form extends StatefulWidget {
  const Follow_Up_Form({super.key});

  @override
  State<Follow_Up_Form> createState() => _Follow_Up_FormState();
}

class _Follow_Up_FormState extends State<Follow_Up_Form> {
  bool _isloading = false;
  final _formKey = GlobalKey<FormState>();
  final _date = TextEditingController();
  final _reason = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
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
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 50,
                ),
                const SizedBox(height: 25.0),
                //name
                TextFormField(
                  controller: _date,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),

                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 10,
                ),
                //brand
                TextFormField(
                  controller: _reason,
                  // obscureText: true,
                  maxLines: 4,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // submit form dat
                        // _submit('1', '1');
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Follow_Up_Form()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.green,
                        ),
                        height: 46,
                        width: 80,
                        child: _isloading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2.5,
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
    );
  }
}
