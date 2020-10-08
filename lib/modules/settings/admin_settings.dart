import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/components/multiStateView.dart';
import 'package:phonepayz/models/getDthServiceProviders_response.dart';
import 'package:phonepayz/models/getMobileServiceProviders_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';

class HomeCard{
  String title;
  String image;
  HomeCard({@required this.title, @required this.image});
}

class AdminSettings extends StatefulWidget{
  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  List<HomeCard> card = [
    HomeCard(title: "Mobile", image: "images/smartphone.png"),
    HomeCard(title: "Dth", image: "images/radar.png"),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
     length: 2,
     child: Column(
       children: [
         SizedBox(height: 20,),
         TabBar(
             indicatorColor: Colors.black,
             labelStyle: TextStyle(fontSize: 16,fontFamily: 'Quicksand'),
             isScrollable: true,
             unselectedLabelStyle: TextStyle(fontSize: 16,fontFamily: 'Quicksand'),
             indicatorSize: TabBarIndicatorSize.label,
             labelColor: Colors.black,
             unselectedLabelColor: Colors.grey.shade500,
             physics: BouncingScrollPhysics(),
             onTap: (index){
               setState(() {
                 currentIndex = index;
               });
             },
             tabs: [
               Tab(
                 child: Text("Mobile"),
               ),
               Tab(
                 child: Text("Dth"),
               ),
             ]
         ),
         (currentIndex == 0)?AdminMobile():AdminDth()
       ],
     ),
   );
  }
}

class AdminMobile extends StatefulWidget{
  @override
  _AdminMobileState createState() => _AdminMobileState();
}

