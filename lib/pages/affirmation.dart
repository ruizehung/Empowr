import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class Affirmation extends StatefulWidget {
  const Affirmation({super.key, required this.content});

  final String content;

  @override
  State<Affirmation> createState() => _AffirmationState();
}

class _AffirmationState extends State<Affirmation> {
  bool isLiked = false; // State to manage the like button

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 32, right: 32),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Center(
            child: Text(
              widget.content,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.share),
              iconSize: 40,
              onPressed: () {
                Share.share(widget.content); // Share the affirmation
              },
            ),
            const SizedBox(height: 100),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                
                color: isLiked ? Colors.red : null,
              ),
              iconSize: 40,
              onPressed: () {
                setState(() {
                  isLiked = !isLiked; // Toggle the like state
                });
              },
            ),
          ],
        ),
      ],
    ),
  );
}
}

