import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'settings.dart';

class Data {
  static load() async {
    Data._instance = Data._();
    Data.instance._settings = await Settings.load();
  }

  static Data get instance => Data._instance;

  static Data _instance;

  Data._();

  String get token => this._settings.token;

  Settings _settings;

  final _errors = [
    'first error example',
    'second error example',
  ];
  var _attemptsCount = 0;

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

  Future<String> createAccount(String email, String password) async {
    if (this._attemptsCount < this._errors.length) {
      var res = this._errors[this._attemptsCount];
      this._attemptsCount++;
      return res;
    } else {
      await this._settings.setToken('create_account_token_${DateFormat('y-MM-dd_hh-mm-ss').format(DateTime.now())}');
      return null;
    }
  }

  Future<String> login(String email, String password) async {
    await this._settings.setToken('login_token_${DateFormat('y-MM-dd_hh-mm-ss').format(DateTime.now())}');
    return null;
  }

  Future logout() async {
    await this._settings.setToken(null);
  }
}
