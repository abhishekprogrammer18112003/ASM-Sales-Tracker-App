import 'dart:convert';
import 'dart:io';

import 'package:asm_sales_tracker/screens/follow_up_form.dart';
import 'package:asm_sales_tracker/screens/follow_up_page.dart';
import 'package:asm_sales_tracker/screens/nav_screen.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lead_Creation_page extends StatefulWidget {
  @override
  _Lead_Creation_pageState createState() => _Lead_Creation_pageState();
}

// ignore: camel_case_types
class _Lead_Creation_pageState extends State<Lead_Creation_page> {
  bool imageselected = false;
  // late String Login_enc_id;

  // void setenc_id() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Login_enc_id = prefs.getString("login_enc_id")!;
  // }

  // void initState() async {
  //   super.initState();
  //   setenc_id();
  //   // fetchDatacement();
  //   // fetchDatasteel();
  // }

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
  List<String> _cementoptions = ['Cement 1', 'cement 2'];

  // void fetchDatacement() async {
  //   final url = Uri.parse('https://asm.sortbe.com/api/Cement-List');
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     setState(() {
  //       _cementoptions = List<String>.from(jsonData['cement_name']);
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  @override
  String? _selectsteel;
  List<String> _steeloptions = ['steel 1', 'steel 2'];
  // void fetchDatasteel() async {
  //   final url = Uri.parse('https://asm.sortbe.com/api/Steel-List');
  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
  //     setState(() {
  //       _steeloptions = List<String>.from(jsonData['steel_name']);
  //     });
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }
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
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          imageselected = true;
        });
        print(_image!.path);
      }
    } on Exception catch (e) {
      print("failed to pick image : $e");
    }
  }

  Future getImageFromgallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          imageselected = true;
        });
        print(_image!.path);
      }
    } on Exception catch (e) {
      print("failed to pick image : $e");
    }
  }

  bool _isloading = false;

  // Future<void> _submit(String cement_id, String steel_id) async {
  //   setState(() {
  //     _isloading = true;
  //   });
  //   final response = await http
  //       .post(Uri.parse('https://asm.sortbe.com/api/Create-Lead'), body: {
  //     'enc_string': 'HSjLAS82146',
  //     'name': _name.text.toString(),
  //     'mobile': _mobile.text.toString(),
  //     'email': _email.text.toString(),
  //     'address': _address.text.toString(),
  //     'gst': _gst.text.toString(),
  //     'client_type': _selecttype,
  //     'enc_id': Login_enc_id,
  //     'project_name': _projname.text.toString(),
  //     'location': _location.text.toString(),
  //     'sqft': _abuildingsqft.text.toString(),
  //     'building_type': _typeofbuilding.text.toString(),
  //     'cement_id': cement_id,
  //     'steel_id': steel_id,
  //     'brick': _brick.text.toString(),
  //     'sand': _sand.text.toString(),
  //     'other_items': _otheritems.text.toString(),
  //     'perv_seller_name': _sellername.text.toString(),
  //     'brand': _brand.text.toString(),
  //     'pricing': _pricing.text.toString(),
  //     'prev_seller_address': _selleraddress.text.toString(),
  //     'prev_seller_contact_no': _sellermobile.text.toString(),
  //   });
  //   var data = jsonDecode(response.body.toString());
  //   setState(() {
  //     _isloading = false;
  //   });
  //   if (response.statusCode == 200) {
  //     // Login successful.
  //     // You can save the user's session token or navigate to the next screen here.
  //     if (data['status'] == 'Success') {
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => Nav_Screen()));
  //     } else {}
  //   } else {
  //     // Login failed.
  //     // You can display an error message here.
  //   }
  // }

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text("Lead Details",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 50,
                ),
                //person name
                TextFormField(
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Lead Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    //
                    if (value == null || value.isEmpty) {
                      return "Enter lead name";
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
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Mobile',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
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
                // Container(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: <Widget>[
                //       // Text(
                //       //   '  Cement',
                //       //   style: TextStyle(fontSize: 13.0),
                //       // ),
                //       // const SizedBox(height: 8.0),
                //       DropdownButtonFormField(
                //         decoration: const InputDecoration(
                //           labelText: "Business Type",
                //           border: OutlineInputBorder(),
                //         ),
                //         validator: (value) {
                //           if (value!.isEmpty) {
                //             return 'Please select the type';
                //           }
                //           return null;
                //         },
                //         value: _selecttype,
                //         items: _typeoptions.map((String option) {
                //           return DropdownMenuItem(
                //             value: option,
                //             child: Text(option),
                //           );
                //         }).toList(),
                //         onChanged: (newValue) {
                //           setState(() {
                //             _selecttype = newValue!;
                //           });
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: _selecttype,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selecttype = newValue!;
                    });
                  },
                  items: _typeoptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    // filled: true,
                    // labelText: 'Option',
                    hintText: 'Business Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select the Business type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                          height: 46,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.blue,
                          ),
                          child: const Center(
                            child: Text("Next",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                          )),
                      onTap: () {
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
      ),
    );
  }

  Widget _buildPage2() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: _formKey2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text("Project Details",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                  controller: _location,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Location of the Project',
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
                //proj name
                TextFormField(
                  controller: _projname,
                  decoration: const InputDecoration(
                    labelText: 'Project Name (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 10,
                ),

                //location

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
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                // Container(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: <Widget>[
                //       // Text(
                //       //   '  Cement',
                //       //   style: TextStyle(fontSize: 13.0),
                //       // ),

                //       DropdownButtonFormField(
                //         decoration: const InputDecoration(
                //           labelText: "Select the Cement",
                //           border: OutlineInputBorder(),
                //         ),
                //         validator: (value) {
                //           if (value!.isEmpty) {
                //             return 'Please select the Cement';
                //           }
                //           return null;
                //         },
                //         value: _selectcement,
                //         items: _cementoptions.map((String option) {
                //           return DropdownMenuItem(
                //             value: option,
                //             child: Text(option),
                //           );
                //         }).toList(),
                //         onChanged: (newValue) {
                //           setState(() {
                //             _selectcement = newValue!;
                //           });
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: _selectcement,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectcement = newValue!;
                    });
                  },
                  items: _cementoptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    // filled: true,
                    // labelText: 'Option',
                    hintText: 'Select the Cement',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please Select the Cement';
                    }
                    return null;
                  },
                ),
                //steel brand
                const SizedBox(
                  height: 10,
                ),

                // Container(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: <Widget>[
                //       // Text(
                //       //   '  Steel',
                //       //   style: TextStyle(fontSize: 13.0),
                //       // ),

                //       DropdownButtonFormField(
                //         validator: (value) {
                //           if (value!.isEmpty) {
                //             return 'Please select the Steel';
                //           }
                //           return null;
                //         },
                //         decoration: const InputDecoration(
                //           labelText: "Select the Steel",
                //           border: OutlineInputBorder(),
                //         ),
                //         value: _selectsteel,
                //         items: _steeloptions.map((String option) {
                //           return DropdownMenuItem(
                //             value: option,
                //             child: Text(option),
                //           );
                //         }).toList(),
                //         onChanged: (newValue) {
                //           setState(() {
                //             _selectsteel = newValue;
                //           });
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: _selectsteel,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectsteel = newValue!;
                    });
                  },
                  items: _steeloptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    // filled: true,
                    // labelText: 'Option',
                    hintText: 'Select the Steel',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please Select the Steel';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 10,
                ),
                //brick
                TextFormField(
                  controller: _brick,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Brick requirements (optional) ',
                    // floatingLabelBehavior: FloatingLabelBehavior.always,
                    // hintText: 'Enter text here',
                    // contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 24)
                    // contentPadding: EdgeInsets.only(top: 2, left: 10, right: 5),
                    // labelStyle: TextStyle(),
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
                    labelText: 'Other Items (optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _currentPageIndex--;
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                          height: 46,
                          width: 95,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1.5),
                            // color: Colors.blue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("Previous",
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 17)),
                            ),
                          )),
                    ),
                    GestureDetector(
                      child: Container(
                          height: 46,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.blue,
                          ),
                          child: const Center(
                            child: Text("Next",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                          )),
                      onTap: () {
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
              height: 40,
            ),
            const Text("Site Photo (optional)",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 50,
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
                            width: 110,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(211, 197, 170, 204),
                                borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.camera),
                                Text(
                                  "Camera",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: getImageFromgallery,
                        child: Container(
                            height: 40,
                            width: 110,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(211, 197, 170, 204),
                                borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.photo),
                                Text(
                                  "Gallery",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                      height: 46,
                      width: 95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.blue, width: 1.5),
                        // color: Colors.blue,
                      ),
                      child: const Center(
                        child: Text("Previous",
                            style: TextStyle(color: Colors.blue, fontSize: 17)),
                      )),
                  onTap: () {
                    _currentPageIndex++;
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                      height: 46,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.blue,
                      ),
                      child: Center(
                          child: imageselected
                              ? const Text("Next",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17))
                              : const Text("Skip",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17)))),
                  onTap: () {
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
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
                    labelText: 'Seller\'s Name (optional)',
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
                    labelText: 'Seller\'s Address (optional)',
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
                    labelText: 'Seller\'s Contact Number (optional)',
                    border: OutlineInputBorder(),
                  ),

                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                          height: 46,
                          width: 95,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.blue, width: 1.5),
                            // color: Colors.blue,
                          ),
                          child: const Center(
                            child: Text("Previous",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 17)),
                          )),
                      onTap: () {
                        _currentPageIndex++;
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
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
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Center(
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
