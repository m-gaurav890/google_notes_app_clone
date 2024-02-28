import 'package:flutter/material.dart';

import 'model/my_note_model.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final Function() onArchivePressed;

  const NoteWidget({
    required this.note,
    required this.onArchivePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.content),
      trailing: IconButton(
        icon: Icon(Icons.archive),
        onPressed: onArchivePressed, // Call the callback function when pressed
      ),
    );
  }
}