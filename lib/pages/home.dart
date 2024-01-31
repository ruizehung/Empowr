import 'dart:async';
import 'dart:math';

import 'package:empowr/pages/affirmation.dart';
import 'package:empowr/pages/leave_note.dart';
import 'package:empowr/pages/view_encouragement.dart';
import 'package:empowr/pages/send_encouragement.dart';
import 'package:empowr/pages/signin.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:empowr/pages/notifi_service.dart';

List<String> affirmations = [
  "The more I focus my mind upon the good, the more good comes to my life.",
  "I am fine with who I am, and I love who I am becoming.",
  "Stepping out of my comfort zone is necessary for growth.",
  "I am worthy of love and respect.",
  "I believe in myself.",
  "Every challenge I face is an opportunity to grow and improve",
  "I am in charge of my own happiness, and I cultivate it with positive thoughts and actions.",
  "I am resilient, strong, and capable of handling whatever comes my way.",
  "I attract success by being my authentic self.",
  "Gratitude fills my heart and shapes my perspective on life.",
];

// Create an enum for pages
enum Pages { affirmations, sendEncouragement, leaveNote, receiveEncouragement }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = PageController(initialPage: 0);
  Pages currentPage = Pages.affirmations;

  final _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  String getRandomAffirmation() {
    return affirmations[Random().nextInt(affirmations.length)];
  }

  Future<void> runAlarm() async {
    while (true) {
      NotificationService()
          .showNotification(title: 'Empowr', body: getRandomAffirmation());

      // Push notification appears every 30 minutes on lock screen
      await Future.delayed(Duration(minutes: 30));
    }
  }

  @override
  Widget build(BuildContext context) {
    runAlarm(); // Call the runAlarm function in the main method
    // Check if user is logged in
    if (_user == null) {
      return const SignInPage();
    }

    Widget body;
    switch (currentPage) {
      case Pages.affirmations:
        body = PageView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final affirmation = affirmations[Random().nextInt(affirmations.length)];
            return Affirmation(content: affirmation);
          },
        );
      case Pages.sendEncouragement:
        body = const SendEncouragement();
      case Pages.leaveNote:
        body = const LeaveNote();
      case Pages.receiveEncouragement:
        body = const ViewEncouragement();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Empowr',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/affirmation_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: body,
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(240, 217, 209, 1),
              ),
              padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top,
                bottom: 24,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage(_user?.photoURL ??
                        'https://t4.ftcdn.net/jpg/05/42/36/11/360_F_542361185_VFRJWpR2FH5OiAEVveWO7oZnfSccZfD3.jpg'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _user?.displayName ?? 'User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _user?.email ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sunny),
              title: const Text('Affirmations'),
              onTap: () {
                setState(() {
                  currentPage = Pages.affirmations;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sentiment_satisfied_alt_rounded),
              title: const Text('Send Encouragement'),
              onTap: () {
                setState(() {
                  currentPage = Pages.sendEncouragement;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Leave a note'),
              onTap: () {
                setState(() {
                  currentPage = Pages.leaveNote;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_rounded),
              title: const Text('View Encouragement'),
              onTap: () {
                setState(() {
                  currentPage = Pages.receiveEncouragement;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                _auth.signOut();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_mark_outlined),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Empowr',
                  applicationVersion: '1.0.0',
                  children: [
                    const Text(
                        'Empowr is a daily affirmation app designed to motivate users to read' 
                        'several affirmations each day, enhancing their self-esteem, cultivating' 
                        'a positive outlook, and alleviating stress. It also allows users to'
                        'anonymously share notes about their encouragement needs, fostering a' 
                        'supportive community where members can exchange anonymous words of' 
                        'motivation and support.'
                    ),
                  ],
                );
                
              },
            ),
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
