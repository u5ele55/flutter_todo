import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'note.dart';

class DBHandler {
  Future<Database>? database;
  bool isInitCalled = false;

  Future<void> initDatabase() async {
    if (isInitCalled) return;
    isInitCalled = true;
    database = openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<Database> getDatabase() async => database!;

  Future<void> insertNote(Note note) async {
    final db = await getDatabase();
    await db.insert(
      "notes",
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// add note to the last free id (s.t there's no id that's bigger)
  Future<void> pushNote(Note note) async {
    final db = await getDatabase();
    final d = await db.query("notes", orderBy: "id DESC", limit: 1);
    int lastId = int.parse(d[0]["id"].toString());
    note.id = lastId + 1;
    await insertNote(note);
  }

  Future<List<Note>> getNotes() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query("notes");

    return List.generate(
      maps.length,
      (index) => Note.fromMap(maps[index]),
    );
  }

  Future<void> updateNote(Note note) async {
    final db = await getDatabase();
    await db.update(
      "notes",
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await getDatabase();
    await db.delete(
      "notes",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
