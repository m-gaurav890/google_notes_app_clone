import 'package:flutter/material.dart';
import 'package:google_notes_app_clone/Settings.dart';
import 'package:google_notes_app_clone/archive_view.dart';
import 'package:google_notes_app_clone/colors.dart';
import 'package:google_notes_app_clone/home.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: bgColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                child: Text(
                  "Google Keep",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: white,
                    fontSize: 25,
                  ),
                ),
              ),
              Divider(
                color: white.withOpacity(0.3),
              ),
              SectionOne(),
              SectionTwo(),
              SectionThree(),

            ],
          ),
        ),
      ),
    );
  }

  Widget SectionOne() {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 10),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Colors.orangeAccent.withOpacity(0.3)),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.lightbulb,
                color: white.withOpacity(0.7),
                size: 26,
              ),
              const SizedBox(
                width: 27,
              ),
              Text(
                "Notes",
                style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SectionTwo() {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 10),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ArchiveView()));
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.archive_outlined,
                color: white.withOpacity(0.7),
                size: 26,
              ),
              const SizedBox(
                width: 27,
              ),
              Text(
                "Archive",
                style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget SectionThree() {
    return Container(
      margin: const EdgeInsets.only(right: 10, top: 10),
      child: TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsView()));
        },
        child: Container(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              Icon(
                Icons.settings,
                color: white.withOpacity(0.7),
                size: 26,
              ),
              const SizedBox(
                width: 27,
              ),
              Text(
                "Settings",
                style: TextStyle(color: white.withOpacity(0.7), fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
