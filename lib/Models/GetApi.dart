import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';
import '../Models/Session.dart';
import 'dart:io';

class GetApi {
  SessionDart sessionDart;
//TODO:if there is a connection write to db
  //TODO: if connected to wifi read and save to db
  //check if there is a connection

  static Future<bool> checkIfHaveConnection() async
  {
    bool isConnected = false;
    print("----> " + Constants.MONTH_SESSIONS);
    try {
      final result = await InternetAddress.lookup("google.com");//Constants.MONTH_SESSIONS
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('----- 21 Api connected');
        isConnected = true;
        fetchSessions();
      }
    } on SocketException catch (_) {
      print('----- 21 Api not connected');
      //_noTextAlert(" there is no connection at this time");
    }
    return isConnected;
  }







  static Future<String> fetchSessions() async {
    List<CurrentSession> csessions = new List<CurrentSession>();
    var response = await http.get(Constants.MONTH_SESSIONS);
    if (response.statusCode == 200) {
      String sesDat = response.body;
      var sesDate = json.decode(sesDat);
      Iterable list = sesDate["CurrentSessions"];
      csessions =
          list.map((model) => CurrentSession.fromJson(model)).toList();

     // Set<CurrentSession> set = Set.from(csessions);

      print("GetApi length sess==> 50  " + csessions.length.toString());
      print("//////////////////////////////////////////////////////////");
      csessions.forEach((sess) => print (sess.department));
      print("----------------------------------------------");
      for(var i =0;i<csessions.length;i++)
        {
          //TODO: chang this to store in db
          print ("GetApi sess==> 56  " + csessions[i].department);
        }
      print("//////////////////////////////////////////////////////////");
    //  print("GetApi sess==> 56  " + sesDate["CurrentSessions"].toString());
      return sesDat;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<String> fetchRoles() async {
    List<Role> csessions = new List<Role>();
    var response = await http.get(Constants.ALL_ROLES);
    if (response.statusCode == 200) {
      String sesDat = response.body;
      // var sesDate = json.decode(sesDat);
      Iterable list = json.decode(sesDat);
      csessions =
          list.map((model) => Role.fromJson(model)).toList();
      return sesDat;
    }
  }

  Future<http.Response> fetchValidUsers() {
    return http.get(Constants.VALID_USERS);
  }





/*
  static List<SessionDart> createSessionList(String data) {
    List<SessionDart> nList = new List();
    //String ses = {data: CurrentSessions};

    var parsedJson = json.decode(data);
    //List<Session> nList = Session.fromJson(parsedJson);
    print("------ 45 > " +
        parsedJson['CurrentSessions'][1]['Department'].toString());
    // var user = User(parsedJson);
    // print("**** 44 > " + parsedJson);
    for (int i = 0; i < parsedJson.length; i++) {
      Session _session = new Session(
          parsedJson[i]["EventSessionID"],
          parsedJson[i]["EventIDfk"],
          parsedJson[i]["CampusLocation"],
          parsedJson[i]["StartDate"],
          parsedJson[i]["TimeOfDay"],
          parsedJson[i]["Day"],
          parsedJson[i]["Divison"],
          parsedJson[i]["WaverName"]);
      nList.add(_session);
      print("------ 59 > " + parsedJson[i]["Divison"]);
    }
    return nList;
  }

   */
}
