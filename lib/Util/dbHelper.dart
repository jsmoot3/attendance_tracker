import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../Models/App_Models.dart';
import '../Models/Session.dart';
import 'dart:convert';

class DbHelper {
  //Singleton
  static DbHelper _dbHelper;
//Database entry point
  static Database _database;
  //database path
  static String dbpath;
  static int DATABASE_VERSION = 2;

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
    dbpath = dir.path + "/trackerDb.db";
    // print("--DBhelp--->45 In the initializedDB the db --> " + dbpath);
    //clearTable("tblSessions");
    var db = await openDatabase(dbpath,
        version: DATABASE_VERSION, onCreate: _createDbs);
    return db;
  }

  Future _createDbs(Database db, int version) async {
    await Future.wait([
      _createTblSessionsDB(db, version),
      _createTblRolesDB(db, version),
      _createTblValidUserDB(db, version),
      _createTblDeptDB(db, version),
      //   _createTblWaverDB(db, version);
    ]);
    print("----->47 _createDbs ");
  }

  //Create the TblSessionsDB.db database
  Future _createTblSessionsDB(Database db, int version) async {
    //clearTable("tblSessions");
    print("----->57 creatingDB tblSessions ");
    try {
      final sTableSessions = "CREATE TABLE IF NOT EXISTS tblSessions" +
          " ( " +
          " FLEventSessionID INT," +
          " FLeventIDfk INT," +
          " CampusLocation STRING," +
          " Trainer STRING," +
          " StartDate DATETIME," +
          " TimeOfDay TIME," +
          " Day STRING," +
          " Department STRING," +
          " TrainingGroup STRING," +
          " WeekofClass STRING," +
          " Divison STRING," +
          " RequireWaver BOOL," +
          " WaverName TEXT " +
          " )";
      await db.execute(sTableSessions);
    } catch (e) {
      debugPrint("help _createTblSessionsDB Error 87: " + e.toString());
      print("There is a problem " + e.toString());
    }
  }

  //Create the TblAttendieDB.db database
  void _createTblAttendieDB(Database db, int version) async {
    clearTable("tblAttendie");
    await db.execute("CREATE TABLE IF NOT EXISTS tblAttendie(" +
        "id INTEGER PRIMARY KEY," +
        "StudentId TEXT," +
        "EventSessionId_fk TEXT," +
        "EventID_fk TEXT," +
        "Date TEXT," +
        "SignedInBy TEXT," +
        "OtherAttLocation TEXT");
  }

  //Create the TblRoles.db database
  Future _createTblRolesDB(Database db, int version) async {
    clearTable("TblRoles");
    print("----->106 creatingDB TblRoles ");
    try {
      final sTableRoles = "CREATE TABLE IF NOT EXISTS TblRoles (" +
          "RName TEXT," +
          "Emplid TEXT," +
          "User TEXT" +
          ")";
      await db.execute(sTableRoles);
    } catch (e) {
      debugPrint("insertDocRoles Error 115: " + e.toString());
      print("There is a problem " + e.toString());
    }
  }

  //Create the TblWaverDB.db database
  Future _createTblWaverDB(Database db, int version) async {
    await db.execute("CREATE TABLE IF NOT EXISTS TblWaver(" +
        "id INTEGER PRIMARY KEY," +
        "Name  TEXT," +
        "Length INTEGER," +
        "Doc BINARY" +
        "DocType  TEXT");
  }

  //Create the TblDept.db database
  Future _createTblDeptDB(Database db, int version) async {
    clearTable("TblDept");
    try {
      print("----->133 creatingDB TblDept ");
      final sql = "CREATE TABLE IF NOT EXISTS TblDept(" + "Name TEXT" + ")";
      await db.execute(sql);
    } catch (e) {
      debugPrint("help createTblDeptDB Error 115: " + e.toString());
    }
  }

  //Create the TblDept.db database
  Future _createTblValidUserDB(Database db, int version) async {
    clearTable("TblDept");
    try {
      final sql = "CREATE TABLE IF NOT EXISTS TblValidUser (" +
          "Barcode TEXT," +
          "CardId TEXT," +
          "EmpLid TEXT"
              ")";
      await db.execute(sql);
    } catch (e) {
      debugPrint("help createTblValidUser Error 152: " + e.toString());
    }
  }
