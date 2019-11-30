import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart' as Constants;
import '../Models/App_Models.dart';
import '../Models/Session.dart';

class API {
  Future<Session> fetchSessions() async {
    final response = await http.get(Constants.MONTH_SESSIONS);
    if (response.statusCode == 200) {
      //TODO;  need to fix the get into objects
      // return Session.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<http.Response> fetchRoles() {
    return http.get(Constants.ALL_ROLES);
  }

  Future<http.Response> fetchValidUsers() {
    return http.get(Constants.VALID_USERS);
  }
}
