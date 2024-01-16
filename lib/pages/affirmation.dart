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
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Align items to center
          children: [
            Text(
              widget.content,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share(widget.content); // Share the affirmation
                  },
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
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
      ),
    );
    ;
  }
}
