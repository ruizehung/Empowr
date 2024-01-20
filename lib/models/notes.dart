import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  late String? id;
  late String ownerID;
  late String content;
  late DateTime createdAt;
  late int encouragementCount;

  Note({
    this.id,
    required this.ownerID,
    required this.content,
    required this.createdAt,
    required this.encouragementCount,
  });

  factory Note.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final Timestamp timestamp = data?['createdAt'] as Timestamp; // Get Timestamp
    final DateTime dateTime = timestamp.toDate(); // Convert to DateTime

    return Note(
      id: snapshot.id,
      ownerID: data?['ownerID'],
      content: data?['content'],
      createdAt: dateTime,
      encouragementCount: data?['encouragementCount'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      "ownerID": ownerID,
      "content": content,
      "createdAt": createdAt,
      "encouragementCount": encouragementCount,
    };
  }
}