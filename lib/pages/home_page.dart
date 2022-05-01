import 'package:flutter/material.dart';
import 'package:todo/globals.dart';
import 'package:todo/models/database.dart';
import 'package:todo/models/note.dart';
import 'package:todo/pages/note_page.dart';
import 'package:todo/widgets/note_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Note> allNotes;

  Future<List<Note>> databaseThing() async {
    allNotes = await dbHandler.getNotes();
    return allNotes;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _addNoteDialog,
              icon: const Icon(Icons.add),
              tooltip: "Add new note",
            ),
          ],
          title: const Text("Your notes"),
        ),
        body: Container(
          child: notesList(),
        ),
      ),
    );
  }

  _addNoteDialog() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotePage(note: Note(-1, "", "")),
        ));
  }

  Widget notesList() => FutureBuilder(
        future: databaseThing(),
        builder: (context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  NoteItem(note: snapshot.data![index]),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return const Center(
              child: SizedBox(
                height: 56,
                width: 56,
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 122, 90, 0),
                ),
              ),
            );
          }
        },
      );
}
