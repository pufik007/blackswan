import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:after_layout/after_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated/i18n.dart';
import 'data/navigator_bloc/navigator_bloc.dart';
import 'data/app_bloc/bloc.dart';
import 'data/api/entities/level.dart';
import 'ui/pages/create_account_page.dart';
import 'ui/pages/first_page.dart';
import 'ui/pages/home_page_alt.dart';
import 'ui/pages/log_in_page.dart';
import 'ui/pages/logo_page.dart';
import 'ui/pages/journey_page.dart';
import 'ui/pages/level_page.dart';
import 'package:camera/camera.dart';
import 'ui/camera_alt/camera_prediction_page.dart';
import 'data/api/entities/exercise_detection.dart';
import 'ui/pages/tutorial/tutorial.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MaterialApp(home: OneTimePage()));
}

class OneTimePage extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SplashState extends State<OneTimePage>
    with AfterLayoutMixin<OneTimePage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => App()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Tutorial()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(''),
      ),
    );
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  // ignore: close_sinks
  final _appBloc = AppBloc()..add(Load());

  final GlobalKey<NavigatorState> _loginNavKey = GlobalKey();
  final GlobalKey<NavigatorState> _homeNavKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => this._appBloc,
      child: BlocBuilder<AppBloc, AppState>(
        bloc: this._appBloc,
        builder: (context, state) {
          var title = 'Tensorfit';

          if (state is Loading) {
            return MaterialApp(
              title: title,
              home: LogoPage(),
            );
          }
          if (state is LoggedOff) {
            return BlocProvider(
              create: (context) =>
                  LoginNavigatorBloc(navigatorKey: this._loginNavKey),
              child: MaterialApp(
                title: title,
                theme: state.theme,
                localizationsDelegates: [S.delegate],
                supportedLocales: S.delegate.supportedLocales,
                localeResolutionCallback:
                    S.delegate.resolution(fallback: Locale("en", "")),
                navigatorKey: this._loginNavKey,
                routes: {
                  '/log_in': (context) => LogInPage(),
                  '/create_account': (context) => CreateAccountPage(),
                },
                home: FirstPage(cameras),
              ),
            );
          } else if (state is JourneyCreation) {
            return MaterialApp(
              title: title,
              theme: state.theme,
              localizationsDelegates: [S.delegate],
              supportedLocales: S.delegate.supportedLocales,
              localeResolutionCallback:
                  S.delegate.resolution(fallback: Locale("en", "")),
              home: JourneyPage(state.fillUserData, false),
            );
          } else if (state is JourneyValidation) {
            return MaterialApp(
              title: title,
              theme: state.theme,
              localizationsDelegates: [S.delegate],
              supportedLocales: S.delegate.supportedLocales,
              localeResolutionCallback:
                  S.delegate.resolution(fallback: Locale("en", "")),
              home: Scaffold(
                body: Center(
                  child: Text('Preparing journey... It may take some time.'),
                ),
              ),
            );
          } else if (state is LoggedIn) {
            return BlocProvider(
              create: (context) =>
                  HomeNavigatorBloc(navigatorKey: this._homeNavKey),
              child: MaterialApp(
                title: title,
                theme: state.theme,
                localizationsDelegates: [S.delegate],
                supportedLocales: S.delegate.supportedLocales,
                localeResolutionCallback:
                    S.delegate.resolution(fallback: Locale("en", "")),
                navigatorKey: this._homeNavKey,
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/level':
                      final List args = settings.arguments;
                      final Level level = args[0];
                      final ImageProvider image = args[1];
                      final Alignment imageAlign = args[2];
                      return MaterialPageRoute(
                        builder: (context) {
                          return LevelPage(level, image, imageAlign);
                        },
                      );
                    case '/camera_prediction_page':
                      final List args = settings.arguments;
                      final Level level = args[0];
                      final List<ExerciseDetection> exerciseDetection = args[1];
                      return MaterialPageRoute(
                        builder: (context) {
                          return CameraPredictionPage(
                              cameras, level, exerciseDetection);
                        },
                      );
                    default:
                      return null;
                  }
                },
                routes: {
                  '/create_journey': (context) => JourneyPage(false, true),
                },
                home: HomePageAlt(),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    this._appBloc.close();
    super.dispose();
  }
}
