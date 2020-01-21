import 'dart:io';
import 'dart:convert';

import 'package:flutter/services.dart';

class WaverObj {
  String name;
  int length;
  String docType;
  List<int> doc;

  WaverObj({this.name, this.length, this.docType, this.doc});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["Name"] = this.name;
    map["Length"] = this.length;
    map["DocType"] = this.docType;
    map["Doc"] = this.doc;
    return map;
  }

  factory WaverObj.fromJson(Map<String, dynamic> json) => WaverObj(
        name: json["Name"] == null ? null : json["Name"],
        length: json["Length"] == null ? null : json["Length"],
        docType: json["DocType"] == null ? null : json["DocType"],
        doc: json["Doc"] == null ? null : utf8.encode(json["Doc"]),
      );
}
