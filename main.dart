import 'package:flutter/material.dart';
import 'package:list_app/opening_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List App',
      home: OpeningView(),
    );
  }
}
