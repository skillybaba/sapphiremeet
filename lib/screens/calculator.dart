import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';


class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  bool flag = false;
  var docdata;
  
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('C A L C U L A T O R'),
        backgroundColor: Colors.yellow[800],
      ),
      body:  SimpleCalculator(
                  theme: CalculatorThemeData(operatorColor: Colors.yellow[800]),
                )
              
    );
  }
}
