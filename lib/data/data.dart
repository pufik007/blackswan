import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tensorfit/data/api/entities/exercise_info.dart';
import 'package:tensorfit/data/api/entities/goal.dart';
import 'package:tensorfit/data/api/entities/journey.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import 'package:tensorfit/data/api/responses/user_response.dart';
import 'package:tensorfit/ui/pages/journey_bloc/user_gender_type.dart';

import 'api/api.dart';
import 'api/entities/user.dart';
import 'settings.dart';

class Data {
  static load() async {
    Data._instance = Data._();
    Data.instance._settings = await Settings.load();
    await Data.instance._loadGoals();
  }

  static Data get instance => Data._instance;

  static Data _instance;

  Data._();

  String get token => this._settings.token;

  bool get needFillUserData =>
      this._settings.user.dateOfBirth == null ||
      this._settings.user.height == null ||
      this._settings.user.weight == null ||
      //     this._settings.user.gender == null ||
      this._settings.user.locale == null;

  List<Goal> get goals {
    if (this._goals.length == 0) {
      this._loadGoals();
    }
    return this._goals;
  }

  Settings _settings;
  List<Goal> _goals = [];

  loginFacebook() async {
    final facebookSignIn = FacebookLogin();

    final FacebookLoginResult facebookUser = await facebookSignIn.logIn(['email']);

    if (facebookUser.status == FacebookLoginStatus.loggedIn) {
      var res = await Api.loginFacebook(facebookUser.accessToken.token);

      if (res.token != null && res.response != null && res.response is UserResponse) {
        await this._settings.setClient(res.response.client);
        await this._settings.setToken(res.token);
        await this._settings.setUser(res.response.user);
        return null;
      } else if (res.errors != null) {
        return res.errors.first;
      } else {
        return 'DATA: invalid http response';
      }
    }
  }

  loginGoogle() async {
    final googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final auth = await googleUser.authentication;
    await googleSignIn.signOut();

    var res = await Api.loginGoogle(auth.idToken);

    if (res.token != null && res.response != null && res.response is UserResponse) {
      await this._settings.setClient(res.response.client);
      await this._settings.setToken(res.token);
      await this._settings.setUser(res.response.user);
      return null;
    } else if (res.errors != null) {
      return res.errors.first;
    } else {
      return 'DATA: invalid http response';
    }
/*
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    try {
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      print(authResult);
    } catch (e) {
      print(e);
    }
*/
  }

  loginApple() async {
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    print(result);
/*
    switch (result.status) {
      case AuthorizationStatus.authorized:

      // Store user ID
        await FlutterSecureStorage()
            .write(key: "userId", value: result.credential.user);

        // Navigate to secret page (shhh!)
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) =>
                SecretMembersOnlyPage(credential: result.credential)));
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        setState(() {
          errorMessage = "Sign in failed 😿";
        });
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
    */
  }

  Future<String> register(String email, String password) async {
    var res = await Api.register(email, password);
    if (res.token != null && res.response != null && res.response is UserResponse) {
      await this._settings.setClient(res.response.client);
      await this._settings.setToken(res.token);
      await this._settings.setUser(res.response.user);
      return null;
    } else if (res.errors != null) {
      return res.errors.first;
    } else {
      return 'DATA: invalid http response';
    }
  }

  Future<String> login(String email, String password) async {
    var res = await Api.login(email, password);
    if (res.token != null && res.response != null && res.response is UserResponse) {
      await this._settings.setClient(res.response.client);
      await this._settings.setToken(res.token);
      await this._settings.setUser(res.response.user);
      return null;
    } else if (res.errors != null) {
      return res.errors.first;
    } else {
      return 'DATA: invalid http response';
    }
  }

  Future logout() async {
    Api.logout(
      this._settings.user.email,
      this._settings.client,
      this._settings.token,
    );
    await this._settings.clear();
  }

  Journey journey;

  Future<Journey> getJourney(bool forceUpdate) async {
    if (!forceUpdate && this.journey != null) {
      return this.journey;
    }
    var res = await Api.getJourney(
      this._settings.user.email,
      this._settings.client,
      this._settings.token,
    );
    if (res.token != null && res.response != null && res.response is Journey) {
      await this._settings.setToken(res.token);
      this.journey = res.response;
      return res.response;
    } else {
      return null;
    }
  }

  Future<String> createJourney(List<Goal> goals) async {
    var res = await Api.updateGoals(
      this._settings.user.email,
      this._settings.client,
      this._settings.token,
      goals,
    );

    if (res.token != null) {
      await this._settings.setToken(res.token);
    } else if (res.errors != null) {
      return res.errors.first;
    } else {
      return 'DATA: invalid http response';
    }

    res = await Api.createJourney(
      this._settings.user.email,
      this._settings.client,
      this._settings.token,
    );

    if (res.token != null && res.response != null && res.response is Journey) {
      await this._settings.setToken(res.token);
      this.journey = res.response;
      return null;
    } else if (res.errors != null) {
      return res.errors.first;
    } else {
      return 'DATA: invalid http response';
    }
  }

  Future<String> fillUserData(DateTime dateOfBirth, int height, int weight, UserGenderType gender) async {
    var newUser = this._settings.user.update(dateOfBirth, height, weight, gender, 'ru');

    var res = await Api.updateUser(
      newUser,
      this._settings.client,
      this._settings.token,
    );

    if (res.token != null && res.response != null && res.response is User) {
      await this._settings.setToken(res.token);
      await this._settings.setUser(res.response);
      return null;
    } else if (res.errors != null) {
      return res.errors.first;
    } else {
      return 'DATA: invalid http response';
    }
  }

  Future<List<Level>> getLevels() async {
    var res = await Api.getLevels(
      this._settings.user,
      this._settings.client,
      this._settings.token,
    );

    if (res.token != null && res.response != null && res.response is List<Level>) {
      await this._settings.setToken(res.token);
      return res.response;
    } else if (res.errors != null) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<ExerciseInfo>> getExercises(Level level) async {
    var res = await Api.getExercises(
      this._settings.user,
      this._settings.client,
      this._settings.token,
      level.id,
    );

    if (res.token != null && res.response != null && res.response is List<ExerciseInfo>) {
      await this._settings.setToken(res.token);
      return res.response;
    } else if (res.errors != null) {
      return null;
    } else {
      return null;
    }
  }

  Future<String> replaceExercise(int exerciseID, int substituteID) async {
    var res = await Api.replaceExercise(
      this._settings.user,
      this._settings.client,
      this._settings.token,
      exerciseID,
      substituteID,
    );

    if (res.token != null) {
      await this._settings.setToken(res.token);
      return null;
    } else if (res.errors != null) {
      return res.errors.first;
    } else {
      return 'DATA: invalid http response';
    }
  }

  Future _loadGoals() async {
    var res = await Api.getGoals();
    if (res.response != null && res.response is List<Goal>) {
      this._goals = res.response;
    }
  }
}
