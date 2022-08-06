import 'dart:io';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/Routes.dart';
import 'package:gj_sms/Size_Config.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/add_contact/ContactsProvider.dart';
import 'package:gj_sms/group/model/groupmodel.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:gj_sms/home/provider/GroupProvider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';


import 'home/components/SelectsubGroup.dart';
import 'home/models/TemplateModel.dart';
import 'home/provider/SendSmsProvider.dart';

//group  model bottom sheet
Future<dynamic> groupModelSheet(
    BuildContext context, String title, GroupModel? model) {
  final grpFromKey = GlobalKey<FormState>();
  final titleNameController = TextEditingController();
  Provider.of<GroupCreateProvider>(context, listen: false).setErrorTxt();
  String errorTxt = "";
  if (model != null) {
    titleNameController.text = model.title;
  }
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        SizeConfig().init(context);
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 300,
            child: Form(
              key: grpFromKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title == update ? update + " Group" : createGrp,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  grpTextField(titleNameController, "Group"),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                    child: InkWell(
                      onTap: () async {
                        bool valid = grpFromKey.currentState!.validate();
                        if (!valid) {
                          return;
                        }
                        grpFromKey.currentState!.save();

                        if (title == update) {
                          await Provider.of<GroupCreateProvider>(context,
                                  listen: false)
                              .updateGroup(GroupModel(
                                  model!.id, titleNameController.text,
                                  expand: false));
                          Navigator.pop(context);
                          showAlertCenter(context, "Group Updated",
                              "Sub Group Updated successfully");
                        } else {
                          if (await Provider.of<GroupCreateProvider>(context,
                                      listen: false)
                                  .addGroup(
                                      titleNameController.text.toString()) ==
                              true) {
                            Navigator.pop(context);
                            showAlertCenter(context, "Group Added",
                                "Group Added successfully");
                          }
                        }
                      },
                      child: Container(
                        width: SizeConfig.screenWidth,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kPrimaryColor),
                        child: Center(
                            child: Text(
                          title == update ? update : create,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ),
                  Consumer<GroupCreateProvider>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          value.getErrorTxt(),
                          style: TextStyle(
                              color: value.getErrorTxt() == group_added
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 16),
                        )),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      });
}

//sub group model bottom sheet
Future<dynamic> subGroupModelSheet(BuildContext context, String title,
    SubGroup? model, GroupModel grpModel) async {
  Provider.of<GroupCreateProvider>(context, listen: false).emptySelection();
  Provider.of<SubGroupProvider>(context, listen: false).setErrorTxt();
  await Provider.of<GroupCreateProvider>(context, listen: false)
      .getGroupsFromDb();
  final _subGrpFromKey = GlobalKey<FormState>();
  final subtitleNameController = TextEditingController();

  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        SizeConfig().init(context);
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: title == update ? 350 : 400,
            child: Form(
              key: _subGrpFromKey,
              child: Provider.of<GroupCreateProvider>(context, listen: false)
                      .getGroups()
                      .isEmpty
                  ? Center(
                      child: Container(
                      child: Text('Add Group to create subgroup'),
                    ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title == update
                                ? update + " Sub group"
                                : create_sub_group,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        // groupDropdown(context, title),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            grpModel.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        grpTextField(subtitleNameController, "Sub Group"),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 50),
                          child: InkWell(
                            onTap: () async {
                              bool valid =
                                  _subGrpFromKey.currentState!.validate();
                              if (!valid) {
                                return;
                              }
                              _subGrpFromKey.currentState!.save();
                              if (title == update) {
                                Provider.of<SubGroupProvider>(context,
                                        listen: false)
                                    .updateSubGroup(SubGroup(
                                        title: subtitleNameController.text
                                            .toString(),
                                        id: model!.id,
                                        groupId: model.groupId));
                                Navigator.pop(context);
                                showAlertCenter(context, "Sub Group Updated",
                                    "Sub Group Updated successfully");
                              } else {
                                if (await Provider.of<SubGroupProvider>(context,
                                            listen: false)
                                        .insertSubGroup(SubGroup(
                                            title: subtitleNameController.text
                                                .toString(),
                                            groupId: grpModel.id)) ==
                                    true) {
                                  Navigator.pop(context);
                                  showAlertCenter(context, "Sub Group Added",
                                      "Sub Group added successfully");
                                }
                              }
                            },
                            child: Container(
                              width: SizeConfig.screenWidth,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: kPrimaryColor),
                              child: Center(
                                  child: Text(
                                title == update ? update : create,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ),
                        ),
                        Consumer<SubGroupProvider>(
                            builder: (context, value, child) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              value.getErrorTxt(),
                              style: TextStyle(
                                  color: value.getErrorTxt() == sub_group_added
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 18),
                            )),
                          );
                        })
                      ],
                    ),
            ),
          ),
        );
      });
}

