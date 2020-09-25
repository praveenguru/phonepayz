import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phonepayz/utils/constants.dart';

class ButtonFilled extends StatefulWidget{
  final Function onPressed;
  bool isLoading = false;
  final String buttonText;
  ButtonFilled({@required this.onPressed, @required this.buttonText, @required this.isLoading});
  @override
  _ButtonFilledState createState() => _ButtonFilledState();
}

class _ButtonFilledState extends State<ButtonFilled> {
  getButtonWidget() {
    if (widget.isLoading) {
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
      return Text(widget.buttonText, style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 350,
      child: FlatButton(
        onPressed: widget.onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)
        ),
        color: Constants().primaryColor,
        child: getButtonWidget()
      ),
    );
  }
}