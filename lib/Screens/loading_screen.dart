import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final myController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 10.0);
  TextEditingController _textFieldController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    imageCache.clear();

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
        hintText: "Login number",
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
                    image: AssetImage('images/TrackerLogo.png'),
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

  _changeText() {
    setState(() {
      if (_textFieldController.text != null) {
        print('Your number was $_textFieldController.text ');
      } else {
        print('there is no letter ');
      }
      _textFieldController.text = "Login number";
    });
  }
}