class _AdminMobileState extends State<AdminMobile> {
  ViewState state;
  String token = "";
  bool isLoading = false;
  List<String>apiProvider = [
    "Udhayam",
    "StockXchange",
    "mRobotics",
  ];
  String selectedProvider;
  List<MobileServiceProviders> provider = [];
  getToken() {
    setState(() {
      state = ViewState.Loading;
    });
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((val) {
        print(val.token);
        token = val.token;
        getMobileServiceProviders();
      });
    }
  }

  showErrorDialog(String title,String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(title,style: TextStyle(fontSize: 18,fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
            content: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(message,style: TextStyle(fontSize: 14,fontFamily: 'Quicksand',height: 1.5),textAlign: TextAlign.center,),
            ),
            actions: [
              FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Done",style: TextStyle(fontSize: 14,fontFamily: 'Quicksand',color: Colors.blue),))
            ],
          );
        }
    );
  }

  changeMobileServiceProvider(String api, int id){
    setState(() {
      isLoading = true;
    });
    ApiProvider().changeMobileServiceProvider(token, api, id).then((response) async{
      Navigator.pop(context);
      await showErrorDialog("Message", response.message);
      await getMobileServiceProviders();
      setState(() {
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      showErrorDialog("Error", error.toString());
    });
  }

  getMobileServiceProviders(){
    setState(() {
      state = ViewState.Loading;
    });
    ApiProvider().getMobileServiceProviders(token).then((response) {
      provider = response.providers;
      setState(() {
        state = ViewState.Content;
      });
    }).catchError((error){
      setState(() {
        state = ViewState.Error;
      });
    });
  }

  getButtonWidget() {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 1.5,
        ),
      );
    } else {
      return Text("Change",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),);
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }
  //getLoadingWidget
  getLoadingWidget(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Loader(),
          SizedBox(height: 8,),
          Text("Please wait")
        ],
      ),
    );
  }
  //getErrorWidget
  getErrorWidget(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Text("Oops something went wrong",style: TextStyle(color: Colors.grey.shade500),),
          SizedBox(height: 10,),
          FlatButton(
              color: Constants().primaryColor,
              onPressed: (){
                //getDistributors(token);
              },
              child: Text("Retry",style: TextStyle(fontSize: 16,color: Colors.white),)
          )
        ],
      ),
    );
  }
  //dialog
  showDialogBox(int id){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              height: 210,
              width: 280,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("Change Provider",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: DropdownButtonFormField<String>(
                        hint: Text("Select Api Provider",style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                        value: selectedProvider,
                        iconEnabledColor: Colors.grey.shade200,
                        iconDisabledColor: Colors.grey.shade200,
                        onChanged: (value) {
                          setState(() {
                            selectedProvider = value;
                            print(selectedProvider);
                          });
                        },
                        items: apiProvider.map((item) {
                          return  DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(color: Colors.black,fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                    child: FlatButton(
                        onPressed: (){
                          changeMobileServiceProvider(selectedProvider, id);
                          print(id);
                          print(selectedProvider);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: Colors.green.shade500,
                        child: getButtonWidget()
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  //getContentWidget
  getContentWidget(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10,),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                dataRowHeight: 50,
                dividerThickness: 2,
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade50),
                columns: [
                  DataColumn(
                    label: Text("Name",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Api Provider",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Action",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                ],
                rows: provider
                .map(
                (item) => DataRow(
                    cells: [
                      DataCell(
                        Text(item.name,style: TextStyle(fontSize: 16)),
                      ),
                      DataCell(
                        Text(item.api,style: TextStyle(fontSize: 16)),
                      ),
                      DataCell(
                        FlatButton(
                          onPressed: (){
                            print(item.id);
                            showDialogBox(item.id);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: BorderSide(
                                color: Colors.green.shade500,
                              )
                          ),
                          child: Text("Change",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.green.shade500),),
                        ),
                      ),
                    ])).toList()
            )
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiStateView(
      state: state,
      contentView: getContentWidget(),
      errorView: getErrorWidget(),
      loaderView: getLoadingWidget(),
    );
  }
}

class AdminDth extends StatefulWidget{
  @override
  _AdminDthState createState() => _AdminDthState();
}

class _AdminDthState extends State<AdminDth> {
  ViewState state;
  String token = "";
  bool isLoading = false;
  List<String>apiProvider = [
    "StockXchange",
  ];
  String selectedProvider;
  List<DthServiceProviders> providers = [];
  getToken() {
    setState(() {
      state = ViewState.Loading;
    });
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((val) {
        print(val.token);
        token = val.token;
        getDthServiceProviders();
      });
    }
  }

  showErrorDialog(String title,String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(title,style: TextStyle(fontSize: 18,fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
            content: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(message,style: TextStyle(fontSize: 14,fontFamily: 'Quicksand',height: 1.5),textAlign: TextAlign.center,),
            ),
            actions: [
              FlatButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Done",style: TextStyle(fontSize: 14,fontFamily: 'Quicksand',color: Colors.blue),))
            ],
          );
        }
    );
  }

  changeDthServiceProvider(String api, int id){
    setState(() {
      isLoading = true;
    });
    ApiProvider().changeDthServiceProvider(token, api, id).then((response) async{
      Navigator.pop(context);
      await showErrorDialog("Message", response.message);
      await getDthServiceProviders();
      setState(() {
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      showErrorDialog("Message", error.toString());
    });
  }

  getDthServiceProviders(){
    setState(() {
      state = ViewState.Loading;
    });
    ApiProvider().getDthServiceProviders(token).then((response) {
      providers = response.providers;
      setState(() {
        state = ViewState.Content;
      });
    }).catchError((error){
      setState(() {
        state = ViewState.Error;
      });
    });
  }

  getButtonWidget() {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 1.5,
        ),
      );
    } else {
      return Text("Change",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),);
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }
  //getLoadingWidget
  getLoadingWidget(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          Loader(),
          SizedBox(height: 8,),
          Text("Please wait")
        ],
      ),
    );
  }
  //getErrorWidget
  getErrorWidget(){
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30,),
          Text("Oops something went wrong",style: TextStyle(color: Colors.grey.shade500),),
          SizedBox(height: 10,),
          FlatButton(
              color: Constants().primaryColor,
              onPressed: (){
                //getDistributors(token);
              },
              child: Text("Retry",style: TextStyle(fontSize: 16,color: Colors.white),)
          )
        ],
      ),
    );
  }
  //dialog
    showDialogBox(int id){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              height: 210,
              width: 280,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("Change Provider",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: DropdownButtonFormField<String>(
                      hint: Text("Select Api Provider",style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                      value: selectedProvider,
                      iconEnabledColor: Colors.grey.shade200,
                      iconDisabledColor: Colors.grey.shade200,
                      onChanged: (value) {
                        setState(() {
                          selectedProvider = value;
                          print(selectedProvider);
                        });
                      },
                      items: apiProvider.map((item) {
                        return  DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(color: Colors.black,fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    height: 50,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 20),
                    child: FlatButton(
                        onPressed: (){
                          changeDthServiceProvider(selectedProvider, id);
                          print(id);
                          print(selectedProvider);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: Colors.green.shade500,
                        child: getButtonWidget()
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  //getContentWidget
  getContentWidget(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10,),
        Card(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  dataRowHeight: 50,
                  dividerThickness: 2,
                  headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade50),
                  columns: [
                    DataColumn(
                      label: Text("Name",style: TextStyle(fontWeight: FontWeight.bold),),
                      numeric: false,
                    ),
                    DataColumn(
                      label: Text("Api Provider",style: TextStyle(fontWeight: FontWeight.bold),),
                      numeric: false,
                    ),
                  ],
                  rows: providers
                      .map(
                          (item) => DataRow(
                          cells: [
                            DataCell(
                              Text(item.name,style: TextStyle(fontSize: 16)),
                            ),
                            DataCell(
                              Text(item.api,style: TextStyle(fontSize: 16)),
                            ),
                            /*DataCell(
                              FlatButton(
                                onPressed: (){
                                  print(item.id);
                                  showDialogBox(item.id);
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                    side: BorderSide(
                                      color: Colors.green.shade500,
                                    )
                                ),
                                child: Text("Change",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.green.shade500),),
                              ),
                            ),*/
                          ])).toList()
              )
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return MultiStateView(
      state: state,
      contentView: getContentWidget(),
      errorView: getErrorWidget(),
      loaderView: getLoadingWidget(),
    );
  }
}