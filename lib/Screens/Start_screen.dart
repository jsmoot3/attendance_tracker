import 'package:flutter/material.dart';
import 'Sessions_screen.dart';
import '../Models/GetApi.dart';
import '../Models/AppData.dart';
import '../Models/Session.dart';
import 'package:attendance_tracker/Util/dbHelper.dart';

//import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';

class StartScreen extends StatefulWidget {
  // final String text;
  // final newdata;
  StartScreen({this.trackerData});

  final trackerData;
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  // final myController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 10.0);
  TextEditingController _textFieldController = TextEditingController();
  List<CurrentSession> csessions = new List<CurrentSession>();
  AppData _appData;

  void initState() {
    super.initState();
    updateUI(widget.trackerData);
  }

  void updateUI(dynamic tData) {
    setState(() {
      if (tData == null) {
        return;
      }
      _appData = tData;
//if(_appData.appDataSessions == null){
      // _appData.appDataSessions = new
//}
    });
  }

  Future<List<CurrentSession>> getAllSessions() async {
    var dbHelper = DbHelper();
    Future<List<CurrentSession>> dishes = dbHelper.readAllSessions();
    return dishes;
  }

  clearTable() {
    setState(() {
      var dbHelper = DbHelper();
      //    dbHelper.clearTable("tblSessions");
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textFieldController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    imageCache.clear();

//TODO:if have a connection update DB

    if (_appData != null) {
      // AppData appdata = _appData;
      final logButton = RaisedButton(
        child: Text(
          "Submit",
          style: TextStyle(
            fontSize: 42.0,
          ),
        ),
        onPressed: _changeText,
        color: Colors.green,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        splashColor: Colors.grey,
      );

      final nTextField = TextField(
        controller: _textFieldController,
        decoration: InputDecoration(
          //Add th Hint text here.
          hintText: "Group Number" + _appData.appDataSessions[0].department,
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontSize: 40.0,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
      );

      return Scaffold(
        appBar: AppBar(
          title: Text('Attrndance Tracker'),
        ),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image(
                    image: AssetImage('asset/images/TrackerLogo.png'),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0,horizontal: 5),
                  child: nTextField,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 5),
                  child: logButton,
                ),
              ),
              //  SizedBox(height: 5.0),

              Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Expanded(
                    child: Text("Sessions " +
                        _appData.appDataSessions.length.toString()),
                  ),
                  Expanded(
                    child: Text(
                        "Roles " + _appData.appDataroles.length.toString()),
                  ),
                  Expanded(
                    child: Text(
                        "Users " + _appData.appDataallUsers.length.toString()),
                  ),
                  Expanded(
                    child: Text("Departments " +
                        _appData.appDepartments.length.toString()),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // By default, show a loading spinner.
      return _loadingView;
    }
  }

  // handle the button click event
  _changeText() {  
    String text1 = _textFieldController.text;
    if (text1 != '') {
      // print('Your number was =>$text1');
      _appData.groupNum = text1;
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionsScreen(
              trackerData: _appData,
            ),
          ));
    } else {
      print('there is no letter ');
      _noTextAlert('there is no letter ');
    }
    // _textFieldController.text = "Login number";
    // });
  }

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

  _noTextAlert(String _mess) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not in stock'),
          content: const Text("ewewe"),
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
}
