import 'package:attendance_tracker/Screens/Start_screen.dart';
import 'package:flutter/material.dart';
import 'TakeAttendance_Screen.dart';
import '../Models/GetApi.dart';
import '../Models/Session.dart';
import 'dart:convert';
import '../Models/AppData.dart';
//import 'package:flutter_redux/flutter_redux.dart';
import '../store/actions.dart';
import 'Start_screen.dart';
import 'package:attendance_tracker/Util/dbHelper.dart';
import 'dart:convert';
import '../Models/App_Models.dart';
import 'package:intl/intl.dart';

class SessionsScreen extends StatefulWidget {
  final AppData trackerData;
  SessionsScreen({this.trackerData});

  @override
  //State<StatefulWidget> createState() {
  //  return _SessionsScreen();
  // }
  _SessionsScreenState createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  List csessions = new List<CurrentSession>();
  List allSessions = new List<CurrentSession>();
  List roles = new List<Role>();
  List valStudents = new List<ValidUser>();

  CurrentDataInfo cDataInfo = new CurrentDataInfo();
  String groupAccessId;

  AppData applicationData;
  int count = 0;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  void initState() {
    super.initState();
    updateUI(widget.trackerData);
  }

  void updateUI(dynamic tData) {
    // setState(() {
    if (tData == null) {
      return;
    }
    applicationData = tData;
    allSessions = tData.appDataSessions;
    roles = tData.appDataroles;
    valStudents = tData.appDataallUsers;
    groupAccessId = tData.groupId;
    cDataInfo = tData.appDataCurrentDataInfo;
    //String from = widget.trackerData.appDataCurrentDataInfo.from;
    // });
  }

  ////////////////////////////////////////////   String user;
  String empLid;
//Find sessions for departments allowed
///////////////////////////////////////
  List<CurrentSession> viewableSessions() {
    List<String> accessGroupes = new List<String>();
    List csessionsL = new List<CurrentSession>();
    roles.forEach((r) {
      if (r.user == groupAccessId) {
        int count = accessGroupes.where((n) => n == r.rName).toList().length;
        if (count < 1) {
          accessGroupes.add(r.rName);
        }
        if (r.rName == "FL_Admin") {
          csessionsL = allSessions;
        } else if (accessGroupes.where((n) => n != "FL_Admin").toList().length >
            0) {
          //now an admin need to find associated events to id
          allSessions.forEach((sess) {
            if (accessGroupes
                    .where(
                        (n) => n.toUpperCase() == sess.department.toUpperCase())
                    .toList()
                    .length >
                0) {
              csessionsL.add(sess);
            }
          });
        }
      }
      return csessionsL;
    });
    return csessionsL;
  }

