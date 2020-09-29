import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/components/admin_textfield_filled.dart';
import 'package:phonepayz/components/button_filled.dart';
import 'package:phonepayz/components/loader.dart';
import 'package:phonepayz/models/getDistributor_response.dart';
import 'package:phonepayz/models/getSuperDistributors_response.dart';
import 'package:phonepayz/network/api_provider.dart';
import 'package:phonepayz/utils/constants.dart';

class Distributor extends StatefulWidget{
  @override
  _DistributorState createState() => _DistributorState();
}

class _DistributorState extends State<Distributor> {
  String amount = "";
  String token = "";
  String mobile = "";
  String address = "";
  String name = "";
  String id = "";
  bool onPressed = false;
  bool isLoading = false;
  List<Distributors> distributors = [];
  List<SuperDistributors> superDistributors = [];
  SuperDistributors selectedSuperDistributor;

  showErrorDialog(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Alert",style: TextStyle(fontSize: 18,fontFamily: 'Quicksand',fontWeight: FontWeight.bold),),
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

  getSuperDistributors(String token){
    ApiProvider().getSuperDistributors(token).then((response) {
      superDistributors = response.superDistributors;
      setState(() {
        isLoading = false;
      });
      if(response.status == false){
        showErrorDialog(response.message);
      }
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      showErrorDialog(error.toString());
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
      return Text("Submit",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),);
    }
  }

  createDistributor(){
    setState(() {
      isLoading = true;
    });
    ApiProvider().createDistributor(token, name, address, mobile, id).then((response){
      print(id);
      if(response.status){
        onPressed = false;
        getDistributors(token);
      }else{
        showErrorDialog(response.message);
      }
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


  getDistributors(String token){
    ApiProvider().getDistributors(token).then((response) {
      distributors = response.distributors;
      setState(() {
        isLoading = false;
      });
      if(response.status == false){
        showErrorDialog(response.message);
      }
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
        getDistributors(val.token);
        getSuperDistributors(token);
      });
    }
  }

  addMoney(String id){
    setState(() {
      isLoading = true;
    });
    ApiProvider().addMoney(token, int.parse(amount), id).then((response) {
      setState(() {
        isLoading = false;
      });
      if(response.status){
        Navigator.pop(context);
        getDistributors(token);
      }else{
        showErrorDialog(response.message);
      }
    }).catchError((error){
      setState(() {
        isLoading = false;
      });
      showErrorDialog(error.toString());
    });
  }

  showDialogBox(String id){
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
                      maxLength: 4,
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
                        onPressed: (){
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
    ):(onPressed == false)?SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(height: 30,),
          (distributors.isEmpty)?Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Text("No distributors were found, create a distributor",style: TextStyle(),),
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
                rows: distributors
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
                            onPressed: (){
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
    ):Column(
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
                          Text("New Distributor",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                        ],
                      ),
                      SizedBox(height: 30,),
                      Text("Distributor Name",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      AdminTextFieldFilled(
                        keyboardType: TextInputType.text,
                        hintText: "Enter distributor name",
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
                      SizedBox(height: 20,),
                      Text("Select Super Distributor",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.grey.shade200,
                        height: 50,
                        width: 350,
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child:  Row(
                          children: [
                            Expanded(
                              child: DropdownButton<SuperDistributors>(
                                hint: Text("Select Super Distributor",style: TextStyle(fontSize: 14,color: Colors.grey.shade500),),
                                underline: Container(color: Colors.grey.shade200,),
                                value: selectedSuperDistributor,
                                iconEnabledColor: Colors.grey.shade200,
                                iconDisabledColor: Colors.grey.shade200,
                                onChanged: (SuperDistributors Value) {
                                  setState(() {
                                    selectedSuperDistributor = Value;
                                    id = selectedSuperDistributor.id;
                                  });
                                },
                                items: superDistributors.map((SuperDistributors user) {
                                  return  DropdownMenuItem<SuperDistributors>(
                                    value: user,
                                    child: Text(
                                      user.name,
                                      style:  TextStyle(color: Colors.black,fontSize: 14),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down,color: Colors.grey.shade500,size: 18,),
                          ],
                        ),
                      ),
                      SizedBox(height: 30,),
                      ButtonFilled(
                        onPressed: (){
                          createDistributor();
                        },
                        isLoading: isLoading,
                        buttonText: "Create Distributor",
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