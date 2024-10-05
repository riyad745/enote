import 'package:enote/model/note.dart';
import 'package:enote/pages/note_detail.dart';
import 'package:flutter/material.dart';

class FavoriteNotesPage extends StatelessWidget {
  final List<Note> favoriteNotes;

  const FavoriteNotesPage({super.key, required this.favoriteNotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Favorite Notes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favoriteNotes.length,
        itemBuilder: (context, index) {
          final note = favoriteNotes[index];
          return Dismissible(
            key: Key(note.title),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Note "${note.title}" removed from favorites'),
                duration: const Duration(seconds: 2),
              ));
            },
            child: Card(
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(note.description.toString().substring(0, 2)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailsPage(note: note),
                    ),
                  );
                },
                trailing: const Icon(Icons.arrow_forward_ios_outlined),
              ),
            ),
          );
        },
      ),
    );
  }
}
