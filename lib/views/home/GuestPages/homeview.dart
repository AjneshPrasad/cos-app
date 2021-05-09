import 'dart:js';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/Services/loading.dart';

import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../productItem.dart';
import 'desc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading =false;
  QuerySnapshot dish;
  String img;
  DatabaseService databaseService = new DatabaseService();
  FirebaseStorageService firebaseStorageService = new FirebaseStorageService();
  @override
  void initState() {
    databaseService.getData('Southern Cross').then(
            (results){
          setState(() {
            dish = results;
          });
        }
    );
    super.initState();
  }


  int productCart = 0;
  @override
  Widget build(BuildContext context) {
    if(dish != null){
      return LayoutBuilder(
          builder: (context, costr) {
            var count= 4;
            if(costr.maxWidth > 1200) count= 8;
            else if(costr.maxWidth<700) count=1;
            return Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: GridView.builder(
                              itemCount: dish.docs.length,
                              itemBuilder: (context,index){
                                img=dish.docs[index].get('img');
                                return Card(
                                  child: InkWell(
                                      splashColor: Colors.grey,
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>ProductDetailScreen(
                                          dishname:'${dish.docs[index].get('title')}',price: dish.docs[index].get('price'),
                                          desc: '${dish.docs[index].get('desc')}',img: '${dish.docs[index].get('img')}',
                                        )));
                                      },
                                      child: Column(
                                        children:[
                                          Container(
                                            height: 200.0,
                                            child: FutureBuilder(
                                              future: firebaseStorageService.getImage(context,'${dish.docs[index].get('img')}' ),
                                              builder: (context,snapshot){
                                                if (snapshot.connectionState== ConnectionState.done){
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width/1.2,
                                                    height:MediaQuery.of(context).size.height/1.2 ,
                                                    child: snapshot.data,
                                                  );
                                                }
                                                if (snapshot.connectionState== ConnectionState.waiting){
                                                  return Container(
                                                    width: MediaQuery.of(context).size.width/1.2,
                                                    height:MediaQuery.of(context).size.height/1.2 ,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                return Container();
                                              },
                                            ),
                                          ),
                                          Text('${dish.docs[index].get('title')}'),
                                          Text('${dish.docs[index].get('price')}'),
                                        ],
                                      )
                                  ),
                                );
                              },
                              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: count,
                                childAspectRatio:1/1.8,
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            );
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



