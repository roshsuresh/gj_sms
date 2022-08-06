import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gj_sms/group/model/groupmodel.dart';
import 'package:gj_sms/group/model/sub_group.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:provider/provider.dart';
//
// class SubGroups extends StatefulWidget {
//   const SubGroups({Key? key}) : super(key: key);
//
//   @override
//   _SubGroupState createState() => _SubGroupState();
// }
//
// class _SubGroupState extends State<SubGroups> {
//
//   @override
//   void initState() {
//     WidgetsBinding.instance!.addPostFrameCallback((_) async {
//       Provider.of<SubGroupProvider>(context,listen: false).getSubgroupsFromDb();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(sub_group_report),),
//       body: Container(
//         child: listSubGroups(),
//       ),
//     );
//   }
// }

// Widget listSubGroups(){
//   return  Consumer<SubGroupProvider>(
//     builder: (context,value,child){
//       print("list sub length ${value.getSubGroupList().length}");
//       return value.getSubGroupList().isEmpty?Center(
//         child: Text(no_data_found),
//       ): ListView.builder(
//           itemCount: value.getSubGroupList().length,
//           itemBuilder: (context,index){
//             return ListItem(model: value.getSubGroupList()[index],);
//           }
//       );
//     },
//
//   );
// }
class ListItem extends StatelessWidget {
  final SubGroup model;
  final GroupModel groupModel;
  const ListItem({Key? key, required this.model, required this.groupModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(model.toMap());
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      model.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                            onTap: () {
                              // subGroupModelSheet(context, update, model,);
                            },
                            child: Icon(Icons.edit)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                            onTap: () async {
                              showAlertBox(context, model.id!);
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
