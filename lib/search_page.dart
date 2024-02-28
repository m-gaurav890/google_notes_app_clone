import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_notes_app_clone/Services/db.dart';
import 'package:google_notes_app_clone/colors.dart';
import 'NoteView.dart';
import 'model/my_note_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //Search notes isss list m save honge jo hum search kraynge
  List<Note?> searchResultNotes = [];
  List<int> searchResultIDs = [];

  bool isLoading = false;

  void searchResult(String query) async {
    searchResultNotes.clear();
    setState(() {
      isLoading = true;
    });
    //db.dart m bnaya hai getNoteString
    final resultIds = await NotesDatabase.instance.getNoteString(query);
    List<Note?> searchResultNotesLocal = [];
    resultIds.forEach((element) async {
      final searchNote = await NotesDatabase.instance.readOneNotes(element);
      searchResultNotesLocal.add(searchNote);
      setState(() {
        searchResultNotes.add(searchNote);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: white.withOpacity(0.1)
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: white,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          setState(() {
                            searchResult(value.toLowerCase());
                          });
                        },
                        cursorColor: white,
                        style: TextStyle(fontSize: 18, color: white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Search Your Notes",
                          hintStyle: TextStyle(
                            fontSize: 18,
                            color: white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  : noteSectionAll()
            ]
          ),
        ),
      ),
    );
  }



  Widget noteSectionAll() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "Search Results",
              style: TextStyle(
                  color: white.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: MasonryGridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: searchResultNotes.length,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              itemBuilder: (context, index) =>
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NoteViewState(
                                      note: searchResultNotes[index]!)));
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: white.withOpacity(0.4),
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            searchResultNotes[index]!.title,
                            style: TextStyle(
                                color: white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            searchResultNotes[index]!.content.length > 250
                                ? "${searchResultNotes[index]!.content.substring(
                                0, 250)}....."
                                : searchResultNotes[index]!.content,
                            style: TextStyle(color: white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}