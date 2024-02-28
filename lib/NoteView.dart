import 'package:flutter/material.dart';
import 'package:google_notes_app_clone/Services/db.dart';
import 'package:google_notes_app_clone/colors.dart';
import 'package:google_notes_app_clone/edit_note_view.dart';
import 'package:google_notes_app_clone/home.dart';
import 'package:google_notes_app_clone/model/my_note_model.dart';
import 'package:intl/intl.dart';


class NoteViewState extends StatefulWidget {
  Note note;

  NoteViewState({required this.note, super.key});

  @override
  State<NoteViewState> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteViewState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: white),
        actions: [
          IconButton(
            onPressed: () async{
              await NotesDatabase.instance.pinNotes(widget.note);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
            },
            icon: Icon(widget.note.pin?Icons.push_pin:Icons.push_pin_outlined),
          ),
          IconButton(
            onPressed: () async{
              await NotesDatabase.instance.archiveNotes(widget.note);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
            },
            icon: Icon(widget.note.isArchived? Icons.archive : Icons.archive_outlined),
          ),
          //delete Function
          IconButton(
              onPressed: () async {
                await NotesDatabase.instance.deleteNotes(widget.note);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: const Icon(Icons.delete_forever_outlined)),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditNoteView(
                            note: widget.note,
                          )));
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Created On: ${DateFormat('dd-MM-yyyy – hh:mm').format(widget.note.createdTime)}",
              style: TextStyle(
                color: white,
              ),),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.note.title,
                style: TextStyle(
                    color: white, fontWeight: FontWeight.bold, fontSize: 23),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.note.content,
                style: TextStyle(color: white, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
