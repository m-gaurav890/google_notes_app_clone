import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_notes_app_clone/Services/login_info.dart';
import 'package:google_notes_app_clone/model/my_note_model.dart';
import 'db.dart';

class FireDb {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //In this we will create four method --> Create, Read, Update and Delete

  //Create

  createNewNoteFirestore(Note note, String id) async {
    LocalDataSaver.getSyncData().then((isSyncOn)async {
      //sync state check
      if(isSyncOn.toString()=="true"){
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("usernotes")
            .doc(id)
            .set({
          "Title": note.title.toString(),
          "Content": note.content.toString(),
          "Date": note.createdTime,
        }).then((_) {
          print("Data added successfully");
        });
      }
    });

  }

  //Read
  getAllStoredNotes() async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(current_user!.email)
        .collection("usernotes")
        .orderBy("Date")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Map note = result.data();

        //Converting Time stamp to DateTime
        Timestamp timestamp = note["Date"];
        DateTime dateTime = timestamp.toDate();

        //Inserting note here
        NotesDatabase.instance.insertData(Note(
            pin: false,
            isArchived: false,
            title: note["Title"],
            content: note["Content"],
            createdTime: dateTime));
      });
    });
  }

  //update

  updateNoteFirestore(Note note) async {
    LocalDataSaver.getSyncData().then((isSyncOn) async {
      //sync state check
      if(isSyncOn.toString()=="true"){
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("usernotes")
            .doc(note.id.toString())
            .update({
          "Title": note.title.toString(),
          "Content": note.content
        }).then((_) {
          print("updated successfully");
        });
      }
    });

  }

  deleteNoteFirestore(Note note) async {

    LocalDataSaver.getSyncData().then((isSyncOn)async {
      //sync state check
      if(isSyncOn.toString()=="true"){
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("usernotes")
            .doc(note.id.toString())
            .delete()
            .then((_) {

          print("Data deleted Successfully");
        });
      }
    });

  }
}
