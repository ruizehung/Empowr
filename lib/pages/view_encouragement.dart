import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class ViewEncouragement extends StatefulWidget {
  const ViewEncouragement({Key? key}) : super(key: key);

  @override
  State<ViewEncouragement> createState() => _ViewEncouragementState();
}

class _ViewEncouragementState extends State<ViewEncouragement> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: db.collection("notes").orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var notes = snapshot.data?.docs;

        if (notes == null || notes.isEmpty) {
          return const Center(
            child: Text('No notes available.'),
          );
        }

        notes.removeWhere((note) {
          return note.data()['ownerID'] != _auth.currentUser!.uid;
        });

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            var note = notes[index].data();

            return Card(
              child: ExpansionTile(
                title: ListTile(
                  title: Text(
                    note['content'],
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    'Encouragement Count: ${note['encouragementCount'] ?? 0}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                children: [
                  EncouragementsWidget(noteId: notes[index].id),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class EncouragementsWidget extends StatelessWidget {
  final String noteId;

  const EncouragementsWidget({Key? key, required this.noteId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return StreamBuilder(
      stream: db.collection("notes").doc(noteId).collection("encouragements").orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        var replies = snapshot.data?.docs;

        if (replies == null || replies.isEmpty) {
          return const Center(
            child: Text('No replies available.'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: replies.length,
          itemBuilder: (context, index) {
            var reply = replies[index].data();

            return Card(
              child: ListTile(
                title: Text(
                  reply['content'],
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

