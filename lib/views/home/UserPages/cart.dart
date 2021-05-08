

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/views/auth/register.dart';
import 'package:cos/views/home/UserPages/desc_logged.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Cart extends StatefulWidget{
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  QuerySnapshot dish;
  String img;
  int counter = 0;
  int total=0;
  DatabaseService databaseService = new DatabaseService();
  FirebaseStorageService firebaseStorageService = new FirebaseStorageService();
  @override
  void initState() {
    databaseService.getData('Hot bread').then(
            (results){
          setState(() {
            dish = results;
          });
        }
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(dish != null){
      return LayoutBuilder(
          builder: (context, costr) {
            var count= 4;
            if(costr.maxWidth > 1200) count= 8;
            else if(costr.maxWidth<700) count=1;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                actions: [
                  Padding(padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                      },
                      child: const Text("Proceed to Checkout",style:TextStyle(color:Colors.white),),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Text(
                          "My Cart",
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
                        Text('Image',style:TextStyle(fontWeight: FontWeight.bold)),
                        Text('Dish name',style:TextStyle(fontWeight: FontWeight.bold)),
                        Text('Quantity',style:TextStyle(fontWeight: FontWeight.bold)),
                        Text('Unit Price',style:TextStyle(fontWeight: FontWeight.bold)),
                        Text('Total',style:TextStyle(fontWeight: FontWeight.bold)),
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
                                itemCount: dish.docs.length,
                                itemBuilder: (context,index){
                                  img=dish.docs[index].get('img');
                                  return Card(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:[
                                          Container(
                                            height: 70.0,
                                            child: FutureBuilder(
                                              future: firebaseStorageService.getImage(context,'${dish.docs[index].get('img')}' ),
                                              builder: (context,snapshot){
                                                if (snapshot.connectionState== ConnectionState.done){
                                                  return Container(
                                                    width:60 ,
                                                    height:60,
                                                    child: snapshot.data,
                                                  );
                                                }
                                                if (snapshot.connectionState== ConnectionState.waiting){
                                                  return Container(
                                                    width: 60,
                                                    height:60 ,
                                                    child: CircularProgressIndicator(),
                                                  );
                                                }
                                                return Container();
                                              },
                                            ),
                                          ),
                                          Text('${dish.docs[index].get('title')}'),
                                          Text('${dish.docs[index].get('price')}'),
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey
                                                    )
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(icon:Icon(Icons.remove,color: Colors.redAccent,),
                                                        onPressed:(){
                                                          setState(() {
                                                            if (counter!= 0){
                                                              counter= counter -1;
                                                              total = dish.docs[index].get('price') * counter;
                                                              print('${counter}' + ' '+ '${total}');
                                                            }
                                                            else{
                                                              total = 0;
                                                            }
                                                          });

                                                        }),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.grey)
                                                      ),
                                                      child: Text('${counter}'),
                                                    ),
                                                    IconButton(icon:Icon(Icons.add,color: Colors.green,),
                                                        onPressed:(){
                                                          setState(() {
                                                            counter= counter +1;
                                                            total = dish.docs[index].get('price') * counter;
                                                            print('${counter}' + ' '+ '${total}');
                                                          });

                                                        })
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete,size: 30,),
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
                                                },
                                              ),
                                            ],
                                          )
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
                  Row(
                    children: [
                      Text('Total:',textAlign:TextAlign.right,
                          style:TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent))
                    ],
                  ),
                  Column(
                    children: [
                      Text('Order Instruction:',style:TextStyle(fontSize: 18),)

                    ],
                  )

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