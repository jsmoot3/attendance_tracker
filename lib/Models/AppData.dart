import '../Models/App_Models.dart';
import '../Models/Session.dart';

class AppData {
  String groupId;
  CurrentDataInfo appDataCurrentDataInfo;
  List<CurrentSession> appDataSessions;
  List<Role> appDataroles;
  List<ValidUser> appDataallUsers;
  List<String> appDepartments;
}

class CurrentDataInfo {
  String from;
  String to;
  String rcount;
  String month;
  String dateSpan;

  CurrentDataInfo({this.from, this.to, this.rcount, this.month, this.dateSpan});

  factory CurrentDataInfo.fromJson(Map<String, dynamic> json) =>
      CurrentDataInfo(
          from: json["from"] == null ? null : json["from"].toString(),
          to: json["to"] == null ? null : json["to"].toString(),
          rcount: json["rcount"] == null ? null : json["rcount"],
          month: json["month"] == null ? null : json["month"],
          dateSpan: json["dateSpan"] == null ? null : json["dateSpan"]);
}