Widget groupDropdown(BuildContext context, String title) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: title == update
        ? Container()
        : Consumer<GroupCreateProvider>(
            builder: (context, value, child) {
              return DropdownButtonFormField<GroupModel>(
                validator: (models) {
                  if (models == null) {
                    return "Select group";
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30),
                      ),
                      borderSide: BorderSide(color: kTextColor)),
                  labelText: "Group",
                  hintText: "Select Sub Group Name",
                ),
                items: value
                    .getGroups()
                    .map((e) => DropdownMenuItem<GroupModel>(
                          child: Text(e.title),
                          value: e,
                        ))
                    .toList(),
                value: value.getSelectedItem(),
                onChanged: (model) {
                  value.setSelectedGroup(model!);
                },
              );
            },
          ),
  );
}

//key 1 text field
Widget grpTextField(TextEditingController controller, String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter $title Name";
        }
      },
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: "$title Name",
          hintText: "Enter $title Name ",
          prefixIcon: Icon(Icons.group)),
    ),
  );
}

Widget grpTextFieldPhone(TextEditingController controller, String title) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter $title";
        } else if (value.length != 10) {
          return "Please enter a valid phone number!";
        } else if (value.contains("+")) {
          return "No need to enter +91";
        }
      },
      keyboardType: TextInputType.phone,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: "$title",
          hintText: "Enter $title ",
          prefixIcon: Icon(Icons.group)),
    ),
  );
}

Future<dynamic> addContactModelSheet(
    BuildContext context, String title, ContactModel? model) async {
  Provider.of<ContactProvider>(context, listen: false).emptyError();
  final cntNameTextController = TextEditingController();
  final cntPhoneTextController = TextEditingController();
  final formKeyContact = GlobalKey<FormState>();
  SizeConfig().init(context);
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 400,
            child: Form(
              key: formKeyContact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title == update ? update + " Contact" : add_contact,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25),
                    ),
                  ),
                  grpTextField(cntNameTextController, "Full"),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  grpTextFieldPhone(cntPhoneTextController, "Phone"),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: InkWell(
                      onTap: () async {
                        bool valid = formKeyContact.currentState!.validate();
                        if (!valid) {
                          return;
                        }
                        formKeyContact.currentState!.save();
                        if (title == update) {
                        } else {
                          if (await Provider.of<ContactProvider>(context,
                                  listen: false)
                              .addContacts(ContactModel(
                                  name: cntNameTextController.text.toString(),
                                  phoneNum: int.parse(
                                      cntPhoneTextController.text)))) {
                            Navigator.pop(context);
                            showAlertCenter(context, "Contact Added",
                                "Contact added successfully");
                          }
                        }
                      },
                      child: Container(
                        width: SizeConfig.screenWidth,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: kPrimaryColor),
                        child: Center(
                            child: Text(
                          title == update ? update : "Add Contact",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ),
                  Consumer<ContactProvider>(builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        value.getError(),
                        style: TextStyle(
                            color: value.getError() == sub_group_added
                                ? Colors.green
                                : Colors.red,
                            fontSize: 18),
                      )),
                    );
                  })
                ],
              ),
            ),
          ),
        );
      });
}

