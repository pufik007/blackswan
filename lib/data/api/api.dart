import 'dart:convert';

import 'package:tensorfit/data/api/entities/errors.dart';
import 'package:tensorfit/data/api/responses/user_response.dart';

import 'entities/user.dart';
import 'package:http/http.dart' as http;

const String _url = "https://blackbird-staging-api.herokuapp.com";

abstract class Api {
  static Future<UserResponse> register(String login, String password) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var body = jsonEncode({"email": login, "password": password});

      var httpRes = await http.post('$_url/auth', headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var user = User.fromJson(json.decode(httpRes.body));
        var token = httpRes.headers['access-token'];
        var client = httpRes.headers['client'];
        if (token == null) {
          return UserResponse.error(['API: token is absent in header']);
        } else if (client == null) {
          return UserResponse.error(['API: client is absent in header']);
        } else {
          return UserResponse.ok(token, client, user);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return UserResponse.error(errors.errors);
      }
    } catch (e) {
      return UserResponse.error(['${e.toString()}']);
    }
  }

  static Future<UserResponse> login(String login, String password) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var body = jsonEncode({"email": login, "password": password});

      var httpRes = await http.post('$_url/auth/sign_in', headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var user = User.fromJson(json.decode(httpRes.body));
        var token = httpRes.headers['access-token'];
        var client = httpRes.headers['client'];
        if (token == null) {
          return UserResponse.error(['API: token is absent in header']);
        } else if (client == null) {
          return UserResponse.error(['API: client is absent in header']);
        } else {
          return UserResponse.ok(token, client, user);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return UserResponse.error(errors.errors);
      }
    } catch (e) {
      return UserResponse.error(['${e.toString()}']);
    }
  }

  static logout(String uid, String client, String token) async {
    try {
      Map<String, String> headers = {
        "access-token": token,
        "client": client,
        "uid": uid,
      };

      http.delete('$_url/auth/sign_out', headers: headers);
    } catch (e) {}
  }
}
