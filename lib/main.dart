import 'package:flutter/material.dart';
import './screens/auth.dart';
import './screens/home.dart';
import './screens/infoscreen.dart';
import './screens/Loading.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/auth': (context) => Auth(),
      '/home': (context) => Home(),
      '/info': (context) => InfoScreen(),
    },
  ));
}