showSubCategories(BuildContext context) {
  // Provider.of<SubGroupProvider>(context,listen: false).getSubgroupsFromDb();
  showBottomSheet(
      context: context,
      builder: (context) {
        return Container();
        // return Consumer<SubGroupProvider>(
        //     builder: (context,value,child){
        //       return ListView.builder(
        //           itemBuilder: (context,index){
        //             return ListTile(
        //               leading: Text(index.toString()),
        //               title: Text(value.subGroupList[index].title,style: TextStyle(color: Colors.black),),
        //               subtitle: Text(value.subGroupList[index].groupTitle!,style: TextStyle(color: Colors.black)),
        //        //             );
        //           }
        //       );
        //     }
        // );
      });
}

Future<dynamic> sendMessageDialogue(
    BuildContext context, TemplateModel model, String formattedTemp) {
  List<Widget> inputBox = [];
  RegExp squreRegex = new RegExp(r'\[\[(.*?)\]\]', multiLine: true);
  List<String> conList =
      model.editvariables == null ? [] : model.editvariables!.split(",");
  String data = "";
  int count = squreRegex.allMatches(formattedTemp).length;
  print("count length $count");
  for (int i = 0; i < count; i++) {
    inputBox.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter ${conList[i]}";
            }
          },
          onChanged: (val) {
            data = val;
          },
          onSaved: (val) {},
          //  keyboardType: TextInputType.phone,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            labelText: "${conList[i]}",
            hintText: "Enter ${conList[i]} ",
          ),
        )));
  }
  print("input box length ${inputBox.length}");
  final smsFormKey = GlobalKey<FormState>();
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return SmsPopUp(
          model: model,
          formattedTemplate: formattedTemp,
        );
      });
}

class SmsPopUp extends StatefulWidget {
  final TemplateModel model;
  final String formattedTemplate;
  const SmsPopUp(
      {Key? key, required this.model, required this.formattedTemplate})
      : super(key: key);

  @override
  _SmsPopUpState createState() => _SmsPopUpState();
}

class _SmsPopUpState extends State<SmsPopUp> {
  String data = "fd";
  List<Widget> inputBox = [];

  @override
  void initState() {
    List<String> conList = widget.model.editvariables == null
        ? []
        : widget.model.editvariables!.split(",");
    String data = "";
    RegExp squreRegex = new RegExp(r'\[\[(.*?)\]\]', multiLine: true);
    int count = squreRegex.allMatches(widget.formattedTemplate).length;
    for (int i = 0; i < count; i++) {
      inputBox.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter ${conList[i]}";
              }
            },
            onChanged: (val) {
              RegExp squreRegex = new RegExp(r'\[\[(.*?)\]\]', multiLine: true);
              String temtT =
                  Provider.of<SendSmsProvider>(context, listen: false)
                      .selectedTemplate;
              int j = 0;
              String newString = temtT.replaceAllMapped(squreRegex, (match) {
                print('ji');
                while (j < 4) {
                  print(" i $i j $j");
                  if (i == j) {
                    j++;
                    return "[[$val]]";
                  } else {
                    print("else worked");
                    j++;
                    return '${match.group(0)}';
                  }
                }

                return '${match.group(0)}';
              });
              print("new string\t" + newString);
              Provider.of<SendSmsProvider>(context, listen: false)
                  .setTemplate(newString);
            },

