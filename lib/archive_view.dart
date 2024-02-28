import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_notes_app_clone/search_page.dart';
import 'package:google_notes_app_clone/side_menu_bar.dart';

import 'NoteView.dart';
import 'Services/db.dart';
import 'Services/login_info.dart';
import 'colors.dart';
import 'model/my_note_model.dart';

class ArchiveView extends StatefulWidget {
  const ArchiveView({super.key});

  @override
  State<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  late String? imageUrl;
  bool isLoading = true;
  List<Note> notesList = [];
  bool isStaggered = true;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  //Read All

  Future getAllNotes() async {
    LocalDataSaver.getImg().then((value) {
      if (this.mounted) {
        imageUrl = value;
      }
    });
    this.notesList = await NotesDatabase.instance.readAllArchiveNotes();
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    getAllNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: CircularProgressIndicator(
                color: white,
              ),
            ),
          )
        : Scaffold(
            endDrawerEnableOpenDragGesture: true,
            key: _drawerKey,
            drawer: const SideMenu(),
            backgroundColor: bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //Search container
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: black.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3)
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: cardColor,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchPage()));
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 200,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Search Your Notes",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: white.withOpacity(0.5)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //second Row
                            Container(
                              padding: const EdgeInsets.only(right: 5),
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isStaggered = !isStaggered;
                                      });
                                    },
                                    child: Icon(
                                      Icons.grid_view,
                                      color: white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  CircleAvatar(
                                    onBackgroundImageError:
                                        (object, StackTrace) {
                                      print("ok");
                                    },
                                    radius: 19,
                                    backgroundImage: NetworkImage(
                                      imageUrl.toString(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      isStaggered ? noteSectionAll() : noteListSection(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget noteSectionAll() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Text(
                "All",
                style: TextStyle(
                    color: white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: MasonryGridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: notesList.length,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NoteViewState(note: notesList[index])));
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
                      notesList[index].title,
                      style: TextStyle(
                          color: white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      notesList[index].content.length > 250
                          ? "${notesList[index].content.substring(0, 250)}....."
                          : notesList[index].content,
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget noteListSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              Text(
                "All",
                style: TextStyle(
                    color: white.withOpacity(0.5),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notesList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NoteViewState(note: notesList[index])));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
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
                      notesList[index].title,
                      style: TextStyle(
                          color: white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      notesList[index].content.length > 250
                          ? "${notesList[index].content.substring(0, 250)}....."
                          : notesList[index].content,
                      style: TextStyle(color: white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
