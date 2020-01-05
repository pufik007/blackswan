import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tensorfit/data/app_bloc/app_bloc.dart';
import 'package:tensorfit/generated/i18n.dart';
import 'package:tensorfit/ui/widgets/TensorfitButton.dart';
import 'package:tensorfit/ui/widgets/login_adapt.dart';
import 'Dart:io' show Platform;

import 'login_bloc/bloc.dart';

const _maxItemHeight = 50.0;
const _dividerThickness = 2.0;

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  // ignore: close_sinks
  LoginBloc _bloc;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    this._emailController.clear();
    this._passwordController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this._bloc == null) {
      this._bloc = LoginBloc(BlocProvider.of<AppBloc>(context));
    }

    return AdaptLogin(
      child: this._buildBody(context),
      minAspectRatio: 0.6,
    );
  }

  @override
  void dispose() {
    this._bloc.close();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    var theme = Theme.of(context);
    var divider = Expanded(
      child: Divider(
        color: theme.disabledColor,
        thickness: _dividerThickness,
      ),
    );

    var loginButtons = List<Widget>();
    loginButtons.add(TensorfitBorderedButton(
      title: S.of(context).login_facebook,
      height: _maxItemHeight,
      icon: SvgPicture.asset('assets/login/facebook.svg'),
      onPressed: () {
        this._bloc.add(LoginByFacebook());
      },
    ));
    loginButtons.add(TensorfitBorderedButton(
      title: S.of(context).login_google,
      height: _maxItemHeight,
      icon: SvgPicture.asset('assets/login/google.svg'),
      onPressed: () {
        this._bloc.add(LoginByGoogle());
      },
    ));

    if (Platform.isMacOS) {
      loginButtons.add(TensorfitBorderedButton(
        title: S.of(context).login_apple,
        height: _maxItemHeight,
        icon: SvgPicture.asset('assets/login/apple.svg'),
        onPressed: () {
          this._bloc.add(LoginByApple());
        },
      ));
    }

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.95,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Image(
                      image: AssetImage('assets/logo.png'),
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Expanded(
                    child: this._wrap(loginButtons, _maxItemHeight),
                  ),
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(
                children: <Widget>[
                  divider,
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(S.of(context).login_or, style: TextStyle(color: theme.disabledColor, fontWeight: FontWeight.w500)),
                  ),
                  divider,
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder(
                bloc: this._bloc,
                builder: (context, state) {
                  Color emailColor = state.error == null ? theme.buttonColor: theme.errorColor;

                  Widget emailButton = TextField(
                    autocorrect: true,
                    controller: this._emailController,
                    decoration: InputDecoration(
                      labelText: S.of(context).login_email,
                      labelStyle: TextStyle(color: emailColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: buttonBorderWidth, color: emailColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: buttonBorderWidth, color: emailColor),
                      ),
                    ),
                    onChanged: (value) {
                      this._bloc.add(ChangeEmail(value));
                    },
                  );
                  if(state.error == null) {
                    emailButton = Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[emailButton],
                    );
                  } else {
                    emailButton = Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[emailButton,IconButton(
                        icon: Icon(
                          Icons.error_outline,
                          color: theme.errorColor,
                        ),
                        onPressed: () {
                          this._showError(context, 'Login failed', state.error);
                        },
                      ),],
                    );
                  }

                  var passwordButton = Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextField(
                        controller: this._passwordController,
                        obscureText: !state.showPassword,
                        decoration: InputDecoration(
                          labelText: S.of(context).login_password,
                          labelStyle: TextStyle(color: theme.buttonColor),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: buttonBorderWidth, color: theme.buttonColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: buttonBorderWidth, color: theme.buttonColor),
                          ),
                        ),
                        onChanged: (value) {
                          this._bloc.add(ChangePassword(value));
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: state.showPassword ? theme.buttonColor : theme.disabledColor,
                        ),
                        onPressed: () {
                          this._bloc.add(ChangeShowPassword());
                        },
                      ),
                    ],
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: this._wrap(
                          [emailButton, passwordButton],
                          _maxItemHeight,
                        ),
                      ),
                      TensorfitButton(
                        title: S.of(context).login_log_in,
                        onPressed: state.enable
                            ? () {
                                this._bloc.add(Login());
                              }
                            : null,
                      ),
                      FlatButton(
                        child: Text(S.of(context).login_forgot_your_password),
                        onPressed: () {
                          print('forgot_password');
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wrap(List<Widget> items, double maxItemHeight) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight * (1 - 0.05 * (items.length - 1)) > maxItemHeight * items.length) {
          var rows = List<Widget>();

          for (var item in items) {
            if (rows.length > 0) {
              rows.add(
                Container(
                  height: constraints.maxHeight * 0.05,
                ),
              );
            }
            rows.add(
              Container(
                height: maxItemHeight,
                child: item,
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows,
          );
        } else {
          var rows = List<Widget>();

          for (var item in items) {
            if (rows.length > 0) {
              rows.add(
                Container(
                  height: constraints.maxHeight * 0.05,
                ),
              );
            }
            rows.add(
              Expanded(
                child: item,
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows,
          );
        }
      },
    );
  }

  _showError(BuildContext context, String title, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(error),
        );
      },
    );
  }
}
