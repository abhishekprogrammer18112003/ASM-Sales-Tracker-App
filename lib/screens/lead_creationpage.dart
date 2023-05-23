// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:asm_sales_tracker/constant.dart';
import 'package:dio/dio.dart';

import 'package:asm_sales_tracker/screens/follow_up_form.dart';
// ignore: unused_import
import 'package:asm_sales_tracker/screens/follow_up_page.dart';
// ignore: unused_import
import 'package:asm_sales_tracker/screens/nav_screen.dart';

import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lead_Creation_page extends StatefulWidget {
  @override
  _Lead_Creation_pageState createState() => _Lead_Creation_pageState();
}

// ignore: camel_case_types
class _Lead_Creation_pageState extends State<Lead_Creation_page> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  bool imageselected = false;

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
  bool showtextbusinesstype = true;

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
  final _abuildingsqft = TextEditingController();
  final _typeofbuilding = TextEditingController();
  final _brick = TextEditingController();
  final _sand = TextEditingController();
  final _otheritems = TextEditingController();
  String? loginenc_id;
  Future<String> getencid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("login_enc_id")!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getencid();
    getsteeldate();
    getcementdate();
    getprevcementdate();
    getprevsteeldate();
    getlocation();
    getsellersname();
    imageflag = '0';
    imageselected = false;
  }

  String? _selectcement;
  String? _selectprevcement;
  List<dynamic> _cementoptions = [];
  List<dynamic> _prevcementoptions = [];
  String? cementindex;
  String? cementprevindex;

  Future<List?> getcementdate() async {
    print('****************************');
    final response = await http.post(Uri.parse(apiurl + "Cement-List"), body: {
      'enc_string': 'HSjLAS82146',
    });

    if (response.statusCode == 200) {
      print("done Cement");
      final data = jsonDecode(response.body.toString());
      _cementoptions.addAll(data['cement_name']);
      return _cementoptions;
    } else {
      return null;
    }
  }

  Future<List?> getprevcementdate() async {
    print('****************************');
    final response = await http.post(Uri.parse(apiurl + "Cement-List"), body: {
      'enc_string': 'HSjLAS82146',
    });

    if (response.statusCode == 200) {
      print("done Cement");
      final data = jsonDecode(response.body.toString());
      _prevcementoptions.addAll(data['cement_name']);
      return _prevcementoptions;
    } else {
      return null;
    }
  }

  @override
  // ignore: override_on_non_overriding_member
  String? _selectsteel;
  String? _selectprevsteel;
  String? steelindex;
  String? steelprevindex;
  List<dynamic> _steeloptions = [];
  List<dynamic> _prevsteeloptions = [];
  Future<List?> getsteeldate() async {
    print('****************************');
    final response = await http.post(Uri.parse(apiurl + "Steel-List"), body: {
      'enc_string': 'HSjLAS82146',
    });

    if (response.statusCode == 200) {
      print("done steel");
      final data = jsonDecode(response.body.toString());
      _steeloptions.addAll(data['steel_name']);
      return _steeloptions;
    } else {
      return null;
    }
  }

  Future<List?> getprevsteeldate() async {
    print('****************************');
    final response = await http.post(Uri.parse(apiurl + "Steel-List"), body: {
      'enc_string': 'HSjLAS82146',
    });

    if (response.statusCode == 200) {
      print("done prev steel");
      final data = jsonDecode(response.body.toString());
      _prevsteeloptions.addAll(data['steel_name']);
      return _prevsteeloptions;
    } else {
      return null;
    }
  }

  //seller details
  final cement_pricing = TextEditingController();
  final steel_pricing = TextEditingController();
  // final _selleraddress = TextEditingController();
  // final _sellermobile = TextEditingController();

  final _pageController = PageController();

  bool get wantKeepAlive => true;
  File? _image;
  String imageflag = '0';
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          imageselected = true;
          imageflag = '1';
        });
        // print(_image.path);
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
          imageflag = '1';
        });
        // print(_image.path);
      }
    } on Exception catch (e) {
      print("failed to pick image : $e");
    }
  }

  bool _isloading = false;

  void savedata(String client_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("client_id", client_id.toString());
    prefs.setString("person_name", _name.text.toString());
    prefs.setString("person_phone_number", _mobile.text.toString());
  }

  Future<double> getlatitude() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position.latitude;
  }

  Future<double> getlongitude() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position.longitude;
  }

  Future<String> getdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    loginenc_id = prefs.getString("login_enc_id");
    return loginenc_id!;
  }

  String? _selectlocation;
  // String? steelindex;
  String? locationindex;
  List<dynamic> _locationoptions = [];
  Future<List?> getlocation() async {
    print('****************************');
    loginenc_id = await getdetails() as String?;
    final response = await http.post(Uri.parse(apiurl + "Location-List"),
        body: {'enc_string': 'HSjLAS82146', 'enc_id': loginenc_id.toString()});

    if (response.statusCode == 200) {
      print("done location");
      final data = jsonDecode(response.body.toString());
      _locationoptions.addAll(data['status_name']);
      return _locationoptions;
    } else {
      return null;
    }
  }

  String? _selectsellersname;
  // String? steelindex;
  String? sellersindex;
  List<dynamic> _sellersoptions = [];
  Future<List?> getsellersname() async {
    print('****************************');
    loginenc_id = await getdetails() as String?;
    final response = await http.post(Uri.parse(apiurl + "Seller-Info"),
        body: {'enc_string': 'HSjLAS82146', 'enc_id': loginenc_id.toString()});

    if (response.statusCode == 200) {
      print("done sellersname");
      final data = jsonDecode(response.body.toString());
      _sellersoptions.addAll(data['status_name']);
      return _sellersoptions;
    } else {
      return null;
    }
  }

  void next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: Duration(milliseconds: 700),
        content: Container(
          margin: EdgeInsets.symmetric(horizontal: 25),
          // padding: EdgeInsets.all(16),
          height: 40,
          decoration: BoxDecoration(
              color: Color.fromARGB(192, 252, 48, 48),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: Text(
            "Enter all required fields",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
        )));
  }

  String? latitude;
  String? longitude;

  Future<void> _submit(String cement_id, String steel_id, String prev_cement_id,
      String prev_steel_id, String Location_id, String sellers_id) async {
    print("**********************");
    setState(() {
      _isloading = true;
    });

    latitude = (await getlatitude()).toString();
    longitude = (await getlongitude()).toString();
    // ignore: unused_local_variable
    Dio dio = Dio();

    FormData formData = FormData.fromMap({
      'enc_string': 'HSjLAS82146',
      'name': _name.text.toString(),
      'mobile': _mobile.text.toString(),
      'email': _email.text.toString(),
      'address': _address.text.toString(),
      'gst': _gst.text.toString(),
      'client_type': _selecttype,
      'enc_id': loginenc_id,
      'project_name': _projname.text.toString(),
      'location': Location_id,
      'sqft': _abuildingsqft.text.toString(),
      'building_type': _typeofbuilding.text.toString(),
      'cement_id': cement_id,
      'steel_id': steel_id,
      'brick': _brick.text.toString(),
      'sand': _sand.text.toString(),
      'other_items': _otheritems.text.toString(),
      'prev_seller_name': sellers_id,

      // ignore: equal_keys_in_map
      'seller_cement_id': prev_cement_id,
      'cement_price': cement_pricing.text.toString(),
      // ignore: equal_keys_in_map
      'seller_steel_id': prev_steel_id,

      'steel_price': steel_pricing.text.toString(),

      // 'prev_seller_address': '',
      // 'prev_seller_contact_no': '',
      'project_img_flag': imageflag.toString(),
      'project_img':
          imageselected ? await MultipartFile.fromFile(_image!.path) : null,

      'lat': latitude.toString(),
      'long': longitude.toString(),
    });

    print(Location_id);
    print(sellers_id);

    String url = apiurl + "Create-Lead";
    var response = await Dio().post(url, data: formData);
    var data = response.data;
    print(data);

    print("*************************************");

    setState(() {
      _isloading = false;
    });
    // await uploadImageHTTP(_image, "https://asm.sortbe.com/api/Create-Lead");

    if (response.statusCode == 200) {
      print("*****************");
      print(data);
      // Login successful.
      // You can save the user's session token or navigate to the next screen here.
      if (data['status'] == 'Success') {
        print("next page");
        savedata(data['client_id'].toString());
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const Follow_Up_Form())));
      } else {
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
        setState(() {
          _isloading = false;
        });
      }
    } else {
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
            child: Center(child: Text("Please Try again")),
          )));

      // Login failed.
      // You can display an error message here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      child: FocusScope(
        node: _focusScopeNode,
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
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 50,
                  ),
                  //person name
                  TextFormField(
                    controller: _name,
                    // textInputAction: TextInputAction.next,
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
                    // textInputAction: TextInputAction.next,
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

                  // DropdownButtonFormField<String>(
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   value: _selecttype,
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       _selecttype = newValue!;
                  //     });
                  //   },
                  //   items: _typeoptions.map((option) {
                  //     return DropdownMenuItem(
                  //       value: option,
                  //       child: Text(option),
                  //     );
                  //   }).toList(),
                  //   decoration: const InputDecoration(
                  //     // filled: true,
                  //     // labelText: 'Option',
                  //     hintText: 'Business Type',
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null) {
                  //       return 'Please select the Business type';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  TextFormField(
                    controller: TextEditingController(text: _selecttype),

                    // textInputAction: TextInputAction.,

                    // autovalidateMode: AutovalidateMode.disabled,
                    decoration: const InputDecoration(
                      // filled: true,
                      // labelText: 'Option',
                      hintText: 'Business Type',
                      border: OutlineInputBorder(),

                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                    ),

                    readOnly: true,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Business Type',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _typeoptions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selecttype = _typeoptions[index];
                                          // showtextbusinesstype = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(_typeoptions[index],
                                              style: TextStyle(
                                                fontSize: 16,
                                              )),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          });
                    },
                    // autovalidateMode: AutovalidateMode.values[1],
                    // validator: (value) {
                    //   if (value!.isEmpty) {
                    //     return 'Please Select the Business Type';
                    //   }
                    //   return null;
                    // },
                  ),
                  // showtextbusinesstype
                  //     ? Text(
                  //         "Select the Business type",
                  //         style: TextStyle(color: Colors.red),
                  //       )
                  //     : Text(""),
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
                            print(_selecttype);
                            _selecttype == null ? show() : next();
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
                // TextFormField(
                //   controller: _location,
                //   textInputAction: TextInputAction.next,
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   // obscureText: true,
                //   decoration: const InputDecoration(
                //     labelText: 'Location of the Project',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your location';
                //     }
                //     return null;
                //   },
                //   keyboardType: TextInputType.text,
                // ),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      // filled: true,
                      // labelText: 'Option',
                      hintText: 'Select the Location',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Select the Steel';
                    //   }
                    //   return null;
                    // },
                    readOnly: true,
                    controller: TextEditingController(text: _selectlocation),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select the Location',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _locationoptions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectlocation =
                                              _locationoptions[index]
                                                  ['location_name'];
                                          locationindex =
                                              _locationoptions[index]['id'];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(_locationoptions[index]
                                              ['location_name']),
                                        ),
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

                // DropdownButtonFormField<String>(

                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   value: _selectcement,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectcement = newValue!;
                //     });
                //   },
                //   decoration: const InputDecoration(
                //     // filled: true,
                //     // labelText: 'Option',
                //     hintText: 'Select the Cement',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value == null) {
                //       return 'Please Select the Cement';
                //     }
                //     return null;
                //   },
                // ),

                TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                        // filled: true,
                        // labelText: 'Option',
                        hintText: 'Select the Cement',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.arrow_drop_down_outlined)),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Select the Cement';
                    //   }
                    //   return null;
                    // },
                    readOnly: true,
                    controller: TextEditingController(text: _selectcement),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select the Cement',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _cementoptions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectcement =
                                              _cementoptions[index]['name'];
                                          cementindex =
                                              _cementoptions[index]['id'];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                              _cementoptions[index]['name']),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          });
                    }),
                //steel brand
                const SizedBox(
                  height: 10,
                ),

                // DropdownButtonFormField<String>(
                //   autovalidateMode: AutovalidateMode.onUserInteraction,
                //   value: _selectsteel,
                //   onChanged: (String? newValue) {
                //     setState(() {
                //       _selectsteel = newValue!;
                //     });
                //   },
                //   items: _steeloptions.map((option) {
                //     return DropdownMenuItem(
                //       value: option,
                //       child: Text(option),
                //     );
                //   }).toList(),
                //   decoration: const InputDecoration(
                //     // filled: true,
                //     // labelText: 'Option',
                //     hintText: 'Select the Steel',
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value == null) {
                //       return 'Please Select the Steel';
                //     }
                //     return null;
                //   },
                // ),

                TextFormField(
                    textInputAction: TextInputAction.next,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      // filled: true,
                      // labelText: 'Option',
                      hintText: 'Select the Steel',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Select the Steel';
                    //   }
                    //   return null;
                    // },
                    readOnly: true,
                    controller: TextEditingController(text: _selectsteel),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select the Steel',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              content: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _steeloptions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectsteel =
                                              _steeloptions[index]['name'];
                                          steelindex =
                                              _steeloptions[index]['id'];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                              _steeloptions[index]['name']),
                                        ),
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
                          // _currentPageIndex++;
                          // _pageController.nextPage(
                          //   duration: const Duration(milliseconds: 300),
                          //   curve: Curves.easeInOut,
                          // );
                          _selectcement == null || _selectsteel == null
                              ? show()
                              : next();
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
                  height: 40,
                ),
                const Text("Previous Seller Details",
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 50,
                ),
                //name
                // TextFormField(
                //   controller: _sellername,
                //   // obscureText: true,
                //   decoration: const InputDecoration(
                //     labelText: 'Seller\'s Name (optional)',
                //     border: OutlineInputBorder(),
                //   ),

                //   keyboardType: TextInputType.name,
                // ),

                TextFormField(
                    textInputAction: TextInputAction.next,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      // filled: true,
                      // labelText: 'Option',
                      hintText: 'Select the Sellers name (optional)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Select the Steel';
                    //   }
                    //   return null;
                    // },
                    readOnly: true,
                    controller: TextEditingController(text: _selectsellersname),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select the Seller',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _sellersoptions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectsellersname =
                                              _sellersoptions[index]
                                                  ['seller_name'];
                                          sellersindex =
                                              _sellersoptions[index]['id'];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(_sellersoptions[index]
                                              ['seller_name']),
                                        ),
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
                // TextFormField(
                //   controller: _brand,
                //   // obscureText: true,
                //   decoration: const InputDecoration(
                //     labelText: 'Brand (optional)',
                //     border: OutlineInputBorder(),
                //   ),

                //   keyboardType: TextInputType.text,
                // ),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      // filled: true,
                      // labelText: 'Option',
                      hintText: 'Select the Cement (optional)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Select the Steel';
                    //   }
                    //   return null;
                    // },
                    readOnly: true,
                    controller: TextEditingController(text: _selectprevcement),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select the Cement',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _prevcementoptions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectprevcement =
                                              _prevcementoptions[index]['name'];
                                          cementprevindex =
                                              _prevcementoptions[index]['id'];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                            _prevcementoptions[index]['name']),
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
                //pricing
                TextFormField(
                  controller: cement_pricing,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Cement Price (optional)',
                    border: OutlineInputBorder(),
                  ),

                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    textInputAction: TextInputAction.next,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      // filled: true,
                      // labelText: 'Option',
                      hintText: 'Select the Steel (optional)',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please Select the Steel';
                    //   }
                    //   return null;
                    // },
                    readOnly: true,
                    controller: TextEditingController(text: _selectprevsteel),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select the Steel',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _prevsteeloptions.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectprevsteel =
                                              _prevsteeloptions[index]['name'];
                                          steelprevindex =
                                              _prevsteeloptions[index]['id'];
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                            _prevsteeloptions[index]['name']),
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
                TextFormField(
                  controller: steel_pricing,
                  // obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Steel Price (optional)',
                    border: OutlineInputBorder(),
                  ),

                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                //address
                // TextFormField(
                //   controller: _selleraddress,
                //   // obscureText: true,
                //   decoration: const InputDecoration(
                //     labelText: 'Seller\'s Address (optional)',
                //     border: OutlineInputBorder(),
                //   ),

                //   keyboardType: TextInputType.text,
                // ),
                const SizedBox(
                  height: 10,
                ),
                //mobile
                // TextFormField(
                //   controller: _sellermobile,
                //   // obscureText: true,
                //   decoration: const InputDecoration(
                //     labelText: 'Seller\'s Contact Number (optional)',
                //     border: OutlineInputBorder(),
                //   ),

                //   keyboardType: TextInputType.phone,
                // ),
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
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        print("sellers index  :" + sellersindex.toString());
                        print("location index :" + locationindex.toString());
                        print("cement index :" + cementindex.toString());
                        print("steelindex  : " + steelindex.toString());
                        print(
                            "prev steel index : " + steelprevindex.toString());
                        print("prev cement index : " +
                            cementprevindex.toString());
                        _submit(
                            cementindex.toString(),
                            steelindex.toString(),
                            cementprevindex.toString(),
                            steelprevindex.toString(),
                            locationindex.toString(),
                            sellersindex.toString());
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
                                child: Text(
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
