import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';
import '../Models/Session.dart';
import '../Models/AppData.dart';
import 'dart:io';

class GetApi {
  SessionDart sessionDart;
//TODO:if there is a connection write to db
  //TODO: if connected to wifi read and save to db
  //check if there is a connection

  static Future<AppData> checkIfHaveConnectionUpdateDB() async {
    bool isConnected = false;
    AppData checkIfHaveConnectionUpdateDB;
    AppData _AppData = new AppData();
    // print("----> " + Constants.MONTH_SESSIONS);
    try {
      final result = //await checkForconnection();
          await InternetAddress.lookup("google.com"); //Constants.MONTH_SESSIONS
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print(await '----- 25 Api connected');
        isConnected = true;
        _AppData.appDataSessions = await fetchSessions();
        _AppData.appDataroles = await fetchRoles();
        _AppData.appDataallUsers = await fetchValidUsers();

        print(await "GetApi length sesData==> 27  " +
            _AppData.appDataSessions.length.toString());
        print(await "GetApi length roleData==> 28  " +
            _AppData.appDataroles.length.toString());
        print(await "GetApi length valusrData==> 29  " +
            _AppData.appDataallUsers.length.toString());
        //return _AppData;
      }
    } on SocketException catch (_) {
      print('----- 21 Api not connected');
      //_noTextAlert(" there is no connection at this time");
    }
    return _AppData;
  }

  Future<AppData> GetAllData() async {}

  static Future<List<CurrentSession>> fetchSessions() async {
    List<CurrentSession> csessions = new List<CurrentSession>();
    var response = await http.get(Constants.MONTH_SESSIONS);
    if (await response.statusCode == 200) {
      String sesDat = response.body;
      var sesDate = json.decode(sesDat);
      Iterable list = sesDate["CurrentSessions"];
      csessions = list.map((model) => CurrentSession.fromJson(model)).toList();

      // Set<CurrentSession> set = Set.from(csessions);

      //print(await "GetApi length sess==> 50  " + csessions.length.toString());
      // print("//////////////////////////////////////////////////////////");
      // csessions.forEach((sess) => print(sess.department));
      // print("----------------------------------------------");
      // for (var i = 0; i < csessions.length; i++) {
      //TODO: chang this to store in db
      //print("GetApi sess==> 50  " + csessions[i].department);
      // }
      //print("//////////////////////////////////////////////////////////");
      //  print("GetApi sess==> 56  " + sesDate["CurrentSessions"].toString());
      return csessions;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Role>> fetchRoles() async {
    List<Role> roles = new List<Role>();
    var response = await http.get(Constants.ALL_ROLES);
    if (response.statusCode == 200) {
      String rolDat = response.body;
      // var sesDate = json.decode(sesDat);
      Iterable list = json.decode(rolDat);
      roles = list.map((model) => Role.fromJson(model)).toList();

      // print("////////////////  Roles  ////////////////////////");
      // print("GetApi length roles==> 68  " + roles.length.toString());
      /*
      for (var i = 0; i < roles.length; i++) {
        //TODO: chang this to store in db
        //print("GetApi sess==> 50  " + roles[i].department);
      }
      print("//////////////////////////////////////////////////////////");

       */
      return roles;
    }
  }

  //////////////////////////////////////
  //get the valid users to vertifi against
  //**
  static Future<List<ValidUser>> fetchValidUsers() async {
    List<ValidUser> validusers = new List<ValidUser>();
    var response = await http.get(Constants.VALID_USERS);
    if (response.statusCode == 200) {
      String vUsrDat = response.body;
      // var sesDate = json.decode(sesDat);
      Iterable list = json.decode(vUsrDat);
      validusers = list.map((model) => ValidUser.fromJson(model)).toList();
      /*
      print("////////////////  validusers  ////////////////////////");
      print("GetApi length validusers==> 68  " + validusers.length.toString());
      for (var i = 0; i < validusers.length; i++) {
        //TODO: chang this to store in db
        //print("GetApi sess==> 50  " + roles[i].department);
      }
      print("//////////////////////////////////////////////////////////");

       */
      return validusers;
    }
  }
/*
  static Future<List<InternetAddress>> checkForconnection() async {
    final result =
        await InternetAddress.lookup("google.com"); //Constants.MONTH_SESSIONS
    return result;
  }

 */
}
