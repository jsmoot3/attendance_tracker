import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';
import '../Models/Session.dart';
import '../Models/AppData.dart';
import 'dart:io';
import 'package:attendance_tracker/Util/dbHelper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:attendance_tracker/Util/FileHelper.dart';

class GetApi {
  SessionDart sessionDart;
  static DbHelper _dbHelper = new DbHelper();
  static FileHelper _fileHelper = new FileHelper();
//TODO:if there is a connection write to db
  //TODO: if connected to wifi read and save to db
  //check if there is a connection

  static Future<AppData> checkIfHaveConnectionUpdateDB() async {
    //bool isConnected = false;
    //AppData checkIfHaveConnectionUpdateDB;
    AppData _AppData = new AppData();
    // print("----> " + Constants.MONTH_SESSIONS);
    try {
      //  final result = await InternetAddress.lookup(
      //      "https://google.com"); //Constants.MONTH_SESSIONS
      bool haveconnection = false;
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        haveconnection = true;
      }
      if (haveconnection) {
        // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('----- 25 Api connected');
        //isConnected = true;


        await fetchSessions();
        await fetchRoles();
        await fetchValidUsers();


        _AppData = await fillAppData();
        /*
        if(_AppData != null) {


          print("GetApi length sesData==>   " +
              _AppData.appDataSessions.length.toString());
          print("GetApi length roleData==>   " +
              _AppData.appDataroles.length.toString());
          print("GetApi length valusrData==>   " +
              _AppData.appDataallUsers.length.toString());
        }

         */
        return _AppData;
      } else {
        //  _AppData = await fillAppData();
        if (_AppData == null) return null;
        return _AppData; //fill the application using the DB
      }
    } on SocketException catch (_) {
      print('----- 21 Api not connected');
      _AppData = await fillAppData();
      //_noTextAlert(" there is no connection at this time");
    } catch (e) {
      print('get checkifconn Error 58 ' + e.toString());
    }
    //return null;
  }

  static Future<void> fetchSessions() async {
    List<CurrentSession> csessions = new List<CurrentSession>();
    AppData tAppData = new AppData();
    List<String> tdepartment = new List<String>();
    var response = await http.get(Constants.MONTH_SESSIONS);
    if (response.statusCode == 200) {
      String sesDat = response.body;
      var sesDate = json.decode(sesDat);
      tAppData.from = sesDate["From"];
      tAppData.to = sesDate["To"];
      tAppData.month = sesDate["Month"];

      Iterable list = sesDate["CurrentSessions"];
      Iterable listd = sesDate["Departments"];
      csessions = list.map((model) => CurrentSession.fromJson(model)).toList();
      tdepartment = listd.map((s) => (s as String)).toList();
      //create insert session into file
      if (csessions != null && csessions.length > 0) {
        await _fileHelper.writeEventSessions(csessions);
      }

      // csessions = await _dbHelper.readAllSessions();
      // print("#########- Sessions 74->" + csessions.length.toString());
      //  tAppData.appDataSessions = csessions;

      //insert departments in to data obj
      //tAppData.appDepartments = tdepartment;
      //insert data into department data
      //   if (tdepartment != null && tdepartment.length > 0) {
      //   _dbHelper.insertTblDept(tdepartment);
      //   }

      //  tdepartment = await _dbHelper.getAllDepartments();
      //  print("******* - Departments 86->" + tdepartment.length.toString());
      //  tAppData.appDepartments = tdepartment;

      /// return ;
    } else {
      return null;
      //throw Exception('Failed to load post');
    }
  }

  static Future<bool> fetchRoles() async {
    List<Role> roles = new List<Role>();
    bool status = false;
    var response = await http.get(Constants.ALL_ROLES);
    if (response.statusCode == 200) {
      String rolDat = response.body;
      // var sesDate = json.decode(sesDat);
      Iterable list = json.decode(rolDat);
      roles = list.map((model) => Role.fromJson(model)).toList();

      //insert roles into the DB
      //if (roles != null && roles.length > 0) {
      // await _dbHelper.insertRoles(roles);
      //}

      if (roles != null && roles.length > 0) {
        status = await _fileHelper.writeRoles(roles);
      }

      // roles = await _dbHelper.getAllRoles();
      // print("///// Roles /////> " + roles.length.toString());

      return status;
    }
    return null;
  }

  //////////////////////////////////////
  //get the valid users to vertifi against
  //**
  static Future<void> fetchValidUsers() async {
    List<ValidUser> validusers = new List<ValidUser>();
    bool status = false;
    var response = await http.get(Constants.VALID_USERS);
    if (response.statusCode == 200) {
      String vUsrDat = response.body;
      // var sesDate = json.decode(sesDat);
      Iterable list = json.decode(vUsrDat);
      validusers = list.map((model) => ValidUser.fromJson(model)).toList();
      if (validusers != null && validusers.length > 0) {
        status = await _fileHelper.writeValidUsers(validusers);
      }
      return status;
    }
    return status;
  }

  static Future<AppData> fillAppData() async {
    AppData _appData = new AppData();

    _appData.appDataSessions = await _fileHelper.readSessionsFile();
    _appData.appDataroles = await _fileHelper.readRolesFile();
    _appData.appDataallUsers = await _fileHelper.readValidUsers();
   /*
    Future.wait([
       _fileHelper.readSessionsFile(),
       _fileHelper.readRolesFile(),
       _fileHelper.readValidUsers()
    ]).then((List<dynamic> results) => {
    _appData.appDataSessions = results[0],
        _appData.appDataSessions = results[1],
        _appData.appDataSessions = results[2]
    });
    */

    return  _appData;
  }
}
