import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gj_sms/Register/model/register.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/add_contact/ContactsProvider.dart';
import 'package:gj_sms/group/model/SubGroupContact.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/models/send_sms_model.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:gj_sms/home/provider/SendSmsProvider.dart';
import 'package:gj_sms/home/provider/SubGrpContacts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants.dart';
import '../../Routes.dart';
import 'ShowContats.dart';

class SelectSubGroup extends StatefulWidget {
  const SelectSubGroup({Key? key}) : super(key: key);

  @override
  _ShowSubGroupsState createState() => _ShowSubGroupsState();
}

class _ShowSubGroupsState extends State<SelectSubGroup> {
  double smsBalance = 0.00;
  showPopUp(int totalCount) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (context) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          totalCount == 0 ? "Select Contacts" : "Send Sms",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          totalCount == 0
                              ? "Please select participants"
                              : "Current balance",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      totalCount == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "$smsBalance",
                                style:
                                    TextStyle(fontSize: 22, color: Colors.red),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () async {
                            if (totalCount == 0) {
                              Navigator.pop(context);
                            } else {
                              List<ContactModel> selectedContact =
                                  Provider.of<ContactProvider>(context,
                                          listen: false)
                                      .selectedList;
                              List<SubGrpContacts> subGrpContacts =
                                  Provider.of<SubGrpContactsProvider>(context,
                                          listen: false)
                                      .selectedGroups;
                              print(
                                  "Subgroup Selected Length : ${subGrpContacts.length}");
                              await Provider.of<SendSmsProvider>(context,
                                      listen: false)
                                  .addContactsFromSelected(subGrpContacts);
                              Provider.of<SendSmsProvider>(context,
                                      listen: false)
                                  .addContactFromSingleSelected(
                                      selectedContact);
                              print(
                                  " seleted groups contacts ${Provider.of<SendSmsProvider>(context, listen: false).selectedContactList.length}");
                              String text = Provider.of<SendSmsProvider>(
                                      context,
                                      listen: false)
                                  .selectedTemplate
                                  .replaceAll("[[", "")
                                  .replaceAll("]]", "");
                              List<ContactModel> tempList =
                                  Provider.of<SendSmsProvider>(context,
                                          listen: false)
                                      .selectedContactList;

                              // print(numbers);
                              await Future.delayed(Duration(milliseconds: 500));
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              if (pref.getString('register') != null) {
                                print(pref.getString('register'));
                                RegisterModel reg = RegisterModel.fromJson(
                                    jsonDecode(pref.getString('register')!));
                                SendSmsModel model = SendSmsModel(
                                  message: text,
                                  orgid: int.parse(reg.orgid),
                                  senderid: reg.senderid,
                                  id: reg.user,
                                  contacts: tempList,
                                  provider: reg.provider,
                                  pwd: reg.pass,
                                  clientId: int.parse(reg.clientid),
                                );
                                bool success =
                                    await Provider.of<SendSmsProvider>(context,
                                            listen: false)
                                        .sendSmsNew(model);
                                // print("status $success");

                                Navigator.pop(context);
                                Navigator.pushNamed(context, success_screen);
                              } else {
                                Navigator.popAndPushNamed(context, register);
                              }
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: 50,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text(
                                totalCount == 0 ? "Close" : confirm_string,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      print('not lagging herer');
      Provider.of<ContactProvider>(context, listen: false).clearSelectedList();
      Provider.of<SubGrpContactsProvider>(context, listen: false).clearList();
      Provider.of<ContactProvider>(context, listen: false).readAllContacts();
      Provider.of<SubGroupProvider>(context, listen: false)
          .getSubgroupsFromDb();
      smsBalance = (await Provider.of<SendSmsProvider>(context, listen: false)
          .getWalletBalance())!;
      print('sms balance $smsBalance');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.group),
                text: "Sub Group",
              ),
              Tab(
                icon: Icon(Icons.contacts),
                text: "Contacts",
              ),
            ],
          ),
          title: const Text('Select Participants'),
        ),
        body: TabBarView(
          children: [listSubGroups(), ListContacts()],
        ),
        floatingActionButton: InkWell(
          onTap: () async {
            int count = 0;
            var selectedList =
                Provider.of<SendSmsProvider>(context, listen: false)
                    .selectedList;
            await Future.forEach(selectedList, (SubGroup element) async {
              print("this working");
              count = count +
                  await Provider.of<SubGrpContactsProvider>(context,
                          listen: false)
                      .getGrpContactsCount(element.id!);
              await Provider.of<SubGrpContactsProvider>(context, listen: false)
                  .getGrpContacts(element.id!);
              print("this working $count");
            });
            count = count +
                Provider.of<ContactProvider>(context, listen: false)
                    .selectedList
                    .length;
            print("count:  $count");
            showPopUp(count);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 50,
            decoration: BoxDecoration(
                color: kPrimaryColor, borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    send_sms,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget listSubGroups() {
  return Consumer<SubGroupProvider>(
    builder: (context, value, child) {
      print("list sub length ${value.getSubGroupList().length}");
      return value.getSubGroupList().isEmpty
          ? Center(
              child: Text(no_data_found),
            )
          : ListView.builder(
              itemCount: value.getSubGroupList().length,
              itemBuilder: (context, index) {
                return Consumer<SendSmsProvider>(
                  builder: (context, value1, child) {
                    return value1
                            .checkExistsSelected(value.getSubGroupList()[index])
                        ? ListItem(
                            model: value.getSubGroupList()[index],
                          )
                        : SelectedListItem(
                            model: value.getSubGroupList()[index]);
                  },
                );
              });
    },
  );
}

class ListItem extends StatefulWidget {
  final SubGroup model;
  final bool? showControls;
  final Function? function;

  const ListItem(
      {Key? key, required this.model, this.showControls, this.function})
      : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  int count = 0;
  void getCount() async {
    count = await Provider.of<SubGrpContactsProvider>(context, listen: false)
        .getGrpContactsCount(widget.model.id!);
    setState(() {
      print("getting count");

      print(count);
    });
  }

  @override
  void initState() {
    getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (widget.function == null) {
            Provider.of<SendSmsProvider>(context, listen: false)
                .addToSelectedList(widget.model);
          } else {
            // widget.function;
          }
        },
        child: Container(
          width: double.infinity,
          height: 80,
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
                Positioned(
                  top: 0,
                  left: 0,
                  child: Text(
                    widget.model.groupTitle!,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.model.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('$count contacts')),
                      ],
                    )
                  ],
                ),
              ],
            ),
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
    );
  }
}

