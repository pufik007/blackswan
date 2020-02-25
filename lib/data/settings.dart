import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static SharedPreferences _prefs;

  static Future<Settings> load() async {
    if (Settings._prefs == null) {
      Settings._prefs = await SharedPreferences.getInstance();
    }

    return Settings._().._load();
  }

  String get client => this._client;

  String get email => this._email;

  String get token => this._token;

  String _client;
  String _email;
  String _token;

  Settings._();

  setUser(String client, String email, String token) async {
    await Settings._prefs.setString('client', client);
    await Settings._prefs.setString('client_email', email);
    await Settings._prefs.setString('login_token', token);
    this._client = client;
    this._email = email;
    this._token = token;
  }

  _load() {
    var client = Settings._prefs.getString('client');
    if (client != null) {
      this._client = client;
    }
    var email = Settings._prefs.getString('client_email');
    if (email != null) {
      this._email = email;
    }
    var token = Settings._prefs.getString('login_token');
    if (token != null) {
      this._token = token;
    }
  }
}