/*
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
      r = await db.insert("tblSessions", inPut.toJson());
    } catch (e) {
      debugPrint("help insertSession Error 160: " + e.toString());
    }
    return r;
  }
*/

  Future<int> insertSessionRaw(List<CurrentSession> temp) async {
    var r;
    Database db = await this.database;
    try {
      if (db != null) {
        print("trying to insert into db Sessions");
         clearTable("tblSessions");
        for (var i = 0; i < temp.length; i++) {
          CurrentSession inPut = temp[i];
          final isql = "INSERT INTO tblSessions" +
              "( " +
              " FLEventSessionID," +
              " FLeventIDfk," +
              " CampusLocation," +
              " Trainer," +
              " StartDate," +
              " TimeOfDay," +
              " Day," +
              " Department," +
              " TrainingGroup," +
              " WeekofClass," +
              " Divison," +
              " RequireWaver," +
              "  WaverName" +
              " )" +
              " VALUES( " +
              " '${inPut.flEventSessionId}'," +
              " '${inPut.fLeventIDfk}'," +
              " '${inPut.campusLocation}'," +
              " '${inPut.trainer}'," +
              " '${inPut.startDate}'," +
              " '${inPut.timeOfDay}'," +
              " '${inPut.day}'," +
              " '${inPut.department}'," +
              " '${inPut.trainingGroup}'," +
              " '${inPut.weekofClass}'," +
              " '${inPut.divison}'," +
              " '${inPut.requireWaiver}'," +
              " '${inPut.waiverName}'" +
              " )";
          r = await db.rawInsert(isql);
        }
      } else {
        print("help tblSessions211  db not created");
        return null;
      }
    } catch (e) {
      debugPrint("help insertSession Error 208: " + e.toString());
    }
    return r;
  }

  //read all sessions
  //read all
  Future<List<CurrentSession>> readAllSessions() async {
    Database dbReady = await this.database;
    List<CurrentSession> dishes = List();
    try {
      List<Map> list = await dbReady.rawQuery("SELECT * FROM tblSessions ");
      for (int i = 0; i < list.length; i++) {
        CurrentSession csess = new CurrentSession();
        csess.flEventSessionId = list[i]["FLEventSessionID"].toString();
        csess.fLeventIDfk = list[i]["FLeventIDfk"].toString();
        csess.campusLocation = list[i]["CampusLocation"].toString();
        csess.trainer = list[i]["Trainer"];
        csess.timeOfDay = list[i]["TimeOfDay"];
        csess.day = list[i]["Day"];
        csess.department = list[i]["Department"];
        csess.trainingGroup = list[i]["TrainingGroup"];
        csess.weekofClass = list[i]["WeekofClass"].toString();
        csess.divison = list[i]["Divison"];
        csess.requireWaiver = list[i]["RequireWaver"];
        csess.waiverName = list[i]["WaverName"];
        csess.startDate = list[i]["StartDate"] == null
            ? null
            : DateTime.parse(list[i]["StartDate"]);
        //if (i < 20) {
        dishes.add(csess);
        //}
      }
    } catch (e) {
      debugPrint("help readAllSessions Error 257: " + e.toString());
      return null;
    }
    return dishes.toList();
    //dishes;
  }

//insert roles
  Future<int> insertRoles(List<Role> _roles) async {
    var r;
    Database db = await this.database;
    try {
      // r = await db.insert("TblRoles", _roles.toMap());
      for (var i = 0; i < _roles.length; i++) {
        Role temp = _roles[i];
        final rsql = "INSERT INTO TblRoles " +
            "( " +
            " RName," +
            " Emplid," +
            " User" +
            " )" +
            " VALUES ( " +
            " '${temp.rName}'," +
            " '${temp.empLid}'," +
            " '${temp.user}'" +
            ")";
        r = await db.rawInsert(rsql);
      }
    } catch (e) {
      debugPrint("help insertRoles Error 284:" + e.toString());
    }
    return r;
  }

//insert Attendie
  Future<int> insertAttendie(Attendie _attendie) async {
    var r;
    Database db = await this.database;
    try {
      r = await db.insert("tblAttendie", _attendie.toMap());
    } catch (e) {
      debugPrint("help insertAttendie265:" + e.toString());
    }
    return r;
  }

