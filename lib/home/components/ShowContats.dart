import 'package:flutter/material.dart';
import 'package:gj_sms/add_contact/ContactModel.dart';
import 'package:gj_sms/add_contact/ContactsProvider.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/components/list_contacts_and_move_cntacts.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:gj_sms/home/provider/SubGrpContacts.dart';
import 'package:provider/provider.dart';

import '../../Constants.dart';
import '../../utils.dart';

class ShowContacts extends StatefulWidget {

  const ShowContacts({Key? key,}) : super(key: key);

  @override
  _ShowContactsState createState() => _ShowContactsState();
}

class _ShowContactsState extends State<ShowContacts> {
  final scaffoldState = GlobalKey<ScaffoldState>();


  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<ContactProvider>(context,listen: false).readAllContacts();
      Provider.of<ContactProvider>(context,listen: false).clearSelectedList();
      Provider.of<SubGroupProvider>(context,listen: false).getSubgroupsFromDb();

    });
  }
  void showSelectSUbCategory(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius:  BorderRadius.circular(10.0),
        ),
        builder: (context){
          return Container(
            height: MediaQuery.of(context).size.height-200,
            child: Consumer<SubGroupProvider>(
                builder: (context,value,child){
                  return ListView.builder(

                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: value.subGroupList.length,
                      addAutomaticKeepAlives: false,
                      itemBuilder: (context,index){
                        return InkWell(
                          onTap: (){
                            value.setSelectedModel(value.subGroupList[index]);
                            Navigator.pop(context);
                          },
                          child: ListTile(
                            leading: Text(index.toString()),
                            title: Text(value.subGroupList[index].title,style: TextStyle(color: Colors.black),),
                            subtitle: Text(value.subGroupList[index].groupTitle!,style: TextStyle(color: Colors.black)),

                          ),
                        );
                      }
                  );
                }
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text('Sub group contacts'),
      ),
      body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: (){
                         showSelectSUbCategory();
                        },
                        child: Consumer<SubGroupProvider>(
                        builder: (context,value,index){
                          return Text(value.selectedModel==null? 'Click to Select SubGroup':value.getSelectedModel()!.title,style: TextStyle(color:value.selectedModel==null?Colors.redAccent: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),);
                       },
                      )
                  ),
                  ),
                  SearchBox(),
                // FutureBuilder(
                //     builder: (context,index){
                //       return
                //     }
                // )
                  Expanded(
                    child: Consumer<ContactProvider>(
                    builder: (context,value,child){

                      return value.getContactList().isEmpty?Center(child: Text('please Add Contacts'),): ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.getContactList().length,
                          addAutomaticKeepAlives: false,
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context,index){
                            return value.checkSelected(value.contactList[index])?SelectedContactCard(
                                model: value.contactList[index]
                            ): ContactCard(
                                model: value.contactList[index]

                            );
                          }
                      );
                    },
                ),
                  ),

                ]
              ),

              Positioned(
                bottom: 0,
                  child: InkWell(
                    onTap: (){
                      SubGroup? grpModel = Provider.of<SubGroupProvider>(context,listen: false).getSelectedModel();
                      if(grpModel==null){
                        showSelectSUbCategory();
                      }
                      List<ContactModel> selList =  Provider.of<ContactProvider>(context,listen: false).selectedList;
                      Provider.of<SubGrpContactsProvider>(context,listen: false).insertGrpContacts(grpModel!.id!, selList);
                      showModalBottomSheet(context: context, builder: (context){
                        return Wrap(
                          children:[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                    Text('Contacts added',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black),),
                                    SizedBox(height: 20,),
                                    Text('${selList.length} Contacts added',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.black),),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: kPrimaryColor
                                        ),
                                        width: MediaQuery.of(context).size.width*0.6,
                                        height: 50,

                                      child: InkWell(
                                        onTap:(){
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ShowContactsOrMoveContacts(subId: Provider.of<SubGroupProvider>(context,listen: false).selectedModel!)));
                                      },
                                        child: Center(
                                        child: Text("Ok",style: TextStyle(color: Colors.white),),
                                        ),
                                      ) ,
                                  ),
                                    )
                                ],
                                  ) ,
                                )
                              ]
                        );
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: kPrimaryColor
                      ),
                      child: Center(
                        child: Text(
                          'Add to Sub Group',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
              )
            ],
          )

    );
  }
}
class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchTxtController = TextEditingController();
    return Container(
      child: grpTextFieldPhone(searchTxtController, "Search... ",context) ,
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
  const ContactCard({Key? key,required this.model,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(

          onTap:(){
          Provider.of<ContactProvider>(context,listen: false).setSelectedList(model);
          },
        child: ListTile(
          title: Text(model.name!,style: TextStyle(color: Colors.black,fontSize: 18),),
          subtitle: Text(model.phoneNum!.toString(),style: TextStyle(color: Colors.grey,fontSize: 14),),
        )
      ),
    );
  }
}
class SelectedContactCard extends StatelessWidget {
  final ContactModel model;
  const SelectedContactCard({Key? key,required this.model,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:(){
          Provider.of<ContactProvider>(context,listen: false).deSelectList(model);
        },
        child: ListTile(
          tileColor: Colors.blue.shade100,
          title: Text(model.name!,style: TextStyle(color: Colors.black,fontSize: 18),),
          subtitle: Text(model.phoneNum!.toString(),style: TextStyle(color: Colors.grey,fontSize: 14),),
          trailing: Image.asset('assets/images/ticked.png',width: 20,height: 20,),
        )
    );
  }
}

