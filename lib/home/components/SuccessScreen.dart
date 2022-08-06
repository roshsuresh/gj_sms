import 'package:flutter/material.dart';
import 'package:gj_sms/Size_Config.dart';
import 'package:gj_sms/home/provider/SendSmsProvider.dart';
import 'package:provider/provider.dart';

import '../../Constants.dart';
import '../../Routes.dart';
import '../../add_contact/ContactsProvider.dart';
import '../../utils.dart';
import '../provider/SubGrpContacts.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  double balance = 0;
  bool isBuildFinished = false;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<ContactProvider>(context, listen: false).clearSelectedList();
      Provider.of<SubGrpContactsProvider>(context, listen: false).clearList();
      Provider.of<SendSmsProvider>(context, listen: false).clearAllLists();
      int sucCount =
          Provider.of<SendSmsProvider>(context, listen: false).successCount;
      sucCount == 0
          ? showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: CenterFailed(),
                );
              })
          : showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: CenterSuccess(),
                );
              });
      Future.delayed(Duration(milliseconds: 1500), () {
        setState(() {
          isBuildFinished = true;
        });

        Navigator.pop(context);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !isBuildFinished
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BalanceBox(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Success :${Provider.of<SendSmsProvider>(context, listen: false).successCount} ',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Failed : ${Provider.of<SendSmsProvider>(context, listen: false).failedCount}',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, home);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                              child: Text(
                            'Ok',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}

class BalanceBox extends StatefulWidget {
  const BalanceBox({Key? key}) : super(key: key);

  @override
  State<BalanceBox> createState() => _BalanceBoxState();
}

class _BalanceBoxState extends State<BalanceBox> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<SendSmsProvider>(context, listen: false).getWalletBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height: SizeConfig.screenHeight! * 0.4,
      decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Balance',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: Provider.of<SendSmsProvider>(context, listen: false)
                .getWalletBalance(),
            builder: (context, value) {
              if (value.hasData) {
                double? balance = value.data as double?;
                return Center(
                  child: Text(
                    '${balance == null ? 0 : balance}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    '0',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
