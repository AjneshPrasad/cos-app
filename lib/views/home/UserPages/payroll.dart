

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/views/auth/register.dart';
import 'package:cos/views/home/UserPages/desc_logged.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class payroll extends StatefulWidget{
  @override
  _payrollState createState() => _payrollState();
}

class _payrollState extends State<payroll> {
  QuerySnapshot request;
  QuerySnapshot orders;
  QuerySnapshot users;
  String img;



  String address;
  DatabaseService databaseService = new DatabaseService();
  FirebaseStorageService firebaseStorageService = new FirebaseStorageService();
  String _setTime, _setDate;
  String _hour, _minute, _time;
  int Total= 0;
  int counter=0;
  int i=0;

  final FirebaseAuth _auth= FirebaseAuth.instance;


  @override
  void initState() {
    databaseService.getData('Pending registration request').then(
            (results){
          setState(() {
            request = results;
          });
        }
    );
    databaseService.getData('User').then(
            (results2){
          setState(() {
            users = results2;
          });
        }
    );


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(request != null){
      return LayoutBuilder(
          builder: (context, costr) {
            var count= 4;
            if(costr.maxWidth > 1200) count= 8;
            else if(costr.maxWidth<700) count=1;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey,
                  actions: [

                  ],
                ),
                body: SingleChildScrollView(
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Text(
                                  "Pending requests",
                                  style: TextStyle(
                                    //fontWeight:FontWeight.bold,
                                    fontSize: 21.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Email',style:TextStyle(fontWeight: FontWeight.bold)),
                                Text('Name',style:TextStyle(fontWeight: FontWeight.bold)),
                                Text('Id',style:TextStyle(fontWeight: FontWeight.bold)),
                                Text('Phone',style:TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection:Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.tealAccent.shade100,
                                      borderRadius: BorderRadius.circular(20.0)
                                  ),

                                  height:costr.maxHeight/2 ,
                                  width: costr.maxWidth*2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ListView.builder(
                                          scrollDirection:Axis.vertical,
                                          itemCount: request.docs.length,
                                          itemBuilder: (context,index){
                                              return Card(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children:[
                                                      Text('${request.docs[index].get('empEmail')}'),
                                                      Text('${request.docs[index].get('empFname')}'+" "+ '${request.docs[index].get('empLname')}'),
                                                      Text('${request.docs[index].get('empId')}'),
                                                      Text('${request.docs[index].get('empPhone')}'),
                                                      IconButton(
                                                        icon: Icon(Icons.check_box_outlined,size: 30,),
                                                        onPressed: (){
                                                          setState(() {
                                                            dynamic register = {
                                                              'userId':request.docs[index].get('userId'),'empId':request.docs[index].get('empId'),'empFname':request.docs[index].get('empFname'),
                                                              'empLname':request.docs[index].get('empLname'),'empEmail':request.docs[index].get('empEmail'),
                                                            };
                                                            databaseService.Payrollapproved(register);
                                                            databaseService.DeleteRequest(request.docs[index].id);
                                                            initState();
                                                          });
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.highlight_remove_outlined,size: 30,),
                                                        onPressed: (){
                                                          setState(() {
                                                            databaseService.DeleteRequest(request.docs[index].id);
                                                            initState();
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  )
                                              );

                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          ),
                        ]
                    )
                ));
          }
      );
    }
    else{
      return Container(
        color: Colors.white30,
        child: Center(
          child: SpinKitChasingDots(
            color: Colors.blueAccent,
            size: 50.0,
          ),
        ),
      );
    }
  }


}

