import 'package:cos/Model/user.dart';
import 'package:cos/Services/auth.dart';
import 'package:cos/Services/wrapper.dart';
import 'package:cos/views/home/GuestPages/desc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MyApp());


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<USer>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Uni Eats',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Open Sans',)
        ),
        home: Wrapper(),
          debugShowCheckedModeBanner: false,
      ),
    );
  }
}


