class EventAttendie {
  String StudentBarCode;
  String StudentId;
  int EventSessionId_fk;
  int FLEventId_FK;
  int WeekOfClass;
  String AttendieName;
  DateTime Date;
  bool HasCheckWaiver;
  String SignedInBy;
  String OtherAttLocation;
  String Emplid;

  EventAttendie({
    this.StudentBarCode,
    this.StudentId,
    this.EventSessionId_fk,
    this.FLEventId_FK,
    this.WeekOfClass,
    this.AttendieName,
    this.Date,
    this.HasCheckWaiver,
    this.SignedInBy,
    this.OtherAttLocation,
    this.Emplid
  });

  Map<String, dynamic> toJson() => {
        "StudentBarCode": StudentBarCode == null ? null : StudentBarCode,
        "StudentId": StudentId == null ? null : StudentId,
        "EventSessionId_fk":
            EventSessionId_fk == null ? null : EventSessionId_fk.toString(),
        "FLEventId_FK": FLEventId_FK == null ? null : FLEventId_FK.toString(),
        "WeekOfClass": WeekOfClass == null ? null : WeekOfClass,
        "AttendieName": AttendieName == null ? null : AttendieName,
        "Date": Date == null ? null : Date.toString(),
        "HasCheckWaiver": HasCheckWaiver == null ? null : HasCheckWaiver.toString(),
        "SignedInBy": SignedInBy == null ? null : SignedInBy,
        "OtherAttLocation": OtherAttLocation == null ? null : OtherAttLocation,
        "Emplid":
            EventSessionId_fk == null ? null : EventSessionId_fk.toString(),
        

        /*
        "CurrentSessions": currentSessions == null
            ? null
            : List<dynamic>.from(currentSessions.map((x) => x.toJson())),
        "Departments": departments == null
            ? null
            : List<dynamic>.from(departments.map((x) => x)),
            */
      };
}
