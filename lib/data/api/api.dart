import 'dart:convert';

import 'package:tensorfit/data/api/entities/errors.dart';
import 'package:tensorfit/data/api/entities/exerciseDetection.dart';
import 'package:tensorfit/data/api/entities/goal.dart';
import 'package:tensorfit/data/api/responses/public_response.dart';
import 'package:tensorfit/data/api/responses/private_response.dart';
import 'package:tensorfit/data/api/responses/user_response.dart';

import 'entities/exercise_info.dart';
import 'entities/journey.dart';
import 'entities/level.dart';
import 'entities/user.dart';
import 'package:http/http.dart' as http;

const String _url = "https://api.tensorfit.com";

abstract class Api {
  static Future<PrivateResponse> register(String login, String password) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var body = jsonEncode({"email": login, "password": password});

      var httpRes = await http.post('$_url/auth', headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var user = User.fromJson(json.decode(httpRes.body));
        var token = httpRes.headers['access-token'];
        var client = httpRes.headers['client'];
        if (token == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else if (client == null) {
          return PrivateResponse.error(['API: client is absent in header']);
        } else {
          return PrivateResponse.ok(
              token, UserResponse(client: client, user: user));
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> login(String login, String password) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var body = jsonEncode({"email": login, "password": password});

      var httpRes =
          await http.post('$_url/auth/sign_in', headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var user = User.fromJson(json.decode(httpRes.body));
        var token = httpRes.headers['access-token'];
        var client = httpRes.headers['client'];
        if (token == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else if (client == null) {
          return PrivateResponse.error(['API: client is absent in header']);
        } else {
          return PrivateResponse.ok(
              token, UserResponse(client: client, user: user));
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> loginGoogle(String tokenID) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var body = jsonEncode({"id_token": tokenID});

      var httpRes = await http.post('$_url/auth/google_oauth2/validate',
          headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var user = User.fromJson(json.decode(httpRes.body));
        var token = httpRes.headers['access-token'];
        var client = httpRes.headers['client'];
        if (token == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else if (client == null) {
          return PrivateResponse.error(['API: client is absent in header']);
        } else {
          return PrivateResponse.ok(
              token, UserResponse(client: client, user: user));
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> loginFacebook(String tokenID) async {
    try {
      Map<String, String> headers = {"Content-type": "application/json"};
      var body = jsonEncode({"id_token": tokenID});

      var httpRes = await http.post('$_url/auth/facebook/validate',
          headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var user = User.fromJson(json.decode(httpRes.body));
        var token = httpRes.headers['access-token'];
        var client = httpRes.headers['client'];
        if (token == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else if (client == null) {
          return PrivateResponse.error(['API: client is absent in header']);
        } else {
          return PrivateResponse.ok(
              token, UserResponse(client: client, user: user));
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static logout(String uid, String client, String token) async {
    try {
      Map<String, String> headers = {
        "uid": uid,
        "client": client,
        "access-token": token,
      };

      http.delete('$_url/auth/sign_out', headers: headers);
    } catch (e) {}
  }

  static Future<PublicResponse> getGoals() async {
    try {
      var httpRes = await http.get('$_url/public/goals');

      if (httpRes.statusCode == 200) {
        var res = List<Goal>();
        for (var value in json.decode(httpRes.body)) {
          var goal = Goal.fromJson(value);
          res.add(goal);
        }

        return PublicResponse.ok(res);
      } else {
        return PublicResponse.error(['API: somthing went wrong (']);
      }
    } catch (e) {
      return PublicResponse.error([e.toString()]);
    }
  }

  static Future<PrivateResponse> getJourney(
      String uid, String client, String token) async {
    try {
      Map<String, String> headers = {
        "uid": uid,
        "client": client,
        "access-token": token,
      };

      var httpRes = await http.get('$_url/journey', headers: headers);

      print(httpRes.body);

      if (httpRes.statusCode == 200 || httpRes.statusCode == 202) {
        var journey = Journey.fromJson(json.decode(httpRes.body));
        var newToken = httpRes.headers['access-token'];
        if (token == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, journey);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> createJourney(
      String uid, String client, String token) async {
    try {
      Map<String, String> headers = {
        "uid": uid,
        "client": client,
        "access-token": token,
        "Content-type": "application/json",
      };

      var body = jsonEncode(Journey(difficulty: 'normal').toJson());

      var httpRes =
          await http.post('$_url/journey', headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var journey = Journey.fromJson(json.decode(httpRes.body));
        var newToken = httpRes.headers['access-token'];
        if (token == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, journey);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> updateUser(
      User user, String client, String token) async {
    try {
      Map<String, String> headers = {
        "uid": user.email,
        "client": client,
        "access-token": token,
        "Content-type": "application/json",
      };

      var body = jsonEncode(user.toJson());

      var httpRes =
          await http.patch('$_url/auth', headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var newUser = User.fromJson(json.decode(httpRes.body));
        var newToken = httpRes.headers['access-token'];
        if (newToken == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, newUser);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> updateGoals(
      String uid, String client, String token, List<Goal> goals) async {
    try {
      Map<String, String> headers = {
        "uid": uid,
        "client": client,
        "access-token": token,
        "Content-type": "application/json",
      };

      var body = jsonEncode({"goals": goals});

      var httpRes =
          await http.patch('$_url/dreams', headers: headers, body: body);

      if (httpRes.statusCode == 200) {
        var newToken = httpRes.headers['access-token'];
        if (newToken == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, json.decode(httpRes.body));
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> getLevels(
      User user, String client, String token) async {
    try {
      Map<String, String> headers = {
        "uid": user.email,
        "client": client,
        "access-token": token,
        "Content-type": "application/json",
      };

      var httpRes = await http.get('$_url/levels', headers: headers);

      print(httpRes.body);

      if (httpRes.statusCode == 200) {
        var levels = Level.fromJsonArray(json.decode(httpRes.body));
        var newToken = httpRes.headers['access-token'];
        if (newToken == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, levels);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> getExercises(
      User user, String client, String token, int levelID) async {
    try {
      Map<String, String> headers = {
        "uid": user.email,
        "client": client,
        "access-token": token,
        "Content-type": "application/json",
      };

      var httpRes = await http.get('$_url/levels/$levelID/exercise_variants',
          headers: headers);

      print(httpRes.body);

      if (httpRes.statusCode == 200) {
        var exercises = ExerciseInfo.fromJsonArray(json.decode(httpRes.body));
        var newToken = httpRes.headers['access-token'];
        if (newToken == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, exercises);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> replaceExercise(User user, String client,
      String token, int exerciseID, int substituteID) async {
    try {
      Map<String, String> headers = {
        "uid": user.email,
        "client": client,
        "access-token": token,
        "Content-type": "application/json",
      };

      var body = jsonEncode({
        "substitute_id": substituteID,
      });

      var httpRes = await http.post(
          '$_url/exercise_variants/$exerciseID/replace',
          headers: headers,
          body: body);

      print(httpRes.body);

      if (httpRes.statusCode == 204) {
        var newToken = httpRes.headers['access-token'];
        if (newToken == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, null);
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

  static Future<PrivateResponse> getExerciseDetection(
      User user, String client, String token, String id) async {
    try {
      Map<String, String> headers = {
        "uid": user.email,
        "client": client,
        "access-token": token,
        "Content-type": "application/json",
      };

      var httpRes = await http.get('$_url/exercise/$id/exercise_detections',
          headers: headers);

      print(httpRes.body);

      if (httpRes.statusCode == 200) {
        var exerciseDetections = ExerciseDetection.fromJsonObject(json.decode(httpRes.body));
        var newToken = httpRes.headers['access-token'];
        if (newToken == null) {
          return PrivateResponse.error(['API: token is absent in header']);
        } else {
          return PrivateResponse.ok(newToken, exerciseDetections);
          
        }
      } else {
        var errors = Errors.fromJson(json.decode(httpRes.body));
        return PrivateResponse.error(errors.errors);
      }
    } catch (e) {
      return PrivateResponse.error(['${e.toString()}']);
    }
  }

}
