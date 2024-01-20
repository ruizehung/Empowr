import 'package:flutter/material.dart';

class ViewEncouragement extends StatefulWidget {
  const ViewEncouragement({super.key});

  @override
  State<ViewEncouragement> createState() => _ViewEncouragementState();
}

class _ViewEncouragementState extends State<ViewEncouragement> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("View Encouragement"),
    );
  }
}
