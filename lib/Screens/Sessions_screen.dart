import 'dart:developer';
import 'package:flutter/material.dart';
import '../Util/Data.dart';
import '../Models/API.dart';
import '../Models/Session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';

class SessionsScreen extends StatelessWidget {
  final String text;

  SessionsScreen({Key key, @required this.text}) : super(key: key);
//  static var sessInfo = getApi.fetchSessions();
  // static var CSession = sessInfo.CurrentSessions;

  //print("===> " + CSessions[1].Department);

  // List<Session> montSes = sessInfo.CurrentSessions;
  // var _sess = getApi.fetchSessions();
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fetch Data Example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("List"),
        ),
        body: getCurrentSessions(),
      ),
    );
  }
}

class getCurrentSessions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new getCurrentSessionsState();
  }
}

class getCurrentSessionsState extends State<getCurrentSessions> {
  List csessions;
  String _responseSess = null;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  void initState() {
    super.initState();
    if (_responseSess == null) {
      getApi.fetchSessions().then((String s) => setState(() {
            _responseSess = s;
          }));
    }
  }

  //getApi _getApi = new getApi();

  //String response = getApi.fetchSessions().toString();
  //await http.get(Constants.MONTH_SESSIONS, headers: {"Accept": "application/json"});

  //print("==> 55  " + response.toString()); // + response.body);
  /*
      setState(() {
        var sessionDart = sessionDartFromJson(response.body);
        var resBody = json.decode(response.body);
        csessions = resBody["currentSessions"];
      });
      */

  @override
  Widget build(BuildContext context) {
    String responseSess = _responseSess;
    print("sess==> 76  " + responseSess.toString());
    var sesDat = json.decode(responseSess);
    List<CurrentSession> csessions = sesDat["CurrentSessions"];
    print("sessDat==> 78  " + sesDat["CurrentSessions"].toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      // body: _buildSuggestions(),
      //body: _myListView(context));
      //body: _myListViewDy(context));
      body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: csessions == null ? 0 : csessions.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Card(
                      child: Container(
                        child: Text(csessions[index].department.toString()),
                        //child: Text("Test-------->100 -- $index"),
                        /*   style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54
                ),*/
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

/*
  Widget _buildSuggestions() {
    ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: CSession.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.amber,
          child: Center(child: Text('Entry text')),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _buildRow(CurrentSession pair) {
    return new ListTile(
      title: new Text(pair.department, style: _biggerFont),
    );
  }

  Widget _myListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Sun'),
        ),
        ListTile(
          title: Text('Moon'),
        ),
        ListTile(
          title: Text('Star'),
        ),
      ],
    );
  }
*/
  Widget _myListViewDy(BuildContext context) {
    return ListView.builder(
      itemCount: 10, //csessions.length,
      itemBuilder: (context, index) {
        return ListTile(
          //title: Text(csessions[index].Department),
          title: Text("Test-------->100 -- $index"),
        );
      },
    );
  }
} //End of class
