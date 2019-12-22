import 'package:attendance_tracker/Screens/Start_screen.dart';
import 'package:flutter/material.dart';
import '../Models/GetApi.dart';
import '../Models/Session.dart';
import 'dart:convert';
import '../Models/AppData.dart';
//import 'package:flutter_redux/flutter_redux.dart';
import '../store/actions.dart';
import 'Start_screen.dart';
import 'package:attendance_tracker/Util/dbHelper.dart';

class SessionsScreen extends StatelessWidget {
  final String text;
  final newdata;
  SessionsScreen({Key key, @required this.text, this.newdata})
      : super(key: key);

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
  // StartScreen({this.appDataSession});
//final appDataSession;

  @override
  State<StatefulWidget> createState() {
    return new getCurrentSessionsState();
  }
}

class getCurrentSessionsState extends State<getCurrentSessions> {
  List csessions = new List<CurrentSession>();
  AppData _responseSess = null;
  int count = 0;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  void initState() {
    super.initState();
  }

  Future<List<CurrentSession>> getAllSessions() async {
    DbHelper helper = DbHelper();
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final cSessTuture = helper.readAllSessions();
      cSessTuture.then((result) {
        List<CurrentSession> oSessions = List<CurrentSession>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          oSessions.add(result[i]); //(CurrentSession.fromDb(result[i]));
          //debugPrint(oSessions[i].department);
        }
        setState(() {
          csessions = oSessions;
          count = count;
        });
      });
    });
    return csessions;
  }

  // get image info
  Image getImage(CurrentSession _dession) {
    var assetImage = AssetImage("asset/images/cc4.png");
    switch (_dession.department) {
      case "HDH":
        {
          assetImage = AssetImage("asset/images/butFLife.png");
        }
        break;
      case "FM":
        {
          assetImage = AssetImage("asset/images/AEvent.jpg");
        }
        break;
      case "PD":
        {
          assetImage = AssetImage("asset/images/butPol.png");
        }
        break;
      case "HDH-FitLife":
        {
          assetImage = AssetImage("asset/images/butFLife.png");
        }
        break;
      case "RSCD":
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
        break;
      case "TEST":
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
        break;
      case "FL":
        {
          assetImage = AssetImage("asset/images/FLife75.png");
        }
        break;
      case "test2":
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
        break;
      case "Theater Department":
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
        break;
      case "Recreation":
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
        break;
      case "Village":
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
        break;
      case "ARV_FM":
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
        break;
      case "ARV_HDH-FitLife":
        {
          assetImage = AssetImage("asset/images/butFLife.png");
        }
        break;
      default:
        {
          assetImage = AssetImage("asset/images/people3.png");
        }
    }
    //var assetImage = AssetImage("asset/images/cc4.png");
    Image newImage = new Image(
      image: assetImage,
      height: 96.0,
      width: 96.0,
      fit: BoxFit.fitWidth,
    );
    return newImage;
  }

  //geting the title text
  String getHeadtext(CurrentSession _dession) {
    return _dession.department + " " + _dession.trainingGroup;
  }

  //geting the subtitle text
  String getSubtext(CurrentSession _dession) {
    return _dession.day + _dession.timeOfDay;
  }

  @override
  Widget build(BuildContext context) {
    // String responseSess = _responseSess.appDataSessions;
    // print("sess==> 76  " + responseSess.toString());
    //  var sesDat = json.decode(responseSess);
    // List<CurrentSession> csessions = sesDat["CurrentSessions"];
    //   print("sessDat==> 78  " + sesDat["CurrentSessions"].toString());
    // StoreConnector<int, String>(converter: (store) => store.state.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      // body: _buildSuggestions(),
      //body: _myListView(context));
      //body: _myListViewDy(context));

      body: FutureBuilder<List<CurrentSession>>(
          future: getAllSessions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              // return: show loading widget
              print("snapshot has nothing 190");
              //return new Center(
             //   child: new CircularProgressIndicator(),
              //);
            }
            if (snapshot.hasError) {
              print("There was an error");
              //return new Center(
              //  child: new CircularProgressIndicator(),
              //);
            }
            List<CurrentSession> sessData = snapshot.data ?? [];
            return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: count, //csessions == null ? 0 : csessions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 150,
                    // padding: const EdgeInsets..all(10.0),
                    child: Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        //decoration:
                        // BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            // isThreeLine: true,
                            onLongPress: () {
                              //TODO: do something else
                              _noTextAlert("test");
                            },
                            leading: Container(
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.white24))),
                              child: getImage(sessData[index]),
                            ),
                            title: Text(
                              getHeadtext(sessData[index]),
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Container(
                              child: Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        sessData[index].campusLocation,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      getSubtext(sessData[index]),
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            )

                            /* subtitle: Text(
                        getSubtext(csessions[index]),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      */

                            //  trailing: Icon(Icons.keyboard_arrow_right),
                            ),
                      ),
                    ),
                  );
                });
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

  Widget get _loadingView {
    return new Center(
      child: new CircularProgressIndicator(),
    );
  }

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

  _noTextAlert(String mess) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not in stock'),
          content: const Text('This item is no longer available'),
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
} //End of class
