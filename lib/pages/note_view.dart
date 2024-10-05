import 'dart:convert';
import 'dart:io';

import 'package:enote/model/note.dart';
import 'package:enote/pages/add_note.dart';
import 'package:enote/pages/favourite_page.dart';
import 'package:enote/pages/note_detail.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final file = await _localFile;
    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      setState(() {
        _notes = jsonList.map((e) => Note.fromJson(e)).toList();
      });
    }
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/notes.json');
  }

  Future<File> _saveNotes() async {
    final file = await _localFile;
    return file.writeAsString(json.encode(_notes));
  }

  void _addNote() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );
    if (newNote != null) {
      setState(() {
        _notes.add(newNote);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Added Successfully')));
      });
      _saveNotes();
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  void _toggleFavorite(int index) {
    setState(() {
      _notes[index].isFavorite = !_notes[index].isFavorite;
    });
    _saveNotes();
  }

  List<Note> get _favoriteNotes {
    return _notes.where((note) => note.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'E-Notes',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteNotesPage(favoriteNotes: _favoriteNotes),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            child: ListTile(
              title: Text(note.title),
              subtitle: Text(
                  _getFirstLine(note.description.toString().substring(0, 2))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailsPage(note: note),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(
                        note.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: note.isFavorite ? Colors.red : null,
                      ),
                      onPressed: () {
                        _toggleFavorite(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to favorite.')),
                        );
                      }),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteNote(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deleted Successfully')),
                      );
                    },
                  ),
                  const Icon(Icons.arrow_forward_ios_outlined),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getFirstLine(String text) {
    // Get the first line of the text
    final List<String> lines = text.split('\n');
    return lines.isNotEmpty ? lines.first : '';
  }
}
