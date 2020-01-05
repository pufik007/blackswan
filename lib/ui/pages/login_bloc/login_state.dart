import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

@immutable
class LoginState extends Equatable {
  bool get enable {
    return (this.error == null) && (this.email != '') && (this.password != '');
  }

  final String email;
  final String password;
  final bool showPassword;
  final String error;

  LoginState(
    this.email,
    this.password,
    this.showPassword,
    this.error,
  );

  @override
  List<Object> get props => [this.email, this.password, this.showPassword, this.error];
}
