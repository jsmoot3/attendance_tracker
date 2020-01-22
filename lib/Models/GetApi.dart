import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';
import '../Models/Session.dart';
import '../Models/AppData.dart';
import 'dart:io';
import 'package:attendance_tracker/Models/WaverObj.dart';
import 'package:connectivity/connectivity.dart';
import 'package:attendance_tracker/Util/FileHelper.dart';

class GetApi {
  SessionDart sessionDart;
  //static DbHelper _dbHelper = new DbHelper();
  static FileHelper _fileHelper = new FileHelper();
  static AppData _AppData = new AppData();
  //check if there is a connection

  static Future<AppData> checkIfHaveConnectionUpdateDB() async {
    bool isConnected = false;
    try {
      //  final result = await InternetAddress.lookup(
      //      "https://google.com"); //Constants.MONTH_SESSIONS
      bool haveconnection = false;
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        haveconnection = true;
      }
      if (haveconnection && false) {
        // if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('----- 25 Api connected');
        //isConnected = true;

        // await compute (fetchValidUsers, isConnected);
        try {
          //await Future.wait([fetchValidUsers(),fetchSessions(),fetchRoles()] );

          //await

          await fetchAllWaivers();
          await fetchSessions();
          await fetchRoles();
          //     await fetchValidUsers();

          // var s =
          // var r =
          //  await Future.wait([s, r]);

          _AppData = await fillAppData();
        } catch (e) {
          print("Api Haveconnection error51 " + e.toString());
        }
        //  await fetchValidUsers();
        //  await fetchSessions();
        //  await fetchRoles();

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
        _AppData = await fillAppData();
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

  static Future<AppData> fillAppData() async {
    AppData _appData = new AppData();
    _appData.appDataCurrentDataInfo = await _fileHelper.readDataInfoFromFile();
    _appData.appDataSessions = await _fileHelper.readSessionsFile();
    _appData.appDataroles = await _fileHelper.readRolesFile();
    _appData.appDepartments = await _fileHelper.readDepartments();
    // _appData.appDataallUsers = await _fileHelper.readValidUsers();
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

    return _appData;
  }

  static Future<void> fetchSessions() async {
    List<CurrentSession> csessions = new List<CurrentSession>();
    AppData tAppData = new AppData();
    List<String> tdepartment = new List<String>();
    var response = await http.get(Constants.MONTH_SESSIONS);
    if (response.statusCode == 200) {
      String sesDat = response.body;
      var sesDate = json.decode(sesDat);

      CurrentDataInfo cDataInfo = new CurrentDataInfo();
      cDataInfo.from = sesDate["From"];
      cDataInfo.to = sesDate["To"];
      cDataInfo.rcount = sesDate["Rcount"].toString();
      cDataInfo.month = sesDate["Month"];
      //cDataInfo.dateSpan = sesDate["dateSpan"];

      Iterable list = sesDate["CurrentSessions"];
      Iterable listd = sesDate["Departments"];
      csessions = list.map((model) => CurrentSession.fromJson(model)).toList();
      tdepartment = listd.map((s) => (s as String)).toList();
      //create insert session into file

      await _fileHelper.writeDataInfoToFile(cDataInfo);
      if (csessions != null && csessions.length > 0) {
        await _fileHelper.writeEventSessions(csessions);
      }
      if (tdepartment != null && tdepartment.length > 0) {
        await _fileHelper.writeDepartments(tdepartment);
      }

      /// return ;
    } else {
      return null;
      //throw Exception('Failed to load post');
    }
    return true;
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
  static Future<bool> fetchValidUsers() async {
    List<ValidUser> validusers = new List<ValidUser>();
    bool status = false;
    var response = await http.get(Constants.VALID_USERS);
    if (response.statusCode == 200) {
      String vUsrDat = response.body;
      // var sesDate = json.decode(sesDat);
      Iterable list = json.decode(vUsrDat);
      validusers = list.map((model) => ValidUser.fromJson(model)).toList();
      if (validusers != null && validusers.length > 0) {
        await _fileHelper.writeValidUsers(validusers);
      }
      return status;
    }
    return status;
  }

  static Future<List<ValidUser>> fetchValidUsersC() async {
    List<ValidUser> validusers = new List<ValidUser>();
    print("In fetch user compute");
    var response = await http.get(Constants.VALID_USERS);
    if (response.statusCode == 200) {
      String vUsrDat = response.body;
      validusers = await compute(getValUsers, vUsrDat);
    }
    return validusers;
  }

  static Future<List<ValidUser>> getValUsers(String vUsrDat) async {
    print("In fetch user compute getValUsers");
    List<ValidUser> valusers = new List<ValidUser>();
    Iterable list = json.decode(vUsrDat);
    valusers = list.map((model) => ValidUser.fromJson(model)).toList();
    if (valusers != null && valusers.length > 0) {
      await _fileHelper.writeValidUsers(valusers);
    }
    return valusers;
  }

  static Future<void> fetchAllWaivers() async {
    List<WaverObj> waverObjs = new List<WaverObj>();
    bool status = false;

    try {
      var response = await http.get(Constants.WAVERS_API);
      if (response.statusCode == 200) {
        String vWavDat = response.body;
        // var sesDate = json.decode(sesDat);
        Iterable list = json.decode(vWavDat);
        // final list = json.decode(vWavDat);
        waverObjs = list.map((model) => WaverObj.fromJson(model)).toList();

        if (waverObjs != null && waverObjs.length > 0) {
          await _fileHelper.writewaverObjs(waverObjs);
        }
      }
    } catch (ex) {
      print('get fetchAllWaivers Error 232 ' + ex.toString());
    }
  }
}
