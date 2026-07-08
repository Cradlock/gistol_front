


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
    Widget build(BuildContext context) {

      // TODO: implement build
      return AppBar( 
            title: Text (
              "GISTOLOGY ACADEMY",
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge 
            ),
            backgroundColor: Theme.of(context).colorScheme.surface, 
            iconTheme: IconThemeData(color:Theme.of(context).colorScheme.onSurface),
          
          );
    }

  @override 
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);
  
}


