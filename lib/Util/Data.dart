import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../Util/dbHelper.dart';
import '../Models/Session.dart';
import '../Models/App_Models.dart';
import '../Models/AppData.dart';

class getData {
  Future<AppData> GetDbItems() async {}
//CUID
////////////////////////////////////////////////////////////
//insert sessions
  Future<int> insertSession(CurrentSession inPut) async {
    var r;
    Database db = await getDatabase();
    try {
      r = await db.insert("tblSessions", inPut.toMap());
    } catch (e) {
      debugPrint("insertDoc:" + e.toString());
    }
    return r;
  }

//insert roles
  Future<int> insertRoles(Role _Roles) async {
    var r;
    Database db = getDatabase();
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
    Database db = getDatabase();
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
    Database db = getDatabase();
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
    Database db = getDatabase();
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
      Database db = getDatabase();
      var out = await db.rawQuery(sql);
      return out;
    } else {
      return null;
    }
  }

  Future<List> getRolesFromIdDb(String query) async {
    String dept = query;
    String sql =
        "Select * from TblRoles where User = " + query + " || EmpId ==" + query;
    if (query.length < 1) {
      Database db = getDatabase();
      var out = await db.rawQuery(sql);
      return out;
    } else {
      return null;
    }
  }

  getDatabase() async {
    var inDb = DbHelper();
    final db = await inDb.db;
    return db;
  }

/////////////////////////////////////////////////////////////////////////
  //////////  eND cuid  ///////////////////////

  /////////////////////////////////////////////////////////////////////
  ////////////  api calls
  //////////////////////////////////////////////////////////////

}
