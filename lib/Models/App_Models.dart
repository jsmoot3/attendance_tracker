//application Models used

class Role {
  int id;
  String RName;
  String User;
  Role(this.RName, this.User);
  Role.withId(this.id, this.RName, this.User);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["RName"] = this.RName;
    map["User"] = this.User;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  Role.fromOject(dynamic input) {
    this.id = input["id"];
    this.RName = input["RName"];
    this.User = input["User"];
  }
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
