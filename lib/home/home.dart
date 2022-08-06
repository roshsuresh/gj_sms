import 'package:flutter/material.dart';
import 'package:gj_sms/Components/CustomAnimatedBottomBar.dart';
import 'package:gj_sms/Routes.dart';
import 'package:gj_sms/home/components/list_menus.dart';

import '../Constants.dart';
import '../utils.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _inactiveColor = Colors.grey;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget _buildBottomBar(){
      return CustomBottomAppbar(
        containerHeight: 70,
        backgroundColor: Colors.black,
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index){
          setState(() => _currentIndex = index);
          if (_currentIndex==1) {
            Navigator.pushReplacementNamed(context, about_screen);
          }else{
            Navigator.pushReplacementNamed(context, home);
          }

        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.green,
            inactiveColor: _inactiveColor,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.logout),
            title: Text('Logout'),
            activeColor: Colors.deepPurple.shade200,
            inactiveColor: Colors.blue.shade200,
            textAlign: TextAlign.center,
          ),
          // BottomNavyBarItem(
          //   icon: Icon(Icons.message),
          //   title: Text(
          //     'Messages ',
          //   ),
          //   activeColor: Colors.pink,
          //   inactiveColor: _inactiveColor,
          //   textAlign: TextAlign.center,
          // ),
          // BottomNavyBarItem(
          //   icon: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   activeColor: Colors.blue,
          //   inactiveColor: _inactiveColor,
          //   textAlign: TextAlign.center,
          // ),
        ],
      );
    }
    return Scaffold(
      extendBody: true,
      appBar: AppBar(title: Text('BULK SMS'),backgroundColor: kPrimaryColor,automaticallyImplyLeading: false,),
      body: SafeArea(
        child: Container(
          child: Categories(),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


    );
  }
}
