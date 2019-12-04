// To parse this JSON data, do
//
//     final currentUsersDart = currentUsersDartFromJson(jsonString);

import 'dart:convert';

List<CurrentUsersDart> currentUsersDartFromJson(String str) =>
    List<CurrentUsersDart>.from(
        json.decode(str).map((x) => CurrentUsersDart.fromJson(x)));

String currentUsersDartToJson(List<CurrentUsersDart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CurrentUsersDart {
  String cardId;
  String barcode;

  CurrentUsersDart({
    this.cardId,
    this.barcode,
  });

  factory CurrentUsersDart.fromJson(Map<String, dynamic> json) =>
      CurrentUsersDart(
        cardId: json["CardId"] == null ? null : json["CardId"],
        barcode: json["Barcode"] == null ? null : json["Barcode"],
      );

  Map<String, dynamic> toJson() => {
        "CardId": cardId == null ? null : cardId,
        "Barcode": barcode == null ? null : barcode,
      };
}
