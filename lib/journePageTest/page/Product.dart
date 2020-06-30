import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String subTitle;
  final String description;
  final String price;
  final String time;
  final String level;
  final color;

  Product({
    @required this.id,
    @required this.title,
    @required this.subTitle,
    @required this.description,
    @required this.price,
    @required this.color,
    @required this.time,
    @required this.level,
  });
}

class ProductData with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'June 2',
        subTitle: 'Here will be sime text to motivere users do exercises',
        description: 'Exercises: 2',
        price: 'Here will be sime text to motivere users do exercises',
        color: '0xFFD6D6D6',
        time: '23 min',
        level: 'Level 1'),
    Product(
        id: 'p2',
        title: 'June 3',
        subTitle: 'Here will be sime text to motivere users do exercises',
        description: 'Exercises: 3',
        price: 'Here will be sime text to motivere users do exercises',
        color: '0xFFD6D6D6',
        time: '27 min',
        level: 'Level 1'),
    Product(
        id: 'p3',
        title: 'June 4',
        subTitle: 'Here will be sime text to motivere users do exercises',
        description: 'Exercises: 4',
        price: 'Here will be sime text to motivere users do exercises',
        color: '0xFF81C784',
        time: '20 min',
        level: 'Level 1'),
    Product(
        id: 'p4',
        title: 'June 5',
        subTitle: 'Here will be sime text to motivere users do exercises',
        description: ' Exercises: 5',
        price: 'Here will be sime text to motivere users do exercises',
        color: '0xFF81C784',
        time: '15 min',
        level: 'Level 1'),
    Product(
        id: 'p5',
        title: 'June 6',
        subTitle: 'Here will be sime text to motivere users do exercises',
        description: ' Exercises: 26',
        price: 'Here will be sime text to motivere users do exercises',
        color: '0xFF81C784',
        time: '28 min',
        level: 'Level 1'),
  ];

  UnmodifiableListView<Product> get items => UnmodifiableListView(_items);

  Product getElementById(String id) =>
      _items.singleWhere((value) => value.id == id);
}
