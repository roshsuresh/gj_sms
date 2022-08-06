import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:gj_sms/Register/componets/register_form.dart';
import 'package:gj_sms/Size_Config.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin{
   Animation? _growAnimation;
   AnimationController? _animationController;



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/login.jpg')
              
            )
          ),
          child: Stack(
            children: [
              Center(
              child: RegisterForm(),
            ),
              Positioned(
                bottom: 0,
                left: 0,
                  right: 0,
                  child: Image.asset("assets/images/watermark.png"))
            ],
          ),
        ),
      ),
    );
  }
}

