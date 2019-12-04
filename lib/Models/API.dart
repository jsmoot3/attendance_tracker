import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';
import '../Models/Session.dart';

class getApi {
  static fetchSessions() async {
    final response = await http.get(Constants.MONTH_SESSIONS);
    if (response.statusCode == 200) {
      // print("==> " + response.body);
      // return Session.fromJson(json.decode(response.body));
/*
      String testt = response.body;
      print("===> " + testt);
      var responseJson = json.decode(response.body.toString());
      String _CurrentSessions = responseJson['CurrentSessions'].toString();
      print("%%%%% 20> " + _CurrentSessions);
      var _sessList = createSessionList(_CurrentSessions);
      // print("==> " + responseJson.CurrentSessions);
      */
      print("==> " + response.body);
      final sessionDart = sessionDartFromJson(response.body);
      print("%%%%%%> " + sessionDart.month);
      return sessionDart;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<http.Response> fetchRoles() {
    return http.get(Constants.ALL_ROLES);
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
