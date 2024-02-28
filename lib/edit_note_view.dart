import 'package:flutter/material.dart';
import 'package:google_notes_app_clone/NoteView.dart';
import 'package:google_notes_app_clone/Services/db.dart';
import 'package:google_notes_app_clone/colors.dart';
import 'package:google_notes_app_clone/home.dart';
import 'model/my_note_model.dart';

class EditNoteView extends StatefulWidget {
   Note note;
   EditNoteView({required this.note,super.key});
  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {

  late String newTitle;
  late String newContent;
  @override
  void initState() {
    newTitle=widget.note.title.toString();
    newContent= widget.note.content.toString();
    super.initState();
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
              Note newNote = Note(title: newTitle,content: newContent,createdTime: widget.note.createdTime,pin: widget.note.pin,isArchived: widget.note.isArchived,id: widget.note.id);
              await NotesDatabase.instance.updateNotes(newNote);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
            },
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Form(
              child: TextFormField(
                initialValue: newTitle,
                onChanged: (value){
                  newTitle=value;
                },
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
            ),
            Container(
              height: 400,
              child: Form(
                child: TextFormField(
                  initialValue: newContent,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value){
                    newContent=value;
                  },
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
