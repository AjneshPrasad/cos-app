import 'package:cos/Model/user.dart';
import 'package:cos/Services/auth.dart';
import 'package:cos/Services/wrapper.dart';
import 'package:cos/views/home/GuestPages/desc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MyApp());


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<USer>.value(
      value: AuthService().user,
      builder:(context,index){
        return MaterialApp(
          title: 'Uni Eats',
          theme: ThemeData(
              primarySwatch: Colors.cyan,
              textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Open Sans',)
          ),
          home: Wrapper(),
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}


