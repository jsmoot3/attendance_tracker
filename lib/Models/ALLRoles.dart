// To parse this JSON data, do
//
//     final allRolesDart = allRolesDartFromJson(jsonString);

import 'dart:convert';

List<AllRolesDart> allRolesDartFromJson(String str) => List<AllRolesDart>.from(
    json.decode(str).map((x) => AllRolesDart.fromJson(x)));

String allRolesDartToJson(List<AllRolesDart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllRolesDart {
  String rName;
  String user;

  AllRolesDart({
    this.rName,
    this.user,
  });

  factory AllRolesDart.fromJson(Map<String, dynamic> json) => AllRolesDart(
        rName: json["RName"] == null ? null : json["RName"],
        user: json["User"] == null ? null : json["User"],
      );

  Map<String, dynamic> toJson() => {
        "RName": rName == null ? null : rName,
        "User": user == null ? null : user,
      };
}
