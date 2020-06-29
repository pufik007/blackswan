import './Product.dart';
import './item_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productData = context.watch<ProductDataProvider>();
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height - 80,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                Container(
                  padding:
                      new EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                  child: ListTile(
                    title: Container(
                      padding: new EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 10.0),
                      child: Text(
                        'Here will be a city allustration',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    subtitle: Container(
                      padding: new EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: Text('Workout plan',
                          style: TextStyle(fontSize: 32, color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  height: 400,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: productData.items.length,
                      itemBuilder: (context, int index) =>
                          ChangeNotifierProvider.value(
                            value: productData.items[index],
                            child: ItemCard(),
                          )),
                ),
              ],
            )),
      ),
    );
  }
}
