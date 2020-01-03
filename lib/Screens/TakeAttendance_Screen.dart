import 'package:flutter/material.dart';
import '../Models/Session.dart';

class TakeAttendance extends StatefulWidget {
  CurrentSession sessionData;
  TakeAttendance({this.sessionData});
  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  CurrentSession activeSession;
  void initState() {
    super.initState();
    updateUI(widget.sessionData);
  }

  void updateUI(dynamic tData) {
    setState(() {
      if (tData == null) {
        return;
      }
      activeSession = tData;
//if(_appData.appDataSessions == null){
      // _appData.appDataSessions = new
//}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        //const SizedBox(width: 25),
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            activeSession.department,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            activeSession.campusLocation,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            activeSession.day,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            activeSession.timeOfDay,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
