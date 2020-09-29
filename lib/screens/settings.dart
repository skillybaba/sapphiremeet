import 'package:application/screens/subscreens/settingsub.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map info;
  @override
  Widget build(BuildContext context) {
    info=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      body: Column(children:[
        SizedBox(height: 40,),
        SettingSub(
        info: info['data'],
        imageurl: info['url'],
      ),])
    );
  }
}
