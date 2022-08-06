import 'package:flutter/material.dart';
import 'package:gj_sms/sms_log/model/SmsLogModel.dart';
import 'package:gj_sms/sms_log/provider/sms_log_provider.dart';
import 'package:provider/provider.dart';

class SmsLog extends StatefulWidget {
  const SmsLog({Key? key}) : super(key: key);

  @override
  State<SmsLog> createState() => _SmsLogState();
}

class _SmsLogState extends State<SmsLog> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<SmsLogProvider>(context,listen: false).getLog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log'),),
      body:Container(


        child: Consumer<SmsLogProvider>(
          builder: (context,snap,child){
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snap.modelList.length,
                itemBuilder: (context,index){
                  return SmsLogTile(model: snap.modelList[index],index: index,);
                }
            );
          },
        )
      )

    );
  }
}

class SmsLogTile extends StatelessWidget {
  final SmsLogModel model;
  final int index;
  const SmsLogTile({Key? key, required this.model, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(model.data!.msg,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Success: ${model.data!.success}'),
                  SizedBox(width: 4,),
                  Text('Failed: ${model.data!.fail}'),
                ],
              ),

            ),
            Consumer<SmsLogProvider>(
                builder: (context,snap,child){
                  return InkWell(
                      onTap: (){
                        snap.setExpandList(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(model.visible?Icons.keyboard_arrow_up:Icons.keyboard_arrow_down,size: 30,),
                      ));
                },
                )
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Consumer<SmsLogProvider>(

            builder: (context, snapshot,child) {
              return Visibility(
                visible: model.visible,
                child: ListView.builder(
                  shrinkWrap: true,
                    itemCount: model.details.length,
                    itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(model.details[index].name,style: TextStyle(fontWeight: FontWeight.bold),),
                    trailing: Text(model.details[index].phone),
                  );
               })
              );
            }
          ),
        ),
      ],

    );
  }
}
