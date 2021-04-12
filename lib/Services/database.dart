import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  final CollectionReference resturants = FirebaseFirestore.instance.collection('Hotbread');

  Future<void>createDishData(String title,int price,String img,String desc,String uid)async{
    return await resturants.doc(uid).set({
      'title': title,
      'price':price,
      'img':img,
      'desc':desc
    });
  }

  Future getDish()async{
    List itemList = [];

    try{
      await resturants.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          itemList.add(element.data());
        });
      });
      return itemList;
    }catch(e){

      print(e.toString());
      return null;
    }
  }
}