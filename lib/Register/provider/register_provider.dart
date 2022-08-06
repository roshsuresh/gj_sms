import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/Register/model/register.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterProvider with ChangeNotifier{
  GlobalKey<FormState> _formkey =GlobalKey<FormState>();

  GlobalKey<FormState> getFormKey()=>_formkey;

  Future<bool> checkRegister(String key1,String key2,String slnNo) async{
    var params={
      'Key1':key1,
      'Key2':key2,
      'slno1':slnNo
    };

    final uri = Uri.https(baseUrl1,'/Bulksmsapp/keycheckmobile2.php',params);
    print(uri);
    final response=await http.post(uri,headers: {
      HttpHeaders.contentTypeHeader:'application/json'
    });

    final Map<String,dynamic> respon=jsonDecode(response.body);
    print(jsonEncode(respon));
    if(respon.containsKey("status")){
      return false;
    }else if(respon.containsKey("client")){
      final re=RegisterModel.fromJson(respon);
      // print(re.toJson());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //
      prefs.setString("register",jsonEncode(respon) );
      return true;
    }else{
      return false;
    }



  }




}