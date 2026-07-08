




import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerBlock extends StatelessWidget{
  final bool isMobile;

  const DrawerBlock({super.key,required this.isMobile});
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(                   
        shape: RoundedRectangleBorder(
          borderRadius: this.isMobile 
            ? BorderRadius.zero : 
            const BorderRadius.only(
              topLeft: Radius.circular(32),
              bottomLeft: Radius.circular(32)
            )
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 16),
            child: Column( 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: Icon(Icons.arrow_back_ios,size: 20,color: colors.onSurface)
                  ),
                  
                  const SizedBox(height: 24),
                  
                  ListTile(
                    title:Text("navigation.menu_title".tr(),style: Theme.of(context).textTheme.titleLarge),
                  ),
                   
                  ListTile(
                    leading: const Icon(Icons.account_box),
                    title: Text("navigation.account_btn".tr(),style: Theme.of(context).textTheme.titleMedium),
                    onTap: () => context.push('/account'),
                  ),                  
                  ListTile( 
                    leading: const Icon(Icons.home),
                    title: Text("navigation.home_btn".tr(), style: Theme.of(context).textTheme.titleMedium),
                    onTap: () {
                      context.push("/");
                      Navigator.pop(context);
                    },
                  ),

                  ListTile( 
                    leading: const Icon(Icons.settings),
                    title: Text("navigation.settings_btn".tr(), style: Theme.of(context).textTheme.titleMedium ),
                    onTap: () {
                      context.push("/settings");
                      Navigator.pop(context);
                    }
                  ),

                  ListTile( 
                    leading: const Icon(Icons.task),
                    title: Text("navigation.tasks_btn".tr(), style: Theme.of(context).textTheme.titleMedium ),
                    onTap: () {
                      context.push("/tasks");
                      Navigator.pop(context);
                    }
                  ),


                  const Spacer(),

                  ListTile(
                    dense: true, // Делает элемент чуть компактнее
                    title: Text("documents.terms_title".tr(), style: Theme.of(context).textTheme.bodyMedium ),
                    onTap: () => context.push('/service'),
                  ),
                  ListTile(
                    dense: true,
                    title: Text("documents.privacy_title".tr(), style: Theme.of(context).textTheme.bodyMedium),
                    onTap: () => context.push('/policy'),
                  )
                ],
            ),
    
          )

        )
      );

  }
}


