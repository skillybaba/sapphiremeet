import 'package:flutter/material.dart';
import './screens/auth.dart';
import './screens/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Auth(),
      '/home': (context) => Home(),
    },
  ));
}
