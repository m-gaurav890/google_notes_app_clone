import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_notes_app_clone/colors.dart';
import 'package:google_notes_app_clone/logIn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Services/login_info.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late bool value ;

  getSyncSet()async{
    LocalDataSaver.getSyncData().then((valueFromDb) {
      setState(() {
        value=valueFromDb!;
      });
    });
  }

  @override
  void initState() {
    getSyncSet();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: bgColor,
        elevation: 0.0,
        title:  Text("Settings",style: TextStyle(
          color: white
        ),),
        actions: [
          IconButton(onPressed: ()async{
            await GoogleSignIn().signOut();
            FirebaseAuth.instance.signOut();
            LocalDataSaver.saveLoginData(false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Sync",
                  style: TextStyle(
                    color: white,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Transform.scale(
                  scale: 1,
                  child: Switch.adaptive(
                      value: value,
                      onChanged: (switchValue) => setState(() {
                            this.value = switchValue;
                            LocalDataSaver.saveSyncSet(switchValue);
                          })),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
