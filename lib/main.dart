import 'package:first_run/screens/main_screen/main_screen.dart';
import 'package:flutter_web/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Akonet Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue,
            fontFamily: "Raleway"),
        home: MainScreen());
  }
}
