import 'package:cos/Services/loading.dart';
import 'package:cos/views/auth/register.dart';
import 'package:cos/views/home/UserPages/payroll.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_logged.dart';
import 'package:cos/views/home/UserPages/ResturantPage.dart';
import 'package:flutter/material.dart';

import 'dart:developer';


import 'package:cos/Services/auth.dart';



class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading =false;
  String email='';
  String resturantemail='southerncross@gmail.com';
  String payrollemail='southerncross@gmail.com';
  String payrollpass='payroll69';
  String resturantpass='12345678';
  String pass='';
  String error='';
  bool _obscureText = true;


  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
              },
              child: const Text("Register",style:TextStyle(color:Colors.white),),
            ),
          ),
        ],
      ),
        backgroundColor: Colors.blueGrey,
        body: Center(
          child:Container(
            width:500.0 ,
            height:365.0 ,
            color: Colors.white30,
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 30.0,),
                  Text('Sign In',style:TextStyle(fontSize: 20.0),),
                  SizedBox(height: 20.0,),
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
                  SizedBox(height: 20.0,),
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
                  SizedBox(height: 20.0,),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed:()async{
                        if(_formKey.currentState.validate()){
                          setState(() => loading= true);
                          dynamic result= await _auth.signIn(email, pass);
                          if(email ==resturantemail && pass==resturantpass){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResturantPage()));
                          }
                          else if(email ==payrollemail && pass==payrollpass){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => payroll()));
                          }
                          else if(result== null ){
                            setState(()
                            {
                              error ='Email or Password may be incorrect';
                              loading = false;
                            });
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CollapsingNavigationDrawerUser()));

                          }
                        }
                      },
                      child: const Text("Login",style:TextStyle(color:Colors.white),),
                    ),
                  ),
                  SizedBox(height: 13.0,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red,fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        )
    );

  }
}
