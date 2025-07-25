import 'package:ecomarce_store/root_screen.dart';
import 'package:ecomarce_store/services/my_app_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_sign_in/google_sign_in.dart';


class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn({required BuildContext contex}) async{
    final googleSignIn = GoogleSignIn(); 
    final googleAccount = await googleSignIn.signIn();
    if(googleAccount != null){
      final googleAuth = await googleAccount.authentication;
      if(googleAuth.accessToken != null && googleAuth.idToken != null){
        try{

          final authResults = await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
          ));
          WidgetsBinding.instance.addPostFrameCallback((_) async{
            Navigator.push(contex, MaterialPageRoute(builder: (contex)=> RootScreen()));
          });

        }on FirebaseAuthException catch(error){
           WidgetsBinding.instance.addPostFrameCallback((_) async{
            await MyAppMethod.showErrorORWarningDialog(
              context: contex, 
              subtitle: 'An error has been occured ${error.message}', 
              fct: (){}
              );
          });
        }catch(error){
             WidgetsBinding.instance.addPostFrameCallback((_) async{
            await MyAppMethod.showErrorORWarningDialog(
              context: contex, 
              subtitle: 'An error has been occured $error', 
              fct: (){}
              );
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )
      ),
      onPressed: (){
        _googleSignIn(contex: context);
      },
      icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,), 
      label: Text('sigin with google', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),));
  }
}