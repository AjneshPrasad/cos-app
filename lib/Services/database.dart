import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  getData(String collection) async {
    await Firebase.initializeApp();
    return await FirebaseFirestore.instance.collection(collection).get();
  }
  Future<void> addUser(credentials) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('User').add(credentials).catchError((e){
      print(e);
    });
  }
  Future<void> Payrollregister(credentials) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('Pending registration request').add(credentials).catchError((e){
      print(e);
    });
  }
  Future<void> Payrollapproved(credentials) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('Payroll deduction users').add(credentials).catchError((e){
      print(e);
    });
  }
  Future<void> addToCart(item) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('User Cart').add(item).catchError((e){
      print(e);
    });
  }
  Future<void> checkout(item) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('checkout order').add(item).catchError((e){
      print(e);
    });
  }
  Future<void> UpdateCart(Selected,newValues) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('User Cart').doc(Selected).update(newValues).catchError((e){
      print(e);
    });
  }
  Future<void> DeleteCart(docId) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('User Cart').doc(docId).delete().catchError((e){
      print(e);
    });
  }
  Future<void> DeleteRequest(docId) async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.collection('Pending registration request').doc(docId).delete().catchError((e){
      print(e);
    });
  }
}

class FirebaseStorageService extends ChangeNotifier{
  FirebaseStorageService();
  static Future<dynamic> loadImage(BuildContext context,String img) async{
    return await FirebaseStorage.instance.ref().child(img).getDownloadURL();
  }

  Future<Widget> getImage(BuildContext context,String imgName) async{
    Image img;
    await Firebase.initializeApp();
    await FirebaseStorageService.loadImage(context, imgName).then((value) {
      img= Image.network(
        value.toString(),
        fit: BoxFit.cover,
      );
    });
    return img;
  }

}



//flutter run --web-renderer html
//flutter run -d chrome --release
//flutter run -d chrome --web-renderer html
//flutter run -d chrome --release --web-renderer html
