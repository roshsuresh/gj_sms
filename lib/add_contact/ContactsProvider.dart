import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gj_sms/SqlLite/Db.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';

class ContactProvider with ChangeNotifier {
  List<ContactModel> contactList = [];
  List<ContactModel> selectedList = [];
  List<ContactModel> getContactList() => contactList;
  String errorTxt = "";
  String getError() => errorTxt;

  String searchTxt = "";
  setSearchTxt(String s) {
    searchTxt = s;
    notifyListeners();
  }

  emptyError() {
    errorTxt = "";
    notifyListeners();
  }

  clearSelectedList() {
    selectedList.clear();
    notifyListeners();
  }

  setSelectedList(ContactModel model) {
    ContactModel? cm = selectedList.singleWhereOrNull((e) => e.id == model.id);
    if (cm == null) {
      selectedList.add(model);
    } else {
      print('already added');
      selectedList.removeWhere((element) => element.id == model.id);
    }

    print("list selected");
    notifyListeners();
  }

  deSelectList(ContactModel model) {
    selectedList.remove(model);
    print("list de-selected");
    notifyListeners();
  }

  bool checkSelected(ContactModel model) {
    ContactModel? cm = selectedList.singleWhereOrNull((e) => e.id == model.id);
    print(selectedList.length);
    if (cm != null) {
      print('true');
      return true;
    } else {
      print('false');

      return false;
    }

    // for(var i=0;i<selectedList.length;i++){
    //     if (selectedList[i].id==model.id) {
    //       return true;
    //     }
    // }
    // return false;
  }

  Future<bool> addContacts(ContactModel model) async {
    if (await DatabaseHelper.db
        .checkContact(int.parse(model.phoneNum!.toString()))) {
      bool data = await DatabaseHelper.db.insertContacts(model);
      // errorTxt = "Contact added";
      notifyListeners();
      readAllContacts();
      print(errorTxt);
      return data;
    } else {
      errorTxt = "Phone number already exists !";
      notifyListeners();
      print(errorTxt);
      return false;
    }
  }

  Future<bool> updateContact(ContactModel model) async {
    bool data = await DatabaseHelper.db.updateContacts(model);
    errorTxt = "Contact updated";
    notifyListeners();
    readAllContacts();
    return data;
  }

  Future<bool> deleteContact(int id) async {
    bool data = await DatabaseHelper.db.deleteContacts(id);
    errorTxt = "Contact Deleted";
    notifyListeners();
    readAllContacts();
    return data;
  }

  Future<int> readAllContacts() async {
    contactList.clear();
    contactList = await DatabaseHelper.db.getAllContacts();
    print("contact list ${contactList.length}");
    contactList = contactList
        .fold<Map<int, ContactModel>>({}, (map, c) {
          map.putIfAbsent(c.phoneNum!, () => c);

          return map;
        })
        .values
        .toList();
    contactList.sort((a, b) => a.name!.compareTo(b.name!));
    notifyListeners();
    return 1;
  }

  Future<List<ContactModel>> getContactsWithId(int id) async {
    List<ContactModel> data = await DatabaseHelper.db.getContactsWithIdS(id);
    return data;
  }

  void getContactsWithKey(String s) async {
    contactList.clear();
    if (s.isEmpty) {
      readAllContacts();
    } else {
      contactList = await DatabaseHelper.db.getContactsWithSearch(s);
      notifyListeners();
    }
  }
}
