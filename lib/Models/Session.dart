//event model class event container
class Session {
  int id;
  int EventSessionID;
  int EventID_fk;
  String CampusLocation;
  String StartDate;
  String TimeOfDay;
  String Day;
  String Divison;
  String WaverName;

  Session(this.EventSessionID, this.EventID_fk, this.CampusLocation,
      this.StartDate, this.TimeOfDay, this.Day, this.Divison, this.WaverName);

  Session.withId(
      this.id,
      this.EventSessionID,
      this.EventID_fk,
      this.CampusLocation,
      this.StartDate,
      this.TimeOfDay,
      this.Day,
      this.Divison,
      this.WaverName);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["EventSessionID"] = this.EventSessionID;
    map["EventID_fk"] = this.EventID_fk;
    map["CampusLocation"] = this.CampusLocation;
    map["StartDate"] = this.StartDate;
    map["TimeOfDay"] = this.TimeOfDay;
    map["Day"] = this.Day;
    map["Divison"] = this.Divison;
    map["WaverName"] = this.WaverName;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Session.fromOject(dynamic input) {
    this.id = input["id"];
    this.EventSessionID = input["EventSessionID"];
    this.EventID_fk = input["EventID_fk"];
    this.CampusLocation = input["CampusLocation"];
    this.StartDate = input["StartDate"];
    this.TimeOfDay = input["TimeOfDay"];
    this.Day = input["Day"];
    this.Divison = input["Divison"];
    this.WaverName = input["WaverName"];
  }
}

//record of student that attend event.
class Attendie {
  String StudentId;
  String EventSessionId_fk;
  String FLEventId_FK;
  String Date;
  String SignedInBy;
  String OtherAttLocation;

  Attendie(this.StudentId, this.EventSessionId_fk, this.FLEventId_FK, this.Date,
      this.SignedInBy, this.OtherAttLocation);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["StudentId"] = this.StudentId;
    map["EventSessionId_fk"] = this.EventSessionId_fk;
    map["FLEventId_FK"] = this.FLEventId_FK;
    map["Date"] = this.Date;
    map["SignedInBy"] = this.SignedInBy;
    map["OtherAttLocation"] = this.OtherAttLocation;
    return map;
  }

  Attendie.fromOject(dynamic input) {
    this.StudentId = input["StudentId"];
    this.EventSessionId_fk = input["EventSessionId_fk"];
    this.FLEventId_FK = input["FLEventId_FK"];
    this.Date = input["Date"];
    this.SignedInBy = input["SignedInBy"];
    this.OtherAttLocation = input["OtherAttLocation"];
  }
}
