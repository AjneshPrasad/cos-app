
import 'package:cos/Model/member.dart';
import 'package:cos/Model/user.dart';
import 'package:cos/views/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class AuthService{
  final FirebaseAuth _auth= FirebaseAuth.instance;
  Member member;
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
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  //Register with email and password
  Future registerWithEmailAndPass(String email,String password)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user= result.user;
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