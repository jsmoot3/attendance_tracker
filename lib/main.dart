import 'package:flutter/material.dart';
import 'package:attendance_tracker/Screens/loading_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendence TrackerV2',
      home: LoadingScreen(),
    );
  }
}
