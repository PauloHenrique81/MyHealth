import 'package:flutter/material.dart';
import 'package:myhealth/route_genarator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyHealth',
      initialRoute: 'Wrapper',
      onGenerateRoute: RouteGenarator.genareteRoute,
      debugShowCheckedModeBanner: true,
    );
  }
}
