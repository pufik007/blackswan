import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api/entities/user.dart';

class Settings {
  static SharedPreferences _prefs;

  static Future<Settings> load() async {
    if (Settings._prefs == null) {
      Settings._prefs = await SharedPreferences.getInstance();
    }

    return Settings._().._load();
  }

  String get token => this._token;

  String get client => this._client;

  User get user => this._user;

  String _token;

  String _client;

  User _user;

  Settings._();

  clear() async {
    await Settings._prefs.setString('access-token', null);
    await Settings._prefs.setString('client', null);
    await Settings._prefs.setString('user', null);
    this._token = null;
    this._client = null;
    this._user = null;
  }

  setClient(String client) async {
    await Settings._prefs.setString('client', client);
    this._client = client;
  }

  setToken(String token) async {
    if(token != null && token != '') {
      await Settings._prefs.setString('access-token', token);
      this._token = token;
    }
  }

  setUser(User user) async {
    await Settings._prefs.setString('user', jsonEncode(user.toJson()));
    this._user = user;
  }

  _load() {
    var token = Settings._prefs.getString('access-token');
    if (token != null) {
      this._token = token;
    }
    var client = Settings._prefs.getString('client');
    if (client != null) {
      this._client = client;
    }
    var user = Settings._prefs.getString('user');
    if (user != null) {
      this._user = User.fromJson(jsonDecode(user));
    }
  }
}
