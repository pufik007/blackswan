import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static SharedPreferences _prefs;

  static Future<Settings> load() async {
    if (Settings._prefs == null) {
      Settings._prefs = await SharedPreferences.getInstance();
    }

    return Settings._().._load();
  }

  String get token => this._token;

  String _token;

  Settings._();

  setToken(String token) async {
    await Settings._prefs.setString('login_token', token);
    this._token = token;
  }

  _load() {
    var token = Settings._prefs.getString('login_token');
    if (token != null) {
      this._token = token;
    }
  }
}
