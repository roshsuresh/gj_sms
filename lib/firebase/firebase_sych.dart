import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gj_sms/Register/model/register.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/add_contact/ContactsProvider.dart';
import 'package:gj_sms/group/Group.dart';
import 'package:gj_sms/group/model/SubGroupContact.dart';
import 'package:gj_sms/group/model/groupmodel.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:gj_sms/home/provider/GroupProvider.dart';
import 'package:gj_sms/home/provider/SubGrpContacts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



class FireBaseSync{
 late DocumentReference groups;
 late DocumentReference subgroups;
 late DocumentReference grpContacts;
 late DocumentReference contacts ;

  FireBaseSync(){
    init();
  }
 Future<int> init() async {
    SharedPreferences _pref=await SharedPreferences.getInstance();

    RegisterModel model=RegisterModel.fromJson(jsonDecode(_pref.getString("register")!));
    CollectionReference root=FirebaseFirestore.instance.collection(model.clientid);
     groups = root.doc("groups");
     subgroups = root.doc('subGroups');
     grpContacts = root.doc('grpContacts');
     contacts = root.doc('contacts');
     return 1;
  }


  Future<bool> export({required BuildContext context}) async{
   await init();
   await Provider.of<GroupCreateProvider>(context,listen: false).getGroupsFromDb();
   await Provider.of<SubGroupProvider>(context,listen: false).getSubgroupsFromDb();
   await Provider.of<ContactProvider>(context,listen: false).readAllContacts();
   await Provider.of<SubGrpContactsProvider>(context,listen: false).getAllGrpContacts();
    List<GroupModel> grpList=Provider.of<GroupCreateProvider>(context,listen: false).getGroups();
    for (int i = 0; i < grpList.length; i++){
      // if(groups.)
      // groups;
    }
    List<SubGroup> subGrpList= Provider.of<SubGroupProvider>(context,listen: false).subGroupList;
     for (int i = 0; i < subGrpList.length; i++){
       // if(groups.)
       // FirebaseFirestore.instance.
     }

     List<ContactModel> contactList=Provider.of<ContactProvider>(context,listen: false).getContactList();
     for (int i = 0; i < contactList.length; i++){
       // if(groups.)
       contacts.set(contactList[i].toMap());
     }
     List<SubGrpContacts> subGrpListAll=Provider.of<SubGrpContactsProvider>(context,listen: false).allList;
     for (int i = 0; i < subGrpListAll.length; i++){
       // if(groups.)
       grpContacts.set(subGrpListAll[i].toMap());
     }
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported successfully')));
    return true;
  }

  Future<bool> import({required BuildContext context}) async{
    await init();
    print("working");
    groups.snapshots().forEach((element) async {
     bool added=await Provider.of<GroupCreateProvider>(context,listen: false).addGroupImport(GroupModel.fromMap(element.data() as Map<String,dynamic>));
      print(added);
    });
    subgroups.snapshots().forEach((element) async {
      bool added=await Provider.of<SubGroupProvider>(context,listen: false).insertSubGroup(SubGroup.fromMap(element.data() as Map<String,dynamic>));
      print(added);
    });
    contacts.snapshots().forEach((element) async {
      bool added=await Provider.of<ContactProvider>(context,listen: false).addContacts(ContactModel.fromMap(element.data() as Map<String,dynamic>));
      print(added);
    });
    grpContacts.snapshots().forEach((element) async {
      bool added=await Provider.of<SubGrpContactsProvider>(context,listen: false).insertGrpContactsSingle(SubGrpContacts.fromMap(element.data() as Map<String,dynamic>));
      print(added);
    });

    // List<GroupModel> grpList=Provider.of<GroupCreateProvider>(context,listen: false).getGroups();
    // for (int i = 0; i < grpList.length; i++){
    //   // if(groups.)
    //   groups!.set(grpList[i].toJson());
    // }
    // List<SubGroup> subGrpList= Provider.of<SubGroupProvider>(context,listen: false).subGroupList;
    // for (int i = 0; i < subGrpList.length; i++){
    //   // if(groups.)
    //   subgroups!.set(subGrpList[i].toMap());
    // }
    //
    // List<ContactModel> contactList=Provider.of<ContactProvider>(context,listen: false).getContactList();
    // for (int i = 0; i < contactList.length; i++){
    //   // if(groups.)
    //   contacts!.set(contactList[i].toMap());
    // }
    // List<SubGrpContacts> subGrpListAll=Provider.of<SubGrpContactsProvider>(context,listen: false).allList;
    // for (int i = 0; i < subGrpListAll.length; i++){
    //   // if(groups.)
    //   grpContacts!.set(subGrpListAll[i].toMap());
    // }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported successfully')));
    return true;
  }
}