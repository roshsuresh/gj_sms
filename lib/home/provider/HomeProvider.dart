import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/home/models/MenuCategories.dart';

class HomeProvider with ChangeNotifier {
  List<MenuCategories> categoryList = [];

  List<MenuCategories> getCategoriesList() {
    if (categoryList.isEmpty) {
      addMenus();
      notifyListeners();
    }

    return categoryList;
  }

  void addMenus() {
    categoryList.add(
      MenuCategories(
          menuName: send_sms, icons: Icons.sms_outlined, menuGroup: "Send"),
    );
    // categoryList.add(MenuCategories(menuName: create_group,icons: Icons.group,menuGroup: ""));
    // categoryList.add(MenuCategories(menuName: create_sub_group,icons: Icons.group,menuGroup: ""));
    categoryList.add(MenuCategories(
        menuName: "Groups", icons: Icons.contact_page_sharp, menuGroup: ""));
    // categoryList.add(MenuCategories(menuName: sub_group_contacts,icons: Icons.group,menuGroup: ""));
    categoryList.add(MenuCategories(
        menuName: add_contact,
        icons: Icons.contact_phone,
        menuGroup: "Contact Manager"));
    categoryList.add(MenuCategories(
        menuName: sms_log,
        icons: Icons.compare_arrows_outlined,
        menuGroup: ""));

    // categoryList.add(MenuCategories(menuName: sub_group_report,icons: Icons.contact_page_sharp,menuGroup: ""));
    categoryList.add(MenuCategories(
        menuName: from_contact_book,
        icons: Icons.import_contacts_outlined,
        menuGroup: "Import"));
    categoryList.add(MenuCategories(
        menuName: "Import From Db",
        icons: Icons.contact_page_sharp,
        menuGroup: ""));
    categoryList.add(MenuCategories(
        menuName: from_excel_file, icons: Icons.receipt, menuGroup: ""));
    categoryList.add(MenuCategories(
        menuName: "Export To Db",
        icons: Icons.import_contacts_outlined,
        menuGroup: "Export"));
    // categoryList.add(MenuCategories(menuName: from_excel_file,icons: Icons.receipt,menuGroup: ""));
  }
}
