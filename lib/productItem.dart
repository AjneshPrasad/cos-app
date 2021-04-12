import 'package:cloud_firestore/cloud_firestore.dart';

class ProductItemModel{
  String title;
  double price;
  String img;
  String desc;
  bool added;

  ProductItemModel({
    this.title,
    this.price,
    this.img,
});
  // ProductItemModel.fromMap(Map<String,dynamic>data){
  //   title= data['title'];
  //   price= data['price'];
  //   img= data['img'];
  //   desc= data['desc'];
  // }
}