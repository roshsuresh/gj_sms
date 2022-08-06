import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/SqlLite/Db.dart';
import 'package:gj_sms/group/model/groupmodel.dart';

class GroupCreateProvider with ChangeNotifier {
  List<GroupModel> groupList = [];
  GroupModel? _selectedItem;

  GroupModel? getSelectedItem() => _selectedItem;
  changeExpand(GroupModel model) {
    GroupModel? m =
        groupList.firstWhereOrNull((element) => model.id == element.id);
    if (m != null) {
      m.expand = !m.expand;
      notifyListeners();
    }
  }

  emptySelection() {
    setErrorTxt();
    _selectedItem = null;
  }

  List<GroupModel> getGroups() => groupList;

  String errorTxt = "";
  String getErrorTxt() => errorTxt;

  setErrorTxt() {
    errorTxt = "";
    notifyListeners();
  }

  void setSelectedGroup(GroupModel groupModel) {
    _selectedItem = groupModel;
    notifyListeners();
  }

  //creating key for form validation
  Future<bool> addGroup(String title) async {
    if (await DatabaseHelper.db.checkGroupName(title)) {
      await DatabaseHelper.db.insertGroup({'title': title});
      errorTxt = group_added;
      notifyListeners();
      getGroupsFromDb();
      return true;
    } else {
      errorTxt = "Group already exists!";
      notifyListeners();
      return false;
    }
  }

  Future<bool> addGroupImport(GroupModel model) async {
    if (await DatabaseHelper.db.checkGroupName(model.title)) {
      await DatabaseHelper.db.insertGroup(model.toJson());

      return true;
    } else {
      return false;
    }
  }

  Future<int> getGroupsFromDb() async {
    groupList = await DatabaseHelper.db.getGroups();
    notifyListeners();
    return 1;
  }

  Future<bool> deleteGroup(int id) async {
    await DatabaseHelper.db.deleteGroup(id);
    getGroupsFromDb();
    return true;
  }

  Future<bool> updateGroup(GroupModel model) async {
    await DatabaseHelper.db.updateGroup(model);
    getGroupsFromDb();
    errorTxt = "Updated";
    notifyListeners();
    errorTxt = "";
    return true;
  }
}
