import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:gj_sms/home/provider/SendSmsProvider.dart';
import 'package:provider/provider.dart';

import '../../Routes.dart';
import '../../add_contact/ContactModel.dart';
import '../../add_contact/ContactsProvider.dart';
import '../../group/componets/show_contacts_withid.dart';
import '../provider/SubGrpContacts.dart';

class ShowContactsOrMoveContacts extends StatefulWidget {
  final SubGroup subId;
  const ShowContactsOrMoveContacts({Key? key, required this.subId})
      : super(key: key);

  @override
  State<ShowContactsOrMoveContacts> createState() =>
      _ShowContactsOrMoveContactsState();
}

class _ShowContactsOrMoveContactsState
    extends State<ShowContactsOrMoveContacts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<ContactProvider>(context, listen: false).clearSelectedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: Stack(
        children: [
          Consumer<ContactProvider>(
            builder: (_, snap, child) {
              return snap.selectedList.isNotEmpty
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        height: 60,
                        child: Card(
                          child: SizedBox(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.red),
                                      child: Center(
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    List<ContactModel> selectedList =
                                        Provider.of<ContactProvider>(context,
                                                listen: false)
                                            .selectedList;
                                    for (var i in selectedList) {
                                      await Provider.of<SubGrpContactsProvider>(
                                              context,
                                              listen: false)
                                          .deleteGrpContacts(
                                              widget.subId.id!, i.id!, context);
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ShowContactsOrMoveContacts(
                                                  subId: widget.subId,
                                                )));
                                  },
                                ),
                                // InkWell(
                                //   onTap: (){
                                //     showBottomSheet(
                                //         context: context,
                                //         builder: (_){
                                //           return Consumer<SubGroupProvider>(
                                //             builder: (context,value,child){
                                //               print("list sub length ${value.getSubGroupList().length}");
                                //               return value.getSubGroupList().isEmpty?Center(
                                //                 child: Text(no_data_found),
                                //               ): ListView.builder(
                                //                   itemCount: value.getSubGroupList().length,
                                //                   itemBuilder: (context,index){
                                //                     return InkWell(
                                //                         onTap: (){
                                //
                                //                         },
                                //                         child: ListItem(model: value.getSubGroupList()[index],));
                                //                   }
                                //               );
                                //             },
                                //
                                //           );
                                //         }
                                //     )
                                //   },
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Container(
                                //       width: MediaQuery.of(context).size.width*0.4,
                                //       decoration: BoxDecoration(
                                //           borderRadius: BorderRadius.circular(8),
                                //           color: Colors.green
                                //       ),
                                //       child: Center(
                                //         child: Text('Move'),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  : Container();
            },
          ),
          SafeArea(
            child: Column(
              children: [
                FutureBuilder(
                  future: Provider.of<SendSmsProvider>(context, listen: false)
                      .getContactsForSingleGroup(widget.subId.id!),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ContactModel>> snapshot) {
                    if (snapshot.hasData) {
                      List<ContactModel> da =
                          snapshot.data as List<ContactModel>;
                      print('getted data${da.length}');
                      return Consumer<ContactProvider>(
                        builder: (_, snap, child) {
                          return Expanded(
                            child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: da.length,
                                itemBuilder: (context, index) {
                                  return snap.checkSelected(da[index])
                                      ? ContactCardSelected(
                                          model: da[index],
                                          subID: widget.subId.id!,
                                        )
                                      : ContactCard(
                                          model: da[index],
                                          showDelete: true,
                                          subID: widget.subId,
                                        );
                                }),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<SubGroupProvider>(context, listen: false)
              .setSelectedModel(widget.subId);
          Navigator.pushNamed(context, sub_group_contact);
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

class ContactCard extends StatelessWidget {
  final ContactModel model;
  final bool? showDelete;
  final bool? selected;
  final SubGroup subID;
  const ContactCard(
      {Key? key,
      required this.model,
      this.showDelete,
      this.selected,
      required this.subID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white70),
        child: Consumer<ContactProvider>(
          builder: (_, snap, child) {
            return InkWell(
              onTap: () {
                snap.setSelectedList(model);
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
                  trailing: showDelete != null
                      ? InkWell(
                          onTap: () {
                            showAlertDialog(
                                context: context,
                                title: 'Are you sure',
                                content:
                                    'This will delete the contact from this group',
                                defaultActionText: 'Delete',
                                function: () {
                                  Provider.of<SubGrpContactsProvider>(context,
                                          listen: false)
                                      .deleteGrpContacts(
                                          subID.id!, model.id!, context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ShowContactsOrMoveContacts(
                                                subId: subID,
                                              )));
                                });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.green.shade300,
                          ))
                      : SizedBox(
                          width: 10,
                          height: 10,
                        )),
            );
          },
        ),
      ),
    );
  }
}

class ContactCardSelected extends StatelessWidget {
  final ContactModel model;
  final bool? showDelete;
  final bool? selected;
  final int subID;
  const ContactCardSelected(
      {Key? key,
      required this.model,
      this.showDelete,
      this.selected,
      required this.subID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white70),
        child: Consumer<ContactProvider>(
          builder: (_, snap, child) {
            return InkWell(
              onTap: () {
                snap.setSelectedList(model);
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
                  selectedTileColor: Colors.blue.shade300,
                  selected: true,
                  trailing: showDelete != null
                      ? InkWell(
                          onTap: () {
                            snap.setSelectedList(model);
                            // showAlertDialog(context: context, title: 'Are you sure', content: 'this will delete the contact from this group', defaultActionText: 'Delete', function: (){Provider.of<SubGrpContactsProvider>(context,listen: false).deleteGrpContacts(subID, model.id!,context);});
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.green.shade300,
                          ))
                      : SizedBox(
                          width: 10,
                          height: 10,
                        )),
            );
          },
        ),
      ),
    );
  }
}
