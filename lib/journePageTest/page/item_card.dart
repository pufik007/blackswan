import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Product.dart';
import './item_page.dart';
import 'package:flutter_svg/svg.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    print('build ItemCard');

    return Container(
      width: 220,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(8.5),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ItemPage(productId: product.id)),
              );
            },
            child: Row(
              children: <Widget>[
                Container(
                  height: 0,
                ),
                Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    color: Color(int.parse(product.color)),
                    width: 220,
                    height: 50,
                    child: Text(
                      '${product.title}',
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    )),
              ],
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            color: Color(int.parse(product.color)),
            height: 60,
            child: Text(
              '${product.subTitle}',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Text(
              '${product.level}',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              '${product.description}',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
          ),
          AspectRatio(
            aspectRatio: 8.5,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                child: Row(children: <Widget>[
                  Icon(Icons.alarm, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    '${product.time}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  )
                ])),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
            child: AspectRatio(
              aspectRatio: 5.1,
              child: SvgPicture.asset(
                'assets/map/stars/stars_0.svg',
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
