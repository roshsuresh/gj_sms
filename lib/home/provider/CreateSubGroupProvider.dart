

import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/SqlLite/Db.dart';
import 'package:gj_sms/group/model/sub_group.dart';

class SubGroupProvider with ChangeNotifier{

  List<SubGroup> subGroupList = [];
  SubGroup? selectedModel;
  SubGroup? getSelectedModel()=>selectedModel;
  setSelectedModel(SubGroup model){
    selectedModel = model;
    notifyListeners();
  }
  List<SubGroup> getSubGroupList() => subGroupList;
  String errorTxt= "";
  String getErrorTxt() =>errorTxt;
  setErrorTxt(){
    errorTxt="";
    notifyListeners();
  }
  Future<bool> insertSubGroup(SubGroup model) async{
    if (await DatabaseHelper.db.checkSubGroupName(model.title)) {
      int inserted = await DatabaseHelper.db.insertSubGroup(model);
      errorTxt = sub_group_added;
      notifyListeners();
      return true;
    }else{
      errorTxt= "SubGroup already exists";
      notifyListeners();
      return false;
    }
  }
  Future<int> getSubgroupsFromDb() async{
    subGroupList.clear();
    subGroupList =await DatabaseHelper.db.getSubGroup();
    notifyListeners();
    return 1;
  }
  Future<List<SubGroup>> getSubgroupsFromDbWithId(int id) async{

    List<SubGroup> grpList=await DatabaseHelper.db.getSubGroupListWithId(id);
    notifyListeners();
    return grpList;
  }

  Future<bool> updateSubGroup(SubGroup model) async{
    print("update ${model.toMap()}");
    int updates = await DatabaseHelper.db.updateSubGroups(model);
    getSubgroupsFromDb();
    errorTxt = update+"ed";
    notifyListeners();
    return true;
  }
  Future<bool> deleteSubGroup(int id) async{
    int deleted = await DatabaseHelper.db.deleteSubGroups(id);
    getSubgroupsFromDb();

    return true;
  }

}