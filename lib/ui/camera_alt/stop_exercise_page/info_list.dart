import 'package:flutter/material.dart';

import 'info_model.dart';
import 'info_item.dart';

class InfoList extends StatelessWidget {
  final List<InfoModel> infoSample;
  InfoList(this.infoSample);

  @override
  Widget build(BuildContext context) {
    return infoSample.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Text('Нет ошибок');
          })
        : ListView(
            children: infoSample
                .map((inf) => InfoItem(
                      key: ValueKey(inf.id),
                      infoItem1: inf,
                    ))
                .toList(),
          );
  }
}