            onFieldSubmitted: (val) {
              RegExp squreRegex = new RegExp(r'\[\[(.*?)\]\]', multiLine: true);
              String temtT =
                  Provider.of<SendSmsProvider>(context, listen: false)
                      .selectedTemplate;
              int j = 0;
              String newString = temtT.replaceAllMapped(squreRegex, (match) {
                print('ji');
                while (j < 4) {
                  print(" i $i j $j");
                  if (i == j) {
                    j++;
                    return "[[$val]]";
                  } else {
                    print("else worked");
                    j++;
                    return '${match.group(0)}';
                  }
                }

                return '${match.group(0)}';
              });
              print("new string\t" + newString);
              Provider.of<SendSmsProvider>(context, listen: false)
                  .setTemplate(newString);
            },
            onSaved: (val) {
              String temtT =
                  Provider.of<SendSmsProvider>(context, listen: false)
                      .selectedTemplate;
              print(
                  "=======================================$val========================================================================");
              temtT = temtT.replaceAll("[[${conList[i]}]]", val!);
              print(
                  "=======================================$temtT========================================================================");
              Provider.of<SendSmsProvider>(context, listen: false)
                  .setTemplate(temtT);
            },
            //  keyboardType: TextInputType.phone,

            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              labelText: "${conList[i]}",
              hintText: "Enter ${conList[i]} ",
            ),
          )));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Wrap(children: [
        Container(
          //   height: MediaQuery.of(context).size.height * 0.75,
          child: Form(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Consumer<SendSmsProvider>(
                        builder: (context, value, child) {
                          print("selected template\t" + value.selectedTemplate);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              value.selectedTemplate
                                  .replaceAll("[[", "")
                                  .replaceAll("]]", ""),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: inputBox,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => SelectSubGroup(),
                        ),
                      );
                    },
                    child: Container(
                      width: SizeConfig.screenWidth,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: kPrimaryColor),
                      child: Center(
                          child: Text(
                        send_sms,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

void importContacts(BuildContext context) async {
  // Request contact permission
  // if () {
  //   // Get all contacts (lightly fetched)
  //
  //  // List<ContactModel> contactList=contacts.map((e) => ContactModel(name: e.displayName, phoneNum:int.parse(e.phones!.isNotEmpty?e.phones!.first.toString():0.toString()))).toList();
  //  //  print("sorted contact list size ${contactList.length}");
  //  //  contactList.forEach((element) async{
  //  //    await Provider.of<ContactProvider>(context,listen: false).addContacts(element);
  //  //    print("added");
  //  //  });
  //
  //   showDialog(
  //       context: context,
  //       builder: (context){
  //         return Wrap(
  //           children:[
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Container(
  //                 color: Colors.white,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Center(
  //                       child: Image.asset("assets/images/ticked.png",width: 50,height: 50,),
  //                     ),
  //                    // Text('${contactList.length} imported successfully')
  //                   ],
  //                 ),
  //           ),
  //             ),
  //           ]
  //         );
  //       }
  //   );
  //
  // }
  //Iterable<Contact> _contacts;

  // if (permissionStatus == PermissionStatus.granted) {
  //   _contacts = await ContactsService.getContacts();
  //   print(_contacts.length);
  // } else{
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) => CupertinoAlertDialog(
  //         title: Text('Permissions error'),
  //         content: Text('Please enable contacts access '
  //             'permission in system settings'),
  //         actions: <Widget>[
  //           CupertinoDialogAction(
  //             child: Text('OK'),
  //             onPressed: () => Navigator.of(context).pop(),
  //           )
  //         ],
  //       ));
  // }
}

Future<void> getContacts(BuildContext context) async {
  List<Contact>? contacts;
  print("sdfsdfdsf");
  FlutterContacts.config.includeNotesOnIos13AndAbove = true;
  FlutterContacts.config.returnUnifiedContacts = false;
  if (await FlutterContacts.requestPermission()) {


    // Get all contacts (lightly fetched)
    // List<Contact> contacts = await FlutterContacts.getContacts();
    // print("sdfsdfdsf ${contacts.length}");

    // Get all contacts (fully fetched)
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });



    //// Contacts.streamContacts().forEach((contact) {
    ////   contact.phones.forEach((element) async {
    // //    if (element.value != null &&
    ////         await DatabaseHelper.db
    ////             .checkContact(int.parse(element.value!.toString()))) {
    ////       try {
    ////         await Provider.of<ContactProvider>(context, listen: false)
    ////             .addContacts(ContactModel(
    ////                 name: contact.displayName,
    // //                phoneNum: int.parse(element.value!)));
    // //      } catch (e) {
    //  //       print(e);
    //    //   }
    //  //   }
    // //  });
    // //}
    // //);



    // contacts = await FlutterContacts.getContacts(
    //     withProperties: true, withPhoto: true);

    // for(int i=0;i<contacts.length;i++){
    //   print(contactList.length);
    //   contacts[i].phones.forEach((element) {
    //
    //         print(element.number);
    //   });
    // }
    // Get contact with specific ID (fully fetched)

    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CenterSuccess(),
          );
        });
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.pop(context);
    });
  } else {
    print("not wir");
  }

  // contacts.forEach((element) async{
  //     await Provider.of<ContactProvider>(context,listen: false).addContacts(element);
  //     print("added");
  // });

  //
  // contacts.forEach((contact) async {
  //   var mobilenum = contact.phones!.toList();
  //
  //   if (mobilenum.length != 0) {
  //     var userContact = ContactModel(
  //         name: contact.displayName,
  //         phoneNum: mobilenum[0].value.toString(),
  //        );
  //     _userList.add(userContact);
  //     iter++;
  //   } else {
  //     iter++;
  //   }
  // }
}

