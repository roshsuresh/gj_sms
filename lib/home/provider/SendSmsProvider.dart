import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gj_sms/Register/model/register.dart';
import 'package:gj_sms/Routes.dart';
import 'package:gj_sms/SqlLite/Db.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/group/model/SubGroupContact.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/models/TemplateModel.dart';
import 'package:gj_sms/home/models/send_sms_model.dart';
import 'package:http/http.dart ' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants.dart';

class SendSmsProvider with ChangeNotifier {
  List<TemplateModel> tempModelList = [];
  String selectedFormattedTxt = "";
  List<SubGroup> selectedList = [];
  get getSelectedList => selectedList;
  get selectedTemp => selectedFormattedTxt;

  List<ContactModel> selectedContactList = [];

  int successCount = 0;
  int failedCount = 0;
  get getSuccessCount => successCount;
  get getFailedCount => failedCount;

  double balance = 0;
  get getBalance => balance;

  clearAllLists() {
    selectedContactList.clear();
    tempModelList.clear();
    selectedList.clear();
  }

  addToSelectedList(SubGroup model) {
    if (checkExistsSelected(model)) {
      selectedList.add(model);
    } else {
      selectedList.remove(model);
    }

    notifyListeners();
  }

  bool checkExistsSelected(SubGroup model) {
    if (selectedList.contains(model)) {
      return false;
    } else {
      return true;
    }
  }

  setFormattedTemplate(String str) {
    selectedFormattedTxt = str;
    notifyListeners();
  }

  get tempList => tempModelList;

  String selectedTemplate = "";

  get templateSelected => selectedTemplate;

  void setTemplate(String template) {
    selectedTemplate = template;
    print("from smsProvider\t $template");
    notifyListeners();
  }

  getTemplatesFromServer(String orgId, BuildContext context) async {
    tempModelList.clear();
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("register") != null) {
      String? d = pref.getString('register');
      RegisterModel m = RegisterModel.fromJson(jsonDecode(d!));
      final params = {'orgid': m.orgid, 'clientid': m.clientid};
      final uri =
          Uri.https(baseUrl1, '/Bulksmsapp/bulksms_template_api.php', params);
      final response = await http.get(uri,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> respon = jsonDecode(response.body);
        print(respon);
        if (respon['template'] != null) {
          respon['template'].forEach((v) {
            tempModelList.add(TemplateModel.fromJson(v));
          });
          notifyListeners();
          print(tempModelList.length);
        }
      }
    } else {
      Navigator.pushNamed(context, register);
    }
  }

  Future<int> addContactFromSingleSelected(List<ContactModel> ids) async {
    Future.forEach(ids, (ContactModel element) {
      ContactModel? m =
          selectedContactList.firstWhereOrNull((e) => e.id == element.id);
      if (m == null) {
        selectedContactList.add(element);
      }
    });
    return 1;
  }

  Future<List<SubGrpContacts>> getContactsForSingleGroupGrpContacts(
      int subId) async {
    print('sub id $subId');

    List<SubGrpContacts> grpContacts =
        await DatabaseHelper.db.selectGrpContacts(subId);
    print('sub grp length ${grpContacts.length}');

    //   conList.addAll(await DatabaseHelper.db.getContactsWithIdS(element.contactId));
    // });

    return grpContacts;
  }

  Future<List<ContactModel>> getContactsForSingleGroup(int subId) async {
    print('sub id $subId');
    List<ContactModel> conList = [];
    List<SubGrpContacts> grpContacts =
        await DatabaseHelper.db.selectGrpContacts(subId);
    print('sub grp length ${grpContacts.length}');
    await Future.forEach(grpContacts, (SubGrpContacts element) async {
      conList
          .addAll(await DatabaseHelper.db.getContactsWithId(element.contactId));
    });
    // grpContacts.forEach((element) async {
    //   conList.addAll(await DatabaseHelper.db.getContactsWithIdS(element.contactId));
    // });
    print('contact list length ${conList.length}');
    return conList;
  }

  Future<int> addContactsFromSelected(List<SubGrpContacts> ids) async {
    Future.forEach(ids, (SubGrpContacts element) async {
      List<ContactModel> f =
          await DatabaseHelper.db.getContactsWithId(element.contactId);
      f.forEach((element) {
        ContactModel? m =
            selectedContactList.firstWhereOrNull((e) => e.id == element.id);
        if (m == null) {
          selectedContactList.add(element);
        }
      });
    });
    return 1;
  }

  Future<double?> getWalletBalance() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? d = pref.getString("register");
    RegisterModel m = RegisterModel.fromJson(jsonDecode(d!));
    if (pref.getString("register") != null) {
      final params = {'orgid': m.clientid};
      final uri = Uri.https(
          "www.eschoolweb.in", "/Bulksmsapp/bulk_smsbalance_api.php", params);
      print(
          '========================================================================');
      print(uri);
      final response = await http.get(uri,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> respon = jsonDecode(response.body);
        print(respon);
        if (respon['balance'] != null) {
          balance = double.parse(respon['balance']);
          return double.parse(respon['balance']);
        }
      }
    }
    return null;
  }

  Future<bool> sendSms(String orgId, String message, String mob, String grpName,
      BuildContext context) async {
    var params = {
      "id": "gjinfo",
      "pwd": "gj123",
      "provider": "LM6",
      "senderid": "GJINFO",
      "text": message,
      "mob": mob,
      "orgid": orgId,
      "groupname": grpName
    };
    final uri =
        Uri.https(baseUrl1, "/smsweb/AdministrativeTools/sms_send.php", params);
    print(
        '========================================================================');
    print("message $message");
    print(
        '========================================================================');
    final response = await http
        .get(uri, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    print(response.body);
    if (response.statusCode == 200) {
      // final Map<String,dynamic> respon=jsonDecode(response.body);
      // print(respon);

      // if (respon['msg'] != null) {
      //   if(respon['msg']=="Success"){
      //     return true;
      //   }else{
      //     return false;
      //   }
      // }
      return true;
    }
    return false;
  }

  Future<bool> sendSmsNew(SendSmsModel model) async {
    var request = http.Request('POST',
        Uri.parse('https://eschoolweb.in/Bulksmsapp/bulk_sms_send.php'));
    request.body = jsonEncode(model.toJson());
    print(jsonEncode(model.toJson()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      // print(jsonDecode(await response.stream.bytesToString()));
      List<dynamic> lis = jsonDecode(await response.stream.bytesToString());
      Map<String, dynamic> re = lis[0];
      print(re.toString());
      Map<String, dynamic> data = re['data'];
      failedCount = data['fail'];
      successCount = data['success'];
      notifyListeners();
    } else {
      print(response.reasonPhrase);
    }
    return true;
  }
}
