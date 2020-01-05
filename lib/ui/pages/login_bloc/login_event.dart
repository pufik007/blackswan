import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent extends Equatable {
  final List _properties;

  LoginEvent([this._properties]);

  @override
  List<Object> get props => this._properties;
}

class ChangeEmail extends LoginEvent {
  final String email;

  ChangeEmail(this.email) : super([email]);
}

class ChangePassword extends LoginEvent {
  final String password;

  ChangePassword(this.password) : super([password]);
}

class ChangeShowPassword extends LoginEvent {
  ChangeShowPassword() : super([]);
}

class CreateAccount extends LoginEvent {
  CreateAccount() : super([]);
}

class Login extends LoginEvent {
  Login() : super([]);
}

class LoginByFacebook extends LoginEvent {
  LoginByFacebook() : super([]);
}

class LoginByGoogle extends LoginEvent {
  LoginByGoogle() : super([]);
}

class LoginByApple extends LoginEvent {
  LoginByApple() : super([]);
}