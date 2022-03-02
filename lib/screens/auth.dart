import 'package:flutter/material.dart';
import 'package:joshua_joshua/screens/auth/login.dart';
import 'package:joshua_joshua/screens/auth/register.dart';

class Auth extends StatefulWidget {

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  int _selectedIndex = 0;
  PageController _pageController = PageController();

  final List<Widget> navWidgets = [
    Login(),
    Register()
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: navWidgets,
        onPageChanged: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key_rounded),
            label: "Sign In",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: "Register"
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
          color: Colors.grey
        ),
        onTap: _onItemTapped,
      ),
    );
  }
}