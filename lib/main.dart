import 'dart:io';

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gj_sms/Constants.dart';
import 'package:gj_sms/Register/provider/register_provider.dart';
import 'package:gj_sms/Register/register_view.dart';
import 'package:gj_sms/Routes.dart';
import 'package:gj_sms/add_contact/ContactsProvider.dart';
import 'package:gj_sms/group_synch/group_sync_proivder.dart';
import 'package:gj_sms/home/home.dart';
import 'package:gj_sms/home/provider/CreateSubGroupProvider.dart';
import 'package:gj_sms/home/provider/GroupProvider.dart';
import 'package:gj_sms/home/provider/HomeProvider.dart';
import 'package:gj_sms/home/provider/SendSmsProvider.dart';
import 'package:gj_sms/sms_log/provider/sms_log_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/provider/SubGrpContacts.dart';

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
        ChangeNotifierProvider(create: (context) => GroupCreateProvider()),
        ChangeNotifierProvider(create: (context) => SubGroupProvider()),
        ChangeNotifierProvider(create: (context) => ContactProvider()),
        ChangeNotifierProvider(create: (context) => SubGrpContactsProvider()),
        ChangeNotifierProvider(create: (context) => SendSmsProvider()),
        ChangeNotifierProvider(create: (context) => SmsLogProvider()),
        ChangeNotifierProvider(create: (context) => GroupSyncProvider()),
      ],
      child: MaterialApp(
        title: 'Gj SMS',
        theme: ThemeData(
            textTheme:
                TextTheme(bodyText1: TextStyle(color: kPrimaryLightColor)),
            primarySwatch: Colors.blue,
            appBarTheme: AppBarTheme(backgroundColor: kPrimaryColor)),
        routes: routes,
        home: SplashFuturePage(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SplashFuturePage extends StatefulWidget {
  SplashFuturePage({Key? key}) : super(key: key);

  @override
  _SplashFuturePageState createState() => _SplashFuturePageState();
}

class _SplashFuturePageState extends State<SplashFuturePage> {
  Future<Widget> futureCall() async {
    // do async operation ( api call, auto login)\\

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? ref = pref.getString('register');
    await Future.delayed(Duration(milliseconds: 2000), () {});
    return ref == null
        ? Future.value(new Register())
        : Future.value(new Home());
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/images/sms_logo.png',
        fit: BoxFit.fill,
        height: 100,
      ),
      title: Text(
        "Bulk SMS ",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      showLoader: true,
      loadingText: Text('Gj INFO TECH'),
      futureNavigator: futureCall(),
    );
  }
}
