import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_notes_app_clone/Services/auth.dart';
import 'package:google_notes_app_clone/Services/login_info.dart';

import 'Services/firestore_db.dart';
import 'home.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(Buttons.Google, onPressed: ()async{
              await signInWithGoogle();
              final User? currentUser=await _auth.currentUser;
              LocalDataSaver.saveLoginData(true);
              LocalDataSaver.saveImg(currentUser!.photoURL.toString());
              LocalDataSaver.saveMail(currentUser.email.toString());
              LocalDataSaver.saveName(currentUser.displayName.toString());
              LocalDataSaver.saveSyncSet(false);
              await FireDb().getAllStoredNotes();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Home()));
            })
          ],
        ),
      ),
    );
  }
}
