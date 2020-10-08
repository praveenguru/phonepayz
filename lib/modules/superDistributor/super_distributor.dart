import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/admin_textfield_filled.dart';
import 'package:phonepayz/components/button_filled.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/models/getUser_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';

class SuperDistributor extends StatefulWidget{
  @override
  _SuperDistributorState createState() => _SuperDistributorState();
}

class _SuperDistributorState extends State<SuperDistributor> {
  String amount = "";
  String token = "";
  String mobile = "";
  String address = "";
  String name = "";
  bool isLoading = false;
  bool onPressed = false;
  List<UserData> superDistributors = [];

  showErrorDialog(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Message",style: TextStyle(fontSize: 18,fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
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
      return Text("Submit",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),);
    }
  }

  getSuperDistributors(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().getUser(token, "SuperDistributor").then((response) {
      if(response != null){
        superDistributors = response.userData;
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      showErrorDialog(error.toString());
    });
  }

  createSuperDistributor(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().addUser(token, "SuperDistributor", name, mobile, address, null).then((response) async{
      await showErrorDialog(response.message);
      await getSuperDistributors();
      setState(() {
        onPressed = false;
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      showErrorDialog(error.toString());
    });
  }

  getToken() {
    setState(() {
      isLoading = true;
    });
    var firebaseAuth = FirebaseAuth.instance;
    if (firebaseAuth.currentUser != null) {
      firebaseAuth.currentUser.getIdTokenResult(true).then((val) {
        print(val.token);
        token = val.token;
        getSuperDistributors();
      });
    }
  }

  addMoney(int id){
    setState(() {
      isLoading = true;
    });
    ApiProvider().addMoney(token, int.parse(amount), id).then((response) async{
      Navigator.pop(context);
      await getSuperDistributors();
      await showErrorDialog(response.message);
      setState(() {
        isLoading = false;
      });
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      showErrorDialog(error.toString());
    });
  }

  showDialogBox(int id){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: Container(
              height: 250,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("Add Money",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  Container(
                    margin: EdgeInsets.only(left: 20,right: 20,top: 30),
                    height: 80,
                    width: 280,
                    child: TextField(
                      cursorColor: Constants().primaryColor,
                      keyboardType: TextInputType.number,
                      onChanged: (val){
                        setState(() {
                          amount = val;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Enter amount",
                          hintStyle: TextStyle(fontSize: 14,color: Colors.grey.shade500),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                                color: Colors.grey.shade200
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 280,
                    margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: FlatButton(
                      onPressed: () {
                         addMoney(id);
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
  @override
  void initState() {
    super.initState();
    getToken();
  }
  @override
  Widget build(BuildContext context) {
    return (isLoading)?Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 100,),
          Loader(),
          SizedBox(height: 10,),
          Text("Please wait",style: TextStyle(),),
        ],
      ),
    ):(superDistributors == null)?Container():(onPressed == false)?SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(height: 30,),
          (superDistributors.isEmpty)?Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Text("No super distributors were found, create a super distributor",style: TextStyle(),),
              ],
            ),
          ):Card(
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
                    label: Text("Balance",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Mobile",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Address",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("Action",style: TextStyle(fontWeight: FontWeight.bold),),
                    numeric: false,
                  ),
                ],
                rows: superDistributors
                    .map(
                      (item) => DataRow(
                      cells: [
                        DataCell(
                          Text(item.name,style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          Text("\u20B9 "+item.balance.toString(),style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          Text(item.mobile,style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          Text(item.address,style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          FlatButton(
                            onPressed: () {
                              showDialogBox(item.id);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(
                                  color: Colors.green.shade500,
                                )
                            ),
                            child: Text("Add Money",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: Colors.green.shade500),),
                          ),
                        ),
                      ]),
                ) .toList(),
              ),
            ),
          ),
          SizedBox(height: 30,),
          FloatingActionButton.extended(
            onPressed: (){
              setState(() {
                onPressed = true;
              });
            },
            backgroundColor: Colors.green.shade500,
            icon: Icon(Icons.add),
            label: Text("Create Super Distributor"),
          ),
          SizedBox(height: 40,),
        ],
      ),
    ): Column(
      children: [
        SizedBox(height: 20,),
        Row(
            children: [
              Expanded(child: Container()),
              Card(
                child: Container(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.keyboard_backspace,size: 24,),
                            onPressed: (){
                              setState(() {
                                onPressed = false;
                              });
                            },
                          ),
                          SizedBox(width: 16,),
                          Text("New Super Distributor",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text("Super Distributor Name",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      AdminTextFieldFilled(
                        keyboardType: TextInputType.text,
                        hintText: "Enter super distributor name",
                        obscureText: false,
                        onChanged: (val){
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      SizedBox(height: 20,),
                      Text("Mobile Number",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      AdminTextFieldFilled(
                        keyboardType: TextInputType.number,
                        hintText: "Enter mobile number",
                        obscureText: false,
                        onChanged: (val){
                          setState(() {
                            mobile = val;
                          });
                        },
                      ),
                      SizedBox(height: 20,),
                      Text("Address",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      AdminTextFieldFilled(
                        keyboardType: TextInputType.text,
                        hintText: "Enter address",
                        obscureText: false,
                        onChanged: (val){
                          setState(() {
                            address = val;
                          });
                        },
                      ),
                      SizedBox(height: 30,),
                      ButtonFilled(
                        onPressed: (){
                          createSuperDistributor();
                        },
                        isLoading: isLoading,
                        buttonText: "Create Super Distributor",
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
            ]),
        Expanded(child: Container()),
      ],
    );
  }
}