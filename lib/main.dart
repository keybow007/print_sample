import 'package:flutter/material.dart';
import 'package:print_sample/home_screen.dart';

import 'data/card_sIze.dart';
import 'data/paper_sIze.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
