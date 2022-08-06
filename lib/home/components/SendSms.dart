
import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/home/models/TemplateModel.dart';
import 'package:gj_sms/home/provider/SendSmsProvider.dart';
import 'package:provider/provider.dart';

import '../../Size_Config.dart';
import '../../utils.dart';
class SendSms extends StatelessWidget {

  const SendSms({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
            child: Text('Send Sms')),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        child:ListTemplates() ,
      ),
    );
  }
}
class ListTemplates extends StatefulWidget {
  const ListTemplates({Key? key}) : super(key: key);

  @override
  _ListTemplatesState createState() => _ListTemplatesState();
}

class _ListTemplatesState extends State<ListTemplates> {



  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
    Provider.of<SendSmsProvider>(context,listen: false).getTemplatesFromServer('10000',context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text('Select Template',style: TextStyle(fontSize: 20,color: Colors.black),)),
          ),
          Expanded(
            child: Consumer<SendSmsProvider>(

              builder: (context,value,index){
                print("${value.tempModelList.length} template length");
                return value.tempModelList.isEmpty?Center(child: Text('No Templates to show'),)  :ListView.builder(

                    scrollDirection: Axis.vertical,
                    itemCount: value.tempModelList.length,
                    itemBuilder: (context,index){
                      return SmsTemplateTile(
                          model: value.tempModelList[index],
                          count: index
                      );
                    }
                );
              },

            ),
          )
        ],
      ),
    );
  }
}

class SmsTemplateTile extends StatelessWidget {
  final TemplateModel model;
  final int count;
  const SmsTemplateTile({Key? key,required this.model, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var templateLength =model.templatecontent.length;
 
    int splitRange=   (templateLength/40).ceil();

    int temp=0;
    String newTemplate = "";

    if (templateLength<40) {
      newTemplate =model.templatecontent;
    }else{
      for(int i =1;i<splitRange;i++){

        String tempStr=model.templatecontent;

        var t= tempStr.substring(temp,40*i);
        newTemplate+=t+"\n";

        temp+=40;
        if(i==splitRange-1){
          if (40*splitRange != templateLength) {
            newTemplate =newTemplate+tempStr.substring(temp,templateLength);
          }
        }
      }
    }


    return  Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        onTap: (){
          Provider.of<SendSmsProvider>(context,listen: false).setTemplate(model.templatecontent.replaceAll("\n", " "));
          sendMessageDialogue(context,model,model.templatecontent.replaceAll("\n", " "));
        },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(model.templatename.replaceAll("\n", " ") ,style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),)),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: newTemplate
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );

  }
}

