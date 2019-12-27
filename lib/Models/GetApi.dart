import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';
import '../Models/Session.dart';
import '../Models/AppData.dart';
import 'dart:io';
import 'package:attendance_tracker/Util/dbHelper.dart';

class GetApi {
  SessionDart sessionDart;
  static DbHelper _dbHelper = new DbHelper();
//TODO:if there is a connection write to db
  //TODO: if connected to wifi read and save to db
  //check if there is a connection

  static Future<AppData> checkIfHaveConnectionUpdateDB() async {
    //bool isConnected = false;
    //AppData checkIfHaveConnectionUpdateDB;
    AppData _AppData = new AppData();
    // print("----> " + Constants.MONTH_SESSIONS);
    try {
      final result = //await checkForconnection();
          await InternetAddress.lookup("google.com"); //Constants.MONTH_SESSIONS
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('----- 25 Api connected');
        //isConnected = true;
        _AppData = await fetchSessions();
        _AppData.appDataroles = await fetchRoles();
        _AppData.appDataallUsers = await fetchValidUsers();

        print("GetApi length sesData==> 27  " +
            _AppData.appDataSessions.length.toString());
        print("GetApi length roleData==> 28  " +
            _AppData.appDataroles.length.toString());
        print("GetApi length valusrData==> 29  " +
            _AppData.appDataallUsers.length.toString());
        //return _AppData;
      }
    } on SocketException catch (_) {
      print('----- 21 Api not connected');
      //_noTextAlert(" there is no connection at this time");
    }
    return _AppData;
  }

  static Future<AppData> fetchSessions() async {
    List<CurrentSession> csessions = new List<CurrentSession>();
    AppData tAppData = new AppData();
    List<String> tdepartment = new List<String>();
    var response = await http.get(Constants.MONTH_SESSIONS);
    if (await response.statusCode == 200) {
      String sesDat = response.body;
      var sesDate = json.decode(sesDat);
      tAppData.from = sesDate["From"];
      tAppData.to = sesDate["To"];
      tAppData.month = sesDate["Month"];

      Iterable list = sesDate["CurrentSessions"];
      Iterable listd = sesDate["Departments"];
      csessions = list.map((model) => CurrentSession.fromJson(model)).toList();
     /// tdepartment = listd.Cast<String>().toList();//.map((model) => model);
      tdepartment = listd.map((s) => (s as String)).toList();
  
//insert departments in to data obj
            tAppData.appDepartments = tdepartment;

      
      //insert sessions into data obj
            if (csessions != null && csessions.length > 0) {
             await _dbHelper.clearTable("tblSessions");
              for (var i = 0; i < csessions.length; i++) {
                _dbHelper.insertSessionRaw(csessions[i]);
              }
            }
      
            csessions = await _dbHelper.readAllSessions();
            print("#########- Sessions 74->" + csessions.length.toString());
            tAppData.appDataSessions = csessions;
      
      /*
      //insert data into department data
            if (tdepartment != null && tdepartment.length > 0) {
              _dbHelper.clearTable("TblDept");
              for (var i = 0; i < tdepartment.length; i++) {
                _dbHelper.insertTblDept(tdepartment[i]);
              }
            }
      
            tdepartment = await _dbHelper.getAllDepartments();
            print("******* - Departments 86->" + tdepartment.length.toString());
            tAppData.appDepartments = tdepartment;
      */
            return tAppData;
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
      
            for (var i = 0; i < roles.length; i++) {
              _dbHelper.insertRoles(roles[i]);
            }
            print("///// Roles /////> " + roles.length.toString());
      
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
      
      class Cast {
}
