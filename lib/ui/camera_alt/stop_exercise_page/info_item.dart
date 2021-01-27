import 'package:flutter/material.dart';

import 'info_model.dart';

class InfoItem extends StatefulWidget {
  const InfoItem({
    Key key,
    @required this.infoItem1,
  }) : super(key: key);

  final InfoModel infoItem1;

  @override
  _InfoItemState createState() => _InfoItemState();
}

class _InfoItemState extends State<InfoItem> {
  double size = 50;
  bool isActive = false;
  Icon fab = Icon(
    Icons.keyboard_arrow_down,
    size: 30,
    color: Colors.white,
  );
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

    return Container(
      height: size,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.deepPurple[700],
          borderRadius: BorderRadius.circular(30)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          IconButton(
              icon: fab,
              onPressed: () {
                setState(() {
                  if (isActive == false) {
                    isActive = true;
                    fab = Icon(
                      Icons.keyboard_arrow_up,
                      size: 30,
                      color: Colors.white,
                    );
                    size = 100;
                  } else if (isActive == true) {
                    isActive = false;
                    fab = Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                      color: Colors.white,
                    );
                    size = 50;
                  }
                });
              }),
          Text(
            '${widget.infoItem1.title}',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            width: 60,
          ),
          (widget.infoItem1.mistakes == '0')
              ? Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.green,
                  ),
                  child: Text('${widget.infoItem1.mistakes} ошибок',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                )
              : Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  child: Text('${widget.infoItem1.mistakes} ошибок',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                )
        ]),
        (isActive == true)
          ? Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${widget.infoItem1.subTitle}',
              style: TextStyle(fontSize: 13, color: Colors.white),
            )
          )
          : null
      ]),
    );
  }
}