//insert Department
  Future<int> insertTblDept(List<String> _dept) async {
    var r;
    Database db = await this.database;
   // clearTable("TblDept");
   // await _createTblDeptDB(db, DATABASE_VERSION);
    try {
      // r = await db.insert("TblDept", _dept.toMap());
      // r = await db.rawInsert("INSERT INTO TblDept (Name) Values ($_dept)");
      for (var i = 0; i < _dept.length; i++) {
        String temp = _dept[i];
        await db.rawInsert("INSERT INTO TblDept (Name) VALUES ('$temp')");
      }
    } catch (e) {
      debugPrint("help insertTblDept Error284:" + e.toString());
    }
    return r;
  }

//ValidUser
  Future<int> insertTblValidUser(List<ValidUser> _validUser) async {
    var r;
    Database db = await this.database;
    try {
 for (var i = 0; i < _validUser.length; i++) {
        ValidUser temp = _validUser[i];
        final vlist = "INSERT INTO TblValidUser " +
            "( " +
            " cardId," +
            " barcode," +
            " empLid" +
            " )" +
            " VALUES ( " +
            " ${temp.cardId}," +
            " ${temp.barcode}," +
            " ${temp.empLid}" +
            ")";
        r = await db.rawInsert(vlist);
      }     
    } catch (e) {
      debugPrint("help TblValidUser289:" + e.toString());
    }
    return r;
  }

  //get sessions based on department
  Future<List> getSessionsByDeptDb(String query) async {
    //String dept = query;
    String sql = "Select * from tblSessions where department = " + query;
    if (query.length < 1) {
      Database db = await this.database;
      var out = await db.rawQuery(sql);
      return out;
    } else {
      return null;
    }
  }

  //countDB
  Future<int> getCount(String tName) async {
    Database db = await this.database;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) FROM " + tName));
    print("droped table --211 " + tName);
    return result;
  }

  //show data in table

  Future<List<CurrentSession>> getAlltblSessions() async {
    Database db = await this.database;
    try {
      final sql = '''SELECT * FROM tblSessions}''';
      final data = await db.rawQuery(sql);
      List<CurrentSession> todos = List();
      for (final node in data) {
        final todo = CurrentSession.fromJson(node);
        todos.add(todo);
      }
      return todos;
    } catch (e) {
      debugPrint("help getAlltblSessions 368:" + e.toString());
    }
    // return r;
    return null;
  }

  Future<List<String>> getAllDepartments() async {
    Database db = await this.database;
    try {
      final sql = '''SELECT * FROM TblDept ''';
      final data = await db.rawQuery(sql);
      List<String> todos = List();
      for (final node in data) {
        todos.add(node.toString());
      }
      return todos;
    } catch (e) {
      debugPrint("help TblDept 360:" + e.toString());
    }
    // return r;
    return null;
  }

  Future<List<Role>> getAllRoles() async {
    Database db = await this.database;
    try {
      List<Role> todos = List();
      if (db != null) {
        final sql = '''SELECT * FROM TblRoles ''';
        // final data = await db.rawQuery(sql);
        final List<Map<String, dynamic>> maps = await db.query('TblRoles');
        if (maps.length != null && maps.length > 0) {
          for (int i = 0; i < maps.length; i++) {
            Role nrole = new Role();
            nrole.empLid = maps[i]["Emplid"].toString();
            nrole.rName = maps[i]["RName"].toString();
            nrole.user = maps[i]["user"].toString();
            todos.add(nrole);
          }
        }
        return todos;
      }
      return null;
    } catch (e) {
      debugPrint("Helper TblRoles 374 Error:" + e.toString());
      return null;
    }
  }

  Future<List<ValidUser>> getAllValidUser() async {
    Database db = await this.database;
    try {
      List<ValidUser> todos = List();
      if (db != null) {
        final sql = '''SELECT * FROM TblValidUser ''';
        List<Map> maps = await db.rawQuery(sql);
        if (maps.length > 0) {
          for (int i = 0; i < maps.length; i++) {
            todos.add(ValidUser.fromOject(maps[i]));
          }
        }
        return todos;
      }
      return null;
    } catch (e) {
      debugPrint("Helper TblValidUser 428 Error:" + e.toString());
      return null;
    }
  }

  //Drop table
  Future<dynamic> clearTable(String tName) async {
    try {
      Database db = await this.database;
      /*
      var temp = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name='$tName'");
      if (temp.length != 1) {
        print("help clearTable table320 does not exist---- " + tName);
        return null;
      }

       */
      var res = await db.rawQuery("DELETE FROM " + tName);
      print("help clearTable table ---- " + tName);
      return res;
    } catch (e) {
      debugPrint("help clearTable Error326:" + e.toString());
    }
    return 0;
  }
}
