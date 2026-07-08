


import 'package:flutter/material.dart';
import 'package:app_front/entry/entry.dart';

class Mainlayout extends StatelessWidget{
  
  final Widget child;

  const Mainlayout({super.key,required this.child});

  @override
    Widget build(BuildContext context) {
      return Scaffold( 
        appBar: const MainHeader(),
        endDrawer: const MainDrawer(),
        body: child
      );
    }

} 
