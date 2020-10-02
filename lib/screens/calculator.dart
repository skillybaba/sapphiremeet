import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool flag = false;
  var docdata;
  void fun() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await Firebase.initializeApp();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var doc = firestore.doc(pref.getString('userdocid'));
    var docdata = await doc.get();
    if (DateTime.now().isAfter(docdata.data()['time'].toDate() )) await doc.update({
      'account':'free',
      'time':DateTime.now().add(Duration(days: 1000)),
      
    });
    
    this.docdata = docdata;
    print('done');
    setState(() {
      flag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!flag) fun();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('C A L C U L A T O R'),
        backgroundColor: Colors.yellow[800],
      ),
      body: flag
          ? docdata.data()['account'] != 'free'
              ? SimpleCalculator(
                  theme: CalculatorThemeData(operatorColor: Colors.yellow[800]),
                )
              : Center(
                  child: Text(
                      "YOU ARE USING A FREE ACCOUNT SO YOU CANNOT USE THE THIS FEATURE",
                      style: TextStyle(
                          color: Colors.yellow[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold)))
          : SpinKitRipple(color: Colors.yellow[800]),
    );
  }
}