  ///////////////////////////////////////////////////
  CurrentDataInfo getCurrenInfo() {
    return cDataInfo;
  }

/////////////////////////////////////////////////////
  // get image info
  String getImage(CurrentSession _dession) {
    var assetImage = "asset/images/cc4.png";
    switch (_dession.department) {
      case "HDH":
        {
          assetImage = "asset/images/butFLife.png";
        }
        break;
      case "FM":
        {
          assetImage = "asset/images/AEvent.jpg";
        }
        break;
      case "PD":
        {
          assetImage = "asset/images/butPol.png";
        }
        break;
      case "HDH-FitLife":
        {
          assetImage = "asset/images/butFLife.png";
        }
        break;
      case "RSCD":
        {
          assetImage = "asset/images/people3.png";
        }
        break;
      case "TEST":
        {
          assetImage = "asset/images/people3.png";
        }
        break;
      case "FL":
        {
          assetImage = "asset/images/FLife75.png";
        }
        break;
      case "test2":
        {
          assetImage = "asset/images/people3.png";
        }
        break;
      case "Theater Department":
        {
          assetImage = "asset/images/people3.png";
        }
        break;
      case "Recreation":
        {
          assetImage = "asset/images/people3.png";
        }
        break;
      case "Village":
        {
          assetImage = "asset/images/people3.png";
        }
        break;
      case "ARV_FM":
        {
          assetImage = "asset/images/people3.png";
        }
        break;
      case "ARV_HDH-FitLife":
        {
          assetImage = "asset/images/butFLife.png";
        }
        break;
      default:
        {
          assetImage = "asset/images/people3.png";
        }
    }
    //var assetImage = AssetImage("asset/images/cc4.png");
    /* Image newImage = new Image(
      image: assetImage,
      height: 96.0,
      width: 96.0,
      fit: BoxFit.fitWidth,
    );
    */
    return assetImage;
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
    //add the acced session to the view
    csessions = viewableSessions();
    // cDataInfo = applicationData.appDataCurrentDataInfo;

    if (csessions == null || csessions.length < 1) {
      // return: show loading widget
      print("No sessionss to display");
      return Scaffold(
        appBar: AppBar(
          title: Text('Startup Name Generator'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "There are no current session for this group Id",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),
              RaisedButton(
                child: Text("Back to Login", style: TextStyle(fontSize: 42.0)),
                onPressed: _returnToMain,
                color: Colors.green,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Attendance Tracker \n'),
            elevation: 10,
            actions: <Widget>[
              InkWell(
                child: Icon(Icons.more_vert),
                onTap: () {
                  print("click more");
                },
              ),
              SizedBox(width: 20, height: 60),
            ],
            bottom: PreferredSize(
              child: Container(
                alignment: Alignment.center,
                color: Colors.red,
                constraints: BoxConstraints.expand(height: 70),
                child: Text(
                  cDataInfo.from,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              preferredSize: Size(50, 50),
            ),
          ),
          body: ListView.builder(
              itemCount: csessions == null ? 0 : csessions.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 140,
                  // padding: const EdgeInsets..all(10.0),
                  child: InkWell(
                    onTap: () =>
                        // _noTextAlert("test-" + csessions[index].department);
                        Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TakeAttendance(
                                sessionData: csessions[index],
                              )),
                    ),
                    child: Card(
                        elevation: 8.0,
                        // color: Colors.lightBlue,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  child: new Image.asset(
                                    getImage(csessions[index]),
                                    fit: BoxFit.fill,
                                  ),
                                  margin: EdgeInsets.only(right: 15.0),
                                )
                              ],
                            ),
                            Expanded(
                              child: Column(
                                //const SizedBox(width: 25),
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                    width: 80,
                                  ),
                                  Text(
                                    getHeadtext(csessions[index]),
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    csessions[index].campusLocation,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              //  textDirection: TextDirection.rtl,

                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: Text(
                                    //getSubtext(csessions[index]),
                                    csessions[index].day,
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 30.0),
                                  child: Text(
                                    //getSubtext(csessions[index]),
                                    csessions[index].timeOfDay,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 30.0, bottom: 35.0),
                                  child: Text(
                                    "Start Date: " +
                                        DateFormat('MM-dd-yyyy')
                                            .format(csessions[index].startDate),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        )

                        /*
                      child: Container(
                        //decoration:
                        // BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                            //  contentPadding: EdgeInsets.symmetric(
                            //      horizontal: 20.0, vertical: 10.0),
                            // isThreeLine: true,
                            onLongPress: () {
                              //TODO: do something else
                              _noTextAlert("test");
                            },
                            leading: Container(
                              //   decoration: new BoxDecoration(
                              //      border: new Border(
                              //           right: new BorderSide(
                              //               width: 1.0, color: Colors.white24))),
                              child: getImage(csessions[index]),
                            ),
                            title: Text(
                              getHeadtext(csessions[index]),
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Container(
                              child: Row(children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        csessions[index].campusLocation,
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
                                      getSubtext(csessions[index]),
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            )),
                      ),*/

                        ),
                  ),
                );
              })
          //         }),
          );
    }
  }

  _returnToMain() {
    Navigator.pop(context);
    print("button clicked Session screen 440");
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
          content: Text(mess),
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
