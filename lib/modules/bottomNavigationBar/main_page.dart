import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/modules/home/mobile_home.dart';
import 'package:phonepayz/modules/settings/settings_page.dart';
import 'package:phonepayz/modules/transactions/transaction_page.dart';
import 'package:phonepayz/utils/constants.dart';
class MainPage extends StatefulWidget{
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Constants().primaryColor,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 14),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(EvaIcons.home),
            title: Text('Home')
          ),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.smartphoneOutline),
              title: Text('Transactions')
          ),
          BottomNavigationBarItem(
              icon: Icon(FeatherIcons.settings),
              title: Text('Settings')
          ),
        ],
      ),
      body: getIndex(),
    );
  }
  getIndex(){
    if(currentIndex == 0){
      return MobileHome();
    }else if(currentIndex == 1){
      return TransactionsPage();
    }else{
      return SettingsPage();
    }
  }
}