class SelectedListItem extends StatelessWidget {
  final SubGroup model;
  const SelectedListItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Provider.of<SendSmsProvider>(context, listen: false)
              .addToSelectedList(model);
        },
        child: Container(
          width: double.infinity,
          height: 80,
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
                Positioned(
                  top: 0,
                  left: 25,
                  child: Text(
                    model.groupTitle!,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 25,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/ticked.png'))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        model.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
    );
  }
}

class ListContacts extends StatelessWidget {
  const ListContacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SearchBox(),
          Consumer<ContactProvider>(
            builder: (context, value, child) {
              return value.getContactList().isEmpty
                  ? Center(
                      child: Text('please Add Contacts'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: value.getContactList().length,
                      itemBuilder: (context, index) {
                        return ContactCard(model: value.contactList[index]);
                      });
            },
          ),
        ],
      ),
    ));
  }
}

class ContactCard extends StatelessWidget {
  final ContactModel model;
  const ContactCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(builder: (context, snapshot, child) {
      return snapshot.checkSelected(model)
          ? SelectedContactCard(
              model: model,
            )
          : Container(
              child: GestureDetector(
                  onTap: () {
                    Provider.of<ContactProvider>(context, listen: false)
                        .setSelectedList(model);
                  },
                  child: ListTile(
                    title: Text(
                      model.name!,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    subtitle: Text(
                      model.phoneNum!.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  )),
            );
    });
  }
}

class SelectedContactCard extends StatelessWidget {
  final ContactModel model;
  const SelectedContactCard({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Provider.of<ContactProvider>(context, listen: false)
              .deSelectList(model);
        },
        child: ListTile(
          tileColor: Colors.blue.shade100,
          title: Text(
            model.name!,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          subtitle: Text(
            model.phoneNum!.toString(),
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          trailing: Image.asset(
            'assets/images/ticked.png',
            width: 20,
            height: 20,
          ),
        ));
  }
}
