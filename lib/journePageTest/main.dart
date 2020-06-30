import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './page/Product.dart';
import './page/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductData>(
          create: (context) => ProductData(),
        ),
      ],
      child: MaterialApp(
        title: 'Demo App',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          backgroundColor: Colors.deepPurple,
        ),
        home: HomePage(),
      ),
    );
  }
}
