// ignore_for_file: constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shorts/view/screens/add_video_screen.dart';
import 'package:shorts/view/screens/messages_screen.dart';
import 'package:shorts/view/screens/profile_screen.dart';
import 'package:shorts/view/screens/search_screen.dart';
import 'dart:math';

import 'package:shorts/view/screens/video_screen.dart';

// getRandomColor() => Colors.primaries[Random().nextInt(Colors.primaries.length)];

getRandomColor() => [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
    ][Random().nextInt(3)];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// PAGES
List pages = [
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  const MessagesScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
