import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Center(child: SvgPicture.asset('assets/logo.svg')),
        ),
      ),
    );
  }
}
