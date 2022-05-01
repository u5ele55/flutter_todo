import 'package:flutter/material.dart';

import 'package:todo/globals.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/home_page.dart';

class NotePage extends StatefulWidget {
  final Note note;
  const NotePage({Key? key, required this.note}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late final TextEditingController _titleEditingController =
      TextEditingController(text: widget.note.title);
  late final TextEditingController _descriptionEditingController =
      TextEditingController(text: widget.note.description);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              children: [
                _textField(_titleEditingController, "Title"),
                _textField(_descriptionEditingController, "Description"),
                const Spacer(),
                if (widget.note.id != -1) _deleteButton(),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _updateCurrentNote,
              icon: const Icon(Icons.done),
              tooltip: "Done",
            )
          ],
          title: Text(widget.note.id == -1 ? "New note" : "Edit note"),
        ),
      ),
    );
  }

  _updateCurrentNote() async {
    Note changedNote = widget.note;
    changedNote.title = _titleEditingController.text;
    changedNote.description = _descriptionEditingController.text;

    String msg = "";

    if (changedNote.id != -1) {
      await dbHandler.updateNote(changedNote);
      msg = "Note edited!";
    } else {
      await dbHandler.pushNote(changedNote);
      msg = "New note added!";
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  _textField(TextEditingController controller, String name) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: name,
              ),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      );

  _deleteButton() => TextButton.icon(
        onPressed: () async => {
          await dbHandler.deleteNote(widget.note.id),
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Note "${widget.note.title}" deleted!'),
            ),
          ),
        },
        icon:
            Icon(Icons.delete, size: 24, color: Theme.of(context).primaryColor),
        label: Text(
          "Delete",
          style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
        ),
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Theme.of(context).shadowColor),
          elevation: MaterialStateProperty.all(4),
          backgroundColor: MaterialStateProperty.all(Colors.white),
        ),
      );
}
