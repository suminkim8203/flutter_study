import 'package:flutter/material.dart';
import 'package:flutter_study/screen/home_screen.dart';
import 'package:flutter_study/screen/route_one_screen.dart';
import 'package:flutter_study/screen/route_three_screen.dart';
import 'package:flutter_study/screen/route_two_screen.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomeScreen(),
        '/one': (BuildContext context) => RouteOneScreen(number: 999),
        '/two': (BuildContext context) => RouteTwoScreen(),
        '/three': (BuildContext context) => RouteThreeScreen(),
      },
    ),
  );
}
