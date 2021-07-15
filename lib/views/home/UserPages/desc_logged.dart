import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cos/Services/auth.dart';
import 'package:cos/Services/database.dart';
import 'package:cos/views/auth/register.dart';
import 'package:cos/widgets/NavigationBar/nav_bar_guest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cos/Model/user.dart';
import 'package:provider/provider.dart';


class ProductDetailScreen extends StatefulWidget {
  final String dishname;
  final int price;
  final String img;
  final String desc;


  const ProductDetailScreen({Key key, this.dishname, this.price, this.img, this.desc}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  QuerySnapshot items;
  int total=0;
  int counter= 0;
  FirebaseStorageService firebaseStorageService = new FirebaseStorageService();
  DatabaseService databaseService = new DatabaseService();
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

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          Padding(padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: (){
                //send order to database
                dynamic orderitem = {
                  'UserId':_auth.currentUser.uid,'item':widget.dishname,'quantity':counter,
                  'subtotal':total,'unit price':widget.price,
                };
                databaseService.addToCart(orderitem);
                // show confirmation and
                _AddedDialog();
              },
              child: const Text("Add to cart",style:TextStyle(color:Colors.white),),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            /*Image.network(
              widget.productDetails.data.productVariants[0].productImages[0]),*/
            FutureBuilder(
              future: firebaseStorageService.getImage(context,widget.img),
              builder: (context,snapshot){
                if (snapshot.connectionState== ConnectionState.done){
                  return Container(
                    padding:const EdgeInsets.fromLTRB(30.0,20.0,10.0,10.0,),
                    width: 300,
                    height:300 ,
                    child: snapshot.data,
                  );
                }
                if (snapshot.connectionState== ConnectionState.waiting){
                  return Container(
                    width: 400,
                    height:200 ,
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Dish Name".toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF565656))),
                  Text(widget.dishname,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black45)),

                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Price".toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF565656))),
                  Text(
                      '\$${widget.price}',
                      style: TextStyle(
                          color:Colors.blueGrey,
                          fontFamily: 'Roboto-Light.ttf',
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Description",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF565656))),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      widget.desc,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4c4c4c))),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              width: double.infinity,
              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Quantity",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF565656))),
                  SizedBox(
                    height: 15,
                  ),
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
                                  total = widget.price * counter;
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
                                total = widget.price * counter;
                                print('${counter}' + ' '+ '${total}');
                              });

                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              color: Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Total:".toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF565656))),
                  Text('\$${total}',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF565656))),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _AddedDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Item is added to cart'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


