import 'dart:js';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/views/product%20overview.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../productItem.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int productCart = 0;
  @override
  Widget build(BuildContext context) {
    CollectionReference Hotbread = FirebaseFirestore.instance.collection('Hotbread');
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
                        child: GridView.builder(itemCount: products.length,
                            itemBuilder: (context,index)=> cart(products[index]),
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

List <ProductItemModel> products =[
  ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie.jpg'),
  ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie.jpg'),
  ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie.jpg'),
  ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie.jpg'),
  ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie.jpg'),
];

  Widget cart(ProductItemModel productItemModel){
    return Card(
      child: InkWell(
          splashColor: Colors.grey,
          onTap: (){
            productView();
          },
          child: Column(
            children:[
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('${productItemModel.img}'),
                      fit:BoxFit.cover,
                    )
                ),
              ),
              Text('${productItemModel.title}'),
              Text('${productItemModel.price}'),
            ],
          )
      ),
    );
  }



}



