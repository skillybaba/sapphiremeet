import 'package:application/screens/aboutus.dart';
import 'package:application/screens/calculator.dart';
import 'package:application/screens/contactus.dart';
import 'package:application/screens/meetHistory.dart';
import 'package:application/screens/sapphireweb.dart';
import 'package:application/screens/settings.dart';
import 'package:flutter/material.dart';
import './screens/auth.dart';
import './screens/home.dart';
import './screens/infoscreen.dart';
import './screens/Loading.dart';
import './screens/contacts.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import './screens/call.dart';
import './screens/payment.dart';
import "./screens/chatpannele.dart" as editedChat;


void main() {


    runApp(
      AdaptiveTheme(
        light: ThemeData(brightness: Brightness.light),
        dark:ThemeData(brightness: Brightness.dark),
        initial: AdaptiveThemeMode.system,
      builder:(light,dark)=>MaterialApp(
        theme: light,
        darkTheme: dark,
      debugShowCheckedModeBanner: false,
      
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/auth': (context) => Auth(),
        '/home': (context) => Home(),
        '/info': (context) => InfoScreen(),
        '/contacts': (context) => ContactView(),
        '/chatpannel': (context) => editedChat.ChatPannel(),
        '/caller': (context) => Call(),
        '/setting': (context) => Settings(),
        '/payments': (context) => Payment(),
        '/Calculator': (context) => Calculator(),
        "/History":(context)=> History(),
        '/contactus':(context)=> Contactus(),
        '/aboutus' :(context) => Aboutus(),
        '/web':(context)=> Sapphireweb(),
      },
    )));
}
