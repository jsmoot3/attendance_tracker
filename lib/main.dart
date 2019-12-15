import 'package:flutter/material.dart';
import 'package:attendance_tracker/Screens/Start_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Store/reducer.dart';

void main() {
  final Store<int> store = Store<int>(reducer, initialState: 0);
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<int> store;
  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Attendence TrackerV2',
          home: StartScreen(),
        ));
  }
}
