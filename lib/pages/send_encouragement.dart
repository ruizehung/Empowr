import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:empowr/models/encouragement.dart';
import 'package:empowr/models/notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SendEncouragement extends StatefulWidget {
  const SendEncouragement({super.key});

  @override
  State<SendEncouragement> createState() => _SendEncouragementState();
}

class _SendEncouragementState extends State<SendEncouragement> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final TextEditingController _encouragementController =
      TextEditingController();
  Note? noteToGiveEncouragement;

  Future<Note?> fetchNoteToGiveEncouragement() async {
    var querySnapshot = await db
        .collection("notes")
        .orderBy('encouragementCount', descending: false)
        .orderBy('createdAt', descending: false)
        .limit(10)
        .get();

    // Create a new list from the documents
    var filteredDocs = List.from(querySnapshot.docs);

    // Filter out notes that are owned by the current user
    filteredDocs.removeWhere((note) {
      return note.data()['ownerID'] == _auth.currentUser!.uid;
    });

    // After filtering, check if there are any documents left
    if (filteredDocs.isNotEmpty) {
      return Note.fromFirestore(filteredDocs.first, null);
    } else {
      return null; // Return null if no notes are found
    }
  }

  Future<void> showSuccessDialogue(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success!'),
          content: const Text('Your encouragement has been sent!'),
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

  void _sendEncouragement() {
  if (_encouragementController.text.isEmpty) {
    return;
  }

  String noteID = noteToGiveEncouragement!.id!;
  var encouragement = Encouragement(
    senderID: _auth.currentUser!.uid,
    content: _encouragementController.text,
    createdAt: DateTime.now(),
  );

  // Add the encouragement to the subcollection
  db
      .collection("notes")
      .doc(noteID)
      .collection("encouragements")
      .add(encouragement.toFirestore())
      .then((documentSnapshot) {
    // Update the encouragement count in the main notes collection
    db.collection("notes").doc(noteID).update({
      'encouragementCount': FieldValue.increment(1),
    }).then((value) {
      showSuccessDialogue(context);
      // Clear the text field after sending
      _encouragementController.clear();
    }).catchError((error) {
      print("Error updating encouragement count: $error");
    });
  }, onError: (e) => print("Error adding document $e"));
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Note?>(
      future: fetchNoteToGiveEncouragement(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        noteToGiveEncouragement = snapshot.data;

        if (noteToGiveEncouragement == null) {
          return const Padding(
            padding: EdgeInsets.only(left: 32, right: 32),
            child: Center(
              child: Text(
                'No notes to give encouragement at this time : (',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(noteToGiveEncouragement!.content),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _encouragementController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Write your words of encouragement here...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _sendEncouragement,
                child: const Text('Send'),
              ),
            ],
          ),
        );
      },
    );
  }
}
