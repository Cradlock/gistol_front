



import 'package:app_front/entry/entry.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget{
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width; 
      
      final bool isMobile = screenWidth < 600;


      return SizedBox( 
        width: isMobile ? double.infinity : 400,
        child: DrawerBlock(isMobile:isMobile)
      );
  }  

}
