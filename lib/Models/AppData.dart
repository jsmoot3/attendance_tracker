import 'dart:convert';
import '../Models/App_Models.dart';
import '../Models/Session.dart';

class AppData {
  String from;
  String to;
  int rcount;
  String month;
  String groupNum;
  List<CurrentSession> appDataSessions;
  List<Role> appDataroles;
  List<ValidUser> appDataallUsers;
  List<String> appDepartments;
}
