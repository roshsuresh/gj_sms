import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/add_contact/ContactsProvider.dart';
import 'package:gj_sms/group/model/groupmodel.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/components/list_contacts_and_move_cntacts.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:gj_sms/home/provider/GroupProvider.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<GroupCreateProvider>(context, listen: false)
          .getGroupsFromDb();
      Provider.of<ContactProvider>(context, listen: false).clearSelectedList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group_report)),
      body: Container(child: listGroups()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          groupModelSheet(context, create, null);
        },
        backgroundColor: kPrimaryColor,
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

Widget listGroups() {
  return Consumer<GroupCreateProvider>(
    builder: (context, value, child) {
      print("list length ${value.getGroups().length}");
      return value.getGroups().isEmpty
          ? Center(
              child: Text(no_data_found),
            )
          : ListView.builder(
              itemCount: value.getGroups().length,
              itemBuilder: (context, index) {
                return ListItem(
                  model: value.getGroups()[index],
                );
              });
    },
  );
}

class ListItem extends StatefulWidget {
  final GroupModel model;
  final bool? contain;
  const ListItem({Key? key, required this.model, this.contain})
      : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool expand = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              ),
            ]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.model.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                            onTap: () {
                              groupModelSheet(context, update, widget.model);
                            },
                            child: Icon(Icons.edit)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                            onTap: () {
                              showAlertBox(context, widget.model.id!);
                            },
                            child: Icon(Icons.delete)),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                expand = !expand;
                              });
                            },
                            child: Icon(Icons.keyboard_arrow_down_sharp)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // listSubGroups(context, widget.model.id!)
            expand ? listSubGroups(context, widget.model) : Container()
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showAlertBox(BuildContext context, int id) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Are you sure'),
        content: Text('deleting may cause deletion of associated items'),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Provider.of<GroupCreateProvider>(context, listen: false)
                  .deleteGroup(id);
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<dynamic> showAlertBoxSubGrpDelete(BuildContext context, int id) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Are you sure'),
        content: Text('deleting may cause deletion of associated items'),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Dismiss alert dialog
            },
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Provider.of<SubGroupProvider>(context, listen: false)
                  .deleteSubGroup(id);
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget listSubGroups(BuildContext context, GroupModel model) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              "Select Sub Group",
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
          )),
      FutureBuilder(
        future: Provider.of<SubGroupProvider>(context, listen: false)
            .getSubgroupsFromDbWithId(model.id!),
        builder: (
          context,
          value,
        ) {
          if (value.hasData) {
            List<SubGroup> data = value.data as List<SubGroup>;
            return data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(no_data_found),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () {
                              subGroupModelSheet(context, create, null, model);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Add sub group here",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Icon(Icons.add_circle_outline)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length + 1,
                    itemBuilder: (context, index) {
                      return index > data.length - 1
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  subGroupModelSheet(
                                      context, create, null, model);
                                },
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5.0,
                                        ),
                                      ]),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Icon(Icons.add_circle)],
                                  ),
                                ),
                              ),
                            )
                          : ListItemSubGroup(
                              model: data[index], grpModel: model);
                    });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(no_data_found),
                  Row(
                    children: [
                      Text(
                        "Add sub Group here",
                        style: TextStyle(fontSize: 18),
                      ),
                      Icon(Icons.add_circle_outline)
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    ],
  );
}

class ListItemSubGroup extends StatelessWidget {
  final SubGroup model;
  final GroupModel grpModel;
  const ListItemSubGroup(
      {Key? key, required this.model, required this.grpModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(model.toMap());
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ShowContactsOrMoveContacts(subId: model)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   child:  Text('model.groupTitle',style: TextStyle(fontSize: 14,),),
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        model.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                              onTap: () {
                                subGroupModelSheet(
                                    context, update, model, grpModel);
                              },
                              child: Icon(Icons.edit)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                              onTap: () async {
                                showAlertBoxSubGrpDelete(context, model.id!);
                              },
                              child: Icon(Icons.delete)),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        // child: ListTile(
        //
        //   title: Text(title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        // //  trailing:  Icon(Icons.edit),
        //   trailing: Container(
        //     child: Row(
        //       children: [
        //         Icon(Icons.edit),
        //         Icon(Icons.delete)
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
