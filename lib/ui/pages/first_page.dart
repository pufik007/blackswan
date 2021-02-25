import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'package:tensorfit/generated/i18n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/ui/widgets/tensorfit_button.dart';
import 'package:tensorfit/ui/widgets/login_adapt.dart';
import 'tutorialOfExercises/camera_page_for_tutorial.dart';

class FirstPage extends StatelessWidget {
  final List<CameraDescription> cameras;
  FirstPage(this.cameras);

  @override
  Widget build(BuildContext context) {
    return LoginAdapt(
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
                child: Text(S.of(context).first_welcome,
                    style: theme.textTheme.display1),
              ),
            ),
            AspectRatio(
              aspectRatio: 5,
              child: SvgPicture.asset(
                'assets/logo.svg',
                fit: BoxFit.fitWidth,
              ),
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
                BlocProvider.of<LoginNavigatorBloc>(context)
                    .add(NavigateToCreateAccount());
              },
            ),
            TensorfitBorderedButton(
              title: S.of(context).first_skip,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 16,
                        child: Container(
                          height: 290,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Приседания',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                              Container(
                                height: 200,
                                width: 600,
                                child: Image.asset(
                                    'assets/tutorialExercises/squats.gif'),
                              ),
                              RaisedButton(
                                color: Colors.deepPurple,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CameraPageTutorial(cameras)));
                                },
                                child: Text('Start exercise',
                                    style: TextStyle(color: Colors.white)),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
            FlatButton(
              child: Text(S.of(context).first_have_account),
              onPressed: () {
                BlocProvider.of<LoginNavigatorBloc>(context)
                    .add(NavigateToLogIn());
              },
            ),
          ],
        ),
      ),
    );
  }
}
