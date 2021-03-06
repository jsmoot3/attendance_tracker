//application Models used
import 'dart:convert';

//List<Role> roleFromJson(String str) =>
//   List<Role>.from(json.decode(str).map((x) => Role.fromJson(x)));

String roleToJson(List<Role> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Role {
  //int id;
  String rName;
  String user;
  String empLid;
  Role({this.rName, this.user, this.empLid});
  //Role.withId(this.id, this.rName, this.User,this.EmpId);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["RName"] = this.rName;
    map["User"] = this.user;
    map["Emplid"] = this.empLid;
    return map;
  }

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        rName: json["RName"] == null ? null : json["RName"],
        user: json["User"] == null ? null : json["User"],
        empLid: json["Emplid"] == null ? null : json["Emplid"],
      );

  Role.fromOject(dynamic input) {
    this.rName = input["RName"];
    this.user = input["User"];
    this.empLid = input["Emplid"];
  }

  Map<String, dynamic> toJson() => {
        "RName": rName == null ? null : rName,
        "User": user == null ? null : user,
        "Emplid": empLid == null ? null : empLid,
      };
}

class ValidUser {
  String cardId;
  String barcode;
  String empLid = "";
  ValidUser({this.cardId, this.barcode, this.empLid});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["CardId"] = this.cardId;
    map["Barcode"] = this.barcode;
    map["EmpLid"] = this.empLid;
    return map;
  }

  ValidUser.fromOject(dynamic input) {
    this.cardId = input["CardId"];
    this.barcode = input["Barcode"];
    this.empLid = input["EmpLid"];
  }
  factory ValidUser.fromJson(Map<String, dynamic> json) => ValidUser(
        cardId: json["CardId"] == null ? null : json["CardId"],
        barcode: json["Barcode"] == null ? null : json["Barcode"],
        empLid: json["EmpLid"] == null ? null : json["EmpLid"],
      );
}

class Department {
  String name;
  List<String> departments;

  Department({this.name});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Name"] = this.name;
    return map;
  }

  Department.fromOject(dynamic input) {
    this.name = input["Name"];
  }
  //factory Department.fromJson( dynamic input> json) (
  //    departments: json["Departments"] == null ? null : List<String>.from(json["Departments"].map((x) => x)),
  // );
}
