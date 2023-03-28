import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

class Lead_Creation_page extends StatefulWidget {
  @override
  _Lead_Creation_pageState createState() => _Lead_Creation_pageState();
}

// ignore: camel_case_types
class _Lead_Creation_pageState extends State<Lead_Creation_page> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  //person details
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _gst = TextEditingController();
  String? _selecttype;

  final List<String> _typeoptions = [
    'Builder',
    'Contractor',
    'Manson',
    'Architecture',
    'House Owner',
    'Engineer',
    'Sub Dealer',
  ];

  //project details
  final _projname = TextEditingController();
  final _location = TextEditingController();
  final _abuildingsqft = TextEditingController();
  final _typeofbuilding = TextEditingController();
  final _brick = TextEditingController();
  final _sand = TextEditingController();
  final _otheritems = TextEditingController();

  String? _selectcement;

  final List<String> _cementoptions = [
    'cement 1',
    'cement2',
    'cement 3',
  ];
  String? _selectsteel;

  final List<String> _steeloptions = [
    'steel 1',
    'steel 2',
    'steel 3',
  ];
  // final _ = TextEditingController();

  //seller details
  final _sellername = TextEditingController();
  final _brand = TextEditingController();
  final _pricing = TextEditingController();
  final _selleraddress = TextEditingController();
  final _sellermobile = TextEditingController();

  int _currentPageIndex = 0;
  final _pageController = PageController();

  @override
  bool get wantKeepAlive => true;
  File? _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
    });

    print(_image!.path);
  }

  Future getImageFromgallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });

    print(_image!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('lead')),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [_buildPage1(), _buildPage2(), _buildPage3(), _buildPage4()],
      ),
    );
  }

  Widget _buildPage1() {
    return Form(
      key: _formKey1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              const Text("Person Details",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 25,
              ),
              //person name
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 10,
              ),
              //person mobile number
              TextFormField(
                controller: _mobile,
                decoration: const InputDecoration(
                  labelText: 'Mobile',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Mobile Number';
                  }
                  if (value.length != 10) {
                    return 'Please enter your correct mobile number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              //email
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Email (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              //address
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(
                  labelText: 'Address (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //gst
              TextFormField(
                controller: _gst,
                decoration: const InputDecoration(
                  labelText: 'GST (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //type
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Text(
                    //   '  Cement',
                    //   style: TextStyle(fontSize: 13.0),
                    // ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Type",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select the type';
                        }
                        return null;
                      },
                      value: _selecttype,
                      items: _typeoptions.map((String option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selecttype = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text('Next'),
                    onPressed: () {
                      if (_formKey1.currentState!.validate()) {
                        _currentPageIndex++;
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage2() {
    return Form(
      key: _formKey2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              const Text("Project Details",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 25,
              ),
              //proj name
              TextFormField(
                controller: _projname,
                decoration: const InputDecoration(
                  labelText: 'Name (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 10,
              ),
              //location
              TextFormField(
                controller: _location,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //building sqft
              TextFormField(
                controller: _abuildingsqft,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Building Sqft (optional)',
                  border: OutlineInputBorder(),
                ),

                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //type of building
              TextFormField(
                controller: _typeofbuilding,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Type of building',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Type of building';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //cement brand
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Text(
                    //   '  Cement',
                    //   style: TextStyle(fontSize: 13.0),
                    // ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Cement",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select the Cement';
                        }
                        return null;
                      },
                      value: _selectcement,
                      items: _cementoptions.map((String option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectcement = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //steel brand
              const SizedBox(
                height: 10,
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Text(
                    //   '  Steel',
                    //   style: TextStyle(fontSize: 13.0),
                    // ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please select the Steel';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Steel",
                        border: OutlineInputBorder(),
                      ),
                      value: _selectsteel,
                      items: _steeloptions.map((String option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectsteel = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //brick
              TextFormField(
                controller: _brick,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Brick requirements (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //sand
              TextFormField(
                controller: _sand,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Sand requirements (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              //others
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _otheritems,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Other Things (optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text('Previous'),
                    onPressed: () {
                      _currentPageIndex--;
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Next'),
                    onPressed: () {
                      if (_formKey2.currentState!.validate()) {
                        _currentPageIndex++;
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 70,
            ),
            const Text("Site Photo (optional)",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 25),
                  _image == null
                      ? const Text('Please Select Image')
                      : Image.file(_image!),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: getImageFromCamera,
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(211, 197, 170, 204),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Text(
                            "Camera",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: getImageFromgallery,
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(211, 197, 170, 204),
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                              child: Text(
                            "Gallery",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: const Text('Previous'),
                  onPressed: () {
                    _currentPageIndex--;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('Next'),
                  onPressed: () {
                    _currentPageIndex++;
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage4() {
    return Form(
      key: _formKey3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              const Text(
                'Previous Seller Details',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25.0),
              //name
              TextFormField(
                controller: _sellername,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Name (optional)',
                  border: OutlineInputBorder(),
                ),

                keyboardType: TextInputType.name,
              ),
              const SizedBox(
                height: 10,
              ),
              //brand
              TextFormField(
                controller: _brand,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Brand (optional)',
                  border: OutlineInputBorder(),
                ),

                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //pricing
              TextFormField(
                controller: _pricing,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Pricing (optional)',
                  border: OutlineInputBorder(),
                ),

                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //address
              TextFormField(
                controller: _selleraddress,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Address (optional)',
                  border: OutlineInputBorder(),
                ),

                keyboardType: TextInputType.text,
              ),
              const SizedBox(
                height: 10,
              ),
              //mobile
              TextFormField(
                controller: _sellermobile,
                // obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mobile (optional)',
                  border: OutlineInputBorder(),
                ),

                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: const Text('Previous'),
                    onPressed: () {
                      _currentPageIndex--;
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Submit'),
                    onPressed: () {
                      if (_formKey3.currentState!.validate()) {
                        // submit form data
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
