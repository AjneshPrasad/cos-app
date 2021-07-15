

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

class ResturantPage extends StatefulWidget{
  @override
  _ResturantPageState createState() => _ResturantPageState();
}

class _ResturantPageState extends State<ResturantPage> {
  QuerySnapshot items;
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
    databaseService.getData('User Cart').then(
            (results){
          setState(() {
            items = results;
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
    databaseService.getData('checkout order').then(
            (results3){
          setState(() {
            orders = results3;
          });
        }
    );

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(items != null){
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
                              "Southern Cross",
                              style: TextStyle(
                                //fontWeight:FontWeight.bold,
                                fontSize: 32.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Customer name',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Date',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Time',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Item',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Quantity',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Delivery Location',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Total',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Payment Method',style:TextStyle(fontWeight: FontWeight.bold)),
                            Text('Remove order',style:TextStyle(fontWeight: FontWeight.bold)),

                          ],
                        ),
                      ),
                      SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.tealAccent.shade100,
                                  borderRadius: BorderRadius.circular(20.0)
                              ),

                              height:costr.maxHeight/2 ,
                              width: costr.maxWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ListView.builder(
                                      itemCount: items.docs.length,
                                      itemBuilder: (context,index){
                                          return Card(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:[
                                                  Text('${users.docs[index].get('First name')}'+" "+ '${users.docs[index].get('Surname')}'),
                                                  Text('${orders.docs[index].get('Date')}'),
                                                  Text('${orders.docs[index].get('Time')}'),
                                                  Text('${items.docs[index].get('item')}'),
                                                  Text('${items.docs[index].get('quantity')}'),
                                                  Text('${orders.docs[index].get('DeliveryLoc')}'),
                                                  Text('\$${items.docs[index].get('subtotal')}'),
                                                  Text('${orders.docs[index].get('payment method')}'),
                                                  IconButton(
                                                    icon: Icon(Icons.delete,size: 30,),
                                                    onPressed: (){
                                                      setState(() {
                                                        databaseService.DeleteCart(items.docs[index].id);
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

