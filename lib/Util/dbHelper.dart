import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';
import '../Models/App_Models.dart';
import '../Models/Session.dart';

class DbHelper {
  //Singleton
  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }
  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  getDatabase() {
    return this.db;
  }

  /////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String p = dir.path + "/trackerDb.db";
    // String p = join(dir.path, "/trackerDb.db");
    var db = await openDatabase(p, version: 1, onCreate: _createDbs);
    return db;
  }

  void _createDbs(Database db, int version) {
    _createTblSessionsDB(db, version);
    _createTblAttendieDB(db, version);
    _createTblRolesDB(db, version);
    _createTblWaverDB(db, version);
    _createTblDeptDB(db, version);
    _createTblValidUserDB(db, version);
  }

  //Create the TblSessionsDB.db database
  void _createTblSessionsDB(Database db, int version) async {
    await db.execute("CREATE TABLE tblSessions(" +
        "id INTEGER PRIMARY KEY," +
        "EventSessionID TEXT," +
        "EventSessionID TEXT," +
        "EventID_fk TEXT," +
        "CampusLocation TEXT," +
        "StartDate TEXT," +
        "TimeOfDay TEXT," +
        "Day TEXT," +
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
}
