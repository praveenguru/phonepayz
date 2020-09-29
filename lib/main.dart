import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/modules/bottomNavigationBar/main_page.dart';
import 'modules/home/admin_home.dart';
import 'modules/home/mobile_home.dart';
import 'modules/login/admin_login.dart';
import 'modules/login/mobile_login.dart';

Future<User> getFirebaseUser() async{
  User firebaseUser = FirebaseAuth.instance.currentUser;
  if(firebaseUser == null){
    firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
  }
  return firebaseUser;
}

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Widget home;
  getFirebaseUser();
  await Future.delayed(Duration(seconds: 1));
  var user = FirebaseAuth.instance.currentUser;
  if(user == null){
    if(kIsWeb){
      home = AdminLogin();
    }else{
      home = MobileLogin();
    }
  }else{
    if(kIsWeb){
      home = AdminHome();
    }else{
      home = MainPage();
    }
  }
  runApp(MyApp(home: home,));
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  Widget home;
  MyApp({this.home});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phonepayz',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Quicksand'
      ),
      home: widget.home,
      debugShowCheckedModeBanner: false,
    );
  }
}