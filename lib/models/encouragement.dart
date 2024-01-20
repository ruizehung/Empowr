import 'package:cloud_firestore/cloud_firestore.dart';

class Encouragement {
  late String senderID;
  late String content;
  late DateTime createdAt;

  Encouragement({
    required this.senderID,
    required this.content,
    required this.createdAt,
  });

  factory Encouragement.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Encouragement(
      senderID: data?['senderID'],
      content: data?['content'],
      createdAt: data?['createdAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "senderID": senderID,
      "content": content,
      "createdAt": createdAt,
    };
  }
}