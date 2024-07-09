import 'package:flutter/material.dart';
import 'package:my_app/screens/home.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:my_app/screens/opt_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() {
    return MainScreenScreenState();
  }
}

class MainScreenScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Settings Page',
        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    Home(),
    // Text('User Page',
    //     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    LoginScreen(),
    //RegisterScreen(),
    //OtpScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
