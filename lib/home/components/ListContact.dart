import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/add_contact/ContactsProvider.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ShowContats.dart';

class ListContactsReport extends StatefulWidget {
  const ListContactsReport({Key? key}) : super(key: key);

  @override
  _ListContactsReportState createState() => _ListContactsReportState();
}

class _ListContactsReportState extends State<ListContactsReport> {

  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<ContactProvider>(context,listen: false).readAllContacts();
      Provider.of<SubGroupProvider>(context,listen: false).getSubgroupsFromDb();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Builder(
          builder: (context) {
            return Stack(
              children: [
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchBox(),
                        Consumer<ContactProvider>(
                          builder: (context,value,child){

                            return value.getContactList().isEmpty?Center(child: Text('please Add Contacts'),): Expanded(
                              child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: value.getContactList().length,
                                  itemBuilder: (context,index){
                                    return ContactCard(
                                        model: value.contactList[index],
                                      showDelete: true,

                                    );
                                  }
                              ),
                            );
                          },
                        ),

                      ]
                  ),
                ),

              ],
            );
          }
      ),
    );
  }
}
Widget grpTextFieldPhone(TextEditingController controller,String title,BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
    child: TextFormField(


      onChanged: (val){
        Provider.of<ContactProvider>(context,listen: false).getContactsWithKey(val);
      },
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),

          focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: "$title",
          hintText: "Enter $title ",
          suffixIcon: Icon(Icons.search)
      ),
    ),
  );
}
class ContactCard extends StatelessWidget {
  final ContactModel model;
  final bool? showDelete;
  const ContactCard({Key? key,required this.model, this.showDelete,}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white70
        ),
        child: GestureDetector(

            onTap:(){
              if(showDelete!=null){
                Provider.of<ContactProvider>(context,listen: false).setSelectedList(model);
              }

            },
            
            child: ListTile(
              title: Text(model.name!,style: TextStyle(color: Colors.black,fontSize: 18),),
              subtitle: Text(model.phoneNum!.toString(),style: TextStyle(color: Colors.grey,fontSize: 14),),
              trailing:Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () async{
                          var url = 'tel:${model.phoneNum}';
                          if (await canLaunch(url)) {
                          await launch(url);
                          } else {
                          throw 'Could not launch $url';
                          }
                        },
                        child: Icon(Icons.call,color: Colors.green,)),
                  ),
                  showDelete!=null?   InkWell(
                      onTap: (){
                        showAlertDialog(context: context, title: 'Are you sure', content: 'this will delete the contact permanently', defaultActionText: 'Delete', function: (){Provider.of<ContactProvider>(context,listen: false).deleteContact(model.id!);});

                      },
                      child: Icon(Icons.delete,color: Colors.green.shade300,)
                  ):SizedBox(width: 10,height: 10,)
                ],
              )
              
            )
        ),
      ),
    );
  }
}
Future showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
  required Function function
}) async {
  if (!Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
          FlatButton(
              child: Text(cancelActionText),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          FlatButton(
            child: Text(defaultActionText),
            onPressed: () {
              function();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }


  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}