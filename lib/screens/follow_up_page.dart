import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Follow_Up_Page extends StatefulWidget {
  const Follow_Up_Page({super.key});

  @override
  State<Follow_Up_Page> createState() => _Follow_Up_PageState();
}

class _Follow_Up_PageState extends State<Follow_Up_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Welcome to Follow-Up Page")),
    );
  }
}
