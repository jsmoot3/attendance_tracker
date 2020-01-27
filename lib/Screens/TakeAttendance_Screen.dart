import 'package:flutter/material.dart';
import '../Models/Session.dart';

class TakeAttendance extends StatefulWidget {
  final CurrentSession sessionData;
  TakeAttendance({this.sessionData});
  @override
  _TakeAttendanceState createState() => _TakeAttendanceState();
}

class _TakeAttendanceState extends State<TakeAttendance> {
  CurrentSession activeSession;
  TextEditingController _textFieldController = TextEditingController();
  void initState() {
    super.initState();
    //   activeSession = new CurrentSession();
    updateUI(widget.sessionData);
  }

  void updateUI(dynamic tData) {
    setState(() {
      if (tData == null) {
        return;
      }
      activeSession = tData;
    });
    print("$activeSession.day");
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
        //hintText: "Group Number",
        fillColor: Colors.grey[200],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 10.0,
          ),
        ),
      ),
      style: TextStyle(
        fontSize: 50.0,
        fontStyle: FontStyle.italic,
        height: 1.5,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Attrndance Tracker'),
        bottom: PreferredSize(
          child: Container(
            alignment: Alignment.center,
            color: Colors.blueGrey,
            constraints: BoxConstraints.expand(height: 70),
            child: Text(
              activeSession.trainingGroup,
              style: TextStyle(fontSize: 30),
            ),
          ),
          preferredSize: Size(50, 50),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Class Count\n test',
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                const Text(
                  "activeSession.campusLocation",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
                Image.asset(
                  'asset/images/TrackerLogo3.png',
                  width: 300,
                  height: 100,
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20),
              child: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: new Border.all(
                      color: Colors.greenAccent,
                      width: 20.0,
                    ),
                    borderRadius: new BorderRadius.circular(38.0),
                  ),
                  child: nTextField),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ButtonTheme(
                  height: 200,
                  minWidth: 400,
                  child: RaisedButton(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 62.0,
                      ),
                    ),
                    onPressed: _changeText,
                    color: Colors.green,
                    textColor: Colors.black,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(38.0),
                        side: BorderSide(color: Colors.grey)),
                  ),
                ),
                Container(
                  child: ButtonTheme(
                    height: 200,
                    minWidth: 400,
                    child: RaisedButton(
                      child: Text(
                        "Reset",
                        style: TextStyle(
                          fontSize: 62.0,
                        ),
                      ),
                      onPressed: _changeText,
                      color: Colors.yellow,
                      textColor: Colors.black,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(38.0),
                          side: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Class Count\n test',
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                  ButtonTheme(
                    height: 150,
                    minWidth: 400,
                    child: RaisedButton(
                      child: Text(
                        "Add guest",
                        style: TextStyle(
                          fontSize: 42.0,
                        ),
                      ),
                      onPressed: _changeText,
                      color: Colors.red,
                      textColor: Colors.yellow,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(38.0),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ButtonTheme(
              height: 150,
              child: RaisedButton(
                child: Text(
                  "but3",
                  style: TextStyle(
                    fontSize: 42.0,
                  ),
                ),
                onPressed: _changeText,
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
            )
          ],
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

  _changeText() {
    // setState(() {
    // if (msg.startsWith('F')) {
    //   msg = 'I have learned FlutterRaised example ';
    // } else {
    //   msg = 'Flutter RaisedButton example';
    // }
    //});
    print("$activeSession.day");
  }
} //end of class
