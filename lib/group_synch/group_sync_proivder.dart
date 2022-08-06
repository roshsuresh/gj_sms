
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gj_sms/group/model/groupmodel.dart';
import 'package:gj_sms/group_synch/group_getting_model.dart';
import 'package:gj_sms/group_synch/model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Register/model/register.dart';
import '../add_contact/ContactModel.dart';
import '../add_contact/ContactsProvider.dart';
import '../group/model/SubGroupContact.dart';
import '../home/provider/CreateSubGroupProvider.dart';
import '../home/provider/GroupProvider.dart';
import '../home/provider/SubGrpContacts.dart';
import 'package:gj_sms/group/model/sub_group.dart' as sub;

class GroupSyncProvider with ChangeNotifier{
  GroupSync? model;
  Future<int> init() async {
    SharedPreferences _pref=await SharedPreferences.getInstance();

    RegisterModel model=RegisterModel.fromJson(jsonDecode(_pref.getString("register")!));

    return 1;
  }
  Future<void> groupSync(BuildContext context) async {
    init();
    SharedPreferences _pref=await SharedPreferences.getInstance();
    await Provider.of<GroupCreateProvider>(context,listen: false).getGroupsFromDb();
    await Provider.of<SubGroupProvider>(context,listen: false).getSubgroupsFromDb();
    await Provider.of<ContactProvider>(context,listen: false).readAllContacts();
    await Provider.of<SubGrpContactsProvider>(context,listen: false).getAllGrpContacts();
    RegisterModel model=RegisterModel.fromJson(jsonDecode(_pref.getString("register")!));
    List<GroupModel> grpList=Provider.of<GroupCreateProvider>(context,listen: false).getGroups();
    List<sub.SubGroup> subGrpList= Provider.of<SubGroupProvider>(context,listen: false).subGroupList;
    List<ContactModel> contactList=Provider.of<ContactProvider>(context,listen: false).getContactList();
    List<SubGrpContacts> subGrpListAll=Provider.of<SubGrpContactsProvider>(context,listen: false).allList;
    List<Groupdetail> groupdetails=[
      Groupdetail(
        group: grpList.map((e) => GroupSyncModel(id: e.id!, title: e.title)).toList(),
        subGroup: subGrpList.map((e) => SubGroupSync(id: e.id!,groupId: e.groupId!, title: e.groupTitle!)).toList(),
        contacts: contactList.map((e) => ContactSync(id: e.id!, name: e.name!, phone: e.phoneNum!, course: e.course==null?"":e.course!)).toList(),
        subGrpContacts: subGrpListAll.map((e) => SubGrpContactSync(id: e.id!, subId: e.subId.toString(), contactId: e.contactId.toString())).toList(),

      )
    ];
    GroupSync? m=GroupSync(orgid:int.parse(model.orgid), groupdetails: groupdetails, );
    var request = http.Request('POST', Uri.parse('https://eschoolweb.in/Bulksmsapp/bulksms_addGroupContactsDetails.php'));
    request.body = jsonEncode(m.toJson());


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Export success')));

      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
  }
  Future<void>  getGroups(BuildContext context) async {
    SharedPreferences _pref=await SharedPreferences.getInstance();

    RegisterModel reg=RegisterModel.fromJson(jsonDecode(_pref.getString("register")!));
    var request = http.Request('POST', Uri.parse('https://eschoolweb.in/Bulksmsapp/bulksms_getGroupDetails.php?orgid=${reg.clientid}'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      GroupGettingModel m=GroupGettingModel.fromJson(jsonDecode(await response.stream.bytesToString()));
      print(m.groupdetails);
      m.groupdetails.group.forEach((element) async {
        bool added=await Provider.of<GroupCreateProvider>(context,listen: false).addGroupImport(GroupModel(int.parse(element.id),element.title, expand: false));
        print(added);
      });
      m.groupdetails.subGroup.forEach((element) async {
        bool added=await Provider.of<SubGroupProvider>(context,listen: false).insertSubGroup(sub.SubGroup(id: int.parse(element.id),title: element.title,groupId: int.parse(element.groupId)));
        print(added);
      });
      m.groupdetails.contacts.forEach((element) async {
        bool added=await Provider.of<ContactProvider>(context,listen: false).addContacts(ContactModel(id: int.parse(element.id), name: element.name,phoneNum: int.parse(element.phone)));
        print(added);
      });
      m.groupdetails.subGrpContacts.forEach((element) async {
        bool added=await Provider.of<SubGrpContactsProvider>(context,listen: false).insertGrpContactsSingle(SubGrpContacts(id: int.parse(element.subcid),subId: int.parse(element.subgrpid),contactId: int.parse(element.cid)));
        print(added);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported successful')));
      notifyListeners();
    }
    else {
    print(response.reasonPhrase);
    }

  }

}