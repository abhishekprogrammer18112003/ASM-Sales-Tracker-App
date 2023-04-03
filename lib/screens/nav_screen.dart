import 'package:asm_sales_tracker/screens/follow_up_page.dart';
import 'package:asm_sales_tracker/screens/home_page.dart';
import 'package:asm_sales_tracker/screens/lead_creationpage.dart';
import 'package:flutter/material.dart';

class Nav_Screen extends StatefulWidget {
  Nav_Screen({
    super.key,
  });

  @override
  _Nav_ScreenState createState() => _Nav_ScreenState();
}

class _Nav_ScreenState extends State<Nav_Screen> {
  int _currentindex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentindex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentindex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          Home_Page(),
          Lead_Creation_page(),
          Follow_Up_Page(),
        ],
        onPageChanged: (int index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        // fixedColor: Colors.amber,
        currentIndex: _currentindex,
        onTap: onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create Leads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.follow_the_signs),
            label: 'Follow-Up',
          ),
        ],
      ),
    );
  }
}