class CenterSuccess extends StatelessWidget {
  const CenterSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/images/success.riv',
      fit: BoxFit.cover,
    );
  }
}

class CenterFailed extends StatelessWidget {
  const CenterFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/images/error.riv',
      fit: BoxFit.cover,
    );
  }
}

class MessageSuccess extends StatelessWidget {
  const MessageSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      'assets/images/message.riv',
      fit: BoxFit.cover,
    );
  }
}

void messageSuccess(BuildContext context, int success, int failed) {
  print('df');
  showDialog(
      context: context,
      builder: (context) {
        return Center(child: MessageSuccess());
      });
  // Future.delayed(Duration(milliseconds: 1500),(){
  //   Navigator.pushReplacementNamed(context,success_screen,arguments: {"success":15,"failed":0});
  // });

  // showDialog(context: context, builder: (context){
  //   return Scaffold(
  //     body: Center(
  //       child: Container(
  //         child: Column(
  //           children: [
  //             SizedBox(height: 10,),
  //             Text('Success : $success',style: TextStyle(color: Colors.black,fontSize: 17),),
  //             SizedBox(height: 10,),
  //             Text('Failed : $failed',style: TextStyle(color: Colors.black,fontSize: 17),),
  //             SizedBox(height: 10,),
  //             InkWell(
  //               onTap: (){
  //                 Navigator.pushReplacementNamed(context, home);
  //               },
  //               child: Container(
  //                 height: 50,
  //                 decoration: BoxDecoration(
  //                     color: kPrimaryColor,
  //                     borderRadius: BorderRadius.circular(15)
  //                 ),
  //                 child: Text('Ok',style: TextStyle(color: Colors.white),),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     )
  //   );
  // });
}

void importContactsFromExcel(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      print(table); //sheet Name
      print(excel.tables[table]!.maxCols);
      print(excel.tables[table]!.maxRows);
      try {
        if (excel.tables[table]!.maxCols == 3) {
          for (var row in excel.tables[table]!.rows) {
            row.forEach((element) async {
              ContactModel model = ContactModel(
                  name: element!.value['name'],
                  phoneNum: element.value['phone'],
                  course: element.value['course']);
              await Provider.of<ContactProvider>(context, listen: false)
                  .addContacts(model);
            });
          }
          showDialog(
              context: context,
              builder: (context) {
                return CenterSuccess();
              });
          break;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please select correct data")));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please select correct data")));
      }
    }
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return Failed();
        });
  }
}

class Failed extends StatelessWidget {
  const Failed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sorry,Something went wrong',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    backgroundColor: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showAlertCenter(BuildContext context, String type, String message) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Column(
            children: <Widget>[
              Text("$type"),
              Image.asset(
                'assets/images/ticked.png',
                height: 50,
                width: 50,
              )
            ],
          ),
          content: new Text("$message"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.popAndPushNamed(context, group_list);
              },
            ),
          ],
        );
      });
}
