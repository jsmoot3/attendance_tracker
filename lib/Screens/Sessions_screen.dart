import 'package:flutter/material.dart';
import '../Util/Data.dart';
import '../Models/API.dart';
import '../Models/Session.dart';

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
  static var sessInfo = getApi.fetchSessions();
  static var CSession = sessInfo.CurrentSessions;
  // final _suggestions = CSession;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
        ),
        // body: _buildSuggestions(),
        //body: _myListView(context));
        body: _myListViewDy(context));
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
      itemCount: CSession.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(CSession[index].Department),
          //title: Text("Test-------->100 -- $index"),
        );
      },
    );
  }
} //End of class
