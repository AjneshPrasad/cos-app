import 'dart:js';
import 'package:cos/Services/database.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../productItem.dart';

class HotBreadPage extends StatefulWidget {
  @override
  _HotBreadPageState createState() => _HotBreadPageState();
}

class _HotBreadPageState extends State<HotBreadPage> {
  @override
  void initState() {

  }


  int productCart = 0;
  @override
  Widget build(BuildContext context) {
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
                        "Hot Bread Kitchen",
                        style: TextStyle(
                          //fontWeight:FontWeight.bold,
                          fontSize: 32.0,
                        ),
                      ),
                      Expanded(child: TextField(
                        decoration: InputDecoration(
                          contentPadding:EdgeInsets.symmetric(horizontal: 10.0) ,
                          hintText: "Search...",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                        ),
                      )
                      ),
                      IconButton(
                        onPressed: (){

                        },
                        icon:Icon(Icons.filter_list_rounded) ,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: GridView.builder(
                            itemCount: products.length,
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
    ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie2.jpg'),
    ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie2.jpg'),
    ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie2.jpg'),
    ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie2.jpg'),
    ProductItemModel(price: 4.00,title: 'pie',img:'assets/pie2.jpg'),
  ];

  Widget cart(ProductItemModel productItemModel){
    return Card(
      child: InkWell(
          splashColor: Colors.grey,
          onTap: (){

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



