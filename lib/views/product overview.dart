import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class productView extends StatefulWidget{
  @override
  _productViewState createState() => _productViewState();
}

class _productViewState extends State<productView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              hero()
            ],
          ),
        )
    );

  }

  Widget hero(){
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset("images/shoe_blue.png",), //This
          // should be a paged
          // view.

        ],
      ),
    );
  }
}