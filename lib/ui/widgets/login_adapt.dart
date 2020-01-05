import 'dart:math';
import 'package:flutter/material.dart';

final _maxWidth = 412.0;

class AdaptLogin extends StatelessWidget {
  final Widget child;
  final double minAspectRatio;

  AdaptLogin({
    this.child,
    this.minAspectRatio,
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
              if (info.orientation == Orientation.portrait) {
                if (constraints.maxWidth >= _maxWidth) {
                  // tablet
                  return Center(
                    child: Container(
                      width: _maxWidth,
                      height: _maxWidth / this.minAspectRatio,
                      child: this.child,
                    ),
                  );
                } else {
                  if (constraints.maxHeight >= constraints.maxWidth / this.minAspectRatio) {
                    // normal device
                    return SingleChildScrollView(
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight - 1,
                        child: this.child,
                      ),
                    );
                  } else {
                    // small device, need scrolling
                    return SingleChildScrollView(
                      child: Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth / this.minAspectRatio,
                        child: this.child,
                      ),
                    );
                  }
                }
              } else {
                if (constraints.maxWidth >= _maxWidth && constraints.maxHeight >= _maxWidth / this.minAspectRatio) {
                  // tablet
                  return Center(
                    child: Container(
                      width: _maxWidth,
                      height: _maxWidth / this.minAspectRatio,
                      child: this.child,
                    ),
                  );
                } else {
                  var width = min(_maxWidth, constraints.maxWidth);
                  // horizontal phone, need scrolling
                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                        width: width,
                        height: width / this.minAspectRatio,
                        child: this.child,
                      ),
                    ),
                  );
                }
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
