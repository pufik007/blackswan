import 'package:flutter/material.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'package:tensorfit/generated/i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/ui/widgets/TensorfitButton.dart';
import 'package:tensorfit/ui/widgets/login_adapt.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AdaptLogin(
      child: this._buildBody(context),
      minAspectRatio: 1,
    );
  }

  Widget _buildBody(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(S.of(context).first_welcome, style: theme.textTheme.display1),
              ),
            ),
            Image(
              image: AssetImage('assets/logo.png'),
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  S.of(context).first_tagline,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.body1,
                ),
              ),
            ),
            TensorfitButton(
              title: S.of(context).first_create_account,
              onPressed: () {
                BlocProvider.of<LoginNavigatorBloc>(context).add(NavigateToCreateAccount());
              },
            ),
            TensorfitBorderedButton(
              title: S.of(context).first_skip,
              onPressed: () {
                print('skip');
              },
            ),
            FlatButton(
              child: Text(S.of(context).first_have_account),
              onPressed: () {
                BlocProvider.of<LoginNavigatorBloc>(context).add(NavigateToLogIn());
              },
            ),
          ],
        ),
      ),
    );
  }
}
