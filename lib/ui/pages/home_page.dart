import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/app_bloc/app_bloc.dart';
import 'package:tensorfit/data/app_bloc/app_event.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as map;
import 'package:tensorfit/ui/widgets/map_widget.dart';
import './home_page_alt.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: close_sinks
  final _mapBloc = map.MapBloc();

  final _leftImages = List<Image>();
  final _rightImages = List<Image>();
  final _leftImagesH = List<Image>();
  final _rightImagesH = List<Image>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 6; i++) {
      _leftImages.add(Image.asset('assets/map/levels/left/${i + 1}.png'));
      _leftImagesH.add(Image.asset('assets/map/levels/left_h/${i + 1}.png'));
      _rightImages.add(Image.asset('assets/map/levels/right/${i + 1}.png'));
      _rightImagesH.add(Image.asset('assets/map/levels/right_h/${i + 1}.png'));
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    for (var i = 0; i < 6; i++) {
      await precacheImage(_leftImages[i].image, this.context);
      await precacheImage(_leftImagesH[i].image, this.context);
      await precacheImage(_rightImages[i].image, this.context);
      await precacheImage(_rightImagesH[i].image, this.context);
    }
    this._mapBloc.add(map.Load());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var color = Color.fromARGB(255, 167, 165, 168);
    var style = theme.textTheme.body2.copyWith(color: color);
    var size = 30.0;

    return BlocProvider(
      create: (context) => this._mapBloc,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 18, 11, 25),
        body: Stack(
          children: <Widget>[
            MapWidget(
              this._leftImages,
              this._leftImagesH,
              this._rightImages,
              this._rightImagesH,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: BottomAppBar(
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      iconSize: size * 2,
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.crop_square,
                            size: size,
                            color: color,
                          ),
                          Text(
                            'Journey',
                            style: style,
                          ),
                        ],
                      ),
                      onPressed: () {
                        BlocProvider.of<HomeNavigatorBloc>(context)
                            .add(NavigateToCreateJourney());
                      },
                    ),
                    IconButton(
                      iconSize: size * 2,
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.crop_square,
                            size: size,
                            color: color,
                          ),
                          Text(
                            'Logout',
                            style: style,
                          ),
                        ],
                      ),
                      onPressed: () {
                        BlocProvider.of<AppBloc>(context).add(Logout());
                      },
                    ),
                    IconButton(
                      iconSize: size * 2,
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.crop_square,
                            size: size,
                            color: color,
                          ),
                          Text(
                            'Change',
                            style: style,
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePageAlt()));
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.crop_square,
                        size: size,
                        color: color,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.crop_square,
                        size: size,
                        color: color,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    this._mapBloc.close();
    super.dispose();
  }
}
