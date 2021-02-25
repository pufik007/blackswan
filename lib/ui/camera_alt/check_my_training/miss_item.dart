import 'package:flutter/material.dart';

import 'mistackes_model.dart';

class MissItems extends StatefulWidget {
  const MissItems({
    Key key,
    @required this.missItem,
  }) : super(key: key);

  final MistackesModel missItem;

  @override
  _MissItemsState createState() => _MissItemsState();
}

class _MissItemsState extends State<MissItems> {
  @override
  Widget build(BuildContext context) {
    var heightBg = MediaQuery.of(context).size.height;
    var widthBg = MediaQuery.of(context).size.width;

    if (heightBg != null && widthBg != null) {
      if (heightBg >= 800) {
        heightBg = MediaQuery.of(context).size.height;
      } else {
        heightBg = MediaQuery.of(context).size.height * 1.1;
      }
      if (widthBg >= 380) {
        widthBg = MediaQuery.of(context).size.width;
      } else {
        widthBg = MediaQuery.of(context).size.width * 1.1;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Container(
        height: 60,
        width: widthBg * 0.9,
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.grey[900]),
        child: Text(
          '${widget.missItem.titleMis}',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
