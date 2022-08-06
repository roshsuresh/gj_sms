import 'package:flutter/material.dart';

class Group extends StatelessWidget {
  const Group({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child:Container() ,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.3,
        notchMargin: 5,
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [Color(int.parse("0xff2193b0")),Color(int.parse("0xff6dd5ed"))])
          ),
        ),
      ),
    );
  }
}
