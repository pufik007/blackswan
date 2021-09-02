import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:tensorfit/ui/widgets/map_bloc/bloc.dart' as map;
import 'journey_page.dart';
import 'level_card_list_widget.dart';
import 'package:tensorfit/data/api/entities/level.dart';
import './home_page.dart';
import './profile_page.dart';
import '../../data/api/entities/user.dart';
import 'motivational_quotes.dart';

class HomePageAlt extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageAlt> {
  // ignore: close_sinks
  final _mapBloc = map.MapBloc();
  Level level;
  ImageProvider image;
  Alignment imageAlign;
  DateTime date;
  String userEmail;
  final imgChoose = List<Image>();
  int _selectedIndex = 0;
  @override
  void initState() {
    for (var i = 0; i < 6; i++) {
      imgChoose.add(Image.asset('assets/map/levels/left/${i + 1}.png'));
      imgChoose.add(Image.asset('assets/map/levels/right/${i + 1}.png'));
      imgChoose.add(Image.asset('assets/map/levels/left/${i + 1}.png'));
      imgChoose.add(Image.asset('assets/map/levels/right/${i + 1}.png'));
    }
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    this._mapBloc.add(map.Load());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(_mapBloc.state.userEmail)));
      }
    });
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => this._mapBloc,
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Journey',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            onTap: _onItemTapped,
          ),
          body: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 0.0),
                child: Column(children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 4,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/imgLevelPage/img_2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Text(
                      'Workout plan',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 322,
                    child: LevelCardListWidget(
                        level, date, image, imageAlign, userEmail, imgChoose),
                  ),

                  // Column(
                  //   children: [
                  //     Container(
                  //         padding:
                  //             EdgeInsets.symmetric(horizontal: 10),
                  //         child: RaisedButton(
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius:
                  //                   BorderRadius.circular(5)),
                  //           onPressed: () {
                  //             Navigator.pushReplacement(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) =>
                  //                         HomePage()));
                  //           },
                  //           color: Colors.deepPurple,
                  //           child: Text(
                  //             'Change',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         )),
                  //     Container(
                  //         padding:
                  //             EdgeInsets.symmetric(horizontal: 10),
                  //         child: RaisedButton(
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius:
                  //                   BorderRadius.circular(5)),
                  //           onPressed: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) =>
                  //                         ProfilePage(_mapBloc
                  //                             .state.userEmail)));
                  //           },
                  //           color: Colors.deepPurple,
                  //           child: Text(
                  //             'Profile',
                  //             style: TextStyle(color: Colors.white),
                  //           ),
                  //         )),
                  //   ],
                  // )
                ]),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    this._mapBloc.close();
    super.dispose();
  }
}
