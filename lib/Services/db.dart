import 'package:google_notes_app_clone/Services/firestore_db.dart';
import 'package:google_notes_app_clone/model/my_note_model.dart';
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

import '../home.dart';

class NotesDatabase{
  static final NotesDatabase instance=NotesDatabase._init();
  static Database? _database;
  NotesDatabase._init();

  //check krenge database khaali hai ya usme kuch hai phle se

  Future<Database?> get database async{
    if(_database != null) return _database;
    _database= await _initializeDb("Notes.db");
    return _database;
  }
  //database kha p store kraana hai
  Future<Database> _initializeDb(String filePath)async{
    final dbPath=await getDatabasesPath();

    //database ko kha se kha move krna hai
    final path =join(dbPath,filePath);


    //ab connection create krenge hum to open kr denge database ko
    return await openDatabase(path,version: 1,onCreate: _createDb);
  }


  //Creating a Database
  Future _createDb(Database db, int version) async{
    const idType="INTEGER PRIMARY KEY AUTOINCREMENT";
    const boolType="BOOLEAN NOT NULL";
    const textType="TEXT NOT NULL";

    await db.execute('''
    CREATE TABLE Notes(
    ${NotesImpNames.id} $idType,
    ${NotesImpNames.pin} $boolType,
    ${NotesImpNames.isArchived} $boolType,
    ${NotesImpNames.title} $textType,
    ${NotesImpNames.content} $textType,
    ${NotesImpNames.createdTime} $textType
    )
    ''');
  }


  //Insert Data in Database
  Future<Note?> insertData(Note note)async{
    final db = await instance.database;
    final id = await db!.insert(NotesImpNames.tableName,note.toJson());
    await FireDb().createNewNoteFirestore(note,id.toString());
    return note.copy(id: id);
  }

  //Read all data in database

  Future<List<Note>> readAllNotes() async{
    final db = await instance.database;
    const orderBy='${NotesImpNames.createdTime}  ASC';
    final queryResult= await db!.query(NotesImpNames.tableName,orderBy: orderBy);
    return queryResult.map((json) => Note.fromJason(json)).toList();
  }

  //Read all data for archive
  Future<List<Note>> readAllArchiveNotes() async{
    final db = await instance.database;
    const orderBy='${NotesImpNames.createdTime}  ASC';
    final queryResult= await db!.query(NotesImpNames.tableName,orderBy: orderBy,where: "${NotesImpNames.isArchived}=1");
    return queryResult.map((json) => Note.fromJason(json)).toList();
  }


  
  //Read a Specific Notes

  Future<Note?> readOneNotes(int id) async{
    final db= await instance.database;
    final map = await db!.query(NotesImpNames.tableName,
        columns: NotesImpNames.values,where: "${NotesImpNames.id}= ?",whereArgs: [id]);
    if(map.isNotEmpty){
      return Note.fromJason(map.first);
    }else{
      return null;
    }
  }

  //Update one data in Database

  Future updateNotes(Note note) async{
    final db= await instance.database;
    await db?.update(NotesImpNames.tableName, note.toJson(),
    where: "${NotesImpNames.id}=?",
    whereArgs: [note.id]);
    await FireDb().updateNoteFirestore(note);
  }

  //pin note functionality

  Future pinNotes(Note note) async{
    final db= await instance.database;
    await db?.update(NotesImpNames.tableName, {NotesImpNames.pin:!note.pin?1:0},
        where: "${NotesImpNames.id}=?",
        whereArgs: [note.id]);
  }

  //archive note functionality

 Future archiveNotes(Note note) async{
    final db= await instance.database;
    await db?.update(NotesImpNames.tableName, {NotesImpNames.isArchived:!note.isArchived?1:0},
        where: "${NotesImpNames.id}=?",
        whereArgs: [note.id]);
  }


  //Delete Note from Database

  Future deleteNotes(Note note)async{
    await FireDb().deleteNoteFirestore(note);
    final db= await instance.database;
    await db!.delete(NotesImpNames.tableName,
    where: "${NotesImpNames.id}=?",
    whereArgs: [note.id]);
  }

  //Get Id's in search page
  Future<List<int>> getNoteString(String query) async{
    final db= await instance.database;
    //isme jitni bhi query thi wo hmne nikaal di ek result naam ke variable m
    final result = await db!.query(NotesImpNames.tableName);
    List<int> resultIds = [];
    //finally we can search either title or content
    result.forEach((element) {
      if(element["title"].toString().toLowerCase().contains(query)|| element["content"].toString().toLowerCase().contains(query)){
        resultIds.add(element["id"] as int);
      }
    });

    return resultIds;
  }


  //Closing a Database

  Future closeDB() async{
    final db=await instance.database;
    db!.close();
  }

}
