import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import '../Util/dbHelper.dart';
import '../Models/Session.dart';
import '../Models/App_Models.dart';

class getData {
//CUID
////////////////////////////////////////////////////////////
//insert sessions
  Future<int> insertSession(SessionDart) async {
    var r;
    Database db = getDatabase();
    try {
      r = await db.insert("tblSessions", SessionDart.toMap());
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
