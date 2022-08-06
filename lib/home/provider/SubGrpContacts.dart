import 'package:flutter/material.dart';
import 'package:gj_sms/SqlLite/Db.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/group/model/SubGroupContact.dart';

class SubGrpContactsProvider with ChangeNotifier {
  List<ContactModel> contactList = [];
  List<SubGrpContacts> allList = [];
  get selectedContactedList => contactList;
  List<SubGrpContacts> selectedGroups = [];
  clearList() {
    selectedGroups.clear();
    notifyListeners();
  }

  Future<bool> insertGrpContacts(int grpId, List<ContactModel> conList) async {
    conList.forEach((item) async {
      if (await DatabaseHelper.db.checkExists(grpId, item.id!)) {
        await DatabaseHelper.db.insertGrpContacts(grpId, item.id!);
      } else {}
    });

    return true;
  }

  Future<bool> insertGrpContactsSingle(SubGrpContacts model) async {
    if (await DatabaseHelper.db.checkExists(model.subId, model.contactId)) {
      await DatabaseHelper.db.insertGrpContacts(model.subId, model.contactId);
    } else {}

    return true;
  }

  Future<int> getGrpContactsCount(int subId) async {
    List<SubGrpContacts> grpContacts =
        await DatabaseHelper.db.selectGrpContacts(subId);
    int count = grpContacts.length;
    print(count);
    return count;
  }

  Future<int> getSelectedGroupContacts(int subId) async {
    List<SubGrpContacts> grpContacts =
        await DatabaseHelper.db.selectGrpContacts(subId);
    int count = grpContacts.length;
    print(count);
    return count;
  }

  getAllGrpContacts() async {
    allList = await DatabaseHelper.db.getAllSubGrpContacts();
    notifyListeners();
  }

  getGrpContacts(int subId) async {
    selectedGroups.clear();
    List<SubGrpContacts> grpContacts =
        await DatabaseHelper.db.selectGrpContacts(subId);
    grpContacts.forEach((element) {
      if (!selectedGroups.contains(element)) {
        selectedGroups.add(element);
      }
    });
    notifyListeners();
    print("selected groups size ${selectedGroups.length}");
  }

  Future<int> deleteGrpContacts(
      int subId, int conId, BuildContext context) async {
    print("deleting");
    await DatabaseHelper.db.deleteGrpContacts(subId, conId);
    getGrpContacts(subId);
    // Navigator.pop(context);
    return 1;
  }
  // void getGrpContactsSelected(List<int> subId) async{
  //   contactList.clear();
  //   Future.forEach(subId, (int element) async{
  //     List<SubGrpContacts> grpContacts = await DatabaseHelper.db.selectGrpContacts(element);
  //     int count = grpContacts.length;
  //     print(count);
  //     contactList.add(value)
  //   });
  //
  // }

}
