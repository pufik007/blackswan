// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import './Product.dart';
// import 'package:flutter_svg/svg.dart';

// class ItemPage extends StatelessWidget {
//   final String productId;

//   ItemPage({Key key, this.productId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final data = context.watch<ProductDataProvider>().getElementById(productId);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           data.title,
//         ),
//       ),
//       body: Container(
//         child: ListView(
//           children: <Widget>[
//             Card(
//               elevation: 5.0,
//               margin:
//                   const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 20.0, vertical: 10.0),
//                 child: Column(
//                   children: <Widget>[
//                     Text(
//                       data.title,
//                       style: TextStyle(fontSize: 26.0),
//                     ),
//                     Divider(),
//                     Column(
//                       children: <Widget>[
//                         Text(
//                           'Level 1:',
//                           style: TextStyle(fontSize: 20.0),
//                         ),
//                         Text(
//                           '${data.price}',
//                           style: TextStyle(fontSize: 24.0),
//                         ),
//                       ],
//                     ),
//                     Divider(),
//                     Text(data.description),
//                     SizedBox(
//                       height: 220.0,
//                     ),
//                     AspectRatio(
//                       aspectRatio: 6.1,
//                       child: SvgPicture.asset(
//                         'assets/map/stars/stars_0.svg',
//                         alignment: Alignment.topCenter,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
