import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final _maxWidth = 412.0;

class LoginAdapt extends StatelessWidget {
  final Widget child;
  final double minAspectRatio;
  final String bgSVGFileName;

  LoginAdapt({
    this.child,
    this.minAspectRatio,
    this.bgSVGFileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _addBackButton(
          context,
          LayoutBuilder(
            builder: (context, constraints) {
              var info = MediaQuery.of(context);
              double width;
              double height;
              if (info.orientation == Orientation.portrait) {
                if (constraints.maxWidth >= _maxWidth) {
                  // tablet
                  width = _maxWidth;
                  height = _maxWidth / this.minAspectRatio;
                } else {
                  if (constraints.maxHeight >= constraints.maxWidth / this.minAspectRatio) {
                    // normal device
                    width = constraints.maxWidth;
                    height = constraints.maxHeight - 1;
                  } else {
                    // small device, need scrolling
                    width = constraints.maxWidth;
                    height = constraints.maxWidth / this.minAspectRatio;
                  }
                }
              } else {
                if (constraints.maxWidth >= _maxWidth && constraints.maxHeight >= _maxWidth / this.minAspectRatio) {
                  // tablet
                  width = _maxWidth;
                  height = _maxWidth / this.minAspectRatio;
                } else {
                  // horizontal phone, need scrolling
                  width = min(_maxWidth, constraints.maxWidth);
                  height = width / this.minAspectRatio;
                }
              }

              var res = SingleChildScrollView(
                child: Container(
                  height: max(constraints.maxHeight, height),
                  alignment: Alignment.center,
                  child: Container(
                    width: width,
                    height: height,
                    child: this.child,
                  ),
                ),
              );

              if(bgSVGFileName == null) {
                return res;
              } else {
                return Stack(
                  children: <Widget>[
                    SvgPicture.asset(this.bgSVGFileName, fit: constraints.maxWidth > constraints.maxHeight ? BoxFit.fitWidth : BoxFit.fitHeight),
                    res,
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _addBackButton(BuildContext context, Widget body) {
    if (Navigator.of(context).canPop()) {
      return Stack(
        children: <Widget>[
          body,
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return body;
    }
  }
}
