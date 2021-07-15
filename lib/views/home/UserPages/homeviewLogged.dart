
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/Services/loading.dart';
import 'package:cos/views/home/GuestPages/hotbread.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../productItem.dart';

import 'desc_logged.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading =false;
  QuerySnapshot dish;
  QuerySnapshot breakfast;
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
    databaseService.getData('Breakfast').then(
            (results){
          setState(() {
            breakfast = results;
          });
        }
    );
    Firebase.initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '',
      home: new DefaultTabController(
          length: 3,
          child: new Scaffold(
            appBar: new PreferredSize( preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Colors.cyan,
              child: new SafeArea(
                child: Column(
                  children: [
                    new Expanded(
                      child: new Container(),
                    ),
                    new TabBar(
                      tabs: [new Text('Breakfast'), new Text('Lunch'),new Text('Dinner')],
                    ),
                  ],
                ),
              ),
            ),
            ),
            body: new TabBarView(
              children: <Widget>[
                new LayoutBuilder(
                    builder: (context, costr) {
                      var count= 4;
                      if(costr.maxWidth > 1200) count= 4;
                      else if(costr.maxWidth<700) count=1;
                      return Scaffold(
                        body: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Text("Southern Cross Breakfast menu", style: TextStyle(//fontWeight:FontWeight.bold,
                                     fontSize: 23.0,
                                  ),
                                  ),
                                ]
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: breakfast?.docs==null
                                        ?Center(child: CircularProgressIndicator()):
                                    GridView.builder(
                                        itemCount: breakfast?.docs?.length,
                                        itemBuilder: (context,index){
                                          img=breakfast.docs[index].get('img');
                                          return Card(
                                            child: InkWell(
                                                splashColor: Colors.grey,
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>ProductDetailScreen(
                                                    dishname:'${breakfast.docs[index].get('title')}',price: breakfast.docs[index].get('price'),
                                                    desc: '${breakfast.docs[index].get('desc')}',img: '${breakfast.docs[index].get('img')}',
                                                  )));
                                                  },
                                                child: Column(
                                                  children:[
                                                    Container(
                                                      height: 250.0,
                                                      child: FutureBuilder(
                                                        future: firebaseStorageService.getImage(context,'${breakfast.docs[index].get('img')}' ),
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
                                                    Text('${breakfast.docs[index].get('title')}'),

                                                    Text('\$${breakfast.docs[index].get('price')}'),
                                                  ],

                                                )

                                            ),

                                          );

                                          },

                                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(

                                          crossAxisCount: count,

                                          childAspectRatio:1,

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

                    ),
                new LayoutBuilder(
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
                                    Text("Southern Cross Lunch menu", style: TextStyle(//fontWeight:FontWeight.bold,
                                      fontSize: 23.0,
                                    ),
                                    ),
                                  ]
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
                                                      height: 250.0,
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

                                                    Text('\$${dish.docs[index].get('price')}'),
                                                  ],

                                                )

                                            ),

                                          );

                                        },

                                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(

                                          crossAxisCount: count,

                                          childAspectRatio:1,

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

                ),
                new LayoutBuilder(
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
                                    Text("Southern Cross Dinner menu", style: TextStyle(//fontWeight:FontWeight.bold,
                                      fontSize: 23.0,
                                    ),
                                    ),
                                  ]
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
                                                      height: 250.0,
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

                                                    Text('\$${dish.docs[index].get('price')}'),
                                                  ],

                                                )

                                            ),

                                          );

                                        },

                                        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(

                                          crossAxisCount: count,

                                          childAspectRatio:1,

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

                ),
              ],
            ),
          )
      ),
    );

}


}

