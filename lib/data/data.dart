import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tensorfit/data/api/entities/goal.dart';
import 'package:tensorfit/data/api/entities/journey.dart';
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

    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
  }

  loginGoogle() async {
    //final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    /*
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await firebaseAuth.signInWithCredential(credential);
    return firebaseAuth.currentUser();
     */
  }

  loginApple() async {
    final result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
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

  Future<Journey> getJourney() async {
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

  Future _loadGoals() async {
    var res = await Api.getGoals();
    if (res.response != null && res.response is List<Goal>) {
      this._goals = res.response;
    }
  }
}
