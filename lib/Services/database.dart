import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  getData(String collection) async {
    return await FirebaseFirestore.instance.collection(collection).get();
  }
  Future<void> addUser(credentials){
    FirebaseFirestore.instance.collection('User').add(credentials).catchError((e){
      print(e);
    });
  }
  Future<void> Payrollregister(credentials){
    FirebaseFirestore.instance.collection('Pending registration request').add(credentials).catchError((e){
      print(e);
    });
  }
  Future<void> addToCart(item){
    FirebaseFirestore.instance.collection('User Cart').add(item).catchError((e){
      print(e);
    });
  }
  Future<void> checkout(item){
    FirebaseFirestore.instance.collection('checkout order').add(item).catchError((e){
      print(e);
    });
  }
  Future<void> UpdateCart(Selected,newValues){
    FirebaseFirestore.instance.collection('User Cart').doc(Selected).update(newValues).catchError((e){
      print(e);
    });
  }
  Future<void> DeleteCart(docId){
    FirebaseFirestore.instance.collection('User Cart').doc(docId).delete().catchError((e){
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
