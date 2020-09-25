import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/utils/constants.dart';

class AdminTextFieldFilled extends StatefulWidget{
  final Function onChanged;
  final String hintText;
  final TextInputType keyboardType;
  bool obscureText = false;
  AdminTextFieldFilled({@required this.onChanged, @required this.hintText, @required this.keyboardType, this.obscureText});
  @override
  _TextFieldFilledState createState() => _TextFieldFilledState();
}

class _TextFieldFilledState extends State<AdminTextFieldFilled> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 350,
      child: TextField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        cursorColor: Constants().primaryColor,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            hintText: widget.hintText,
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
    );
  }
}