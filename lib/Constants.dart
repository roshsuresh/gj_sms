import 'package:flutter/material.dart';

import 'Size_Config.dart';

const String baseUrl = "www.eschoolweb.in";
const String baseUrl1 = "eschoolweb.in";
const goldenColor = Color(0xFFDAA520);
const kPrimaryColor = Color(0xFF00003e);
const kPrimaryLightColor = Color(0xFFa88702);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFFfffbdf);
const kTextColor = Color(0xFF757575);
final inputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}

Widget customAppBar = Container(
  color: kPrimaryColor,
);
//strings
const String createGrp = "Create Group";
const String create = "Create Group";
const String send_sms = "Send Sms";
const String create_group = "Create Group";
const String create_sub_group = "Create Sub Group";
const String add_contact = "Add Contact";
const String sms_log = "Sms Log";
const String contact_report = "Contact Report";
const String group_report = "Groups";
const String sub_group_report = "Sub Groups";
const String from_contact_book = "From Contact Book";
const String from_excel_file = "From Excel File";
const String to_sd_card = "To Sd Card";
const String contact_book = "Contact Book";
const String backup = "Backup";
const String restore = "Restore";
const String group_added = "Group Added";
const String sub_group_added = "Sub group added";
const String update = "Update";
const String no_data_found = "No data found";
const String sub_group_contacts = "Sub group contacts";
const selectSubGroup = "Select SubGroup";
const confirm_string = "Confirm";

String orgId = '10000';
