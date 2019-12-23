import 'package:flutter/material.dart';
import 'package:attendance_tracker/Screens/Start_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'Store/AppDataStore.dart';
import 'Models/AppData.dart';
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:async_loader/async_loader.dart';



void main() {
  final Store<AppData> store = Store<AppData>(appDataStore, initialState: null);
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();
  final Store<AppData> store;
  MyApp(this.store);

  @override
  Widget build(BuildContext context) {
     var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(),
      renderLoad: () => SplashScreen(),
      renderError: ([error]) =>
          new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => new Text(data),
    );
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Attendence TrackerV2',
          home: _asyncLoader, //SplashScreen(), // StartScreen(),
        ));
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
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
                          size: 120.0,
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
}

//remove after prof of concept
const TIMEOUT = const Duration(seconds: 15);
getMessage() async {
  return new Future.delayed(TIMEOUT, () => 'Welcome to your async screen');
}