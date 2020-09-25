import 'package:flutter/material.dart';
import 'package:phonepayz/utils/constants.dart';
class Loader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation<Color>(Constants().primaryColor),
        strokeWidth: 1.5,
      ),
    );
  }

}