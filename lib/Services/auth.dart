
import 'package:cos/Model/user.dart';
import 'package:cos/views/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class AuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  DatabaseService databaseService = new DatabaseService();

  //create user obj based on Firebase user
  USer _userFromFirebaseUser(User user){
    return user != null ? USer(uid: user.uid):null;
  }

  Stream<USer> get user{
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }
  //sign in with email and password
  Future signIn(String email,String password)async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user= result.user;
      print(user.uid);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //Register with email and password
  Future registerWithEmailAndPass(String email,String password,String firstName,surname,String id,String mobile,)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _auth.currentUser.sendEmailVerification();
      User user= result.user;
      Map credentials = {
        'First name':firstName,'Surname':surname,'email':email,
        'empId':id,'mobile':mobile,'pass':password,'userId':user.uid
      };
      databaseService.addUser(credentials);
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //Signout
  Future signOut() async{
    try{
      return await _auth.signOut();

    }
    catch(e){
      print((e.toString()));
      return null;
    }
  }


}