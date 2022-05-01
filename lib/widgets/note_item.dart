import "package:flutter/material.dart";
import 'package:todo/models/note.dart';
import 'package:todo/pages/note_page.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  const NoteItem({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Theme.of(context).shadowColor,
      elevation: 10,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotePage(note: note),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                note.title,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                note.description,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
