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
  Role(this.rName, this.user, this.empLid);
  //Role.withId(this.id, this.rName, this.User,this.EmpId);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["RName"] = this.rName;
    map["User"] = this.user;
    map["Emplid"] = this.empLid;

    //if (id != null) {
    //  map["id"] = id;
    // }
    return map;
  }

  /*
  factory Role.fromJson(Map<String, dynamic> json) => Role(
        rName: json["RName"] == null ? null : json["RName"],
        user: json["User"] == null ? null : json["User"],
    empLid: json["Emplid"] == null ? null : json["Emplid"],
  );
*/
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
  int id;
  String CardId;
  String Barcode;
  ValidUser(this.CardId, this.Barcode);
  ValidUser.withId(this.id, this.CardId, this.Barcode);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["CardId"] = this.CardId;
    map["Barcode"] = this.Barcode;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  ValidUser.fromOject(dynamic input) {
    this.id = input["id"];
    this.CardId = input["CardId"];
    this.Barcode = input["Barcode"];
  }
}

class Department {
  int id;
  String Name;
  Department(this.Name);

  Department.withId(this.id, this.Name);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Name"] = this.Name;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Department.fromOject(dynamic input) {
    this.id = input["id"];
    this.Name = input["Name"];
  }
}
