import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/Register/model/register.dart';
import 'package:gj_sms/Register/provider/register_provider.dart';
import 'package:gj_sms/Routes.dart';
import 'package:gj_sms/Size_Config.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final fromKey = GlobalKey<FormState>();
  final textKey1 = TextEditingController();
  final textKey2 = TextEditingController();
  Future<void> _submit() async {
    final isValid = fromKey.currentState!.validate();

    if (isValid) {
      String deviceId="";
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if(Platform.isAndroid){
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        print('Running on ${androidInfo.androidId}');  // e.g. "Moto G (4)"
        deviceId=androidInfo.androidId;
      }else{
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print('Running on ${iosInfo.utsname.machine}');
        deviceId=iosInfo.utsname.machine;
      }
      bool login=await  Provider.of<RegisterProvider>(context,listen: false).checkRegister(textKey1.text, textKey2.text, deviceId);
      if(login){
        Navigator.popAndPushNamed(context, home);
      }else{

        FocusScope.of(context).requestFocus(FocusNode());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('wrong key pairs')));
      }



    }
    // fromKey.currentState!.save();
    // Navigator.pushNamed(context, home);
  }

@override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
          key: fromKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(

                child: Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       key1(textKey1),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                         child: SizedBox(
                           height: 1.0,
                           child:  Center(
                             child:  Container(
                               margin:  EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                               height: 5.0,
                               color: goldenColor,
                             ),
                           ),
                         ),
                       ),
                       key2(textKey2),



                     ],
    ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 300,
                  height: 40,
                  // color: Colors.green,
                  child: ElevatedButton(
                    onPressed: () {
                      _submit();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: goldenColor,
                        textStyle: const TextStyle(
                          fontSize: 15,
                        )),
                    child: const Text("Login"),
                  ))
            ],
          ),

        ));
  }
}

//key 1 text field
Widget key1(TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      validator: (value){
        if (value!.isEmpty) {
          return "Please enter key 2";
        }
      },
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: "Key 1",
          hintText: "Enter key 1 ",
          prefixIcon: Icon(Icons.vpn_key_outlined)),
    ),
  );
}

//key 2 text field
Widget key2(TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: TextFormField(
      validator: (value){
        if (value!.isEmpty) {
          return "Please enter key 2";
        }
      },
      controller: controller,
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: "Key 2",
          hintText: "Enter key 2 ",
          prefixIcon: Icon(Icons.vpn_key_outlined)),
    ),
  );
}
