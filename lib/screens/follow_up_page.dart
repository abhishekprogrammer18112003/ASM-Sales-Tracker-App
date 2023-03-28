import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Follow_Up_Page extends StatefulWidget {
  const Follow_Up_Page({super.key});

  @override
  State<Follow_Up_Page> createState() => _Follow_Up_PageState();
}

class _Follow_Up_PageState extends State<Follow_Up_Page> {
  File? _imageFile;
  // final picker = ImagePicker();

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    print(_imageFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Selector'),
      ),
      body: Center(
        child: _imageFile == null
            ? Text('No image selected.')
            : Image.file(_imageFile!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("clicked");
          _pickImages();
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
