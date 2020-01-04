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
  TextEditingController _textFieldController = TextEditingController();
  void initState() {
    super.initState();
    activeSession = new CurrentSession();
    updateUI(widget.sessionData);
  }

  void updateUI(dynamic tData) {
    setState(() {
      if (tData == null) {
        return;
      }
      activeSession = tData;
    });
  }

/*
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textFieldController.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    final nTextField = TextField(
      controller: _textFieldController,
      decoration: InputDecoration(
        //Add th Hint text here.
        hintText: "Group Number",
        border: OutlineInputBorder(),
      ),
      style: TextStyle(
        fontSize: 40.0,
        fontStyle: FontStyle.italic,
        height: 1.5,
      ),
    );

    //submit button
    final subButton = RaisedButton(
      child: Text(
        "Submit",
        style: TextStyle(
          fontSize: 42.0,
        ),
      ),
      onPressed: _noTextAlert("Pressed submit"),
      color: Colors.green,
      textColor: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      splashColor: Colors.grey,
    );

//reset button
    final resetButton = RaisedButton(
      child: Text(
        "Submit",
        style: TextStyle(
          fontSize: 42.0,
        ),
      ),
      onPressed: _noTextAlert("Pressed reset"),
      color: Colors.green,
      textColor: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      splashColor: Colors.grey,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Attrndance Tracker'),
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 155.0,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
                  child: nTextField,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
                  // child: subButton,
                  child: Text("Sessions "),
                ),
              ),
              /*   Text(
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
              */
              /*
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
                     // child: subButton,
                      child: Text("Sessions " ),
                    ),
                  ),
                 Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
                      child: RaisedButton(
                        child: Text("Submit", style: TextStyle(fontSize: 42.0)),
                        onPressed: _noTextAlert("Pressed submit"),
                        color: Colors.green,
                        textColor: Colors.yellow,
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        splashColor: Colors.grey,
                      ),
                    ),
                  ),
                 
                ],
              )
               */
            ],
          ),
        ),
      ),
    );
  }

  _noTextAlert(String _mess) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not in stock'),
          content: Text(_mess),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
} //end of class