import 'package:flutter/material.dart';

class ReceiveEncouragement extends StatefulWidget {
  const ReceiveEncouragement({super.key});

  @override
  State<ReceiveEncouragement> createState() => _ReceiveEncouragementState();
}

class _ReceiveEncouragementState extends State<ReceiveEncouragement> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Column(
        children: <Widget>[
          // Text(
          //   'Leave a note',
          //   style: TextStyle(fontSize: 28),
          //   textAlign: TextAlign.start,
          // ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 8, //or null
                decoration:
                    InputDecoration.collapsed(hintText: "What do you want encouragement on? E.g. I have a big test tomorrow."),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Add a submit button
          ElevatedButton(
            onPressed: () {
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
