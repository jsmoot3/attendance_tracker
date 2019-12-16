//event model class event container
// To parse this JSON data, do
//
//     final sessionDart = sessionDartFromJson(jsonString);

import 'dart:convert';

SessionDart sessionDartFromJson(String str) =>
    SessionDart.fromJson(json.decode(str));

String sessionDartToJson(SessionDart data) => json.encode(data.toJson());

class SessionDart {
  DateTime from;
  DateTime to;
  int rcount;
  String month;
  List<CurrentSession> currentSessions;
  List<String> departments;

  SessionDart({
    this.from,
    this.to,
    this.rcount,
    this.month,
    this.currentSessions,
    this.departments,
  });

  factory SessionDart.fromJson(Map<String, dynamic> json) => SessionDart(
        from: json["From"] == null ? null : DateTime.parse(json["From"]),
        to: json["To"] == null ? null : DateTime.parse(json["To"]),
        rcount: json["Rcount"] == null ? null : json["Rcount"],
        month: json["Month"] == null ? null : json["Month"],
        currentSessions: json["CurrentSessions"] == null
            ? null
            : List<CurrentSession>.from(
                json["CurrentSessions"].map((x) => CurrentSession.fromJson(x))),
        departments: json["Departments"] == null
            ? null
            : List<String>.from(json["Departments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "From": from == null ? null : from.toIso8601String(),
        "To": to == null ? null : to.toIso8601String(),
        "Rcount": rcount == null ? null : rcount,
        "Month": month == null ? null : month,
        "CurrentSessions": currentSessions == null
            ? null
            : List<dynamic>.from(currentSessions.map((x) => x.toJson())),
        "Departments": departments == null
            ? null
            : List<dynamic>.from(departments.map((x) => x)),
      };
}

class CurrentSession {
  int flEventSessionId;
  int fLeventIDfk;
  String campusLocation;
  String trainer;
  String timeOfDay;
  String day;
  String department;
  String trainingGroup;
  int weekofClass;
  String divison;
  bool requireWaiver;
  String waiverName;
  DateTime startDate;

  CurrentSession({
    this.flEventSessionId,
    this.fLeventIDfk,
    this.campusLocation,
    this.trainer,
    this.timeOfDay,
    this.day,
    this.department,
    this.trainingGroup,
    this.weekofClass,
    this.divison,
    this.requireWaiver,
    this.waiverName,
    this.startDate,
  });

  factory CurrentSession.fromJson(Map<String, dynamic> json) => CurrentSession(
        flEventSessionId:
            json["FLEventSessionID"] == null ? null : json["FLEventSessionID"],
        fLeventIDfk: json["FLeventIDfk"] == null ? null : json["FLeventIDfk"],
        campusLocation:
            json["CampusLocation"] == null ? null : json["CampusLocation"],
        trainer: json["Trainer"] == null ? null : json["Trainer"],
        timeOfDay: json["TimeOfDay"] == null ? null : json["TimeOfDay"],
        day: json["Day"] == null ? null : json["Day"],
        department: json["Department"] == null ? null : json["Department"],
        trainingGroup:
            json["TrainingGroup"] == null ? null : json["TrainingGroup"],
        weekofClass: json["WeekofClass"] == null ? null : json["WeekofClass"],
        divison: json["Divison"] == null ? null : json["Divison"],
        requireWaiver:
            json["RequireWaiver"] == null ? null : json["RequireWaiver"],
        waiverName: json["WaiverName"] == null ? null : json["WaiverName"],
        startDate: json["StartDate"] == null
            ? null
            : DateTime.parse(json["StartDate"]),
      );

  Map<String, dynamic> toJson() => {
        "FLEventSessionID": flEventSessionId == null ? null : flEventSessionId,
        "FLeventIDfk": fLeventIDfk == null ? null : fLeventIDfk,
        "CampusLocation": campusLocation == null ? null : campusLocation,
        "Trainer": trainer == null ? null : trainer,
        "TimeOfDay": timeOfDay == null ? null : timeOfDay,
        "Day": day == null ? null : day,
        "Department": department == null ? null : department,
        "TrainingGroup": trainingGroup == null ? null : trainingGroup,
        "WeekofClass": weekofClass == null ? null : weekofClass,
        "Divison": divison == null ? null : divison,
        "RequireWaiver": requireWaiver == null ? null : requireWaiver,
        "WaiverName": waiverName == null ? null : waiverName,
        "StartDate": startDate == null ? null : startDate.toIso8601String(),
      };

  //write to the DB
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["EventSessionID"] = flEventSessionId == null ? null : flEventSessionId;
    map["EventIDfk"] = fLeventIDfk == null ? null : fLeventIDfk;
    map["CampusLocation"] = campusLocation == null ? null : campusLocation;
    map["Trainer"] = trainer == null ? null : trainer;
    map["StartDate"] = startDate == null ? null : startDate.toIso8601String();
    map["TimeOfDay"] = timeOfDay == null ? null : timeOfDay;
    map["Day"] = day == null ? null : day;
    map["Department"] = department == null ? null : department;
    map["TrainingGroup"] = trainingGroup == null ? null : trainingGroup;
    // map["WeekofClass"] = weekofClass == null ? null : weekofClass;
    // map["Divison"] = divison == null ? null : divison;
    // map["RequireWaiver"] = requireWaiver == null ? null : requireWaiver;
    map["WaiverName"] = waiverName == null ? null : waiverName;

    return map;
  }

  //from the DB
  CurrentSession.fromDb(dynamic o) {
    this.flEventSessionId = o["FLEventSessionID"];
    this.fLeventIDfk = o["FLeventIDfk"];
    this.campusLocation = o["CampusLocation"];
    this.trainer = o["Trainer"];
    this.trainer = o["TimeOfDay"];
    this.day = o["Day"];
    this.department = o["Department"];
    this.trainingGroup = o["TrainingGroup"];
    this.weekofClass = o["WeekofClass"];
    this.divison = o["Divison"];
    this.requireWaiver = o["RequireWaiver"];
    this.waiverName = o["WaiverName"];
    this.startDate = o["StartDate"];
  }
}

//record of student that attend event.
class Attendie {
  String studentId;
  String eventSessionId_fk;
  String fLEventId_FK;
  String date;
  String signedInBy;
  String otherAttLocation;

  Attendie(this.studentId, this.eventSessionId_fk, this.fLEventId_FK, this.date,
      this.signedInBy, this.otherAttLocation);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["StudentId"] = this.studentId;
    map["EventSessionId_fk"] = this.eventSessionId_fk;
    map["FLEventIdFK"] = this.fLEventId_FK;
    map["Date"] = this.date;
    map["SignedInBy"] = this.signedInBy;
    map["OtherAttLocation"] = this.otherAttLocation;
    return map;
  }

  Attendie.fromOject(dynamic input) {
    this.studentId = input["StudentId"];
    this.eventSessionId_fk = input["EventSessionId_fk"];
    this.fLEventId_FK = input["FLEventIdFK"];
    this.date = input["Date"];
    this.signedInBy = input["SignedInBy"];
    this.otherAttLocation = input["OtherAttLocation"];
  }
}
