import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/Routes.dart';
import 'package:gj_sms/group_synch/group_sync_proivder.dart';
import 'package:gj_sms/home/models/MenuCategories.dart';
import 'package:gj_sms/home/provider/HomeProvider.dart';
import 'package:gj_sms/sms_log/body.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<MenuCategories> categories = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      categories =
          Provider.of<HomeProvider>(context, listen: false).getCategoriesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return ListView.builder(
              itemCount: value.categoryList.length,
              itemBuilder: (context, index) {
                return MenuItem(
                  title: value.categoryList[index].menuName!,
                  icon: value.categoryList[index].icons!,
                  group: value.categoryList[index].menuGroup!,
                );
              });
        },
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String group;

  const MenuItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.group,
  }) : super(key: key);

  void handlePress(String title, BuildContext context) {
    switch (title) {
      case create_group:
        groupModelSheet(context, create, null);
        break;
      // case create_sub_group:
      //   subGroupModelSheet(context, create, null,);
      //   break;
      case "Groups":
        Navigator.pushNamed(context, group_list);
        break;
      case sub_group_report:
        Navigator.pushNamed(context, sub_group_list);
        break;
      case add_contact:
        addContactModelSheet(context, create, null);
        break;
      case sms_log:
        Navigator.push(context, MaterialPageRoute(builder: (_) => SmsLog()));
        break;
      case sub_group_contacts:
        Navigator.pushNamed(context, sub_group_contact);
        break;
      case send_sms:
        Navigator.pushNamed(context, send_sms);
        break;
      case from_contact_book:
        getContacts(context);
        break;
      case contact_report:
        Navigator.pushNamed(context, list_contacts);
        break;
      case from_excel_file:
        importContactsFromExcel(context);
        break;
      case "Export to db":
        Provider.of<GroupSyncProvider>(context, listen: false)
            .groupSync(context);
        break;
      case "Import from db":
        Provider.of<GroupSyncProvider>(context, listen: false)
            .getGroups(context);
        break;
      default:
        print("clicked isn't defined yet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return group != ""
        ? InkWell(
            onTap: () => {handlePress(title, context)},
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      group,
                      style: TextStyle(
                          color: kPrimaryLightColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(),
                      leading: Icon(
                        icon,
                        color: kPrimaryLightColor,
                      ),
                      title: Text(
                        title,
                        style: TextStyle(color: kPrimaryLightColor),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () => {handlePress(title, context)},
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(),
                leading: Icon(
                  icon,
                  color: kPrimaryLightColor,
                ),
                title: Text(
                  title,
                  style: TextStyle(color: kPrimaryLightColor),
                ),
              ),
            ),
          );
  }
}
