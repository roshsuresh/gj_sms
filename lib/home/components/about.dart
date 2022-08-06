import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gj_sms/Components/CustomAnimatedBottomBar.dart';
import 'package:gj_sms/home/components/SuccessScreen.dart';
import 'package:gj_sms/home/components/webview.dart';
import 'package:gj_sms/home/provider/SendSmsProvider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Constants.dart';
import '../../Routes.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  String? version ;
  String? buildNumber ;
  void getPackageInfo() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

  setState(() {
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  });

  }

@override
  void initState() {
    getPackageInfo();

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _inactiveColor = Colors.grey;
    int _currentIndex = 1;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BalanceBox(),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>WebViewGo(url: 'https://gjinfotech.net/gj/contact.php',)));
                  },
                  child: ListTilesAbout(icon: Icons.privacy_tip, title: 'Privacy policy')),
              InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>WebViewGo(url: 'https://gjinfotech.net/gj/contact.php',)));
                  },
                  child: ListTilesAbout(icon: Icons.view_agenda, title: 'Terms and conditions')),
              InkWell(
                  onTap: (){
                    print("clicking");
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>WebViewGo(url: 'https://gjinfotech.net/gj/contact.php',)));
                  },
                  child: ListTilesAbout(icon: Icons.account_box_outlined, title: 'About us')),
              InkWell(
                onTap: () async {
                  SharedPreferences pref=await SharedPreferences.getInstance();
                  pref.clear();
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                  child: ListTilesAbout(icon: Icons.logout, title: 'Logout')),
              Center(
                child:Text('$version ',textAlign: TextAlign.center,),
              )

            ],
          ),
        ),

      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}
class ListTilesAbout extends StatelessWidget {
  final IconData icon;
  final String title;

  const ListTilesAbout({Key? key,required this.icon,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Icon(icon),
            ),
            Text(title,style: TextStyle(fontSize: 18,color: Colors.black),),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Icon(Icons.arrow_forward_ios_rounded),
            )
          ],
        ),
      ),
    );
  }
}
