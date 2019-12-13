import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'Sessions_screen.dart';
import '../Util/Data.dart';
import '../Models/GetApi.dart';



class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  // final myController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 10.0);
  TextEditingController _textFieldController = TextEditingController();





  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textFieldController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    imageCache.clear();

  //  print('checking for connection 33 load scre');
    // check if there is a internet connection
    var isConnectedNow = GetApi.checkIfHaveConnection();
//TODO:if have a connection update DB



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
        hintText: "Group Number",
        border: OutlineInputBorder(),
      ),
      style: TextStyle(
        fontSize: 40.0,
        fontStyle: FontStyle.italic,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Tracker'),
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
              SizedBox(height: 150.0),
            ],
          ),
        ));
  }

  // handle the button click event
  _changeText() {
    //  setState(() {
    // print('Your number was => $_textFieldController.text ');
    // _noTextAlert();
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
