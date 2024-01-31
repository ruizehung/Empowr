import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowr/models/notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeaveNote extends StatefulWidget {
  const LeaveNote({super.key});

  @override
  State<LeaveNote> createState() => _LeaveNoteState();
}

class _LeaveNoteState extends State<LeaveNote> {
  final TextEditingController contentController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void> showSuccessDialogue(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: const Text(
              'You will soon receive encouragement from another person!'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void saveNoteToDatabase(BuildContext context) {
    var note = Note(
      ownerID: _auth.currentUser!.uid,
      content: contentController.text,
      createdAt: DateTime.now(),
      encouragementCount: 0,
    );
    db.collection("notes").add(note.toFirestore()).then((documentSnapshot) {
      showSuccessDialogue(context);
      contentController.clear();
    }, onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: contentController,
                maxLines: 8, //or null
                decoration: const InputDecoration.collapsed(
                    hintText:
                        "What do you want encouragement on? E.g. I have a big test tomorrow."),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Add a submit button
          ElevatedButton(
            onPressed: () {
              saveNoteToDatabase(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
