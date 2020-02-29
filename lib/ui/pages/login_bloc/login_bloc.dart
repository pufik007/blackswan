import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tensorfit/data/app_bloc/bloc.dart' as app;
import 'package:tensorfit/data/data.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final app.AppBloc _appBloc;

  LoginBloc(this._appBloc);

  String _email = '';
  String _password = '';
  bool _showPassword = false;
  String _error;

  @override
  LoginState get initialState => this._state();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is ChangeEmail) {
      this._email = event.email;
      this._error = null;
      yield this._state();
    } else if (event is ChangePassword) {
      this._password = event.password;
      this._error = null;
      yield this._state();
    } else if (event is ChangeShowPassword) {
      this._showPassword = !this._showPassword;
      yield this._state();
    } else if (event is CreateAccount) {
      this._error = await Data.instance.register(this._email, this._password);
      if (this._error != null) {
        yield this._state();
      } else {
        this._appBloc.add(app.Update());
      }
    } else if (event is Login) {
      this._error = await Data.instance.login(this._email, this._password);
      if (this._error != null) {
        yield this._state();
      } else {
        this._appBloc.add(app.Update());
      }
    } else if (event is LoginByFacebook) {
      await Data.instance.loginFacebook();
    } else if (event is LoginByGoogle) {
      await Data.instance.loginGoogle();
    } else if (event is LoginByApple) {
      await Data.instance.loginApple();
    }
  }

  LoginState _state() {
    return LoginState(this._email, this._password, this._showPassword, this._error);
  }
}
