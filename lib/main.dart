import 'package:flutter/material.dart';
import 'package:flutter_trip/widgets/tab_navigator.dart';

void main() => runApp(TripApp());

class TripApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter trip',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
  }
}
