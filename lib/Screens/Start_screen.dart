import 'package:flutter/material.dart';
import 'Sessions_screen.dart';
import '../Models/GetApi.dart';
import '../Models/AppData.dart';
import '../Models/Session.dart';
import 'package:attendance_tracker/Util/dbHelper.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path_provider/path_provider.dart';

class StartScreen extends StatefulWidget {
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

    GetApi.checkIfHaveConnectionUpdateDB().then((AppData d) => setState(() {
          _appData = d;

          //.then((AppData s) => setState(() {
          // _responseSess = s;
          print("+++++++++++++++32");

          // print(_AppData.runtimeType);
          // print("+++++++++++++++");
          //TODO:add information to db

          if (_appData != null) {
            //insert into DB
            // int ses = 0;
            //int rol = 0;
            // int usr = 0;

            //TODO: insert into current session DB
            final DbHelper _getData = DbHelper();

             _getData.clearTable("tblSessions");

            //   Future<Database> trackerDb = _getData.initializeDb();
            // _getData.initializeDb();
            // for (var i = 0; i < 2; i++) {
            //   _getData.insertSession(_AppData.appDataSessions[i]);
            print("*****-->43 " + _appData.appDataSessions[0].toString());
            // }

//print(widget.appDataSession);
            for (var i = 0; i < _appData.appDataSessions.length; i++) {
         //     _getData.insertSessionRaw(_appData.appDataSessions[i]);
            }

            // List<CurrentSession> output =  _getData.getAlltblSessions();

            //TODO: insert into insertRoles DB
            //TODO: insert into valid users DB
          } else {
            CircularProgressIndicator();
          }
        }));
  }

  Future<List<CurrentSession>> getAllSessions() async {
    var dbHelper = DbHelper();
    Future<List<CurrentSession>> dishes =
        dbHelper.readAllSessions();       
    return dishes;
  }

   clearTable() {
    setState(() {
      var dbHelper = DbHelper();
      dbHelper.clearTable("tblSessions");
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
        ),
      );

      return Scaffold(
        appBar: AppBar(
          title: Text('Attrndance Tracker'),
        ),
        resizeToAvoidBottomInset: false,
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
                  padding: EdgeInsets.all(15.0),
                  child: nTextField,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: logButton,
                ),
              ),
            //  SizedBox(height: 5.0),

              Row(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  Expanded(
                    child: Text("SessionID" ),
                  ),
                  Expanded(
                    child: Text("Department"),
                  ),
                  Expanded(
                    child: Text("Day"),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: RaisedButton(
                        color: Colors.red,
                        child: Text("ClearDB"),
                        onPressed: () {                         
                             clearTable();  
                        },
                      ),
                    ),
                  ),
                ],
              ),
              FutureBuilder<List<CurrentSession>>(
                future: getAllSessions(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Row(
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              snapshot.data[index].flEventSessionId.toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              snapshot.data[index].department,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              snapshot.data[index].day,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
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
    //  setState(() {
    // print('Your number was => $_textFieldController.text ');
    // _noTextAlert();
    // AppData appdata = _AppData;
    String text1 = _textFieldController.text;
    if (text1 != '') {
      // print('Your number was =>$text1');

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SessionsScreen(
              text: '$text1',
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
