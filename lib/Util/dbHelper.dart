import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';
import '../Models/App_Models.dart';
import '../Models/Session.dart';

class DbHelper {
  //Singleton
  static DbHelper _dbHelper;
//Database entry point
  static Database _database;

  DbHelper._createInstance();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDb();
    }
    return _database;
  }

  //getDatabase() {
  //  return this.db;
  //}

  /////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  Future<Database> initializeDb() async {
    // print("----->38 In the initializedDB ");
    Directory dir = await getApplicationDocumentsDirectory();
    String p = dir.path + "trackerDb.db";
    print("----->41 In the initializedDB the db --> " + p);
    var db = await openDatabase(p, version: 2, onCreate: _createDbs);
    return db;
  }

  void _createDbs(Database db, int version) {
    print("----->47 _createDbs ");
    _createTblSessionsDB(db, version);
    //   _createTblAttendieDB(db, version);
    //   _createTblRolesDB(db, version);
    //   _createTblWaverDB(db, version);
    //   _createTblDeptDB(db, version);
    //   _createTblValidUserDB(db, version);
  }

  //Create the TblSessionsDB.db database
  void _createTblSessionsDB(Database db, int version) async {
    print("----->57 creatingDB tblSessions ");
    await db.execute("CREATE TABLE tblSessions(" +
        "EventSessionID TEXT," +
        "EventIDfk TEXT," +
        "CampusLocation TEXT," +
        "Trainer TEXT" +
        "StartDate TEXT," +
        "TimeOfDay TEXT," +
        "Day TEXT," +
        "Department TEXT," +
        "TrainingGroup TEXT," +
        "Divison TEXT," +
        "WaverName TEXT)");
  }

  //Create the TblAttendieDB.db database
  void _createTblAttendieDB(Database db, int version) async {
    await db.execute("CREATE TABLE tblAttendie(" +
        "id INTEGER PRIMARY KEY," +
        "StudentId TEXT," +
        "EventSessionId_fk TEXT," +
        "EventID_fk TEXT," +
        "Date TEXT," +
        "SignedInBy TEXT," +
        "OtherAttLocation TEXT");
  }

  //Create the TblRoles.db database
  void _createTblRolesDB(Database db, int version) async {
    await db.execute("CREATE TABLE TblRoles(" +
        "id INTEGER PRIMARY KEY," +
        "RName TEXT," +
        "Emplid TEXT," +
        "User TEXT");
  }

  //Create the TblWaverDB.db database
  void _createTblWaverDB(Database db, int version) async {
    await db.execute("CREATE TABLE TblWaver(" +
        "id INTEGER PRIMARY KEY," +
        "Name  TEXT," +
        "Length INTEGER," +
        "Doc BINARY" +
        "DocType  TEXT");
  }

  //Create the TblDept.db database
  void _createTblDeptDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE TblDept(" + "id INTEGER PRIMARY KEY," + "Name TEXT");
  }

  //Create the TblDept.db database
  void _createTblValidUserDB(Database db, int version) async {
    await db.execute("CREATE TABLE TblValidUser(" +
        "id INTEGER PRIMARY KEY," +
        "Barcode TEXT" +
        "CardId TEXT");
  }

  //insert sessions
  Future<int> insertSession(CurrentSession inPut) async {
    var r;
    Database db = await this.database;
    try {
      if (db != null) {
        // print("able to create db");
      } else {
        // print("No db created");
      }
      r = await db.insert("tblSessions", inPut.toMap());
    } catch (e) {
      debugPrint("insertDoc: " + e.toString());
    }
    return r;
  }

//insert roles
  Future<int> insertRoles(Role _Roles) async {
    var r;
    Database db = await this.database;
    try {
      r = await db.insert("TblRoles", _Roles.toMap());
    } catch (e) {
      debugPrint("insertDoc:" + e.toString());
    }
    return r;
  }

//insert Attendie
  Future<int> insertAttendie(Attendie _Attendie) async {
    var r;
    Database db = await this.database;
    try {
      r = await db.insert("tblAttendie", _Attendie.toMap());
    } catch (e) {
      debugPrint("insertDoc:" + e.toString());
    }
    return r;
  }

//insert Department
  Future<int> insertTblDept(Attendie _Attendie) async {
    var r;
    Database db = await this.database;
    try {
      r = await db.insert("tblAttendie", _Attendie.toMap());
    } catch (e) {
      debugPrint("insertDoc:" + e.toString());
    }
    return r;
  }

//ValidUser
  Future<int> insertTblValidUser(ValidUser _ValidUser) async {
    var r;
    Database db = await this.database;
    try {
      r = await db.insert("TblValidUser", _ValidUser.toMap());
    } catch (e) {
      debugPrint("TblValidUser:" + e.toString());
    }
    return r;
  }

  //get sessions based on department
  Future<List> getSessionsByDeptDb(String query) async {
    String dept = query;
    String sql = "Select * from tblSessions where department = " + query;
    if (query.length < 1) {
      Database db = await this.database;
      var out = await db.rawQuery(sql);
      return out;
    } else {
      return null;
    }
  }

/*
  Future<List<String>> tableList() async {
    List<Map<String, dynamic>> tables = await this.db;

    List<String> list = List();

    for (var i = 1; i < tables.length; i++) {
      list.add(tables[i]['name']);
    }
    return list;
  }
  */

}
