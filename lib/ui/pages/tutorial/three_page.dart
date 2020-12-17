import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tensorfit/data/navigator_bloc/bloc.dart';

class ThreePage extends StatefulWidget {
  final double currentPage;
  ThreePage(this.currentPage);
  @override
  _ThreePageState createState() => _ThreePageState();
}

class _ThreePageState extends State<ThreePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/journey.png'), fit: BoxFit.cover),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: <Widget>[
                  Text(
                    'Our built-in fitness generator makes ',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'your personal training progarmm',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ]),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(bottom: 20.0, top: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.deepPurple)),
              padding:
                  EdgeInsets.only(bottom: 21, top: 21, right: 122, left: 122),
              onPressed: () { 
                BlocProvider.of<LoginNavigatorBloc>(context)
                  .add(NavigateToCreateAccount());
              },
              color: Colors.deepPurple,
              child: Text('Get started',
                  style: TextStyle(fontSize: 17, color: Colors.white)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 52.0),
            child: DotsIndicator(
              dotsCount: 6,
              decorator: DotsDecorator(activeColor: Colors.white),
              position: widget.currentPage,
            ),
          ),
        ],
      ),
    );
  }
}
