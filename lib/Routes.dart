import 'package:flutter/widgets.dart';
import 'package:gj_sms/Register/register_view.dart';
import 'package:gj_sms/group/Group.dart';
import 'package:gj_sms/group/componets/ListGroups.dart';
import 'package:gj_sms/home/components/SendSms.dart';
import 'package:gj_sms/home/components/ShowContats.dart';
import 'package:gj_sms/home/components/SuccessScreen.dart';
import 'package:gj_sms/home/components/about.dart';
import 'package:gj_sms/home/home.dart';

import 'Constants.dart';
import 'home/components/ListContact.dart';
import 'home/components/SelectsubGroup.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  register: (context) => Register(),
  home: (context) => Home(),
  group: (context) => Group(),
  group_list: (context) => GroupList(),
  // sub_group_list:(context)=>SubGroups(),
  sub_group_contact: (context) => ShowContacts(),
  send_sms: (context) => SendSms(),
  selectSubGroup: (context) => SelectSubGroup(),
  list_contacts: (context) => ListContactsReport(),
  success_screen: (context) => SuccessScreen(),
  about_screen: (context) => About()
};
//route constants
const String register = "register";
const String home = "home";
const group = "group";
const group_list = "group_list";
const sub_group_list = "sub_group_list";
const sub_group_contact = "sub_group_contact";
const select_sub_groups = "select_sub_groups";
const list_contacts = "list_contacts";
const success_screen = "success_screen";
const about_screen = "about_screen";
