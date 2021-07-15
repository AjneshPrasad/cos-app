import 'dart:developer';


import 'package:cos/Model/user.dart';
import 'package:cos/Services/auth.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/Services/loading.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class RegistrationPage extends StatefulWidget {

  final Function toggleView;
  RegistrationPage({this.toggleView});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DatabaseService databaseService = new DatabaseService();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool loading =false;
  String firstName="";
  String surname='';
  String id='';
  String mobile='';
  String email='';
  String pass="";
  String error="";
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :Scaffold(
      appBar: AppBar(
        leading: Stack(
          children:[
          IconButton(icon: const Icon(Icons.home,size: 30,),
              onPressed:(){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CollapsingNavigationDrawerGuest()));
              }
          )
          ]
          ),
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: const Text("Login",style:TextStyle(color:Colors.white),),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child:ListView(
           children: [
             Container(
               width:500.0 ,
               height:900.0 ,
               color: Colors.white30,
               padding: EdgeInsets.all(10.0),
               child: Expanded(
                 child:Form(
                   key: _formKey,
                   child: Column(
                     children: [
                       SizedBox(height: 20.0,),
                       Text('Sign Up',style:TextStyle(fontSize: 20.0),),
                       SizedBox(height: 10.0,),
                       TextFormField(
                         validator: (val)=>val.isEmpty ?'Please enter your first name': null,
                         decoration: const InputDecoration(
                           labelStyle: TextStyle(color: Colors.black),
                           border: UnderlineInputBorder(),
                           filled: true,
                           icon: Icon(Icons.person),
                           hintText: "Enter First Name",
                           labelText: "First Name:",
                         ),
                         onChanged: (val){
                           setState(() =>firstName=val);
                         },
                       ),
                       SizedBox(height: 10.0,),
                       TextFormField(
                         validator: (val)=>val.isEmpty ?'Please enter your Surname': null,
                         decoration: const InputDecoration(

                           labelStyle: TextStyle(color: Colors.black),
                           border: UnderlineInputBorder(),
                           filled: true,
                           icon: Icon(Icons.person),
                           hintText: "Enter Surname",
                           labelText: "Surname:",
                         ),
                         onChanged: (val){
                           setState(() =>surname=val);
                         },
                       ),
                       SizedBox(height: 10.0,),
                       TextFormField(
                         maxLength: 9,
                         validator: (val)=>val.length<9 ?'Please enter 9-digit ID': null,
                         decoration: const InputDecoration(
                           labelStyle: TextStyle(color: Colors.black),
                           border: UnderlineInputBorder(),
                           filled: true,
                           icon: Icon(Icons.person),
                           hintText: "Enter Employee ID",
                           labelText: "ID:",
                         ),
                         onChanged: (val){
                           setState(() =>id=val );
                         },
                       ),
                       SizedBox(height: 10.0,),
                       TextFormField(
                         maxLength: 7,
                         validator: (val)=>val.length<6 ?'Please enter 7 digit mobile no': null,
                         decoration: const InputDecoration(
                           labelStyle: TextStyle(color: Colors.black),
                           border: UnderlineInputBorder(),
                           filled: true,
                           icon: Icon(Icons.phone),
                           hintText: "Enter Mobile no",
                           labelText: "Mobile:",
                         ),
                         onChanged: (val){
                           setState(() =>mobile=val);
                         },
                       ),
                       SizedBox(height: 10.0,),
                       TextFormField(
                         validator: (val)=>val.isEmpty ?'Please enter your email address': null,
                         decoration: const InputDecoration(
                           labelStyle: TextStyle(color: Colors.black),
                           border: UnderlineInputBorder(),
                           filled: true,
                           icon: Icon(Icons.email),
                           hintText: "Enter Email Address",
                           labelText: "Email:",
                         ),
                         onChanged: (val){
                           setState(() =>email=val);
                         },
                       ),
                       SizedBox(height: 10.0,),
                       TextFormField(
                         obscureText: _obscureText,
                         maxLength: 9,
                         validator: (val)=>val.isEmpty ?'Please enter your Password': null,
                         decoration: InputDecoration(
                           labelStyle: TextStyle(color: Colors.black),
                           border: UnderlineInputBorder(),
                           filled: true,
                           icon: Icon(Icons.lock),
                           hintText: "Password should be 6 characters or more",
                           labelText: "Password:",
                           suffixIcon:GestureDetector(
                             onTap: (){
                               setState(() {
                                 _obscureText=!_obscureText;
                               });
                             },
                             child: Icon(_obscureText? Icons.visibility:Icons.visibility_off),
                           ),
                         ),
                         onChanged: (val){
                           setState(() =>pass=val);
                         },
                       ),
                       SizedBox(height: 10.0,),
                       Center(
                         child: ElevatedButton(
                           style: ElevatedButton.styleFrom(
                             primary: Colors.blueAccent, // background
                             onPrimary: Colors.white, // foreground
                           ),
                           onPressed:()async{
                             if (_formKey.currentState.validate()){
                               setState(() => loading= true);
                               dynamic result = await _auth.registerWithEmailAndPass(email,pass,firstName,surname,id,mobile);
                               if(result == null){
                                 setState(()
                                 {
                                   error ='Please enter a valid email';
                                   loading = false;
                                 });
                               }
                               else{
                                 _showMyDialog();
                               }
                             }
                           },
                           child: const Text("Register",style:TextStyle(color:Colors.white),),
                         ),
                       ),
                       SizedBox(height: 10.0,),
                       Text(
                         error,
                         style: TextStyle(color: Colors.red,fontSize: 14.0),
                       )
                     ],
                   ),
                 ),),
             ),
           ],
        ),
      )
    );

  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Registered Successfully'),
                Text('Please verify your email before logging in')

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Login'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        );
      },
    );
  }
}