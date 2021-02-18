import 'package:flutter/material.dart';

import 'mistackes_model.dart';
import 'miss_item.dart';

class MissList extends StatelessWidget {
  final List<MistackesModel> infoSample;
  MissList(this.infoSample);

  @override
  Widget build(BuildContext context) {
    return infoSample.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Text('Нет ошибок');
          })
        : Column(
            children: infoSample
                .map((miss) => MissItems(
                      key: ValueKey(miss.id),
                      missItem: miss,
                    ))
                .toList(),
          );
  }
}
