import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Sapphireweb extends StatefulWidget {
  @override
  _SapphirewebState createState() => _SapphirewebState();
}

class _SapphirewebState extends State<Sapphireweb> {
  void func(BuildContext context) async {
    await Firebase.initializeApp();
    var firestore = FirebaseFirestore.instance;
    var doc = firestore.doc('web/0ysJuZ64RshAHyBnbMqc');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var code = pref.getStringList('your info');
    var doccode = pref.getString('userdocid').split('/');
    print(doccode);
    var codedata =
        code[1] + doccode[1] + DateTime.now().toString().split(' ')[0]+ DateTime.now().toString().split(' ')[1];
    print(codedata);
    doc.update({
      codedata: pref.getString('userdocid'),
    });
    showDialog(
        context: context,
        child: AlertDialog(
          content: Text(codedata),
          title: Text('your code'),
          actions: [
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: codedata));
                Toast.show('Copied', context);
              },
              icon: Icon(Icons.copy),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow[800],
          title: Text('Sapphire-Web'),
          centerTitle: true,
        ),
        body: Center(
          child: RaisedButton(
            color: Colors.yellow[800],
            onPressed: () {
              func(context);
            },
            child: Text(
              'Generate Code',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
  }
}
