import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomarce_store/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier{

  UserModel? _userModel;
  UserModel? get getUserModel{

    return _userModel;
  }

  Future<UserModel?> fetchUserInfo() async{
     final FirebaseAuth auth = FirebaseAuth.instance;
     User? user = auth.currentUser;

     if(user == null){
      return null;
     }

     var uid = user.uid;
     try{
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final userDocDict = userDoc.data();
        _userModel = UserModel(
          userId: userDoc.get('userId'), 
          userName: userDoc.get('userName'), 
          userImage: userDoc.get('userImage'), 
          userEmail: userDoc.get('userEmail'), 
          createdAt: userDoc.get('createdAt'), 
          userCart: userDocDict!.containsKey('userCart') ? userDoc.get('userCart') : [], 
          userWish: userDocDict.containsKey('userWish') ? userDoc.get('userWish') : []
          );
     }on FirebaseAuthException catch (error){
      throw error.message.toString();
     }catch (error){
      rethrow;
     }
  }
}