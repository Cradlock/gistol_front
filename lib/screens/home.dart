
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
      // TODO: implement build
      return Scaffold( 
        appBar: AppBar(
          title: Text("GISTOL ACADEMY",style: Theme.of(context).textTheme.headlineMedium ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      
      );
    }
}


