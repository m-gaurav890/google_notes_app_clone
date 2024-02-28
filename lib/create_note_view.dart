import 'package:flutter/material.dart';
import 'package:google_notes_app_clone/Services/db.dart';
import 'package:google_notes_app_clone/home.dart';

import 'colors.dart';
import 'model/my_note_model.dart';

class CreateNoteView extends StatefulWidget {
  const CreateNoteView({super.key});

  @override
  State<CreateNoteView> createState() => _CreateNoteViewState();
}

class _CreateNoteViewState extends State<CreateNoteView> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: white),
        actions: [
          IconButton(
            onPressed: () async {
              await NotesDatabase.instance.insertData(Note(
                title: title.text,
                content: content.text,
                pin: false,
                isArchived: false,
                createdTime: DateTime.now(),
              ));
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: title,
              cursorColor: white,
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold, color: white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.withOpacity(0.8))),
            ),
            Container(
              height: 400,
              child: TextField(
                controller: content,
                keyboardType: TextInputType.multiline,
                minLines: 50,
                maxLines: null,
                cursorColor: white,
                style: TextStyle(fontSize: 18, color: white),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Note",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
