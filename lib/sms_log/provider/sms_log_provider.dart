import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gj_sms/sms_log/model/SmsLogModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Register/model/register.dart';

class SmsLogProvider with ChangeNotifier {
  List<SmsLogModel> modelList = [];
  bool isExpandList = false;
  Map<int, bool> visibilityMap = Map<int, bool>();

  setExpandList(int index) {
    isExpandList = !isExpandList;
    modelList[index].visible = isExpandList;
    notifyListeners();
  }

  Future<void> getLog() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? d = pref.getString("register");
    RegisterModel m = RegisterModel.fromJson(jsonDecode(d!));
    if (pref.getString("register") != null) {
      print("client id${m.clientid}");
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://eschoolweb.in/Bulksmsapp//bulksms_smslog_api.php?orgid=${m.clientid}'));

      print(
          'https://eschoolweb.in/Bulksmsapp//bulksms_smslog_api.php?orgid=${m.clientid}');
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        modelList.clear();
        List<dynamic> b = jsonDecode(await response.stream.bytesToString());
        print(b);
        b.forEach((element) {
          print(element);
          Map<String, dynamic> da = element as Map<String, dynamic>;
          da.forEach((key, value) {
            if (value != null) {
              modelList.add(SmsLogModel.fromJson(value));
            }
          });
        });
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    }
  }
}
