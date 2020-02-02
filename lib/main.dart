import 'package:flutter/material.dart';
import 'package:attendance_tracker/Screens/Start_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Store/AppDataStore.dart';
import 'Models/AppData.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

import 'Models/GetApi.dart';

void main() {
  //final Store<AppData> store = Store<AppData>(appDataStore, initialState: null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // final Store<AppData> store;
  //MyApp(this.store);

  @override
  Widget build(BuildContext context) {
    /*
     var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(context),
      renderLoad: () => SplashScreen(),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => new Text(data),
    );
*/
    return MaterialApp(
      title: 'Attendence TrackerV2',
      home: SplashScreen(), // StartScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppData tData;
  AppData cData;
  bool _loadingInProgress;
  @override
  void initState() {
    super.initState();
  //  _loadingInProgress = true;
    getAttendenceData();
  }

  Future getAttendenceData() async {
    cData = await GetApi.checkIfHaveConnectionUpdateDB();
    //TODO: check for a null on tData do a popup
    if (cData.appDataSessions != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StartScreen(
          trackerData: cData,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
   // if (_loadingInProgress) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/images/triton-5k-hr.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image(
                      image: AssetImage('asset/images/TrackerLogoT.png'),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Loading(
                            indicator: BallPulseIndicator(),
                            size: 60.0,
                            color: Colors.yellow,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          "Loading Application",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    /*else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StartScreen(
          trackerData: tData,
        );
      }));
    }

     */
  }
/*
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
*/
/*
//remove after prof of concept
const TIMEOUT = const Duration(seconds: 15);
getMessage(BuildContext context) async {
GetApi _GetApi = new GetApi();

 
GetApi.checkIfHaveConnectionUpdateDB().then((AppData d) => setState(() {
          _appData = d;
          print("+++++++++++++++32");
          if (_appData != null) {
         
            //TODO: insert into current session DB
            final DbHelper _getData = DbHelper();

            //clear db of data    
             var output = _getData.clearTable("tblSessions");
             if( output == 0)
             {

             }
           // print("*****-->43 " + _appData.appDataSessions[0].toString());
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



/*
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartScreen(
              text: 'test',
            ),
          ));
  });*/



  return new Future.delayed(TIMEOUT, () => //'Welcome to your async screen');
*/
