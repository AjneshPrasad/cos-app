import 'package:cos/Model/user.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_logged.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<USer>(context);
     print(user);
    if(user == null ){
      return CollapsingNavigationDrawerGuest();
    }
    else{
      return CollapsingNavigationDrawerUser();
    }
  }
  
}