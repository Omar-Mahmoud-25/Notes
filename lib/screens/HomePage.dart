import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_project/screens/NoteProvider.dart';
import 'globals.dart';

class MyNotesHomePage extends StatefulWidget {
  const MyNotesHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyNotesHomePage> createState() => _MyNotesHomePageState();
}

class _MyNotesHomePageState extends State<MyNotesHomePage> {
  final Color _forNote = const Color.fromARGB(100, 128, 128, 128);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

  NoteProvider noteProvider = NoteProvider();
  Future<List<Note>> getNotes() async {
    final Notes = await FirebaseFirestore.instance
        .collection('Notes')
        .doc(user!.uid)
        .get();
    Map<dynamic, dynamic> mp = jsonDecode((Notes.data() as Map)['note']);
    List<Note> notes = noteProvider.getNotes(mp);

    return notes;
    // List <dynamic> contents = (Notes.data() as Map)['content'];
  }

  Future setNotes() async {
    Map<dynamic, dynamic> notes = {};
    for (var item in noteProvider.notes) {
      notes[item.title] = item.content;
    }
    var json = jsonEncode(notes);
    final Notes = await FirebaseFirestore.instance
        .collection('Notes')
        .doc(user!.uid)
        .set({'note': json});
  }

  void _addNote(Note note) {
    setState(() {
      noteProvider.notes.add(note);
    });
    setNotes();
    titleController.clear();
    contentController.clear();
    Navigator.pop(context);
  }

  void _showAddNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add new Note'),
              // backgroundColor: _forNote,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Tilte'),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(labelText: 'content'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      _addNote(
                        Note(
                          title: titleController.text,
                          content: contentController.text
                        )
                      );
                    },
                    child: const Text('Add'))
              ],
            ));
    titleController.clear();
    contentController.clear();
  }

  void _showNote(Note note) {
    TextEditingController titleEditorController =
        TextEditingController(text: note.title);
    TextEditingController contentEditorController =
        TextEditingController(text: note.content);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: TextField(
                controller: titleEditorController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              content: TextField(
                controller: contentEditorController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        noteProvider.notes.remove(note);
                      });
                      setNotes();
                      Navigator.pop(context);
                    },
                    child: const Text('Delete')),
                TextButton(
                  onPressed: () {
                    setState(() {
                      note.title = titleEditorController.text;
                      note.content = contentEditorController.text;
                    });
                    setNotes();
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        backgroundColor: back,
        title: Text(
          'Notes',
          style: TextStyle(color: txt),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                invertColors();
              });
            },
            icon: const Icon(Icons.invert_colors),
            color: butt,
            tooltip: 'Invert Colors',
            highlightColor: back,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined),
            color: butt,
            tooltip: 'Settings',
            highlightColor: txt,
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'LogOut',
            color: butt,
            highlightColor: txt,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: FutureBuilder<List<Note>>(
          future: getNotes(),
          builder: (context, snapshot) => Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return InkWell(
                    onTap: () => _showNote(note),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: _forNote,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: txt),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            note.content,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: txt,
                            ),
                          ),
                        ],
                      ),
                    ));
              },
              itemCount: noteProvider.notes.length,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: _showAddNote,
        backgroundColor: butt,
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
