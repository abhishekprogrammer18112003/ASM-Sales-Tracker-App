import 'package:asm_sales_tracker/screens/follow_up_form.dart';
import 'package:asm_sales_tracker/screens/follow_up_page.dart';
import 'package:asm_sales_tracker/screens/home_page.dart';
import 'package:asm_sales_tracker/screens/lead_creationpage.dart';
import 'package:flutter/material.dart';

class Nav_Screen extends StatefulWidget {
  final int initialIndex;
  const Nav_Screen({Key? key, this.initialIndex = 0}) : super(key: key);
  @override
  _Nav_ScreenState createState() => _Nav_ScreenState();
}

class _Nav_ScreenState extends State<Nav_Screen> {
  final PageController _pageController = PageController();
  final List<Widget> _screens = [
    Home_Page(),
    Lead_Creation_page(),
    Follow_Up_Page()
  ];

  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.initialIndex;
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.jumpToPage(widget.initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // fixedColor: Colors.amber,

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
