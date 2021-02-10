import 'package:flutter/foundation.dart';

class InfoModel {
  final String id;
  final String title;
  final String subTitle;
  final String mistakes;

  InfoModel({
    @required this.id,
    @required this.title,
    @required this.subTitle,
    @required this.mistakes,
  });
}
