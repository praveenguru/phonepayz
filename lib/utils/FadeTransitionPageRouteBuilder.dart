import 'package:flutter/material.dart';
class FadeTransitionPageRouteBuilder extends PageRouteBuilder {
  final Widget page;
  FadeTransitionPageRouteBuilder({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
              opaque:false,
              barrierColor:null,
              barrierLabel:null,
              maintainState:true,
              transitionDuration:Duration(milliseconds: 300),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
                
                opacity: animation,
                child: child,
              ),
        );
}