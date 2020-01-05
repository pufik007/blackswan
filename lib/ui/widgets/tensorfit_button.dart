import 'package:flutter/material.dart';

final _buttonRadius = BorderRadius.circular(5.0);
final _buttonMargin = EdgeInsets.symmetric(vertical: 10.0);
final buttonBorderWidth = 1.5;
const buttonDefaultHeight = 45.0;

class TensorfitButton extends StatelessWidget {
  final String title;
  final double height;
  final VoidCallback onPressed;

  TensorfitButton({
    @required this.title,
    this.height = buttonDefaultHeight,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      margin: _buttonMargin,
      height: this.height ?? buttonDefaultHeight,
      child: FlatButton(
        disabledColor: theme.disabledColor,
        color: theme.buttonColor,
        highlightColor: theme.highlightColor,
        splashColor: theme.splashColor,
        shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
        child: Text(this.title, style: theme.primaryTextTheme.button),
        onPressed: this.onPressed,
      ),
    );
  }
}

class TensorfitBorderedButton extends TensorfitButton {
  final Widget icon;

  TensorfitBorderedButton({
    @required String title,
    double height = buttonDefaultHeight,
    this.icon,
    VoidCallback onPressed,
  }) : super(title: title, height: height, onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget iconData;
    if(this.icon != null) {
      iconData = Center(
        child: this.icon,
      );
    }

    return FlatButton(
      padding: EdgeInsets.all(0),
      disabledColor: theme.disabledColor,
      color: theme.primaryTextTheme.button.color,
      highlightColor: theme.highlightColor,
      splashColor: theme.splashColor,
      shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
      child: Container(
        height: this.height,
        decoration: BoxDecoration(
          borderRadius: _buttonRadius,
          border: Border.all(color: theme.buttonColor, width: buttonBorderWidth),
        ),
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: iconData,
            ),
            Expanded(
              child: Center(child: Text(this.title, style: theme.primaryTextTheme.button.copyWith(color: theme.buttonColor))),
            ),
            AspectRatio(
              aspectRatio: 1,
              //child: Container(),
            ),
          ],
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}
